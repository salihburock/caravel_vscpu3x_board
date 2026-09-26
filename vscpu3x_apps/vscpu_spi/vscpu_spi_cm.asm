// --- 1. IDLE STATE ---
0:  CPi 8254 4      // CS=1, SCK=0, MOSI=0 

// --- 2. INTER-PACKET DELAY ---
1:  CP 48 34        // delay_counter = 50000 (Loaded from memory address 34)
2:  ADD 48 33       // delay_counter -= 1 (Adds -1 to subtract)
3:  BZJ 35 48       // if delay_counter == 0, break loop and go to line 5
4:  BZJ 36 32       // else, unconditionally jump back to line 2 (since *32 == 0)

// --- 3. START TRANSMISSION (Byte: 0x5A) ---
5:  CPi 8254 0      // CS=0, SCK=0, MOSI=0 (Pull Chip Select LOW)

// --- BIT 7 (0) ---
6:  CPi 8254 0      // setup MOSI=0, SCK=0
7:  CPi 8254 2      // SCK=1, MOSI=0 (Rising Edge)
8:  CPi 8254 0      // SCK=0, MOSI=0 (Falling Edge)

// --- BIT 6 (1) ---
9:  CPi 8254 1      // setup MOSI=1, SCK=0
10: CPi 8254 3      // SCK=1, MOSI=1
11: CPi 8254 1      // SCK=0, MOSI=1

// --- BIT 5 (0) ---
12: CPi 8254 0      
13: CPi 8254 2      
14: CPi 8254 0      

// --- BIT 4 (1) ---
15: CPi 8254 1      
16: CPi 8254 3      
17: CPi 8254 1      

// --- BIT 3 (1) ---
18: CPi 8254 1      
19: CPi 8254 3      
20: CPi 8254 1      

// --- BIT 2 (0) ---
21: CPi 8254 0      
22: CPi 8254 2      
23: CPi 8254 0      

// --- BIT 1 (1) ---
24: CPi 8254 1      
25: CPi 8254 3      
26: CPi 8254 1      

// --- BIT 0 (0) ---
27: CPi 8254 0      
28: CPi 8254 2      
29: CPi 8254 0      

// --- 4. END TRANSMISSION ---
30: CPi 8254 4      // CS=1, SCK=0, MOSI=0 (Pull Chip Select HIGH)
31: BZJ 37 32       // Unconditional jump back to line 0 to repeat

// --- CONSTANTS & POINTERS ---
32: 0               // Zero condition for unconditional BZJ jumps
33: 4294967295      // 32-bit two's complement for -1 (safely avoids negative signs for asmtomem regex)
34: 50000           // The 32-bit delay value stored in memory
35: 5               // Target address to exit delay
36: 2               // Target address to continue delay loop
37: 0               // Target address to restart main loop

// --- VARIABLES ---
48: 0               // delay_counter