"""Offline checks for upload failures; no serial hardware is accessed."""
import contextlib
import io
import sys
import types
import unittest
from unittest.mock import Mock, patch, mock_open

try:
    import serial
except ImportError:
    sys.modules["serial"] = types.ModuleType("serial")

import run_test
import testutils


class UploadTests(unittest.TestCase):
    @patch("builtins.open", mock_open(read_data="@752\n00000000\n00000000\n"))
    def test_exclusion_rejects_word_inside_block(self):
        with self.assertRaisesRegex(ValueError, "excluded address 753"):
            run_test.check_excluded_addresses("example.mem", {753})

    @patch("builtins.input", return_value="")
    @patch.object(run_test.time, "sleep")
    @patch.object(run_test.os.path, "exists", side_effect=lambda p: p.endswith("_cm.mem"))
    @patch("builtins.open", mock_open(read_data="@240\n901FC01F\n@800\n00000000\n"))
    def test_exclusion_skips_clear_and_keeps_full_image_verification(self, exists, sleep, user_input):
        device = Mock()
        device.CheckMemFromFile.return_value = True
        with contextlib.redirect_stdout(io.StringIO()):
            run_test.main("example", device, True, skip_addresses=[753])
        addresses = [call.args[0] for call in device.WriteWord.call_args_list]
        self.assertEqual(addresses, [a for a in range(2048) if a != 753])
        device.CheckMemFromFile.assert_called_once_with("../example/example_cm.mem")

    def test_cannot_watch_excluded_word(self):
        with self.assertRaisesRegex(ValueError, "Cannot watch"):
            run_test.main("example", Mock(), False, watch_address=753, skip_addresses=[753])

    @patch("builtins.open", mock_open(read_data="@240\n901FC01F\n90200021\n@102\nFFFFFFFF\n"))
    def test_watch_finds_later_corruption_across_sparse_blocks(self):
        device = self.device(["901FC01F", "901FC01F"] + ["801FC01F"] * 4)
        device.WriteWord = Mock()
        with contextlib.redirect_stdout(io.StringIO()), self.assertRaisesRegex(
                IOError, "changed after processing write to address 102"):
            device.WriteMemFromFile("example.mem", watch_address=240)
        self.assertEqual([call.args[0] for call in device.WriteWord.call_args_list],
                         [240, 241, 102])

    @patch("builtins.open", mock_open(read_data="@240\n901FC01F\n90200021\n"))
    def test_watch_stable_image(self):
        device = self.device(["901FC01F", "901FC01F"])
        device.WriteWord = Mock()
        with contextlib.redirect_stdout(io.StringIO()):
            device.WriteMemFromFile("example.mem", watch_address=240)
        self.assertEqual(device.WriteWord.call_count, 2)

    @patch("builtins.open", mock_open(read_data="@240\n901FC01F\n"))
    def test_missing_watch_address_does_not_write(self):
        device = self.device([])
        device.WriteWord = Mock()
        with self.assertRaises(ValueError):
            device.WriteMemFromFile("example.mem", watch_address=100)
        device.WriteWord.assert_not_called()

    def device(self, reads):
        device = testutils.uart.__new__(testutils.uart)
        device.SerialPort = Mock()
        device.ReadWord = Mock(side_effect=reads)
        return device

    @patch.object(testutils.time, "sleep")
    def test_failed_write_stops_after_retry_limit(self, sleep):
        device = self.device([""] * 11)
        with self.assertRaisesRegex(IOError, "address 123"):
            device.WriteWord(123, "12345678")
        self.assertEqual(device.SerialPort.write.call_count, 10)

    @patch.object(testutils.time, "sleep")
    def test_transient_failure_can_recover(self, sleep):
        device = self.device(["00000000", "", "12345678"])
        device.WriteWord(123, "12345678")
        self.assertEqual(device.SerialPort.write.call_count, 2)

    def test_existing_word_does_not_need_write(self):
        device = self.device(["12345678"])
        device.WriteWord(123, "12345678")
        device.SerialPort.write.assert_not_called()

    @patch.object(run_test.os.path, "exists", return_value=False)
    def test_missing_image_is_error(self, exists):
        with self.assertRaises(FileNotFoundError):
            run_test.main("missing", Mock(), False)

    @patch("builtins.input", return_value="")
    @patch.object(run_test.os.path, "exists", side_effect=lambda p: p.endswith("_cm.mem"))
    def test_readback_failure_does_not_request_run(self, exists, user_input):
        device = Mock()
        device.CheckMemFromFile.return_value = False
        output = io.StringIO()
        with contextlib.redirect_stdout(output), self.assertRaises(IOError):
            run_test.main("example", device, False)
        self.assertNotIn("exit program mode", output.getvalue())
        self.assertNotIn("Upload complete", output.getvalue())
        device.WriteMemFromFile.assert_called_once()
        device.CheckMemFromFile.assert_called_once_with("../example/example_cm.mem")

    @patch("builtins.input", return_value="")
    @patch.object(run_test.time, "sleep")
    @patch.object(run_test.os.path, "exists", side_effect=lambda p: p.endswith("_cm.mem"))
    def test_success_requires_readback(self, exists, sleep, user_input):
        device = Mock()
        device.CheckMemFromFile.return_value = True
        with contextlib.redirect_stdout(io.StringIO()):
            run_test.main("example", device, False)
        self.assertEqual([call[0] for call in device.mock_calls],
                         ["WriteMemFromFile", "CheckMemFromFile"])


if __name__ == "__main__":
    unittest.main()
