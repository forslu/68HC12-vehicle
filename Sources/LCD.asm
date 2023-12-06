 XDEF Entry, _Startup
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on

            XREF __SEG_END_SSTACK, init_LCD, display_string

;*********************string initializations*********************
           ;intializing string "disp" to be:
           ;"The value of the pot is:      ",0
           movb #'T',disp
           movb #'h',disp+1
           movb #'e',disp+2
           movb #' ',disp+3
           movb #'v',disp+4
           movb #'a',disp+5
           movb #'l',disp+6
           movb #'u',disp+7
           movb #'e',disp+8
           movb #' ',disp+9
           movb #'o',disp+10
           movb #'f',disp+11
           movb #' ',disp+12
           movb #'t',disp+13
           movb #'h',disp+14
           movb #'e',disp+15
           movb #' ',disp+16
           movb #'p',disp+17
           movb #'o',disp+18
           movb #'t',disp+19
           movb #' ',disp+20
           movb #'i',disp+21
           movb #'s',disp+22
           movb #':',disp+23
           movb #' ',disp+24
           movb #' ',disp+25
           movb #' ',disp+26
           movb #' ',disp+27
           movb #' ',disp+28
           movb #' ',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************



my_variable: SECTION
disp:	ds.b 33

; code section
MyCode:     SECTION
		lds #__SEG_END_SSTACK


		jsr init_LCD




		jsr display_string





