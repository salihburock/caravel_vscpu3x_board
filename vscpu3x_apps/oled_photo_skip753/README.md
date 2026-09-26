Diagnostic variant of the original `oled_photo`. The image moves from words
500–755 to 800–1055, and the image pointer at instruction 50 changes from 500
to 800. All image bytes, initialization, and SPI instructions are unchanged.
The original example files are unchanged.

From `vscpu3x_apps/utils`, select codemaker programming mode and run:

```bash
python3 run_test.py oled_photo_skip753 /dev/ttyUSB0 --memclear --skip-address 753
```

Use your serial port. The option excludes 753 from clearing and rejects any
program/check file that contains it before starting memory operations. This
variant's upload, full readback, and runtime image traversal all avoid 753.
Wait for full readback to pass before switching to run mode.

This tests a workaround for the observed 753/240 interaction, not its cause.
Other addresses have not been established to be unaffected on hardware.
Regenerate the `.mem` with `../utils/asmtomem.py` if the assembly changes.
