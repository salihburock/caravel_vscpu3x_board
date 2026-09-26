"""Build the OLED C example using the local VSCPU compiler source, then verify."""
import argparse
from pathlib import Path
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sim-dir", type=Path,
                        default=Path("/home/salih/EE321/VSCPU-Sim"))
    args = parser.parse_args()
    sim_dir = args.sim_dir.resolve()
    with tempfile.TemporaryDirectory(prefix="oled-vscc-") as directory:
        compiler = Path(directory) / "vscc_static"
        subprocess.run(["cc", "-O2", str(sim_dir / "compilers/vscc_static.c"),
                        "-o", str(compiler)], check=True)
        subprocess.run([str(compiler), str(HERE / "oled_photo_c.c"),
                        "-o", str(HERE / "oled_photo_c_cm.asm")], check=True)
    subprocess.run([sys.executable, str(HERE.parent / "utils/asmtomem.py"),
                    str(HERE / "oled_photo_c_cm.asm")], check=True)
    subprocess.run([sys.executable, str(HERE / "verify.py"),
                    "--sim-dir", str(sim_dir)], check=True)


if __name__ == "__main__":
    main()
