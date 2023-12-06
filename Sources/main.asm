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

            XREF __SEG_END_SSTACK      ; symbol defined by the linker for the end of the stack
            
            ; LCD References
	         

            ; Potentiometer References
          



; variable/data section
my_variable: SECTION
disp:	ds.b 33

;constant section
my_constant: SECTION
constant_string dc.b    'The value of the pot is:        ',0


; code section
MyCode:     SECTION
Entry:
_Startup:

	lds #__SEG_END_SSTACK			;initializes stack pointer	
	ldx #constant_string			;loads arguments into registers
	ldy #disp 
	jsr string_copy				;passes arguments to string copy subroutine





;**************************************************************
;
;                   Write You Code Here
;
;**************************************************************	
; tip: do not let your code fall into the subroutine below this line


string_copy: pshb
	     ldab #33					;copies string starting at the first argument into the string starting at the second argument element-by-element
   cpy_loop: ldaa 1,x+					;uses x and y to store pointers
	     staa 1,y+
	     decb
	     bne cpy_loop				;repeats if b != 0
	     pulb
             rts					;pull and return


