0: BZJi 3 20 // Goto init
//$REGISTERS_SECTION
1: 727 // SP
2: 727 // BP
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
21: BZJi 3 154 // Goto main
22: CP 14 3 // 0
23: CPi 18 722 // spi_byte.count
24: CPIi 18 14 // spi_byte.count
25: CPi 18 722 // spi_byte.count
26: CPI 14 18 // spi_byte.count
27: CPIi 1 14 // push lhs
28: ADDi 1 1 // SP++
29: CPi 14 8 // 8
30: CP 15 14 // rhs
31: ADD 1 5 // SP--
32: CPI 14 1 // pop lhs
33: LT 14 15 // <
34: CPi 18 146 // for exit (P)
35: BZJ 18 14 // for exit
36: CP 18 2 // dc
37: ADDi 18 16381 // off
38: CPI 14 18 // ld
39: CPi 18 723 // spi_byte.pins
40: CPIi 18 14 // spi_byte.pins
41: CP 18 2 // value
42: ADDi 18 16380 // off
43: CPI 14 18 // ld
44: CPIi 1 14 // push lhs
45: ADDi 1 1 // SP++
46: CPi 14 128 // 128
47: CP 15 14 // rhs
48: ADD 1 5 // SP--
49: CPI 14 1 // pop lhs
50: LT 14 15 // a<b
51: CPi 18 56 // lnot (P)
52: BZJ 18 14 // lnot
53: CPi 14 0 // nz->0
54: CPi 18 57 // lnot end (P)
55: BZJ 18 3 // lnot end
56: CPi 14 1 // z->1
57: CPi 18 86 // if else (P)
58: BZJ 18 14 // if else
59: CPi 18 723 // spi_byte.pins
60: CPI 14 18 // spi_byte.pins
61: CPIi 1 14 // push lhs
62: ADDi 1 1 // SP++
63: CP 14 4 // 1
64: CP 15 14 // rhs
65: ADD 1 5 // SP--
66: CPI 14 1 // pop lhs
67: ADD 14 15 // +
68: CPi 18 723 // spi_byte.pins
69: CPIi 18 14 // spi_byte.pins
70: CP 18 2 // value
71: ADDi 18 16380 // off
72: CPI 14 18 // ld
73: CPIi 1 14 // push lhs
74: ADDi 1 1 // SP++
75: CPi 14 128 // 128
76: CP 15 14 // rhs
77: ADD 1 5 // SP--
78: CPI 14 1 // pop lhs
79: CP 16 15 // sub
80: NAND 16 16 // ~
81: ADDi 16 1 // -src
82: ADD 14 16 // a-b
83: CP 18 2 // value
84: ADDi 18 16380 // off
85: CPIi 18 14 // st
86: CPi 18 723 // spi_byte.pins
87: CPI 14 18 // spi_byte.pins
88: CPIi 1 14 // push val
89: ADDi 1 1 // SP++
90: CPi 14 8254 // 8254
91: CP 18 14 // addr
92: ADD 1 5 // SP--
93: CPI 14 1 // pop val
94: CPIi 18 14 // *=
95: CPi 18 723 // spi_byte.pins
96: CPI 14 18 // spi_byte.pins
97: CPIi 1 14 // push lhs
98: ADDi 1 1 // SP++
99: CPi 14 2 // 2
100: CP 15 14 // rhs
101: ADD 1 5 // SP--
102: CPI 14 1 // pop lhs
103: ADD 14 15 // +
104: CPIi 1 14 // push val
105: ADDi 1 1 // SP++
106: CPi 14 8254 // 8254
107: CP 18 14 // addr
108: ADD 1 5 // SP--
109: CPI 14 1 // pop val
110: CPIi 18 14 // *=
111: CPi 18 723 // spi_byte.pins
112: CPI 14 18 // spi_byte.pins
113: CPIi 1 14 // push val
114: ADDi 1 1 // SP++
115: CPi 14 8254 // 8254
116: CP 18 14 // addr
117: ADD 1 5 // SP--
118: CPI 14 1 // pop val
119: CPIi 18 14 // *=
120: CP 18 2 // value
121: ADDi 18 16380 // off
122: CPI 14 18 // ld
123: CPIi 1 14 // push lhs
124: ADDi 1 1 // SP++
125: CPi 14 2 // 2
126: CP 15 14 // rhs
127: ADD 1 5 // SP--
128: CPI 14 1 // pop lhs
129: MUL 14 15 // *
130: CP 18 2 // value
131: ADDi 18 16380 // off
132: CPIi 18 14 // st
133: CPi 18 722 // spi_byte.count
134: CPI 14 18 // spi_byte.count
135: CPIi 1 14 // push lhs
136: ADDi 1 1 // SP++
137: CP 14 4 // 1
138: CP 15 14 // rhs
139: ADD 1 5 // SP--
140: CPI 14 1 // pop lhs
141: ADD 14 15 // +
142: CPi 18 722 // spi_byte.count
143: CPIi 18 14 // spi_byte.count
144: CPi 18 25 // for
145: BZJ 18 3 // loop
146: CP 1 2 // SP=BP
147: ADD 1 5 // SP--
148: CPI 2 1 // pop old BP
149: ADD 1 5 // SP--
150: CPI 15 1 // pop RA
151: CPIi 1 3 // push ret 0
152: ADDi 1 1 // SP++
153: BZJ 15 3 // return
154: CPi 14 4 // 4
155: CPIi 1 14 // push val
156: ADDi 1 1 // SP++
157: CPi 14 8254 // 8254
158: CP 18 14 // addr
159: ADD 1 5 // SP--
160: CPI 14 1 // pop val
161: CPIi 18 14 // *=
162: CP 14 3 // 0
163: CPIi 1 14 // push val
164: ADDi 1 1 // SP++
165: CPi 14 8254 // 8254
166: CP 18 14 // addr
167: ADD 1 5 // SP--
168: CPI 14 1 // pop val
169: CPIi 18 14 // *=
170: CP 14 3 // 0
171: CPi 18 724 // main.i
172: CPIi 18 14 // main.i
173: CPi 18 724 // main.i
174: CPI 14 18 // main.i
175: CPIi 1 14 // push lhs
176: ADDi 1 1 // SP++
177: CPi 14 17 // 17
178: CP 15 14 // rhs
179: ADD 1 5 // SP--
180: CPI 14 1 // pop lhs
181: LT 14 15 // <
182: CPi 18 223 // for exit (P)
183: BZJ 18 14 // for exit
184: CPi 18 449 // init_commands
185: CPIi 1 18 // push base
186: ADDi 1 1 // SP++
187: CPi 18 724 // main.i
188: CPI 14 18 // main.i
189: ADD 1 5 // SP--
190: CPI 18 1 // pop base
191: ADD 18 14 // +idx
192: CPI 14 18 // ld[]
193: CPIi 1 14 // push a0
194: ADDi 1 1 // SP++
195: CP 14 3 // 0
196: CPIi 1 14 // push a1
197: ADDi 1 1 // SP++
198: CPi 18 206 // RA(P)
199: CPIi 1 18 // push RA
200: ADDi 1 1 // SP++
201: CPIi 1 2 // push old BP
202: ADDi 1 1 // SP++
203: CP 2 1 // BP=SP
204: CPi 18 22 // spi_byte
205: BZJ 18 3 // spi_byte
206: ADD 1 5 // SP--
207: CPI 14 1 // pop ret
208: ADD 1 5 // pop arg
209: ADD 1 5 // pop arg
210: CPi 18 724 // main.i
211: CPI 14 18 // main.i
212: CPIi 1 14 // push lhs
213: ADDi 1 1 // SP++
214: CP 14 4 // 1
215: CP 15 14 // rhs
216: ADD 1 5 // SP--
217: CPI 14 1 // pop lhs
218: ADD 14 15 // +
219: CPi 18 724 // main.i
220: CPIi 18 14 // main.i
221: CPi 18 173 // for
222: BZJ 18 3 // loop
223: CP 14 3 // 0
224: CPi 18 724 // main.i
225: CPIi 18 14 // main.i
226: CPi 18 724 // main.i
227: CPI 14 18 // main.i
228: CPIi 1 14 // push lhs
229: ADDi 1 1 // SP++
230: CPi 14 256 // 256
231: CP 15 14 // rhs
232: ADD 1 5 // SP--
233: CPI 14 1 // pop lhs
234: LT 14 15 // <
235: CPi 18 423 // for exit (P)
236: BZJ 18 14 // for exit
237: CPi 18 466 // image
238: CPIi 1 18 // push base
239: ADDi 1 1 // SP++
240: CPi 18 724 // main.i
241: CPI 14 18 // main.i
242: ADD 1 5 // SP--
243: CPI 18 1 // pop base
244: ADD 18 14 // +idx
245: CPI 14 18 // ld[]
246: CPIi 1 14 // push lhs
247: ADDi 1 1 // SP++
248: CPi 14 24 // 24
249: CP 15 14 // rhs
250: ADD 1 5 // SP--
251: CPI 14 1 // pop lhs
252: CP 16 15 // shift amt
253: CPi 17 32 // 32
254: LT 16 17 // amt<32?
255: CPi 18 260 // shift>=32 (P)
256: BZJ 18 16 // shift>=32
257: SRL 14 15 // >>
258: CPi 18 261 // shift done (P)
259: BZJ 18 3 // shift done
260: CPi 14 0 // shift>=32->0
261: CPIi 1 14 // push a0
262: ADDi 1 1 // SP++
263: CPi 14 8 // 8
264: CPIi 1 14 // push a1
265: ADDi 1 1 // SP++
266: CPi 18 274 // RA(P)
267: CPIi 1 18 // push RA
268: ADDi 1 1 // SP++
269: CPIi 1 2 // push old BP
270: ADDi 1 1 // SP++
271: CP 2 1 // BP=SP
272: CPi 18 22 // spi_byte
273: BZJ 18 3 // spi_byte
274: ADD 1 5 // SP--
275: CPI 14 1 // pop ret
276: ADD 1 5 // pop arg
277: ADD 1 5 // pop arg
278: CPi 18 466 // image
279: CPIi 1 18 // push base
280: ADDi 1 1 // SP++
281: CPi 18 724 // main.i
282: CPI 14 18 // main.i
283: ADD 1 5 // SP--
284: CPI 18 1 // pop base
285: ADD 18 14 // +idx
286: CPI 14 18 // ld[]
287: CPIi 1 14 // push lhs
288: ADDi 1 1 // SP++
289: CPi 14 16 // 16
290: CP 15 14 // rhs
291: ADD 1 5 // SP--
292: CPI 14 1 // pop lhs
293: CP 16 15 // shift amt
294: CPi 17 32 // 32
295: LT 16 17 // amt<32?
296: CPi 18 301 // shift>=32 (P)
297: BZJ 18 16 // shift>=32
298: SRL 14 15 // >>
299: CPi 18 302 // shift done (P)
300: BZJ 18 3 // shift done
301: CPi 14 0 // shift>=32->0
302: CPIi 1 14 // push lhs
303: ADDi 1 1 // SP++
304: CPi 14 255 // 255
305: CP 15 14 // rhs
306: ADD 1 5 // SP--
307: CPI 14 1 // pop lhs
308: NAND 14 15 // nand
309: NAND 14 14 // and
310: CPIi 1 14 // push a0
311: ADDi 1 1 // SP++
312: CPi 14 8 // 8
313: CPIi 1 14 // push a1
314: ADDi 1 1 // SP++
315: CPi 18 323 // RA(P)
316: CPIi 1 18 // push RA
317: ADDi 1 1 // SP++
318: CPIi 1 2 // push old BP
319: ADDi 1 1 // SP++
320: CP 2 1 // BP=SP
321: CPi 18 22 // spi_byte
322: BZJ 18 3 // spi_byte
323: ADD 1 5 // SP--
324: CPI 14 1 // pop ret
325: ADD 1 5 // pop arg
326: ADD 1 5 // pop arg
327: CPi 18 466 // image
328: CPIi 1 18 // push base
329: ADDi 1 1 // SP++
330: CPi 18 724 // main.i
331: CPI 14 18 // main.i
332: ADD 1 5 // SP--
333: CPI 18 1 // pop base
334: ADD 18 14 // +idx
335: CPI 14 18 // ld[]
336: CPIi 1 14 // push lhs
337: ADDi 1 1 // SP++
338: CPi 14 8 // 8
339: CP 15 14 // rhs
340: ADD 1 5 // SP--
341: CPI 14 1 // pop lhs
342: CP 16 15 // shift amt
343: CPi 17 32 // 32
344: LT 16 17 // amt<32?
345: CPi 18 350 // shift>=32 (P)
346: BZJ 18 16 // shift>=32
347: SRL 14 15 // >>
348: CPi 18 351 // shift done (P)
349: BZJ 18 3 // shift done
350: CPi 14 0 // shift>=32->0
351: CPIi 1 14 // push lhs
352: ADDi 1 1 // SP++
353: CPi 14 255 // 255
354: CP 15 14 // rhs
355: ADD 1 5 // SP--
356: CPI 14 1 // pop lhs
357: NAND 14 15 // nand
358: NAND 14 14 // and
359: CPIi 1 14 // push a0
360: ADDi 1 1 // SP++
361: CPi 14 8 // 8
362: CPIi 1 14 // push a1
363: ADDi 1 1 // SP++
364: CPi 18 372 // RA(P)
365: CPIi 1 18 // push RA
366: ADDi 1 1 // SP++
367: CPIi 1 2 // push old BP
368: ADDi 1 1 // SP++
369: CP 2 1 // BP=SP
370: CPi 18 22 // spi_byte
371: BZJ 18 3 // spi_byte
372: ADD 1 5 // SP--
373: CPI 14 1 // pop ret
374: ADD 1 5 // pop arg
375: ADD 1 5 // pop arg
376: CPi 18 466 // image
377: CPIi 1 18 // push base
378: ADDi 1 1 // SP++
379: CPi 18 724 // main.i
380: CPI 14 18 // main.i
381: ADD 1 5 // SP--
382: CPI 18 1 // pop base
383: ADD 18 14 // +idx
384: CPI 14 18 // ld[]
385: CPIi 1 14 // push lhs
386: ADDi 1 1 // SP++
387: CPi 14 255 // 255
388: CP 15 14 // rhs
389: ADD 1 5 // SP--
390: CPI 14 1 // pop lhs
391: NAND 14 15 // nand
392: NAND 14 14 // and
393: CPIi 1 14 // push a0
394: ADDi 1 1 // SP++
395: CPi 14 8 // 8
396: CPIi 1 14 // push a1
397: ADDi 1 1 // SP++
398: CPi 18 406 // RA(P)
399: CPIi 1 18 // push RA
400: ADDi 1 1 // SP++
401: CPIi 1 2 // push old BP
402: ADDi 1 1 // SP++
403: CP 2 1 // BP=SP
404: CPi 18 22 // spi_byte
405: BZJ 18 3 // spi_byte
406: ADD 1 5 // SP--
407: CPI 14 1 // pop ret
408: ADD 1 5 // pop arg
409: ADD 1 5 // pop arg
410: CPi 18 724 // main.i
411: CPI 14 18 // main.i
412: CPIi 1 14 // push lhs
413: ADDi 1 1 // SP++
414: CP 14 4 // 1
415: CP 15 14 // rhs
416: ADD 1 5 // SP--
417: CPI 14 1 // pop lhs
418: ADD 14 15 // +
419: CPi 18 724 // main.i
420: CPIi 18 14 // main.i
421: CPi 18 226 // for
422: BZJ 18 3 // loop
423: CPi 14 4 // 4
424: CPIi 1 14 // push val
425: ADDi 1 1 // SP++
426: CPi 14 8254 // 8254
427: CP 18 14 // addr
428: ADD 1 5 // SP--
429: CPI 14 1 // pop val
430: CPIi 18 14 // *=
431: CP 14 3 // 0
432: CP 1 2 // SP=BP
433: ADD 1 5 // SP--
434: CPI 2 1 // pop old BP
435: ADD 1 5 // SP--
436: CPI 15 1 // pop RA
437: CPIi 1 14 // push ret
438: ADDi 1 1 // SP++
439: BZJ 15 3 // return
440: CP 1 2 // SP=BP
441: ADD 1 5 // SP--
442: CPI 2 1 // pop old BP
443: ADD 1 5 // SP--
444: CPI 15 1 // pop RA
445: CPIi 1 3 // push ret 0
446: ADDi 1 1 // SP++
447: BZJ 15 3 // return
448: BZJi 3 448 // HALT
//$DATA_SECTION
449: 174 // g'init_commands'[0]
450: 32 // g'init_commands'[1]
451: 0 // g'init_commands'[2]
452: 33 // g'init_commands'[3]
453: 0 // g'init_commands'[4]
454: 127 // g'init_commands'[5]
455: 34 // g'init_commands'[6]
456: 0 // g'init_commands'[7]
457: 7 // g'init_commands'[8]
458: 129 // g'init_commands'[9]
459: 207 // g'init_commands'[10]
460: 161 // g'init_commands'[11]
461: 200 // g'init_commands'[12]
462: 166 // g'init_commands'[13]
463: 141 // g'init_commands'[14]
464: 20 // g'init_commands'[15]
465: 175 // g'init_commands'[16]
466: 0 // g'image'[0]
467: 0 // g'image'[1]
468: 0 // g'image'[2]
469: 0 // g'image'[3]
470: 0 // g'image'[4]
471: 0 // g'image'[5]
472: 0 // g'image'[6]
473: 0 // g'image'[7]
474: 0 // g'image'[8]
475: 0 // g'image'[9]
476: 0 // g'image'[10]
477: 0 // g'image'[11]
478: 0 // g'image'[12]
479: 0 // g'image'[13]
480: 0 // g'image'[14]
481: 0 // g'image'[15]
482: 0 // g'image'[16]
483: 0 // g'image'[17]
484: 0 // g'image'[18]
485: 0 // g'image'[19]
486: 0 // g'image'[20]
487: 0 // g'image'[21]
488: 0 // g'image'[22]
489: 0 // g'image'[23]
490: 0 // g'image'[24]
491: 0 // g'image'[25]
492: 0 // g'image'[26]
493: 0 // g'image'[27]
494: 0 // g'image'[28]
495: 0 // g'image'[29]
496: 0 // g'image'[30]
497: 0 // g'image'[31]
498: 0 // g'image'[32]
499: 0 // g'image'[33]
500: 0 // g'image'[34]
501: 0 // g'image'[35]
502: 0 // g'image'[36]
503: 0 // g'image'[37]
504: 0 // g'image'[38]
505: 0 // g'image'[39]
506: 0 // g'image'[40]
507: 0 // g'image'[41]
508: 0 // g'image'[42]
509: 0 // g'image'[43]
510: 0 // g'image'[44]
511: 0 // g'image'[45]
512: 0 // g'image'[46]
513: 0 // g'image'[47]
514: 0 // g'image'[48]
515: 0 // g'image'[49]
516: 0 // g'image'[50]
517: 0 // g'image'[51]
518: 0 // g'image'[52]
519: 0 // g'image'[53]
520: 0 // g'image'[54]
521: 0 // g'image'[55]
522: 0 // g'image'[56]
523: 0 // g'image'[57]
524: 0 // g'image'[58]
525: 0 // g'image'[59]
526: 0 // g'image'[60]
527: 0 // g'image'[61]
528: 0 // g'image'[62]
529: 0 // g'image'[63]
530: 0 // g'image'[64]
531: 0 // g'image'[65]
532: 0 // g'image'[66]
533: 5372 // g'image'[67]
534: 4244144128 // g'image'[68]
535: 0 // g'image'[69]
536: 32960 // g'image'[70]
537: 4042800156 // g'image'[71]
538: 67108864 // g'image'[72]
539: 2162225400 // g'image'[73]
540: 941366284 // g'image'[74]
541: 203164700 // g'image'[75]
542: 473437184 // g'image'[76]
543: 0 // g'image'[77]
544: 32960 // g'image'[78]
545: 4033902616 // g'image'[79]
546: 470555660 // g'image'[80]
547: 203164700 // g'image'[81]
548: 943214592 // g'image'[82]
549: 0 // g'image'[83]
550: 4258044 // g'image'[84]
551: 2081164300 // g'image'[85]
552: 203164860 // g'image'[86]
553: 4244172800 // g'image'[87]
554: 0 // g'image'[88]
555: 10550524 // g'image'[89]
556: 3154116608 // g'image'[90]
557: 0 // g'image'[91]
558: 53500 // g'image'[92]
559: 4233887744 // g'image'[93]
560: 0 // g'image'[94]
561: 0 // g'image'[95]
562: 0 // g'image'[96]
563: 0 // g'image'[97]
564: 0 // g'image'[98]
565: 5 // g'image'[99]
566: 3221225120 // g'image'[100]
567: 49376 // g'image'[101]
568: 4169015047 // g'image'[102]
569: 50331648 // g'image'[103]
570: 0 // g'image'[104]
571: 34541343 // g'image'[105]
572: 505158716 // g'image'[106]
573: 943257840 // g'image'[107]
574: 4030726144 // g'image'[108]
575: 0 // g'image'[109]
576: 3640655791 // g'image'[110]
577: 50331648 // g'image'[111]
578: 0 // g'image'[112]
579: 0 // g'image'[113]
580: 0 // g'image'[114]
581: 0 // g'image'[115]
582: 3909091135 // g'image'[116]
583: 825765944 // g'image'[117]
584: 808983583 // g'image'[118]
585: 252117248 // g'image'[119]
586: 64 // g'image'[120]
587: 4211080983 // g'image'[121]
588: 0 // g'image'[122]
589: 0 // g'image'[123]
590: 3237674879 // g'image'[124]
591: 184549376 // g'image'[125]
592: 0 // g'image'[126]
593: 0 // g'image'[127]
594: 0 // g'image'[128]
595: 0 // g'image'[129]
596: 0 // g'image'[130]
597: 0 // g'image'[131]
598: 999231 // g'image'[132]
599: 1027542787 // g'image'[133]
600: 16777216 // g'image'[134]
601: 0 // g'image'[135]
602: 7192 // g'image'[136]
603: 1010317360 // g'image'[137]
604: 808988728 // g'image'[138]
605: 941498127 // g'image'[139]
606: 117506048 // g'image'[140]
607: 0 // g'image'[141]
608: 34017055 // g'image'[142]
609: 1008220208 // g'image'[143]
610: 942684208 // g'image'[144]
611: 404495370 // g'image'[145]
612: 0 // g'image'[146]
613: 61 // g'image'[147]
614: 1061094656 // g'image'[148]
615: 0 // g'image'[149]
616: 0 // g'image'[150]
617: 0 // g'image'[151]
618: 5 // g'image'[152]
619: 253705756 // g'image'[153]
620: 808988728 // g'image'[154]
621: 808983582 // g'image'[155]
622: 252117760 // g'image'[156]
623: 0 // g'image'[157]
624: 0 // g'image'[158]
625: 0 // g'image'[159]
626: 0 // g'image'[160]
627: 0 // g'image'[161]
628: 0 // g'image'[162]
629: 0 // g'image'[163]
630: 0 // g'image'[164]
631: 0 // g'image'[165]
632: 0 // g'image'[166]
633: 0 // g'image'[167]
634: 0 // g'image'[168]
635: 0 // g'image'[169]
636: 0 // g'image'[170]
637: 0 // g'image'[171]
638: 0 // g'image'[172]
639: 0 // g'image'[173]
640: 0 // g'image'[174]
641: 0 // g'image'[175]
642: 0 // g'image'[176]
643: 0 // g'image'[177]
644: 0 // g'image'[178]
645: 0 // g'image'[179]
646: 0 // g'image'[180]
647: 0 // g'image'[181]
648: 0 // g'image'[182]
649: 0 // g'image'[183]
650: 0 // g'image'[184]
651: 0 // g'image'[185]
652: 0 // g'image'[186]
653: 0 // g'image'[187]
654: 0 // g'image'[188]
655: 0 // g'image'[189]
656: 0 // g'image'[190]
657: 0 // g'image'[191]
658: 0 // g'image'[192]
659: 0 // g'image'[193]
660: 0 // g'image'[194]
661: 0 // g'image'[195]
662: 0 // g'image'[196]
663: 0 // g'image'[197]
664: 0 // g'image'[198]
665: 0 // g'image'[199]
666: 0 // g'image'[200]
667: 0 // g'image'[201]
668: 0 // g'image'[202]
669: 0 // g'image'[203]
670: 0 // g'image'[204]
671: 0 // g'image'[205]
672: 0 // g'image'[206]
673: 0 // g'image'[207]
674: 0 // g'image'[208]
675: 0 // g'image'[209]
676: 0 // g'image'[210]
677: 0 // g'image'[211]
678: 0 // g'image'[212]
679: 0 // g'image'[213]
680: 0 // g'image'[214]
681: 0 // g'image'[215]
682: 0 // g'image'[216]
683: 0 // g'image'[217]
684: 0 // g'image'[218]
685: 0 // g'image'[219]
686: 0 // g'image'[220]
687: 0 // g'image'[221]
688: 0 // g'image'[222]
689: 0 // g'image'[223]
690: 0 // g'image'[224]
691: 0 // g'image'[225]
692: 0 // g'image'[226]
693: 0 // g'image'[227]
694: 0 // g'image'[228]
695: 0 // g'image'[229]
696: 0 // g'image'[230]
697: 0 // g'image'[231]
698: 0 // g'image'[232]
699: 0 // g'image'[233]
700: 0 // g'image'[234]
701: 0 // g'image'[235]
702: 0 // g'image'[236]
703: 0 // g'image'[237]
704: 0 // g'image'[238]
705: 0 // g'image'[239]
706: 0 // g'image'[240]
707: 0 // g'image'[241]
708: 0 // g'image'[242]
709: 0 // g'image'[243]
710: 0 // g'image'[244]
711: 0 // g'image'[245]
712: 0 // g'image'[246]
713: 0 // g'image'[247]
714: 0 // g'image'[248]
715: 0 // g'image'[249]
716: 0 // g'image'[250]
717: 0 // g'image'[251]
718: 0 // g'image'[252]
719: 0 // g'image'[253]
720: 0 // g'image'[254]
721: 0 // g'image'[255]
722: 0 // g'spi_byte.count'
723: 0 // g'spi_byte.pins'
724: 0 // g'main.i'
725: 448 // $RA_main
726: 0 // $OLDBP_main
//$STACK_SECTION // $BASE_main = 727
