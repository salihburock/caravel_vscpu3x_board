0: BZJi 3 20 // Goto init
//$REGISTERS_SECTION
1: 276 // SP
2: 276 // BP
3: 0 // CONST_ZERO
4: 1 // CONST_ONE
5: 0 // CONST_NEG_ONE (computed)
6: 0 // reserved
7: 0 // reserved
8: 0 // reserved
9: 0 // reserved
10: 0 // reserved
11: 0 // reserved
12: 0 // reserved
13: 0 // reserved
14: 0 // TEMP1
15: 0 // TEMP2
16: 0 // TEMP3
17: 0 // TEMP4
18: 0 // TEMP5
19: 0 // TEMP6
//$TEXT_SECTION
20: NAND 5 3 // CONST_NEG_ONE = ~(0&0)
21: BZJi 3 91 // Goto main
22: CP 14 3 // constant 0
23: CP 265 14 // $local.spi_byte.21
24: CP 14 265 // $local.spi_byte.21
25: LTi 14 8 // <constant
26: CPi 18 83 // wh exit (P)
27: BZJ 18 14 // wh exit
28: CP 18 2 // dc
29: ADDi 18 16381 // off
30: CPI 14 18 // ld
31: CP 266 14 // $local.spi_byte.22
32: CP 18 2 // value
33: ADDi 18 16380 // off
34: CPI 14 18 // ld
35: NANDi 14 128 // constant mask
36: NAND 14 14 // and
37: CPi 18 53 // if else (P)
38: BZJ 18 14 // if else
39: CP 14 266 // $local.spi_byte.22
40: CPIi 1 14 // push lhs
41: ADDi 1 1 // SP++
42: CP 14 4 // constant 1
43: CP 15 14 // rhs
44: ADD 1 5 // SP--
45: CPI 14 1 // pop lhs
46: CP 16 14 // or
47: NAND 16 16 // ~a
48: CP 17 15
49: NAND 17 17 // ~b
50: NAND 16 17 // a|b
51: CP 14 16
52: CP 266 14 // $local.spi_byte.22
53: CP 14 266 // $local.spi_byte.22
54: CP 8254 14 // direct pointer store
55: CP 14 266 // $local.spi_byte.22
56: CPIi 1 14 // push lhs
57: ADDi 1 1 // SP++
58: CPi 14 2 // constant low
59: CP 15 14 // rhs
60: ADD 1 5 // SP--
61: CPI 14 1 // pop lhs
62: CP 16 14 // or
63: NAND 16 16 // ~a
64: CP 17 15
65: NAND 17 17 // ~b
66: NAND 16 17 // a|b
67: CP 14 16
68: CP 8254 14 // direct pointer store
69: CP 14 266 // $local.spi_byte.22
70: CP 8254 14 // direct pointer store
71: CP 18 2 // value
72: ADDi 18 16380 // off
73: CPI 14 18 // ld
74: SRLi 14 33 // constant shift
75: CP 18 2 // value
76: ADDi 18 16380 // off
77: CPIi 18 14 // st
78: CP 14 265 // $local.spi_byte.21
79: ADDi 14 1 // +constant
80: CP 265 14 // $local.spi_byte.21
81: CPi 18 24 // wh loop
82: BZJ 18 3 // loop
83: CP 1 2 // SP=BP
84: ADD 1 5 // SP--
85: CPI 2 1 // pop old BP
86: ADD 1 5 // SP--
87: CPI 15 1 // pop RA
88: CPIi 1 3 // push ret 0
89: ADDi 1 1 // SP++
90: BZJ 15 3 // return
91: CPi 14 4 // constant low
92: CP 8254 14 // direct pointer store
93: CP 14 3 // constant 0
94: CP 8254 14 // direct pointer store
95: CP 14 3 // constant 0
96: CP 267 14 // $local.main.81
97: CP 14 267 // $local.main.81
98: LTi 14 17 // <constant
99: CPi 18 131 // wh exit (P)
100: BZJ 18 14 // wh exit
101: CPi 18 248 // init_commands
102: CPIi 1 18 // push base
103: ADDi 1 1 // SP++
104: CP 14 267 // $local.main.81
105: ADD 1 5 // SP--
106: CPI 18 1 // pop base
107: ADD 18 14 // +idx
108: CPI 14 18 // ld[]
109: CPIi 1 14 // push a0
110: ADDi 1 1 // SP++
111: CP 14 3 // constant 0
112: CPIi 1 14 // push a1
113: ADDi 1 1 // SP++
114: CPi 18 122 // RA(P)
115: CPIi 1 18 // push RA
116: ADDi 1 1 // SP++
117: CPIi 1 2 // push old BP
118: ADDi 1 1 // SP++
119: CP 2 1 // BP=SP
120: CPi 18 22 // spi_byte
121: BZJ 18 3 // spi_byte
122: ADD 1 5 // SP--
123: CPI 14 1 // pop ret
124: ADD 1 5 // pop arg
125: ADD 1 5 // pop arg
126: CP 14 267 // $local.main.81
127: ADDi 14 1 // +constant
128: CP 267 14 // $local.main.81
129: CPi 18 97 // wh loop
130: BZJ 18 3 // loop
131: CPi 14 4 // constant low
132: CP 270 14 // $local.main.84
133: CP 14 4 // constant 1
134: CPi 18 230 // wh exit (P)
135: BZJ 18 14 // wh exit
136: CP 14 8255 // direct pointer load
137: CP 268 14 // $local.main.82
138: CP 14 268 // $local.main.82
139: NANDi 14 1 // constant mask
140: NAND 14 14 // and
141: CP 269 14 // $local.main.83
142: CP 14 269 // $local.main.83
143: LTi 14 1 // equal zero
144: LTi 14 1 // not
145: CPi 18 155 // if else (P)
146: BZJ 18 14 // if else
147: CP 14 270 // $local.main.84
148: LTi 14 1 // <=constant
149: LTi 14 1 // not
150: CPi 18 155 // if else (P)
151: BZJ 18 14 // if else
152: CP 14 270 // $local.main.84
153: ADD 14 5 // -1
154: CP 270 14 // $local.main.84
155: CP 14 269 // $local.main.83
156: LTi 14 1 // <constant
157: CPi 18 166 // if else (P)
158: BZJ 18 14 // if else
159: CP 14 270 // $local.main.84
160: LTi 14 7 // <constant
161: CPi 18 166 // if else (P)
162: BZJ 18 14 // if else
163: CP 14 270 // $local.main.84
164: ADDi 14 1 // +constant
165: CP 270 14 // $local.main.84
166: CP 14 270 // $local.main.84
167: SRLi 14 39 // constant shift
168: ADDi 14 60 // +constant
169: CP 271 14 // $local.main.85
170: CP 14 271 // $local.main.85
171: ADDi 14 8 // +constant
172: CP 272 14 // $local.main.86
173: CP 14 3 // constant 0
174: CP 267 14 // $local.main.81
175: CP 14 267 // $local.main.81
176: LTi 14 1024 // <constant
177: CPi 18 228 // wh exit (P)
178: BZJ 18 14 // wh exit
179: CP 14 3 // constant 0
180: CP 273 14 // $local.main.87
181: CP 14 267 // $local.main.81
182: CPIi 1 14 // push lhs
183: ADDi 1 1 // SP++
184: CP 14 271 // $local.main.85
185: ADD 14 5 // -1
186: CP 15 14 // rhs
187: ADD 1 5 // SP--
188: CPI 14 1 // pop lhs
189: LT 15 14 // >
190: CP 14 15
191: CPi 18 205 // if else (P)
192: BZJ 18 14 // if else
193: CP 14 267 // $local.main.81
194: CPIi 1 14 // push lhs
195: ADDi 1 1 // SP++
196: CP 14 272 // $local.main.86
197: CP 15 14 // rhs
198: ADD 1 5 // SP--
199: CPI 14 1 // pop lhs
200: LT 14 15 // <
201: CPi 18 205 // if else (P)
202: BZJ 18 14 // if else
203: CPi 14 255 // constant low
204: CP 273 14 // $local.main.87
205: CP 14 273 // $local.main.87
206: CPIi 1 14 // push a0
207: ADDi 1 1 // SP++
208: CPi 14 8 // constant low
209: CPIi 1 14 // push a1
210: ADDi 1 1 // SP++
211: CPi 18 219 // RA(P)
212: CPIi 1 18 // push RA
213: ADDi 1 1 // SP++
214: CPIi 1 2 // push old BP
215: ADDi 1 1 // SP++
216: CP 2 1 // BP=SP
217: CPi 18 22 // spi_byte
218: BZJ 18 3 // spi_byte
219: ADD 1 5 // SP--
220: CPI 14 1 // pop ret
221: ADD 1 5 // pop arg
222: ADD 1 5 // pop arg
223: CP 14 267 // $local.main.81
224: ADDi 14 1 // +constant
225: CP 267 14 // $local.main.81
226: CPi 18 175 // wh loop
227: BZJ 18 3 // loop
228: CPi 18 133 // wh loop
229: BZJ 18 3 // loop
230: CP 14 3 // constant 0
231: CP 1 2 // SP=BP
232: ADD 1 5 // SP--
233: CPI 2 1 // pop old BP
234: ADD 1 5 // SP--
235: CPI 15 1 // pop RA
236: CPIi 1 14 // push ret
237: ADDi 1 1 // SP++
238: BZJ 15 3 // return
239: CP 1 2 // SP=BP
240: ADD 1 5 // SP--
241: CPI 2 1 // pop old BP
242: ADD 1 5 // SP--
243: CPI 15 1 // pop RA
244: CPIi 1 3 // push ret 0
245: ADDi 1 1 // SP++
246: BZJ 15 3 // return
247: BZJi 3 247 // HALT
//$DATA_SECTION
248: 174 // g'init_commands'[0]
249: 32 // g'init_commands'[1]
250: 0 // g'init_commands'[2]
251: 33 // g'init_commands'[3]
252: 0 // g'init_commands'[4]
253: 127 // g'init_commands'[5]
254: 34 // g'init_commands'[6]
255: 0 // g'init_commands'[7]
256: 7 // g'init_commands'[8]
257: 129 // g'init_commands'[9]
258: 207 // g'init_commands'[10]
259: 161 // g'init_commands'[11]
260: 200 // g'init_commands'[12]
261: 166 // g'init_commands'[13]
262: 141 // g'init_commands'[14]
263: 20 // g'init_commands'[15]
264: 175 // g'init_commands'[16]
265: 0 // g'$local.spi_byte.21'
266: 0 // g'$local.spi_byte.22'
267: 0 // g'$local.main.81'
268: 0 // g'$local.main.82'
269: 0 // g'$local.main.83'
270: 0 // g'$local.main.84'
271: 0 // g'$local.main.85'
272: 0 // g'$local.main.86'
273: 0 // g'$local.main.87'
274: 247 // $RA_main
275: 0 // $OLDBP_main
//$STACK_SECTION // $BASE_main = 276
