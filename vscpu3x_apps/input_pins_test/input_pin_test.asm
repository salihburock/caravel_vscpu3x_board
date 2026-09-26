// main loop
0:  CP 48 8254      // tmp = gpio_in (reads the current state of 8254)
1:  CPi 49 58       // shift_amt = 58 (32 + 26 for left shift)
2:  SRL 48 49       // tmp << 26 (Moves IO17 to bit 31 and IO16 to bit 30. Higher bits are destroyed)
3:  CPi 49 30       // shift_amt = 30 (for right shift)
4:  SRL 48 49       // tmp >> 30 (Moves IO17 to bit 1 and IO16 to bit 0. All lower bits are pushed out and zeroed)
5:  CPi 49 34       // shift_amt = 34 (32 + 2 for left shift)
6:  SRL 48 49       // tmp << 2 (Moves IO17 to OUT_3 and IO16 to OUT_2. Bits 1 and 0 are now guaranteed to be 0)
7:  ADDi 48 3       // tmp += 3 (Safely adds binary 0011 to set OUT_1 and OUT_0 to HIGH without any carry)
8:  CP 8254 48      // gpio_out = tmp (write the final aligned output back to 8254)
9:  BZJ 33 32       // unconditional jump to line 0 (branch to *33 if *32 == 0)

// Constants
32: 0               // zero condition for BZJ
33: 0               // target address for the main loop

// Variables
48: 0               // tmp (holds the modified GPIO data)
49: 0               // shift_amt (reused for SRL operations)