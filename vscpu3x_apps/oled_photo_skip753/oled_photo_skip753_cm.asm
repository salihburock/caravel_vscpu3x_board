// Original oled_photo with image relocated to 800-1055 to avoid address 753.
// ==========================================
// PHASE 1: OLED INITIALIZATION
// ==========================================
0: CPi 8254 4         // CS=1 (Inactive), SCK=0, MOSI=0, D/C=0
1: CPi 110 300        // R110 = Pointer to Init Command Array
2: CPi 8254 0         // CS=0 (Active)

3: CPI 121 110        // Load command byte from array into R121
4: CP 124 121         // Copy to Temp register R124
5: ADD 124 104        // R124 += -255 (Check for 0xFF end marker)
6: BZJ 71 124         // If 0xFF hit, Init is done. Jump to Screen Fill (line 50)

// Align 8-bit byte to MSB for universal SPI routine
7: CPi 129 56         // Shift amount: 32 + 24 = 56 (Left shift by 24)
8: SRL 121 129        // data = data << 24 (Moves bit 7 to bit 31)

// Setup SPI Call
9: CPi 122 0          // D/C = 0 (COMMAND MODE)
10: CPi 123 8         // Loop 8 times
11: CPi 120 13        // Store return address = 13
12: BZJ 74 32         // Call SPI_GENERIC (line 240)

13: ADDi 110 1        // Return Point: Increment array pointer
14: BZJ 70 32         // Loop back to line 3

// ==========================================
// PHASE 2: 1D ARRAY SCREEN FILL
// ==========================================
50: CPi 111 800       // R111 = Pointer to Image Data (800)
51: CPi 112 256       // R112 = Total 32-bit words (256 words = 1024 bytes)
52: CPi 122 8         // R122 = 8 (DATA MODE, Bit 3 / D/C is HIGH)

53: CPI 121 111       // Load 32-bit image word
54: CPi 123 32        // Loop 32 times
55: CPi 120 57        // Store return address = 57
56: BZJ 74 32         // Call SPI_GENERIC (line 240)

57: ADDi 111 1        // Return Point: Increment image pointer
58: ADD 112 102       // Counter -= 1 (-1 is at address 102)
59: BZJ 73 112        // If Counter == 0, jump to Halt (line 61)
60: BZJ 72 32         // Else, loop back to line 53

// ==========================================
// PHASE 3: FREEZE STATE
// ==========================================
61: CPi 8254 4        // Pull CS=1 (Inactive/Idle)
62: BZJ 73 32         // Infinite Halt Loop (Jumps to 61)

// ==========================================
// SUBROUTINE: UNIVERSAL SYMMETRIC SPI
// Inputs: R121 (Aligned Data), R122 (D/C), R123 (Bit Count), R120 (Return)
// ==========================================
240: CPi 127 31       // R127 = 31 (Right shift amount to isolate MSB)
241: CPi 128 33       // R128 = 33 (Left shift amount: 32+1 to shift data by 1)

// Bit Loop Start
242: CP 124 121       // Copy data to R124
243: SRL 124 127      // R124 = data >> 31 (R124 is now exactly 0 or 1)

244: ADD 124 122      // R124 = MOSI (0/1) + D/C Flag (0/8)
245: CP 8254 124      // Drive: SCK=0, CS=0

246: CP 126 124
247: ADDi 126 2       // R126 = MOSI + D/C + SCK(2)
248: CP 8254 126      // Drive: SCK=1 (Rising Edge)
249: CP 8254 124      // Drive: SCK=0 (Falling Edge)

250: SRL 121 128      // data = data << 1 (Shifts next bit into MSB position)
251: ADD 123 102      // Bit count -= 1
252: BZJ 88 123       // If count == 0, exit (254)
253: BZJ 87 32        // Else, loop to next bit (242)

// Subroutine Exit
254: BZJ 120 32       // Return to caller

// ==========================================
// CONSTANTS & TARGET ADDRESSES
// ==========================================
32:  0                // Zero for unconditional jumps
102: 4294967295       // Two's Complement -1
104: 4294967041       // Two's Complement -255

// Jump Target Addresses
70: 3                 // Loop Init
71: 50                // Fill Screen
72: 53                // Loop Image Array
73: 61                // Halt Loop
74: 240               // Call SPI_GENERIC
87: 242               // SPI_GENERIC: Bit Loop
88: 254               // SPI_GENERIC: Exit

