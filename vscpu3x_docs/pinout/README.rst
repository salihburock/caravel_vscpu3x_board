Custom CH340 carrier pinout
==========================

vscpu_carrier_pinout.png is the display/share image; the PDF is scalable for
printing and the SVG is editable. connector_pinout.csv contains the J1/J3 table.
The illustration uses vscpu3x_docs/topview.svg, with the M.2 module removed and the
USB connector at the bottom. Bottom-mounted header holes are shown from above;
do not treat it as a bottom-view drawing.

Sources
-------

* vscpu3x_docs/topview.svg: supplied top-view artwork. The generator crops the drawing
  sheet in an embedded copy and scales it to align with the extracted PCB pad
  coordinates. The source SVG is not modified.
* https://github.com/ebubekirtascieee/VSCPU_Efabless-M.2_Test_Board_Two_Layers
  Main.PcbDoc: Components6, Nets6 and Pads6 records. carrier_pads.json retains
  the extracted pad numbers, nets and absolute coordinates in mils.
* hardware/breakout/caravel-M.2-card-QFN/caravel-M.2-card-QFN.kicad_sch in this
  repository: M.2 connector to Caravel IO and QFN package pin mapping. A KiCad
  XML netlist was exported to verify the connection mapping.
* caravel_vscpu3x/verilog/rtl/user_project_wrapper.v: VSCPU gpio_in is IO16..26,
  gpio_out is IO27..37; program_sel is IO10:9 and reset input is IO8.

The carrier J2 pad nets confirm IO24-to-IO8, IO25-to-IO9, IO26-to-IO10, and the
shared management/user UART nets. GPIO_OUT_0 is output bit 3 (IO30), not bit 0.
Pin numbers in the QFN column refer to the silicon package, not the M.2 edge.
P1 and P2 positions/nets are also extracted from the PCB data. SW1 is the reset
pushbutton designator; SW2 is the two-bit mode selector designator.

UART jumper populations must be checked on the assembled board. The diagram
describes the source design; it does not establish which resistors are fitted.
Pin capabilities shown are those of this VSCPU design and current carrier wiring,
not hypothetical alternate peripheral functions.

Edit and export
---------------

The edited vscpu_carrier_pinout.svg is the authoritative illustration. Edit it
directly to preserve the manual annotations and layout. Its embedded board uses
cream solder mask, a red mode switch, silver metalwork and dark chip housings,
matching the supplied board reference. The reset waveform is illustrative
and not to scale.

Export from the repository root::

    inkscape vscpu3x_docs/pinout/vscpu_carrier_pinout.svg --export-type=png --export-filename=vscpu3x_docs/pinout/vscpu_carrier_pinout.png
    inkscape vscpu3x_docs/pinout/vscpu_carrier_pinout.svg --export-type=pdf --export-filename=vscpu3x_docs/pinout/vscpu_carrier_pinout.pdf

draw_pinout.py is the original layout generator; running it overwrites subsequent
manual edits. It is retained for the original extraction/layout logic only.
The pinout is a reference illustration, not manufacturing data.

Using the GPIO labels
---------------------

W8254[n] means bit n of decimal word address 8254, the GPIO output
register. W8255[n] means bit n of the GPIO input register. This notation
is a diagram convention, not literal C or assembly syntax. The PCB net
label suffix is not the register bit number; use the bit shown in the table.

For example, ``CPi 8254 8`` sets J3.4 / GPIO_OUT_0 / IO30 high and all
other GPIO output bits low. ``CP 48 8255`` followed by ``ANDi 48 1``
reads J3.2 / GPIO_IN_1 / IO16 into RAM word 48 as 0 or 1. Reserve that
RAM word when incorporating the example into an application. Use mask 2
instead of 1 for J3.3 / IO17. Inputs use 3.3 V logic and a common ground.

For a complete C and assembly example, see
``vscpu3x_apps/gpio_quadrature/README.rst`` and
``vscpu3x_apps/gpio_quadrature/gpio_quadrature_cm.c``. That application
mirrors both inputs to outputs and generates two phase-shifted outputs.
