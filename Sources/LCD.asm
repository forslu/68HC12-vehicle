 XDEF enterpass_str, wrongpass_str, buttpass_str, speed_str, LCD 
 XDEF Left_str, Right_str, crash_str, chngoil_str, temp_str, disp      

      
 XREF __SEG_END_SSTACK, init_LCD, display_string, pot_value, read_pot

my_variable: SECTION
disp:	    ds.b 33
temp_str: ds.b 33


;constant section
my_constant: SECTION
;LCD Strings
enterpass_str   dc.b  'Enter Password:                 ',0
wrongpass_str   dc.b  'Incorrect Password:             ',0
buttpass_str    dc.b  'Push button to start:          ',0
speed_str       dc.b  'Speed in mph is:                ',0
Left_str        dc.b  'Left Turn:                      ',0
Right_str       dc.b  'Right Turn:                         ',0
crash_str       dc.b  'Oopsie we crash, enter pass:          ',0
chngoil_str     dc.b  'Oopsie no oil, enter pass:          ',0
                



; code section
MyCode:     SECTION

LCD:
			
	ldx #temp_str			;loads arguments into registers
	ldy #disp 
	jsr string_copy				;passes arguments to string copy subroutine
	jsr init_LCD
	jsr display_string  


;**************************************************************

string_copy:   pshb
	    
	             ldab #33					;copies string starting at the first argument into the string starting at the second argument element-by-element
 cpy_loop:     ldaa 1,x+					;uses x and y to store pointers
	             staa 1,y+
	             decb
	             bne cpy_loop				;repeats if b != 0
	             pulb
               rts					;pull and return

start:		ldy 	#0
		;sty 	hund
		jsr 	read_pot
		ldd 	pot_value
		cpd 	#100
	;	blt 	tens
  	        ldx 	#100
		idiv
			
		tfr x, a
		adda 	#$30
	;	staa 	hund
			
  	
;tens: 	        ldy 	#0
	;	sty 	ten
	;	cpd 	#10
	  ;blt 	wuns
		ldx  	#10
		idiv

	 ;stx 	ten
		
		
;wuns: std 	wun
				
	;	ldd 	hund
		addd 	#$30
		stab 	disp + 24
		ldd 	#0
	;	ldd 	ten
		addd 	#$30
		stab 	disp + 25
		ldd 	#0
	;	ldd 	wun
		addd 	#$30
		stab 	disp + 26	

		ldd 	#disp
		jsr	display_string
		
		bra 	start











