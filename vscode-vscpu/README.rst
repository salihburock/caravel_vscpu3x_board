VSCPU Tools for Visual Studio Code
=================================

Install the local VSIX with Extensions: Install from VSIX, then open an .asm
file. If another assembly extension owns the file, select VSCPU Assembly from
Change Language Mode. This extension associates .asm with VSCPU by default;
use files.associations to restrict it to your VSCPU workspace if needed.

Features
--------

* Syntax highlighting, instruction completion, hover descriptions and live errors.
* VSCPU: Select Target Core sets CM (2048 words), CT (2560), or A0 (1536).
* VSCPU: Assemble Current File to .mem validates the entire source before saving.
* VSCPU: Assemble and Upload Current File uploads only the selected core and
  checks every word again after the entire upload. Core selection is MANUAL on
  the board; the protocol cannot determine whether the switches match your choice.

UART upload requires Python 3 with pyserial installed. Set vscpu.pythonPath to
that interpreter (a virtual environment is fine). Choose a detected device in the UART dropdown. vscpu.serialPort sets the
preferred device. The dropdown refreshes every second while open, showing USB
manufacturer/product descriptions and IDs when supplied by the OS. Linux lists
ttyUSB and ttyACM devices; Windows lists available COM ports. Discovery never
opens a port. In remote VS Code sessions, ports belong to the extension host. Upload uses 57600 baud, 8N1. The bundled uploader is independent
of this repository's run_test.py and does not need the repository installed.
No compiler, Node packages or Python are needed for editing/assembly.

Upload workflow
---------------

1. Open the desired .asm; select the target core with VSCPU: Select Target Core.
2. Run VSCPU: Assemble and Upload Current File and select the UART port.
3. Select mode 01 for CM, 10 for CT, or 11 for A0; wait for the board to settle.
4. Click Ready — Upload. Keep the mode unchanged until complete readback passes.
5. Select 00 to run, keeping power on. Verified memory does not prove execution.

The extension never flashes management firmware, clears all SRAM, or uploads
other cores automatically. Other cores may still contain old code. A cancelled
or failed upload can leave a partial image; upload again before running.
The board still needs working management firmware (the corrected repair build).

Assembly format
---------------

Word addresses and operands are decimal by default; explicit 0x hex and 0b binary
literals are also supported. Mnemonics are case-sensitive. Two operands are
required, separated by whitespace or one comma. Comments begin with //.

    0: CPi 48 1234
    1: CPi 8254 15
    2: BZJi 32 0
    32: 2
    48: 0

Data is unsigned 32-bit. Instruction operands are 14-bit. Image addresses must
fit the selected core. Output .mem uses decimal @address directives, matching
this repository's UART loader; it is not generic hexadecimal-address readmemh.
Symbols/macros are not supported. MMIO: 8254 GPIO output; 8255 GPIO input.

Development and validation
--------------------------

Run npm test in this directory. Tests compare assembly output to existing board
images, check malformed input and SRAM bounds, and exercise UART retries and
late memory corruption with a fake serial endpoint. Physical upload through the
extension still requires a board test. Use an Extension Development Host to
check the editor UI. Packaging follows VS Code's VSIX workflow:
https://code.visualstudio.com/api/working-with-extensions/publishing-extension

Source is supplied for local use; this extension has not been published to the
Marketplace and no public publisher identity is claimed.
