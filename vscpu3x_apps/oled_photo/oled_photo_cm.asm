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
50: CPi 111 500       // R111 = Pointer to Image Data (500)
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
// IMAGE DATA (Array begins at 500)
// ==========================================
// ==========================================
// IMAGE DATA (Array begins at 500)
// ==========================================

// --- SSD1306 IMAGE DATA: VSCPU.png ---
// Architecture: 8 Pages (Horizontal Mode) | 4 Columns per 32-bit Word
500: 0            // Page 0, Cols 0-3
501: 0            // Page 0, Cols 4-7
502: 0            // Page 0, Cols 8-11
503: 0            // Page 0, Cols 12-15
504: 0            // Page 0, Cols 16-19
505: 0            // Page 0, Cols 20-23
506: 0            // Page 0, Cols 24-27
507: 0            // Page 0, Cols 28-31
508: 0            // Page 0, Cols 32-35
509: 0            // Page 0, Cols 36-39
510: 0            // Page 0, Cols 40-43
511: 0            // Page 0, Cols 44-47
512: 0            // Page 0, Cols 48-51
513: 0            // Page 0, Cols 52-55
514: 0            // Page 0, Cols 56-59
515: 0            // Page 0, Cols 60-63
516: 0            // Page 0, Cols 64-67
517: 0            // Page 0, Cols 68-71
518: 0            // Page 0, Cols 72-75
519: 0            // Page 0, Cols 76-79
520: 0            // Page 0, Cols 80-83
521: 0            // Page 0, Cols 84-87
522: 0            // Page 0, Cols 88-91
523: 0            // Page 0, Cols 92-95
524: 0            // Page 0, Cols 96-99
525: 0            // Page 0, Cols 100-103
526: 0            // Page 0, Cols 104-107
527: 0            // Page 0, Cols 108-111
528: 0            // Page 0, Cols 112-115
529: 0            // Page 0, Cols 116-119
530: 0            // Page 0, Cols 120-123
531: 0            // Page 0, Cols 124-127
532: 0            // Page 1, Cols 0-3
533: 0            // Page 1, Cols 4-7
534: 0            // Page 1, Cols 8-11
535: 0            // Page 1, Cols 12-15
536: 0            // Page 1, Cols 16-19
537: 0            // Page 1, Cols 20-23
538: 0            // Page 1, Cols 24-27
539: 0            // Page 1, Cols 28-31
540: 0            // Page 1, Cols 32-35
541: 0            // Page 1, Cols 36-39
542: 0            // Page 1, Cols 40-43
543: 0            // Page 1, Cols 44-47
544: 0            // Page 1, Cols 48-51
545: 0            // Page 1, Cols 52-55
546: 0            // Page 1, Cols 56-59
547: 0            // Page 1, Cols 60-63
548: 0            // Page 1, Cols 64-67
549: 0            // Page 1, Cols 68-71
550: 0            // Page 1, Cols 72-75
551: 0            // Page 1, Cols 76-79
552: 0            // Page 1, Cols 80-83
553: 0            // Page 1, Cols 84-87
554: 0            // Page 1, Cols 88-91
555: 0            // Page 1, Cols 92-95
556: 0            // Page 1, Cols 96-99
557: 0            // Page 1, Cols 100-103
558: 0            // Page 1, Cols 104-107
559: 0            // Page 1, Cols 108-111
560: 0            // Page 1, Cols 112-115
561: 0            // Page 1, Cols 116-119
562: 0            // Page 1, Cols 120-123
563: 0            // Page 1, Cols 124-127
564: 0            // Page 2, Cols 0-3
565: 0            // Page 2, Cols 4-7
566: 0            // Page 2, Cols 8-11
567: 5372         // Page 2, Cols 12-15
568: 4244144128   // Page 2, Cols 16-19
569: 0            // Page 2, Cols 20-23
570: 32960        // Page 2, Cols 24-27
571: 4042800156   // Page 2, Cols 28-31
572: 67108864     // Page 2, Cols 32-35
573: 2162225400   // Page 2, Cols 36-39
574: 941366284    // Page 2, Cols 40-43
575: 203164700    // Page 2, Cols 44-47
576: 473437184    // Page 2, Cols 48-51
577: 0            // Page 2, Cols 52-55
578: 32960        // Page 2, Cols 56-59
579: 4033902616   // Page 2, Cols 60-63
580: 470555660    // Page 2, Cols 64-67
581: 203164700    // Page 2, Cols 68-71
582: 943214592    // Page 2, Cols 72-75
583: 0            // Page 2, Cols 76-79
584: 4258044      // Page 2, Cols 80-83
585: 2081164300   // Page 2, Cols 84-87
586: 203164860    // Page 2, Cols 88-91
587: 4244172800   // Page 2, Cols 92-95
588: 0            // Page 2, Cols 96-99
589: 10550524     // Page 2, Cols 100-103
590: 3154116608   // Page 2, Cols 104-107
591: 0            // Page 2, Cols 108-111
592: 53500        // Page 2, Cols 112-115
593: 4233887744   // Page 2, Cols 116-119
594: 0            // Page 2, Cols 120-123
595: 0            // Page 2, Cols 124-127
596: 0            // Page 3, Cols 0-3
597: 0            // Page 3, Cols 4-7
598: 0            // Page 3, Cols 8-11
599: 5            // Page 3, Cols 12-15
600: 3221225120   // Page 3, Cols 16-19
601: 49376        // Page 3, Cols 20-23
602: 4169015047   // Page 3, Cols 24-27
603: 50331648     // Page 3, Cols 28-31
604: 0            // Page 3, Cols 32-35
605: 34541343     // Page 3, Cols 36-39
606: 505158716    // Page 3, Cols 40-43
607: 943257840    // Page 3, Cols 44-47
608: 4030726144   // Page 3, Cols 48-51
609: 0            // Page 3, Cols 52-55
610: 3640655791   // Page 3, Cols 56-59
611: 50331648     // Page 3, Cols 60-63
612: 0            // Page 3, Cols 64-67
613: 0            // Page 3, Cols 68-71
614: 0            // Page 3, Cols 72-75
615: 0            // Page 3, Cols 76-79
616: 3909091135   // Page 3, Cols 80-83
617: 825765944    // Page 3, Cols 84-87
618: 808983583    // Page 3, Cols 88-91
619: 252117248    // Page 3, Cols 92-95
620: 64           // Page 3, Cols 96-99
621: 4211080983   // Page 3, Cols 100-103
622: 0            // Page 3, Cols 104-107
623: 0            // Page 3, Cols 108-111
624: 3237674879   // Page 3, Cols 112-115
625: 184549376    // Page 3, Cols 116-119
626: 0            // Page 3, Cols 120-123
627: 0            // Page 3, Cols 124-127
628: 0            // Page 4, Cols 0-3
629: 0            // Page 4, Cols 4-7
630: 0            // Page 4, Cols 8-11
631: 0            // Page 4, Cols 12-15
632: 999231       // Page 4, Cols 16-19
633: 1027542787   // Page 4, Cols 20-23
634: 16777216     // Page 4, Cols 24-27
635: 0            // Page 4, Cols 28-31
636: 7192         // Page 4, Cols 32-35
637: 1010317360   // Page 4, Cols 36-39
638: 808988728    // Page 4, Cols 40-43
639: 941498127    // Page 4, Cols 44-47
640: 117506048    // Page 4, Cols 48-51
641: 0            // Page 4, Cols 52-55
642: 34017055     // Page 4, Cols 56-59
643: 1008220208   // Page 4, Cols 60-63
644: 942684208    // Page 4, Cols 64-67
645: 404495370    // Page 4, Cols 68-71
646: 0            // Page 4, Cols 72-75
647: 61           // Page 4, Cols 76-79
648: 1061094656   // Page 4, Cols 80-83
649: 0            // Page 4, Cols 84-87
650: 0            // Page 4, Cols 88-91
651: 0            // Page 4, Cols 92-95
652: 5            // Page 4, Cols 96-99
653: 253705756    // Page 4, Cols 100-103
654: 808988728    // Page 4, Cols 104-107
655: 808983582    // Page 4, Cols 108-111
656: 252117760    // Page 4, Cols 112-115
657: 0            // Page 4, Cols 116-119
658: 0            // Page 4, Cols 120-123
659: 0            // Page 4, Cols 124-127
660: 0            // Page 5, Cols 0-3
661: 0            // Page 5, Cols 4-7
662: 0            // Page 5, Cols 8-11
663: 0            // Page 5, Cols 12-15
664: 0            // Page 5, Cols 16-19
665: 0            // Page 5, Cols 20-23
666: 0            // Page 5, Cols 24-27
667: 0            // Page 5, Cols 28-31
668: 0            // Page 5, Cols 32-35
669: 0            // Page 5, Cols 36-39
670: 0            // Page 5, Cols 40-43
671: 0            // Page 5, Cols 44-47
672: 0            // Page 5, Cols 48-51
673: 0            // Page 5, Cols 52-55
674: 0            // Page 5, Cols 56-59
675: 0            // Page 5, Cols 60-63
676: 0            // Page 5, Cols 64-67
677: 0            // Page 5, Cols 68-71
678: 0            // Page 5, Cols 72-75
679: 0            // Page 5, Cols 76-79
680: 0            // Page 5, Cols 80-83
681: 0            // Page 5, Cols 84-87
682: 0            // Page 5, Cols 88-91
683: 0            // Page 5, Cols 92-95
684: 0            // Page 5, Cols 96-99
685: 0            // Page 5, Cols 100-103
686: 0            // Page 5, Cols 104-107
687: 0            // Page 5, Cols 108-111
688: 0            // Page 5, Cols 112-115
689: 0            // Page 5, Cols 116-119
690: 0            // Page 5, Cols 120-123
691: 0            // Page 5, Cols 124-127
692: 0            // Page 6, Cols 0-3
693: 0            // Page 6, Cols 4-7
694: 0            // Page 6, Cols 8-11
695: 0            // Page 6, Cols 12-15
696: 0            // Page 6, Cols 16-19
697: 0            // Page 6, Cols 20-23
698: 0            // Page 6, Cols 24-27
699: 0            // Page 6, Cols 28-31
700: 0            // Page 6, Cols 32-35
701: 0            // Page 6, Cols 36-39
702: 0            // Page 6, Cols 40-43
703: 0            // Page 6, Cols 44-47
704: 0            // Page 6, Cols 48-51
705: 0            // Page 6, Cols 52-55
706: 0            // Page 6, Cols 56-59
707: 0            // Page 6, Cols 60-63
708: 0            // Page 6, Cols 64-67
709: 0            // Page 6, Cols 68-71
710: 0            // Page 6, Cols 72-75
711: 0            // Page 6, Cols 76-79
712: 0            // Page 6, Cols 80-83
713: 0            // Page 6, Cols 84-87
714: 0            // Page 6, Cols 88-91
715: 0            // Page 6, Cols 92-95
716: 0            // Page 6, Cols 96-99
717: 0            // Page 6, Cols 100-103
718: 0            // Page 6, Cols 104-107
719: 0            // Page 6, Cols 108-111
720: 0            // Page 6, Cols 112-115
721: 0            // Page 6, Cols 116-119
722: 0            // Page 6, Cols 120-123
723: 0            // Page 6, Cols 124-127
724: 0            // Page 7, Cols 0-3
725: 0            // Page 7, Cols 4-7
726: 0            // Page 7, Cols 8-11
727: 0            // Page 7, Cols 12-15
728: 0            // Page 7, Cols 16-19
729: 0            // Page 7, Cols 20-23
730: 0            // Page 7, Cols 24-27
731: 0            // Page 7, Cols 28-31
732: 0            // Page 7, Cols 32-35
733: 0            // Page 7, Cols 36-39
734: 0            // Page 7, Cols 40-43
735: 0            // Page 7, Cols 44-47
736: 0            // Page 7, Cols 48-51
737: 0            // Page 7, Cols 52-55
738: 0            // Page 7, Cols 56-59
739: 0            // Page 7, Cols 60-63
740: 0            // Page 7, Cols 64-67
741: 0            // Page 7, Cols 68-71
742: 0            // Page 7, Cols 72-75
743: 0            // Page 7, Cols 76-79
744: 0            // Page 7, Cols 80-83
745: 0            // Page 7, Cols 84-87
746: 0            // Page 7, Cols 88-91
747: 0            // Page 7, Cols 92-95
748: 0            // Page 7, Cols 96-99
749: 0            // Page 7, Cols 100-103
750: 0            // Page 7, Cols 104-107
751: 0            // Page 7, Cols 108-111
752: 0            // Page 7, Cols 112-115
753: 0            // Page 7, Cols 116-119
754: 0            // Page 7, Cols 120-123
755: 0            // Page 7, Cols 124-127
// Total Words: 256 (1024 bytes)