// ==========================================
// SSD1306 INITIALIZATION COMMAND ARRAY (300+)
// ==========================================
300: 174              // 0xAE: Display OFF
301: 32               // 0x20: Set Memory Addressing Mode
302: 0                // 0x00: Horizontal Addressing Mode 
303: 33               // 0x21: Set Column Address
304: 0                // 0x00: Start Column 0
305: 127              // 0x7F: End Column 127
306: 34               // 0x22: Set Page Address
307: 0                // 0x00: Start Page 0
308: 7                // 0x07: End Page 7
309: 129              // 0x81: Set Contrast
310: 207              // 0xCF: Contrast Value
311: 161              // 0xA1: Set Segment Re-map
312: 200              // 0xC8: Set COM Output Scan Direction
313: 166              // 0xA6: Normal Display
314: 141              // 0x8D: Set Charge Pump
315: 20               // 0x14: Enable Charge Pump
316: 175              // 0xAF: Display ON
317: 255              // 0xFF: ARRAY END MARKER

// ==========================================
// IMAGE DATA (Array begins at 800)
// ==========================================
// ==========================================
// IMAGE DATA (Array begins at 800)
// ==========================================

// --- SSD1306 IMAGE DATA: VSCPU.png ---
// Architecture: 8 Pages (Horizontal Mode) | 4 Columns per 32-bit Word
800: 0            // Page 0, Cols 0-3
801: 0            // Page 0, Cols 4-7
802: 0            // Page 0, Cols 8-11
803: 0            // Page 0, Cols 12-15
804: 0            // Page 0, Cols 16-19
805: 0            // Page 0, Cols 20-23
806: 0            // Page 0, Cols 24-27
807: 0            // Page 0, Cols 28-31
808: 0            // Page 0, Cols 32-35
809: 0            // Page 0, Cols 36-39
810: 0            // Page 0, Cols 40-43
811: 0            // Page 0, Cols 44-47
812: 0            // Page 0, Cols 48-51
813: 0            // Page 0, Cols 52-55
814: 0            // Page 0, Cols 56-59
815: 0            // Page 0, Cols 60-63
816: 0            // Page 0, Cols 64-67
817: 0            // Page 0, Cols 68-71
818: 0            // Page 0, Cols 72-75
819: 0            // Page 0, Cols 76-79
820: 0            // Page 0, Cols 80-83
821: 0            // Page 0, Cols 84-87
822: 0            // Page 0, Cols 88-91
823: 0            // Page 0, Cols 92-95
824: 0            // Page 0, Cols 96-99
825: 0            // Page 0, Cols 100-103
826: 0            // Page 0, Cols 104-107
827: 0            // Page 0, Cols 108-111
828: 0            // Page 0, Cols 112-115
829: 0            // Page 0, Cols 116-119
830: 0            // Page 0, Cols 120-123
831: 0            // Page 0, Cols 124-127
832: 0            // Page 1, Cols 0-3
833: 0            // Page 1, Cols 4-7
834: 0            // Page 1, Cols 8-11
835: 0            // Page 1, Cols 12-15
836: 0            // Page 1, Cols 16-19
837: 0            // Page 1, Cols 20-23
838: 0            // Page 1, Cols 24-27
839: 0            // Page 1, Cols 28-31
840: 0            // Page 1, Cols 32-35
841: 0            // Page 1, Cols 36-39
842: 0            // Page 1, Cols 40-43
843: 0            // Page 1, Cols 44-47
844: 0            // Page 1, Cols 48-51
845: 0            // Page 1, Cols 52-55
846: 0            // Page 1, Cols 56-59
847: 0            // Page 1, Cols 60-63
848: 0            // Page 1, Cols 64-67
849: 0            // Page 1, Cols 68-71
850: 0            // Page 1, Cols 72-75
851: 0            // Page 1, Cols 76-79
852: 0            // Page 1, Cols 80-83
853: 0            // Page 1, Cols 84-87
854: 0            // Page 1, Cols 88-91
855: 0            // Page 1, Cols 92-95
856: 0            // Page 1, Cols 96-99
857: 0            // Page 1, Cols 100-103
858: 0            // Page 1, Cols 104-107
859: 0            // Page 1, Cols 108-111
860: 0            // Page 1, Cols 112-115
861: 0            // Page 1, Cols 116-119
862: 0            // Page 1, Cols 120-123
863: 0            // Page 1, Cols 124-127
864: 0            // Page 2, Cols 0-3
865: 0            // Page 2, Cols 4-7
866: 0            // Page 2, Cols 8-11
867: 5372         // Page 2, Cols 12-15
868: 4244144128   // Page 2, Cols 16-19
869: 0            // Page 2, Cols 20-23
870: 32960        // Page 2, Cols 24-27
871: 4042800156   // Page 2, Cols 28-31
872: 67108864     // Page 2, Cols 32-35
873: 2162225400   // Page 2, Cols 36-39
874: 941366284    // Page 2, Cols 40-43
875: 203164700    // Page 2, Cols 44-47
876: 473437184    // Page 2, Cols 48-51
877: 0            // Page 2, Cols 52-55
878: 32960        // Page 2, Cols 56-59
879: 4033902616   // Page 2, Cols 60-63
880: 470555660    // Page 2, Cols 64-67
881: 203164700    // Page 2, Cols 68-71
882: 943214592    // Page 2, Cols 72-75
883: 0            // Page 2, Cols 76-79
884: 4258044      // Page 2, Cols 80-83
885: 2081164300   // Page 2, Cols 84-87
886: 203164860    // Page 2, Cols 88-91
887: 4244172800   // Page 2, Cols 92-95
888: 0            // Page 2, Cols 96-99
889: 10550524     // Page 2, Cols 100-103
890: 3154116608   // Page 2, Cols 104-107
891: 0            // Page 2, Cols 108-111
892: 53500        // Page 2, Cols 112-115
893: 4233887744   // Page 2, Cols 116-119
894: 0            // Page 2, Cols 120-123
895: 0            // Page 2, Cols 124-127
896: 0            // Page 3, Cols 0-3
897: 0            // Page 3, Cols 4-7
898: 0            // Page 3, Cols 8-11
899: 5            // Page 3, Cols 12-15
900: 3221225120   // Page 3, Cols 16-19
901: 49376        // Page 3, Cols 20-23
902: 4169015047   // Page 3, Cols 24-27
903: 50331648     // Page 3, Cols 28-31
904: 0            // Page 3, Cols 32-35
905: 34541343     // Page 3, Cols 36-39
906: 505158716    // Page 3, Cols 40-43
907: 943257840    // Page 3, Cols 44-47
908: 4030726144   // Page 3, Cols 48-51
909: 0            // Page 3, Cols 52-55
910: 3640655791   // Page 3, Cols 56-59
911: 50331648     // Page 3, Cols 60-63
912: 0            // Page 3, Cols 64-67
913: 0            // Page 3, Cols 68-71
914: 0            // Page 3, Cols 72-75
915: 0            // Page 3, Cols 76-79
916: 3909091135   // Page 3, Cols 80-83
917: 825765944    // Page 3, Cols 84-87
918: 808983583    // Page 3, Cols 88-91
919: 252117248    // Page 3, Cols 92-95
920: 64           // Page 3, Cols 96-99
921: 4211080983   // Page 3, Cols 100-103
922: 0            // Page 3, Cols 104-107
923: 0            // Page 3, Cols 108-111
924: 3237674879   // Page 3, Cols 112-115
925: 184549376    // Page 3, Cols 116-119
926: 0            // Page 3, Cols 120-123
927: 0            // Page 3, Cols 124-127
928: 0            // Page 4, Cols 0-3
929: 0            // Page 4, Cols 4-7
930: 0            // Page 4, Cols 8-11
931: 0            // Page 4, Cols 12-15
932: 999231       // Page 4, Cols 16-19
933: 1027542787   // Page 4, Cols 20-23
934: 16777216     // Page 4, Cols 24-27
935: 0            // Page 4, Cols 28-31
936: 7192         // Page 4, Cols 32-35
937: 1010317360   // Page 4, Cols 36-39
938: 808988728    // Page 4, Cols 40-43
939: 941498127    // Page 4, Cols 44-47
940: 117506048    // Page 4, Cols 48-51
941: 0            // Page 4, Cols 52-55
942: 34017055     // Page 4, Cols 56-59
943: 1008220208   // Page 4, Cols 60-63
944: 942684208    // Page 4, Cols 64-67
945: 404495370    // Page 4, Cols 68-71
946: 0            // Page 4, Cols 72-75
947: 61           // Page 4, Cols 76-79
948: 1061094656   // Page 4, Cols 80-83
949: 0            // Page 4, Cols 84-87
950: 0            // Page 4, Cols 88-91
951: 0            // Page 4, Cols 92-95
952: 5            // Page 4, Cols 96-99
953: 253705756    // Page 4, Cols 100-103
954: 808988728    // Page 4, Cols 104-107
955: 808983582    // Page 4, Cols 108-111
956: 252117760    // Page 4, Cols 112-115
957: 0            // Page 4, Cols 116-119
958: 0            // Page 4, Cols 120-123
959: 0            // Page 4, Cols 124-127
960: 0            // Page 5, Cols 0-3
961: 0            // Page 5, Cols 4-7
962: 0            // Page 5, Cols 8-11
963: 0            // Page 5, Cols 12-15
964: 0            // Page 5, Cols 16-19
965: 0            // Page 5, Cols 20-23
966: 0            // Page 5, Cols 24-27
967: 0            // Page 5, Cols 28-31
968: 0            // Page 5, Cols 32-35
969: 0            // Page 5, Cols 36-39
970: 0            // Page 5, Cols 40-43
971: 0            // Page 5, Cols 44-47
972: 0            // Page 5, Cols 48-51
973: 0            // Page 5, Cols 52-55
974: 0            // Page 5, Cols 56-59
975: 0            // Page 5, Cols 60-63
976: 0            // Page 5, Cols 64-67
977: 0            // Page 5, Cols 68-71
978: 0            // Page 5, Cols 72-75
979: 0            // Page 5, Cols 76-79
980: 0            // Page 5, Cols 80-83
981: 0            // Page 5, Cols 84-87
982: 0            // Page 5, Cols 88-91
983: 0            // Page 5, Cols 92-95
984: 0            // Page 5, Cols 96-99
985: 0            // Page 5, Cols 100-103
986: 0            // Page 5, Cols 104-107
987: 0            // Page 5, Cols 108-111
988: 0            // Page 5, Cols 112-115
989: 0            // Page 5, Cols 116-119
990: 0            // Page 5, Cols 120-123
991: 0            // Page 5, Cols 124-127
992: 0            // Page 6, Cols 0-3
993: 0            // Page 6, Cols 4-7
994: 0            // Page 6, Cols 8-11
995: 0            // Page 6, Cols 12-15
996: 0            // Page 6, Cols 16-19
997: 0            // Page 6, Cols 20-23
998: 0            // Page 6, Cols 24-27
999: 0            // Page 6, Cols 28-31
1000: 0            // Page 6, Cols 32-35
1001: 0            // Page 6, Cols 36-39
1002: 0            // Page 6, Cols 40-43
1003: 0            // Page 6, Cols 44-47
1004: 0            // Page 6, Cols 48-51
1005: 0            // Page 6, Cols 52-55
1006: 0            // Page 6, Cols 56-59
1007: 0            // Page 6, Cols 60-63
1008: 0            // Page 6, Cols 64-67
1009: 0            // Page 6, Cols 68-71
1010: 0            // Page 6, Cols 72-75
1011: 0            // Page 6, Cols 76-79
1012: 0            // Page 6, Cols 80-83
1013: 0            // Page 6, Cols 84-87
1014: 0            // Page 6, Cols 88-91
1015: 0            // Page 6, Cols 92-95
1016: 0            // Page 6, Cols 96-99
1017: 0            // Page 6, Cols 100-103
1018: 0            // Page 6, Cols 104-107
1019: 0            // Page 6, Cols 108-111
1020: 0            // Page 6, Cols 112-115
1021: 0            // Page 6, Cols 116-119
1022: 0            // Page 6, Cols 120-123
1023: 0            // Page 6, Cols 124-127
1024: 0            // Page 7, Cols 0-3
1025: 0            // Page 7, Cols 4-7
1026: 0            // Page 7, Cols 8-11
1027: 0            // Page 7, Cols 12-15
1028: 0            // Page 7, Cols 16-19
1029: 0            // Page 7, Cols 20-23
1030: 0            // Page 7, Cols 24-27
1031: 0            // Page 7, Cols 28-31
1032: 0            // Page 7, Cols 32-35
1033: 0            // Page 7, Cols 36-39
1034: 0            // Page 7, Cols 40-43
1035: 0            // Page 7, Cols 44-47
1036: 0            // Page 7, Cols 48-51
1037: 0            // Page 7, Cols 52-55
1038: 0            // Page 7, Cols 56-59
1039: 0            // Page 7, Cols 60-63
1040: 0            // Page 7, Cols 64-67
1041: 0            // Page 7, Cols 68-71
1042: 0            // Page 7, Cols 72-75
1043: 0            // Page 7, Cols 76-79
1044: 0            // Page 7, Cols 80-83
1045: 0            // Page 7, Cols 84-87
1046: 0            // Page 7, Cols 88-91
1047: 0            // Page 7, Cols 92-95
1048: 0            // Page 7, Cols 96-99
1049: 0            // Page 7, Cols 100-103
1050: 0            // Page 7, Cols 104-107
1051: 0            // Page 7, Cols 108-111
1052: 0            // Page 7, Cols 112-115
1053: 0            // Page 7, Cols 116-119
1054: 0            // Page 7, Cols 120-123
1055: 0            // Page 7, Cols 124-127
// Total Words: 256 (1024 bytes)