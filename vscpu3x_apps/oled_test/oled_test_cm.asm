// ==========================================
// MAIN PROGRAM: INIT SEQUENCE
// ==========================================
0: CPi 8254 4         // Start with CS=1 (Inactive)
1: CPi 40 300         // R40 = Pointer to Init Command Array (starts at 300)
2: CPi 8254 0         // Pull CS=0 (Active)

3: CPI 61 40          // Load command byte from array into R61
4: CP 64 61           // Copy command to R64
5: ADD 64 104         // R64 += -255 (Check for 0xFF end marker)
6: BZJ 71 64          // If R64 == 0 (It was 0xFF), Init is done. Jump to Screen Fill (line 50)
7: CPi 62 0           // R62 = 0 (Set D/C flag to COMMAND mode)
8: CPi 60 10          // R60 = 10 (Store the return address)
9: BZJ 74 32          // Call SPI Subroutine (Unconditional jump to line 200)

// Return Point after SPI Subroutine
10: ADDi 40 1         // Increment array pointer
11: BZJ 70 32         // Loop back to line 3 to read next command

// ==========================================
// MAIN PROGRAM: SCREEN FILL (ALL WHITE)
// ==========================================
50: CP 41 105         // R41 = 1024 (Total bytes needed for 128x64 screen)
51: CPi 61 255        // R61 = 255 (0xFF means all 8 pixels in the column are ON)
52: CPi 62 8          // R62 = 8 (Set D/C flag to DATA mode. Bit 3 is HIGH)
53: CPi 60 55         // R60 = 55 (Store the return address)
54: BZJ 74 32         // Call SPI Subroutine (Unconditional jump to line 200)

// Return Point after SPI Subroutine
55: ADD 41 102        // Counter -= 1
56: BZJ 73 41         // If Counter == 0, jump to Halt (line 60)
57: BZJ 72 32         // Else, loop back to line 51

60: CPi 8254 4        // Pull CS=1 (Inactive/Idle)
61: BZJ 73 32         // Infinite Halt Loop (Jumps to itself)

// ==========================================
// SUBROUTINE: SPI BIT-BANG TRANSMITTER
// Inputs: R61 = Byte to send, R62 = D/C Flag (0 or 8), R60 = Return Address
// ==========================================
200: CPi 63 8         // R63 = 8 (Bit loop counter)
201: CP 64 61         // Copy byte to temporary register
202: LT 64 100        // if (byte < 128) R64 = 1, else R64 = 0
203: BZJ 75 64        // if R64 == 0 (byte >= 128, MSB is 1), Jump to line 210

// Block: MSB is 0
204: CPi 65 0         // Output state MOSI = 0
205: BZJ 76 32        // Unconditional Jump to Pin Output (line 213)

// Block: MSB is 1
210: CPi 65 1         // Output state MOSI = 1
211: ADD 61 101       // byte += -128 (Strips the highest bit for the next shift)

// Pin Output & Clock Generation (CS remains 0)
213: ADD 65 62        // Output State = MOSI (0 or 1) + D/C Flag (0 or 8)
214: CP 8254 65       // Drive Pins: SCK=0, MOSI, CS=0, D/C 
215: CP 66 65         // Copy pin state to R66
216: ADDi 66 2        // R66 += 2 (Sets SCK HIGH)
217: CP 8254 66       // Drive Pins: SCK=1, MOSI, CS=0, D/C (Rising edge clocks data into OLED)
218: CP 8254 65       // Drive Pins: SCK=0, MOSI, CS=0, D/C (Falling edge)

// Shift and Loop Control
219: MULi 61 2        // byte *= 2 (Shifts the next bit into the MSB position)
220: ADD 63 102       // Bit loop counter += -1
221: BZJ 78 63        // If counter == 0, transmission complete, jump to exit (line 223)
222: BZJ 77 32        // Else, loop back for next bit (line 201)

// Subroutine Exit
223: BZJ 60 32        // Unconditional Jump to the Address stored in R60 (Return to caller)

// ==========================================
// CONSTANTS, TARGETS & MATH HELPERS (100 - 199)
// ==========================================
32:  0                // Hardcoded 0 for BZJ unconditional jumps
100: 128              // Threshold for MSB evaluation
101: 4294967168       // 32-bit Two's Complement for -128
102: 4294967295       // 32-bit Two's Complement for -1
104: 4294967041       // 32-bit Two's Complement for -255
105: 1024             // Screen byte counter (128 columns * 8 pages)

// Jump Target Addresses (Used by BZJ)
70: 3                 // T_LOOP_INIT
71: 50                // T_SCREEN_FILL
72: 51                // T_SCREEN_LOOP
73: 60                // T_HALT
74: 200               // T_SPI_CALL
75: 210               // T_SPI_MSB_1
76: 213               // T_SPI_PIN_OUT
77: 201               // T_SPI_BIT_LOOP
78: 223               // T_SPI_EXIT

// ==========================================
// SSD1306 INITIALIZATION COMMAND ARRAY (300+)
// ==========================================
300: 174              // 0xAE: Display OFF
301: 32               // 0x20: Set Memory Addressing Mode
302: 0                // 0x00: Horizontal Addressing Mode
303: 33               // 0x21: Set Column Address
304: 0                // 0x00: Start Column (0)
305: 127              // 0x7F: End Column (127)
306: 34               // 0x22: Set Page Address
307: 0                // 0x00: Start Page (0)
308: 7                // 0x07: End Page (7)
309: 129              // 0x81: Set Contrast Control
310: 207              // 0xCF: Contrast Value
311: 161              // 0xA1: Set Segment Re-map (Flips X axis horizontally)
312: 200              // 0xC8: Set COM Output Scan Direction (Flips Y axis vertically)
313: 166              // 0xA6: Normal Display Mode (Non-Inverted)
314: 141              // 0x8D: Set Charge Pump
315: 20               // 0x14: Enable Charge Pump (Required for 3.3V operation)
316: 175              // 0xAF: Display ON
317: 255              // 0xFF: ARRAY END MARKER