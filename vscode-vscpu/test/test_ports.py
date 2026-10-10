import importlib.util
from pathlib import Path
from types import SimpleNamespace
import unittest
spec = importlib.util.spec_from_file_location('ports', Path(__file__).parents[1] / 'scripts/list_ports.py')
ports = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ports)

def port(device):
    return SimpleNamespace(device=device, manufacturer='wch.cn', product='CH340',
                           description='USB Serial', vid=0x1a86, pid=0x7523,
                           serial_number=None, location='1-2')

class PortsTest(unittest.TestCase):
    def test_linux_filters_and_identity(self):
        result = ports.describe_ports(map(port, ['/dev/ttyS0', '/dev/ttyUSB0', '/dev/ttyACM0']), 'linux')
        self.assertEqual([p['label'] for p in result], ['/dev/ttyACM0', '/dev/ttyUSB0'])
        self.assertIn('CH340', result[0]['description'])
        self.assertIn('1A86:7523', result[0]['detail'])
    def test_windows_com_ports(self):
        self.assertEqual(len(ports.describe_ports(map(port, ['COM3', 'COM12']), 'win32')), 2)
    def test_missing_usb_metadata(self):
        p = port('COM1')
        p.manufacturer = p.product = p.vid = p.pid = p.location = None
        p.description = 'n/a'
        self.assertEqual(ports.describe_ports([p], 'win32')[0]['description'], 'Serial port')
