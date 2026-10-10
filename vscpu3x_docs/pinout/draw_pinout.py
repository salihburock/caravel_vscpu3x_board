"""Render the carrier pinout from extracted Altium pad positions/nets.
Coordinates are mils in the source PCB; top view is x right, y up.
"""
import json, csv, base64
import xml.etree.ElementTree as ET
from pathlib import Path
from html import escape as e
P=Path(__file__).resolve().parent
pads=json.loads((P/'carrier_pads.json').read_text())
C={'power':'#ef6262','ground':'#728397','input':'#46bcdf','output':'#93d45a','spi':'#e983b7','uart':'#b79beb','control':'#ffc568'}
out=['<svg xmlns="http://www.w3.org/2000/svg" width="1900" height="1600" viewBox="0 0 1900 1600">', '<rect width="1900" height="1600" fill="#101820"/>','<style>text{font-family:DejaVu Sans,sans-serif;fill:#eef4f7} .muted{fill:#a5b6c5}</style>']
def rect(x,y,w,h,fill,stroke='none',rx=0,dash=''):
 out.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" stroke="{stroke}" stroke-width="2" stroke-dasharray="{dash}"/>')
def text(x,y,s,size=20,fill=None,anchor='start',weight='normal'):
 out.append(f'<text x="{x}" y="{y}" font-size="{size}" text-anchor="{anchor}" font-weight="{weight}"'+(f' style="fill:{fill}"' if fill else '')+f'>{e(s)}</text>')
def line(x,y,X,Y,color='#526b7b',width=2):out.append(f'<path d="M{x},{y} L{X},{Y}" fill="none" stroke="{color}" stroke-width="{width}"/>')
def xy(p):return 820+(p['x']-389.7638)*.32,210+(3543.3071-p['y'])*.32
text(70,74,'VSCPU / CARAVEL',40,weight='bold')
text(70,118,'Custom CH340 carrier • connector pinout',27)
text(70,157,'Two-layer PCB · top view · M.2 module removed · USB connector at bottom',19,'#a5b6c5')
# Keep the supplied SVG unchanged; crop the drawing sheet in an embedded copy.
# The board outline in topview.svg spans x=479.8..764.3, y=190.5..1200.5.
# Include the USB body below the PCB edge. Scale to the PCB mil coordinates.
board = ET.parse(P.parent / 'topview.svg').getroot()
board.set('viewBox', '479.8 190.5 284.5 1110')
board.set('width', '284.5'); board.set('height', '1110')
# Replace the drawing's red raster tint with vector material colors. Keep the
# supplied placement/outline geometry; do not modify vscpu3x_docs/topview.svg.
ns = '{http://www.w3.org/2000/svg}'
for parent in board.iter():
    for element in list(parent):
        if element.get('id') == 'image3':
            parent.remove(element)
for element in board.iter():
    style = element.get('style', '')
    if element.tag == ns+'path':
        element.set('style', style.replace('stroke:#000000', 'stroke:#bdcbbf')
                    .replace('fill:#000000', 'fill:#e4e9df'))
materials = ET.Element(ns+'g', {'id':'material-colors'})
def material(x,y,w,h,color,r=0):
    ET.SubElement(materials, ns+'rect', dict(x=str(x),y=str(y),width=str(w),height=str(h),fill=color,rx=str(r)))
material(479.8,190.5,284.5,1009,'#176244')
# Black connector housings, silver metal cans and plated component leads.
material(484,538,278,99,'#20282c',3)       # M.2 socket
material(489,720,66,150,'#b9c2c5',12)     # crystal can
material(567,196,127,79,'#d3d2c3',3)      # mode switch housing
material(609,203,46,14,'#2b3033',2)
material(609,243,46,14,'#2b3033',2)
material(688,814,40,58,'#aeb9be',6)       # reset pushbutton
material(694,824,28,32,'#333d41',12)
material(549,1092,151,207,'#b7c0c5',4)    # USB shield
material(564,1277,121,22,'#263036',2)
material(609,919,45,83,'#252c30',2)       # regulator housing
material(588,931,22,10,'#bac4c7')
material(588,954,22,10,'#bac4c7')
material(588,977,22,10,'#bac4c7')
material(654,940,24,35,'#bac4c7')
# U1 flash: SOP-8 body and four leads on each side.
material(691,694,66,67,'#252b30',3)
for px in [697,713,729,745]:
    material(px,678,7,17,'#c3c9ce')
    material(px,760,7,17,'#c3c9ce')
