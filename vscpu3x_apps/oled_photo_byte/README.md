This diagnostic displays the same image as `oled_photo` using the byte SPI
transmitter from `oled_test`. Initialization bytes and GPIO pin mapping are
unchanged. Image words are unpacked ahead of time into 1024 byte values, so the
CPU executes no `SRL` instructions. Scratch addresses are separate from code;
the transmitter's unused address 212 contains an explicit harmless instruction.

From `vscpu3x_apps/utils`, with codemaker selected for programming:

```bash
python3 run_test.py oled_photo_byte /dev/ttyUSB0 --memclear
```

Replace the serial port as needed, then switch back to run mode. The supplied
`.mem` is assembled from `oled_photo_byte_cm.asm`; regenerate it with
`asmtomem.py` after editing the assembly. Image data occupies addresses
500–1523, within the codemaker's 2048-word memory.

A software instruction trace of the assembled original and diagnostic programs
confirmed identical 17 command bytes and 1024 image bytes. This is not a physical
timing measurement or validation of the silicon's instruction implementation.

If this version works, investigate the original's shift operations and differences
in transmission spacing. If it also fails, check uploaded memory and capture CS,
D/C, SCK, and MOSI during initialization and image transfer. The loader's success
message alone does not establish that the display received the image correctly.
