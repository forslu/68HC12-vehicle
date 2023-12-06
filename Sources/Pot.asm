;**************************************************************
;* This stationery serves as the framework for a              *
;* user application. For a more comprehensive program that    *
;* demonstrates the more advanced functionality of this       *
;* processor, please see the demonstration applications       *
;* located in the examples subdirectory of the                *
;* Freescale CodeWarrior for the HC12 Program directory       *
;**************************************************************
; Include derivative-specific definitions
            INCLUDE 'derivative.inc'

; export symbols
            XDEF Entry, _Startup
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on

            XREF __SEG_END_SSTACK, init_LCD, read_pot, display_string, pot_value,   ; symbol defined by the linker for the end of the stack
            
            ; LCD References
	         

            ; Potentiometer References
          



; variable/data section
my_variable: SECTION
disp:	ds.b 33
hund:	ds.w 1
ten:	ds.w 1
wun:	ds.w 1
;temp:	ds.b 1


; code section
MyCode:     SECTION
		lds #__SEG_END_SSTACK


	
	 
start:	ldy #0
		sty hund
		jsr read_pot
		ldd pot_value
		cpd #100
		blt tens
  	    ldx #100
		idiv
			
		tfr x, a
		adda #$30
		staa hund
			
  	
tens: 	ldy #0
		sty ten
		cpd #10
	    blt wuns
		ldx  #10
		idiv

	    stx ten
		
		
wuns:   std wun
				
		ldd hund
		addd #$30
		stab disp + 24
		ldd #0
		ldd ten
		addd #$30
		stab disp + 25
		ldd #0
		ldd wun
		addd #$30
		stab disp + 26	

		ldd #disp
	
		
		bra start












