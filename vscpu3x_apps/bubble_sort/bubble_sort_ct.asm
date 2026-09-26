0: BZJi 82 0
1: CP 50 200    // *50 = k   WHILE1
2: LT 50 300    // if(k < SIZE)
3: BZJ 80 50    // PC++  (continue to loop or break)
4: CPi 201 0    // m = 0
5: CP 40 200    // *40 = k   WHILE2 
6: NAND 40 40   // -k-1
7: ADD 40 300   // SIZE-k-1
8: CP 60 201    // *60 = m
9: LT 60 40     // if(m < SIZE-k-1)
10: BZJ 81 60    // PC++ (continue to loop or break)

11: CP 36 89             // *36 = a 
12: ADD 36 201             // *36 = a+m
13: CPI 37 36             // *37 = *(a+m)
14: CP 39 36             // *39 = a+m
15: ADDi 39 1             // *39 = a+m+1
16: CPI 38 39             // *38 = *(a+m+1)
17: LT 37 38             // (*(a+m) < *(a+m+1) )
18: BZJ 83 37             // if ((*(a+m) < *(a+m+1)) == 0) goto INC_m;
19: CPI 97 36             // *97 = *(a+m) 
20: CPI 98 39             // *98 = *(a+m+1)
21: CPIi 36 98             // *(a+m) = *98
22: CPIi 39 97             // *(a+m+1) = *97
23: BZJi 83 0             // jump to 55

55: ADDi 201 1  // INC_m
56: BZJi 82 4   // goto WHILE2

70: ADDi 200 1  // END_WHILE2 + INC_k
71: BZJi 82 0   // goto WHILE1

80: 3
81: 70
82: 1
83: 55

89: 301         // a (start address of array)
90: 0           // tmp_while_1
91: 0           // tmp_while_2
92: 0           // tmp_while_2_1

97: 0           // tmp_val_1
98: 0           // tmp_val_2

130: BZJi 131 0 // END_WHILE1, also end of program
131: 130

200: 0          // k 
201: 0          // m

300: 5          // SIZE
301: 7          // first element of array 
302: 3   
303: 0
304: 6
305: 1          // last element of array
