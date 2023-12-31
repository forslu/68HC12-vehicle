 XDEF wrongpass_str, buttpass_str, speed_str, LCD,  
 XDEF Left_str, Right_str, crash_str, chngoil_str, ten, wun, string_copy      
 XDEF pass1_str, pass11_str, pass111_str, pass1111_str
      
 XREF __SEG_END_SSTACK, init_LCD, display_string, pot_value, read_pot, mph, DCFlag, LCDFlag ,temp_str, disp,

my_variable: SECTION


ten:      ds.w 1
wun:      ds.w 1

;constant section
my_constant: SECTION
;LCD Strings


pass1_str       dc.b  ' Enter Password        *        ',0
pass11_str      dc.b  ' Enter Password        **       ',0 
pass111_str     dc.b  ' Enter Password        ***      ',0
pass1111_str    dc.b  ' Enter Password        ****     ',0
wrongpass_str   dc.b  ' Wrong Password                 ',0
buttpass_str    dc.b  'Fancy Car:      Push to start   ',0
speed_str       dc.b  'Speed is:    mph                ',0
Left_str        dc.b  'Left Turn                       ',0
Right_str       dc.b  'Right Turn                      ',0
crash_str       dc.b  'Oopsie we crash,enter pass      ',0
chngoil_str     dc.b  'Oopsie no oil   enter pass      ',0
                                     ;|
                                     ;^screen newline


; code section
MyCode:     SECTION


LCD:
           ; pshx
           ; brset LCDFlag, #1 ,lcdcont
           ; movb #1, LCDFlag
            ;jsr init_LCD
 lcdcont: 	;pulx
            pshy
            ldy #disp
	          jsr string_copy				;passes arguments to string copy subroutine
    
            ldd #disp
            brset DCFlag, #1, Dispeed    ;get pot then speed to display with
            jsr display_string
            puly
            rts



  

;**************************************************************

string_copy:   pshb
	    
	             ldab #33					;copies string starting at the first argument into the string starting at the second argument element-by-element
 cpy_loop:     ldaa 1,x+					;uses x and y to store pointers
	             staa 1,y+
	             decb
	             bne cpy_loop				;repeats if b != 0
	             pulb
               rts					;pull and return

Dispeed:
	  ldx #speed_str
    ldy #disp
    jsr string_copy

		
    ldd #00
  	ldab mph
	        
    ldy 	#0
		sty 	ten
		cmpb 	#10
	  blt 	wuns
		ldx  	#10
		idiv

	  stx 	ten
		
		
wuns: std 	wun
	  	ldd 	#0
	  	ldd 	ten
	  	addd 	#$30
	  	stab 	disp + 10
	  	ldd 	#0
	  	ldd 	wun
	  	addd 	#$30
	  	stab 	disp + 11	
		
	    ldd #disp
	    jsr display_string
	  	;movb  #0, DCFlag
	  	puly
	    rts











