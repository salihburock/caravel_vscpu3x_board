# Quickstart Guide
This document explains how to create an example test environment for VSCPU3x.
## Hardware Configuration
Follow the schematic to make proper connections for our example test environment.

![Schematic](VSCPU3x_Connections.png)

**Note:** Make sure that you connect `*_SYNC` pins properly, they are essential for avoiding switching glitches.
## Firmware
The firmware is already flashed on the board, and reflashing it needs an FTDI
programmer, so **most users can skip this section**. If you do need to rebuild
it, connect your computer to caravel board and run the terminal commands.
```bash
cd firmware/vscpu3x/vscpu3x_test

make clean flash
```
## VSCPU3x Software
Applications are uploaded over the board's USB serial port, so no programmer
hardware is needed here. To run tests on VerySimpleCPU, you should first program the cores. To physically enable this, you need to switch `PGM_SEL_SW` bits accordingly.

| PGM_SEL_SW | Explanation |
|------------|------------|
| 2'b00      | Run all cores|
| 2'b01      | Program or read codemaker core memory|
| 2'b10      | Program or read control tower core memory|
| 2'b11      | Program or read agent 0 core memory|

**Important Note:** Change one switch at a time, so that `PGM_SEL_SW` never passes through `2'b00` while you move between cores: from `2'b01` to `2'b10`, go through `2'b11`. Passing through `2'b00` starts the cores before all of them are programmed. `run_test.py` programs the cores in the order codemaker, control tower, agent 0.

To run a test on VSCPU cores, please run the following terminal commands.

```bash
cd vscpu3x_apps/utils

# Usage: 
#   test_name: Test name, e.g. oled_test
#   uart_device: Path to UART device, e.g. /dev/ttyUSB0
#   --memclear: Zero the core memory before uploading. Needed the first time and
#               when the new program is shorter than the old one, so that leftover
#               words do not run. Omit it to save time.
python3 run_test.py <test_name> <uart_device> [--memclear]
```
The file naming convention in tests are given below.
- test_name: Name of the folder and prefix of the files. e.g. `oled_test`
- processor_name: Can be `cm`, `ct`, `a0` for codemaker, control tower, agent 0 respectively.

With these naming, explanation of the files that you might find in the test folder is like below.
- `<test_name>_<processor_name>.asm`: VSCPU assembly file.
- `<test_name>_<processor_name>.mem`: VSCPU memory file for writing into core memories.
- `<test_name>_<processor_name>_chk.mem`: VSCPU check file for checking memory after the program has run.

If you have asm files to convert into mem files, please run asmtomem.py as instructed below

```bash
cd vscpu3x_apps/utils

# Usage: 
#   asm_file: Assembly file name, e.g. ../oled_test/oled_test_cm.asm.
#             Make sure you have written file path properly, and it is a .asm file, otherwise it will complain.
python3 asmtomem.py <asm_file>
```

## GPIO (memory-mapped I/O)

A VSCPU program reaches the outside world through two memory-mapped registers.
**They are at different addresses**, and reading the output address gives back
the last value written to it, not the inputs.

```c
#define GPIO_OUT (*((unsigned int *)8254))   /* write */
#define GPIO_IN  (*((unsigned int *)8255))   /* read  */
```

| Register | Address | Bit n | Pads |
|---|---|---|---|
| GPIO out | 8254 | drives IO(27 + n) | IO27-IO37 |
| GPIO in | 8255 | reads IO(16 + n) | IO16-IO26 |

Of those, the board brings four outputs and two inputs out to the J3 header:

| J3 pin | Board net | Pad | Register bit |
|---|---|---|---|
| 1 | +3.3 V | | |
| 2 | `GPIO_IN_1` | IO16 | 8255 bit 0 |
| 3 | `GPIO_IN_0` | IO17 | 8255 bit 1 |
| 4 | `GPIO_OUT_0` | IO30 | 8254 bit 3 |
| 5 | `GPIO_OUT_1` | IO29 | 8254 bit 2 |
| 6 | `GPIO_OUT_2` | IO28 | 8254 bit 1 |
| 7 | `GPIO_OUT_3` | IO27 | 8254 bit 0 |
| 8 | GND | | |

The number in a board net name is not the register bit: use the last column.

See `vscpu3x_apps/gpio_test` for a small example that uses both
directions: it relays the two inputs to two outputs and drives the other two as
a quadrature pair.
