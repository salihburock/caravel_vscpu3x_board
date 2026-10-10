0: BZJi 3 20 // Goto init
//$REGISTERS_SECTION
1: 104 // SP
2: 104 // BP
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
21: BZJi 3 22 // Goto main
22: CP 14 3 // constant 0
23: CP 8254 14 // direct pointer store
24: CP 14 3 // constant 0
25: CP 100 14 // $local.main.10
26: CP 14 4 // constant 1
27: CPi 18 76 // wh exit (P)
28: BZJ 18 14 // wh exit
29: CP 14 8255 // direct pointer load
30: CP 98 14 // $local.main.8
31: CP 14 98 // $local.main.8
32: NANDi 14 3 // constant mask
33: NAND 14 14 // and
34: CP 99 14 // $local.main.9
35: CP 14 99 // $local.main.9
36: CPIi 1 14 // push lhs
37: ADDi 1 1 // SP++
38: CPi 18 94 // quad
39: CPIi 1 18 // push base
40: ADDi 1 1 // SP++
41: CP 14 100 // $local.main.10
42: ADD 1 5 // SP--
43: CPI 18 1 // pop base
44: ADD 18 14 // +idx
45: CPI 14 18 // ld[]
46: CP 15 14 // rhs
47: ADD 1 5 // SP--
48: CPI 14 1 // pop lhs
49: CP 16 14 // or
50: NAND 16 16 // ~a
51: CP 17 15
52: NAND 17 17 // ~b
53: NAND 16 17 // a|b
54: CP 14 16
55: CP 8254 14 // direct pointer store
56: CP 14 100 // $local.main.10
57: ADDi 14 1 // +constant
58: CP 100 14 // $local.main.10
59: CP 14 100 // $local.main.10
60: NANDi 14 3 // constant mask
61: NAND 14 14 // and
62: CP 100 14 // $local.main.10
63: CP 14 3 // constant 0
64: CP 101 14 // $local.main.11
65: CP 14 101 // $local.main.11
66: LTi 14 2000 // <constant
67: CPi 18 74 // wh exit (P)
68: BZJ 18 14 // wh exit
69: CP 14 101 // $local.main.11
70: ADDi 14 1 // +constant
71: CP 101 14 // $local.main.11
72: CPi 18 65 // wh loop
73: BZJ 18 3 // loop
74: CPi 18 26 // wh loop
75: BZJ 18 3 // loop
76: CP 14 3 // constant 0
77: CP 1 2 // SP=BP
78: ADD 1 5 // SP--
79: CPI 2 1 // pop old BP
80: ADD 1 5 // SP--
81: CPI 15 1 // pop RA
82: CPIi 1 14 // push ret
83: ADDi 1 1 // SP++
84: BZJ 15 3 // return
85: CP 1 2 // SP=BP
86: ADD 1 5 // SP--
87: CPI 2 1 // pop old BP
88: ADD 1 5 // SP--
89: CPI 15 1 // pop RA
90: CPIi 1 3 // push ret 0
91: ADDi 1 1 // SP++
92: BZJ 15 3 // return
93: BZJi 3 93 // HALT
//$DATA_SECTION
94: 0 // g'quad'[0]
95: 4 // g'quad'[1]
96: 12 // g'quad'[2]
97: 8 // g'quad'[3]
98: 0 // g'$local.main.8'
99: 0 // g'$local.main.9'
100: 0 // g'$local.main.10'
101: 0 // g'$local.main.11'
102: 93 // $RA_main
103: 0 // $OLDBP_main
//$STACK_SECTION // $BASE_main = 104
