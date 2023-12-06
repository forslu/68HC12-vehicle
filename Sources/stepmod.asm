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

            XREF __SEG_END_SSTACK, RTI_CTL 



CONSTANTS:  SECTION
RTIFLG:       equ     $37 
index:      	dc.b 	  $0A,$12,$14,$0C
indexr:       dc.b 	  $0C,$14,$12,$0A
port_p: 	   	equ     $258
DDR_p:        equ     $25A
port_t:       equ     $240


Variables:  Section
fdelay:       ds.w    1
sdelay:       ds.w    1
temp:         ds.w    1
rotate:       ds.w    1

MyCode:     SECTION

main:
_Startup:
Entry:      lds   #__SEG_END_SSTACK
            
            movw  #15000,fdelay 
            movw  #60000,sdelay
            movb  #$1E, DDR_p         ;Initialize motor bits 1-4
            movb  #$60, RTICTL
            cli

start:    	ldaa port_t              ;load a with port_t
            anda #3                  ;clear bits 3-7
            
chkbit:     staa temp
            brclr temp, #3, start         ;if temp=%00000000 branch to start
            brclr temp, #2, CCWspd     ;if %00000001 branch to turn
            brclr temp, #1, CWspd      ;if %00000010 branch to Slowturn 
            brset temp, #3, start         ;if temp=%00000011 branch to fasturn
            
                                


;CCW PORTION OF CODE
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                            
CCWspd:     ldaa port_t              ;load a with port_t
            anda #7

            bita #4           ;check bit2 (switch3) 
            beq  CCWsloop     ;set delay as n = #30000
            bra  CCWfloop     ;if high set delay as n = #15000
                            
                            

CCWfloop:	  ldaa indexr             ;Load index into a
           	ldx  #0                 ;Set x to 0
            
CCWfloop1:  staa port_p        ;store what's in a to port_p                                 
            inx                 ;increment x 
            ldaa indexr,x        ;increment indexr
	        	jsr  FastDelay

            cpx  #4             ;if x != 4 
	         	bne  CCWfloop1		  	;branch to loop1
	         
            lbra  start       	  ;else branch to start
            
CCWsloop:	  ldaa indexr             ;Load index into a
           	ldx  #0                 ;Set x to 0

CCWsloop1:  staa port_p              ;store what's in a to port_p                                 
            inx                     ;increment x 
            ldaa indexr,x
	        	jsr  SlowDelay          ;jumps to slowdelay in other file

            cpx  #4                ;if x != 4 
	         	bne  CCWsloop1		 	   ;branch to loop1
	         
            lbra  start       	    ;else branch to start
                        
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
            
            
;CW PORTION OF CODE           
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
 
CWspd:      ldaa port_t              ;load a with port_t
            anda #7

            bita #4           ;check bit2 (switch3) 
            beq  CWsloop     ;set delay as n = #30000
            bra  CWfloop     ;if high set delay as n = #15000
                            
                            

CWfloop:	  ldaa index             ;Load index into a
           	ldx  #0                 ;Set x to 0
            
CWfloop1:   staa port_p        ;store what's in a to port_p                                 
            inx                 ;increment x 
            ldaa index,x        ;increment indexr
	        	jsr  FastDelay

            cpx  #4             ;if x != 4 
	         	bne  CWfloop1		  	;branch to loop1
	         
            lbra  start       	  ;else branch to start
            
CWsloop:	  ldaa index             ;Load index into a
           	ldx  #0                 ;Set x to 0

CWsloop1:   staa port_p              ;store what's in a to port_p                                 
            inx                     ;increment x 
            ldaa index,x
	        	jsr  SlowDelay          ;jumps to slowdelay in other file

            cpx  #4                ;if x != 4 
	         	bne  CWsloop1		 	   ;branch to loop1
	         
            lbra  start       	    ;else branch to start
            
            
            
         
            
            
            
