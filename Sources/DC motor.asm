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
            XDEF Entry, _Startup, main, RTI_ISR
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on

            XREF __SEG_END_SSTACK, RTI_CTL        ; symbol defined by the linker for the end of the stack




Constants: section

;CRGINT equ $38
RTIFLG  equ $37 
port_s:       equ    $248
port_s_ddr:   equ    $24A
port_t:	      equ	   $240
port_t_ddr:	  equ	   $242
port_u:       equ    $268
port_u_ddr:   equ    $26A
port_u_pde:   equ    $26C
port_u_psr:   equ    $26D
send:         dc.b   $70, $B0, $D0, $E0, $0      
index:        dc.b   $EB, $77, $7B, $7D, $B7, $BB, $BD, $D7, $DB, $DD, $E7, $ED, $7E, $BE, $DE, $EE

vars:   SECTION

preval: ds.b  1
temp:   ds.b  1
count:  ds.b 1
loop:   ds.b  1
Ton:	  ds.b	1
Toff:	  ds.b	1

; code section
MyCode:     SECTION
main:
_Startup:
Entry:       lds  #__SEG_END_SSTACK
		         movb #$8, port_t_ddr	 ;set bit 3 of port t
             movb #$F0, port_u_ddr   ;set 0-3 input and 4-7 output
             movb #$F0, port_u_psr   ;set up 0-3 as pullup device
             movb #$0F, port_u_pde   ;activate pullup device on pins 0-3 
             movb #$FF, port_s_ddr   ;set port_s as output
             movb  #$80, CRGINT
             movb  #$60, RTICTL
             cli

;P2. scan all four rows~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             ldaa #0
             staa preval
          

start:       ldy  #send  ;step counter
             ldaa #0
           
scan:        ldaa 1, y+  ;store y into port_u post dec
             beq  nopress    ;used to be branch to nopress
             ;if no keypress is detected after one run, branch to nopress
             
             staa port_u
             
             jsr  delay1      ;jump to 1ms delay      BOUNCE: UNCOMMENT WHEN FINISHED
             ldaa port_u
             staa temp    ;DEBUGGING worked before moving here
            
             anda #$F         ;AND to mask off upper

             cmpa #$F         ;if lower nib is not 1111             
             beq  scan      ;KEY IS PRESSED, branch to check 

           
 

;MODIFIED LAB4 CODE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;TESTS COLUMNS TO FIND CORRECT SWITCH

lookup:     ldy #index    ;load index y with 0
            ldaa temp
            ldx #0
firstLoop:
                 
            cmpa y      ;compare ACC a to index
            beq endloop     ;branch to end if equal
  
              
            inx
            iny
            cpx #16        ;compare A to 16 (1-16) CCR z=0 if equal
            bne firstLoop    ;branch to firstLoop if A != 16

endloop:    tfr x,d         ;transfer value of index x to d
            tba
            staa Ton
            staa preval
            ldaa #15
          	suba Ton
            staa Toff                      ;take indexvalue in acc B and move it to A
            bra start
            
;nopress is executed when we get no keypad input             
nopress:    ldaa preval     
            staa Ton
            ldaa #15
          	suba Ton
            staa Toff                      ;take indexvalue in acc B and move it to A
           
            bra start            
            

;END OF COORDINATE 

;RUN MOTOR~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~          
RTI_ISR:    ldaa Ton                      
            ldab Toff
RTon:	      
	          inc count
	          ldaa count
	          
	          cmpa #15         ;if counter > 15 exit
	          bge reset        ;~~~~~~~~~~~~~~~~
	          
	          cmpa Ton            ;if counter is greater than ton branch to RToff
	          bge  RToff          ;~~~~~~~~~~~
	          
	          bset port_t, #$8    ;set motor
	          bra endrti
	        
	          
	    
	          
RToff:      bclr port_t, #$8
           
            

endrti:     bset CRGFLG, #$80
            rti

reset:      movb #0, count
            bra endrti           


;delay subroutine 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
delay1:   
        pshx
      
        ldx #1000  ;2 c
loopd:
        dex      ;1 c
        cpx #0    
        bne loopd  ;3/1
        pulx
       
       
        rts
