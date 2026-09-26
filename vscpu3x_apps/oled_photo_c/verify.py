"""Validate the assembled C program with the user's VSCPU instruction simulator."""
import argparse
import importlib.util
from pathlib import Path
import re


HERE = Path(__file__).resolve().parent


class OLED:
    def __init__(self):
        self.pins = 4
        self.bits = []
        self.output = []
        self.finished = False

    def feed(self, value):
        assert 0 <= value < 16, f"Unexpected GPIO value: {value}"
        if value & 4:
            assert not self.bits, "CS deasserted mid-byte"
            if self.output:
                self.finished = True
        if not value & 4 and value & 2 and not self.pins & 2:
            assert not self.finished, "Data after final CS deassertion"
            self.bits.append((value & 8, value & 1))
            if len(self.bits) == 8:
                assert len({dc for dc, _ in self.bits}) == 1, "D/C changed mid-byte"
                self.output.append((self.bits[0][0], sum(
                    bit << (7 - i) for i, (_, bit) in enumerate(self.bits))))
                self.bits.clear()
        self.pins = value


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sim-dir", type=Path,
                        default=Path("/home/salih/EE321/VSCPU-Sim"))
    args = parser.parse_args()
    spec = importlib.util.spec_from_file_location(
        "vscpu_spi", args.sim_dir / "VerySimpleCPU_spi.py")
    module = importlib.util.module_from_spec(spec)
    # exec source avoids writing __pycache__ into the external simulator folder.
    exec(compile(Path(spec.origin).read_text(), spec.origin, "exec"), module.__dict__)

    class ISASimulator(module.VerySimpleCPUSim):
        """Apply ISA-v1 semantics from http://www.cpu.tc/rtl/.

        The external SPI simulator sign-extends ADDi and disables left shifts.
        CPU addresses are 14 bits; the RAM bounds check is applied afterwards.
        """
        def step(self):
            word = self.M[self.pc]
            op, a, b = word >> 28, (word >> 14) & 0x3FFF, word & 0x3FFF
            if op == 1:
                self.M[a] = (self.M[a] + b) & 0xFFFFFFFF
            elif op in (4, 5):
                amount = self.M[b] if op == 4 else b
                value = self.M[a]
                if amount < 32:
                    value >>= amount
                elif amount < 64:
                    value <<= amount - 32
                else:
                    value = 0
                self.M[a] = value & 0xFFFFFFFF
            elif op == 10:
                self.M[a] = self.M[self.M[b] & 0x3FFF]
            elif op == 11:
                self.M[self.M[a] & 0x3FFF] = self.M[b]
            elif op == 12:
                self.pc = (self.M[a] if self.M[b] == 0 else self.pc + 1) & 0x3FFF
                return
            elif op == 13:
                self.pc = (self.M[a] + b) & 0x3FFF
                return
            else:
                super().step()
                self.pc &= 0x3FFF
                return
            self.pc = (self.pc + 1) & 0x3FFF

    oled = OLED()
    sim = ISASimulator(str(HERE / "oled_photo_c_cm.asm"), oled)
    sim.load()
    assembled = {}
    for line in (HERE / "oled_photo_c_cm.mem").read_text().splitlines():
        if line.startswith("@"):
            address = int(line[1:])  # This repository's loader uses decimal addresses.
        else:
            assert address not in assembled
            assembled[address] = int(line, 16)
            address += 1
    assert max(assembled) < 2048
    for address, word in assembled.items():
        assert sim.M[address] == word, f"Assembly/mem mismatch at {address}"
    assert all(word == assembled.get(address, 0)
               for address, word in enumerate(sim.M))

    class BoardMemory(list):
        high_water = max(assembled)

        def __getitem__(self, address):
            assert 0 <= address < 2048 or address == 8254, address
            return super().__getitem__(address)

        def __setitem__(self, address, value):
            assert 0 <= address < 2048 or address == 8254, address
            if address == 8254:
                oled.feed(value)
            else:
                self.high_water = max(self.high_water, address)
            super().__setitem__(address, value)

    sim.M = BoardMemory(sim.M)
    for steps in range(2_000_000):
        pc = sim.pc
        sim.step()
        if sim.pc == pc:
            break
    else:
        raise AssertionError("Program did not halt")
    source = (HERE.parent / "oled_photo" / "oled_photo_cm.asm").read_text()
    words = {int(a): int(v) for a, v in re.findall(
        r"^(\d+):\s*(\d+)\s*(?://.*)?$", source, re.M)}
    expected = [(0, words[a]) for a in range(300, 317)]
    expected += [(8, byte) for a in range(500, 756)
                 for byte in words[a].to_bytes(4, "big")]
    assert oled.output == expected, f"SPI mismatch: got {len(oled.output)} bytes; first differences {[(i, a, b) for i, (a, b) in enumerate(zip(oled.output, expected)) if a != b][:8]}"
    assert oled.finished and oled.pins == 4 and not oled.bits
    print(f"PASS: 17 command bytes, 1024 image bytes, CS idle, program halted; "
          f"{steps + 1} instructions; highest RAM address {sim.M.high_water}/2047")


if __name__ == "__main__":
    main()