# Source linework is above these material fills.
board.insert(1, materials)
(P/'board_top_realistic.svg').write_bytes(ET.tostring(board))
encoded = base64.b64encode(ET.tostring(board)).decode('ascii')

out.append(f'<image x="820" y="210" width="283.46" height="1105.95" href="data:image/svg+xml;base64,{encoded}"/>')
text(976,620,'J2 · M.2',17,'#eef4f7',anchor='middle',weight='bold')
text(987,885,'RST',16,'#eef4f7',anchor='middle',weight='bold')
text(1012,1195,'USB',17,'#101820',anchor='middle',weight='bold')
text(1063,747,'Flash',17,'#ffffff',anchor='middle',weight='bold')
# Headers: verified by Pads6 net membership + module connector netlist.
data={
'J3':[(1,'+3.3V','3.3 V rail','power',''),(2,'GPIO_IN_1','IO16 · VSCPU input bit 0','input','53'),(3,'GPIO_IN_0','IO17 · VSCPU input bit 1','input','54'),(4,'GPIO_OUT_0','IO30 · VSCPU output bit 3','output','7'),(5,'GPIO_OUT_1','IO29 · VSCPU output bit 2','output','6'),(6,'GPIO_OUT_2','IO28 · VSCPU output bit 1','output','5'),(7,'GPIO_OUT_3','IO27 · VSCPU output bit 0','output','4'),(8,'GND','Ground','ground','')],
'J1':[(1,'GND','Ground','ground',''),(2,'SDO','IO1 · Caravel → host','spi','32'),(3,'SDI','IO2 · Host → Caravel','spi','33'),(4,'CS','IO3 · Active-low SPI select','spi','34'),(5,'SCK','IO4 · Housekeeping SPI clock','spi','35'),(6,'RV_TX','IO6 / IO11 · See UART note','uart','37 / 45'),(7,'RV_RX','IO5 / IO12 · See UART note','uart','36 / 46'),(8,'+3.3V','3.3 V rail','power','')]}
rows=[]
for ref,entries in data.items():
 pp={int(p['pin']):p for p in pads if p['ref']==ref};x,y=xy(pp[1]);heading=y-53
 text(70,heading,ref+'  /  '+('APPLICATION GPIO' if ref=='J3' else 'PROGRAMMING + UART'),26,weight='bold')
 text(740,heading,'QFN pin',16,'#a5b6c5',anchor='middle')
 for n,net,desc,kind,qfn in entries:
  p=pp[n];assert p['net']==net,(ref,n,p,net)
  x,y=xy(p);color=C[kind]
  rect(70,y-14,175,28,color,rx=4);text(81,y+6,net,16,'#101820',weight='bold')
  text(263,y+6,desc,18);text(741,y+6,qfn or '—',17,'#a5b6c5',anchor='middle')
  line(788,y,x-12,y,color)
  if n==1:rect(x-9,y-9,18,18,'#d9bb69',rx=1)
  else:out.append(f'<circle cx="{x}" cy="{y}" r="9" fill="#d9bb69"/>')
  out.append(f'<circle cx="{x}" cy="{y}" r="4" fill="#101820"/>')
  rect(x-32,y-12,19,24,'#101820',rx=3)
  text(x-22.5,y+6,str(n),16,anchor='middle',weight='bold')
  rows.append([ref,n,net,desc,qfn])
