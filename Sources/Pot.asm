
            INCLUDE 'derivative.inc'

; export symbols
            XDEF potval,
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on

            XREF __SEG_END_SSTACK, read_pot, display_string, pot_value,   ; symbol defined by the linker for the end of the stack
            
            ; LCD References
	         

            ; Potentiometer References
          



; variable/data section
my_variable: SECTION
hund:	ds.w 1
ten:	ds.w 1
wun:	ds.w 1
;temp:	ds.b 1

potval: ds.b 1


; code section
MyCode:     SECTION
		lds #__SEG_END_SSTACK	
	 
start:ldy #0
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
			
  	
tens: ldy #0
		  sty ten
		  cpd #10
	    blt wuns
		  ldx  #10
		  idiv

	    stx ten
		
		
wuns:   std wun
				
		  ldd hund
		  addd #$30
		  stab potval
		  ldd #0
		  ldd ten
		  addd #$30
		  stab potval + 1
		  ldd #0
		  ldd wun
		  addd #$30
		  stab potval + 2	

		  ldd #disp
		
		  rts












