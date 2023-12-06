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
            XDEF Entry, _Startup, main, 
            XREF __SEG_END_SSTACK,  RTI_ISR, sum   
            
            
            
            

MY_EXTENDED_RAM: SECTION
password ds.b 4



MyCode:     SECTION
main:
_Startup:
Entry:
            LDS  #__SEG_END_SSTACK     ; initialize the stack pointer
            CLI                     ; enable interrupts
            

;START
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                      ;set password for start
                      ;call keypad for password
                      
                      
                      ;speaker for correct and incorrect 
                      
                      ;return to start if incorrect
                      
                      ;push to start
                     
;POT
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;pot:
      ;jsr read pot value
                
                ;sort alg:     
                          ;is potval < or >= 31
                             ;<
                                  ;bne 0, 15mph 
                                    ;(potval=0) ton = 0 toff = 15
                                    ;bra pot
                                  
                                  ;15mph: ton = 4 toff = 11  
                                    ;bra pot
                                  
                             ;>=
                                  ;is potval < or >= 61
                                  
                                    ;<
                                        ;ton = 8 toff = 7
                                        ;bra pot
                                
                                    ;>=
                                        ;potval > 90
                                          ;ton = 15 toff = 0
                                          ;bra pot
                                          
                                        ;else (potval <= 90)
                                          ;ton = 12 toff = 3
                                          ;bra pot
                                        
                                    
                      
;DC MOTOR
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      ;set interrupt freq to 1 second
      ;collects mileage  





;IRQ
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      
   ;jsr keypadcrash   
      
      
      
;KEYPAD
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ;password ds.b 4    01, 02, 03, 04
 ;keypad input into a load first byte of password into b
 ;cba (compare b to a)
 ;continue for rest 


 ;keypadcrash:      
                    ;enter crash password
                    


;SWITCHES
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    




;TURNING
;__________________________________________________________________________________

;STEPPER MOTOR
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;LED
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     ;turn signal

;____________________________________________________________________________________



;LCD
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~












;PUSH BUTTON
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~






;SPEAKER
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
                      
                      