# Right-side callouts
text(1190,235,'MODE + RESET',25,weight='bold')
text(1190,270,'SW2: two-bit selector',21,C['control'])
for i,s in enumerate(['00  Run','01  Program codemaker (CM)','10  Program control tower (CT)','11  Program agent 0 (A0)']):text(1190,308+i*31,s,19)
text(1190,449,'Logical bits, not a drawing of switch positions.',17,'#a5b6c5')
text(1190,487,'P1 · mode signal header (underside)',20,C['control'])
for n,s in [(2,'IO22 · SW bit 0 · QFN 60'),(1,'IO23 · SW bit 1 · QFN 61')]:
 p=next(p for p in pads if p['ref']=='P1' and p['pin']==str(n));x,y=xy(p)
 out.append(f'<circle cx="{x}" cy="{y}" r="8" fill="{C["control"]}"/>');text(x-17,y+6,str(n),15,'#eef4f7',anchor='end')
text(1190,520,'P1.1 → IO23 [QFN 61] · P1.2 → IO22 [60]',18)
text(1080,260,'P1',16,'#eef4f7',anchor='middle')
text(1190,565,'SW1 / RST: active-low management reset',20,C['control'])
text(1190,596,'RV_RST → QFN 21. Not the VSCPU reset input.',18)
text(1190,651,'Firmware-driven links on this PCB',21,weight='bold')
for i,s in enumerate(['IO24 [QFN 62] → IO8 [42] · VSCPU reset','IO25 [QFN 2] → IO9 [43] · mode bit 0','IO26 [QFN 3] → IO10 [44] · mode bit 1']):text(1190,686+32*i,s,18)
text(1190,818,'POWER',25,weight='bold')
text(1190,852,'P2.1 = +5V_USB     P2.2 = GND',20,C['power'])
for n in [1,2]:
 p=next(p for p in pads if p['ref']=='P2' and p['pin']==str(n));x,y=xy(p)
 out.append(f'<circle cx="{x}" cy="{y}" r="8" fill="{C["power"] if n==1 else C["ground"]}"/>');text(x-17,y+6,str(n),15,'#eef4f7',anchor='end')
text(1080,1035,'P2',16,'#eef4f7',anchor='middle')
for i,s in enumerate(['J1.8 and J3.1 connect directly to the 3.3 V rail.','Onboard regulators: 5 V → 3.3 V → 1.8 V.','Do not apply 5 V to a 3.3 V pin or GPIO.','Do not tie independent power supplies together.']):text(1190,888+30*i,s,18,'#c2d0da')
text(1190,1062,'UART ROUTING',25,weight='bold')
for i,s in enumerate(['J1.6 / RV_TX joins IO6 (management TX)','to IO11 (VSCPU RX).','J1.7 / RV_RX joins IO5 (management RX)','to IO12 (VSCPU TX).','R11/R15: CH340 ↔ VSCPU UART.','R13/R14: alternative management UART route.','Fit one routing pair; firmware must match it.']):text(1190,1100+29*i,s,18,C['uart'] if i in [4,5] else '#c2d0da')
line(70,1375,1830,1375)
for i,(name,key) in enumerate([('Power','power'),('Ground','ground'),('GPIO input','input'),('GPIO output','output'),('SPI','spi'),('UART','uart'),('Control','control')]):
 x=70+i*246;rect(x,1402,18,18,C[key],rx=3);text(x+29,1418,name,18)
text(70,1468,'Orientation: this is the top view. J1/J3 and P1/P2 are bottom-mounted; their through-hole positions are shown from above.',18,'#a5b6c5')
text(70,1500,'GPIO labels are the PCB net names. IO numbers are Caravel signals; QFN numbers identify pins of the 64-pin silicon package.',18,'#a5b6c5')
text(70,1532,'Board artwork: vscpu3x_docs/topview.svg. Pin mapping: Main.PcbDoc + Caravel M.2 QFN schematic + VSCPU RTL.',18,'#a5b6c5')
text(70,1570,'VSCPU_TestBoard_v2 · pinout reference',16,'#8199ac');text(1830,1570,'2026-10-05',16,'#8199ac',anchor='end')
out.append('</svg>');(P/'vscpu_carrier_pinout.svg').write_text('\n'.join(out))
with (P/'connector_pinout.csv').open('w') as f:
 w=csv.writer(f);w.writerow(['Connector','Pin','PCB net','Function / Caravel IO','QFN package pin']);w.writerows(rows)
