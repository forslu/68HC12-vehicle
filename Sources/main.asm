;**************************************************************
;* Notes:                                                     *
;*       -LCDflag Key: 0=start, 1=IRQ, 2=ChnOil,                  *
;*        *
;*        *
;*               *
;*        *
;**************************************************************
; Include derivative-specific definitions
            INCLUDE 'derivative.inc'

; export symbols
            XDEF Entry, _Startup, main, ton, toff
            XREF __SEG_END_SSTACK, Swich, TurnFlag, DCFlag, TurnDurFlag, SLCDCrash, LCDEmpty, LCDEnterpass, LCDincorrect, LCDpushbutton, LCDspeed, LCDFlag, LCD, LCDOil, pot_val, read_pot,  RTI_ISR, sum, hexval, JUMPASS   
                                   
            
            
   ;potentiometer.c.o was created auto????         

MY_EXTENDED_RAM: SECTION
strtpass dc.b  $EB, $77, $7B, $7D
oilpass  dc.b  $7D, $7B, $77

myvars:   section
passtemp  ds.b  4
passkey   ds.b  4
OilFlag   ds.b  1
ton:      ds.b  1
toff:     ds.b  1
mph:      ds.b  1
OdoNum:   ds.w  1
DCount:  ds.b  1


MyCode:     SECTION
main:
_Startup:
Entry:
            LDS  #__SEG_END_SSTACK     ; initialize the stack pointer
            CLI                     ; enable interrupts
            

;START
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Start:      ldx  #0
            brset OilFlag, #1, GetOilPass
GetPass:    ;set password for start
            ;call LCD to display "enter password"
            jsr  JUMPASS     ;call keypad for password
            ldaa hexval     ;load keypad value  to a
            staa passtemp, x   ;store keypad val to passtemp
            inx              ;
            cpx  #4
            bne  GetPass
            bra  CompPass

                        
GetOilPass: ldx #0
Oilloop:    jsr  JUMPASS     ;call keypad for password
            ldaa hexval     ;load keypad value  to a
            staa passtemp, x   ;store keypad val to passtemp
            inx              ;
            cpx  #3
            bne  Oilloop
            bra  OilCh        ;branch to OilCh 
            
            
;compare password with entry          
CompPass:   ldx #0                ;x is counter for pass digits
            bra   ButtPass           ;else branch to ButtPass
            
OilCh:      ldx #0
            inx               ;check one less digit (3)
            ldaa  oilpass          ;set passkey to Oilpassword
            staa  passkey
            bra   chkpass          ;branch to check password
                        
ButtPass:   ldaa strtpass          ;set passkey to startpassword
            staa passkey
            bra  chkpass           ;branch to check password
                 
chkpass:    cpx  #4
            beq  GoodPass
            ldaa passtemp, x  ;this or do y+
            ldab passkey, x  ;and x
            inx
            cba
            beq CompPass
            bra BadPass
            
            
GoodPass:   ;WIP//jsr HappySound                  ;speaker for correct
            movb  #0, OilFlag        ;clear OilFlag
            bra Push2strt
                      
BadPass:    ;WIP//jsr SadSound                  ;speaker for incorrect 
            ;WIP//call LCD to display "wrong password"
            lbra Start          
                      ;return to start 
Push2strt:            ;WIP//call LCD to display "press button to start"
                      ;//WIP push to start
                     
;POT
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

pot:
              jsr read_pot  ;jsr read pot value
                
                    
;sortpot
;_________________________________________________________________________     
sortpot:      ldaa  pot_val         ;is pot_val 0   
              cmpa  #0
              beq   Pot0        ;if so branch to end
                
              cmpa  #31          ;is potval < or >= 31
              bge   MidPotChk    ;if >= branch to UpotChk
                                                
;potval is < 31              
              movb  #15, mph      ;mph = 15              
              movb  #4,  ton      ;ton = 4
              movb  #11, toff     ;toff = 11
              bra   PotFound       ;bra pot                 
                            
                                   
MidPotChk:    cmpa  #61                ;is potval < or >= 61      
              bge   HiPotChk           ;if >= branch to HiPotChk
                                 
;potval is < 61              
              movb  #30, mph      ;mph = 30             
              movb  #8,  ton      ;ton = 8
              movb  #7,  toff     ;toff = 7
              bra   PotFound      ;bra pot                      
                                      
                                
HiPotChk:     cmpa #91            ;is potval < or >= 91
              bge  MaxPot         ;if >= branch to MaxPot
              
;potval is < 91              
              movb  #45, mph      ;mph = 45             
              movb  #12,  ton     ;ton = 12
              movb  #3,  toff     ;toff = 3
              bra   PotFound      ;bra pot                    
                                         
                                          
MaxPot:                                        
;potval is >= 91  
              movb  #45, mph      ;mph = 60             
              movb  #12,  ton     ;ton = 15
              movb  #3,  toff     ;toff =0
              bra   PotFound      ;bra potFound                                          
Pot0:
;(potval=0) ton = 0 toff = 15 
              movb  #0, mph      ;mph = 60             
              movb  #0, ton      ;ton = 15
              movb  #0, toff     ;toff =0
              bra   PotFound     ;bra potFound 
                                                       
PotFound:
              ;jsr   DCMOTOR
              bra   ODO
              
                                                         
  
;_______________________________________________________________________                                  
                      
;DC MOTOR (ODOMETER)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ODO:        brset DCFlag, #1, AddMi        ;branch if check second flag=1
            bra   Switches         ;next           
           


AddMi:      
 ;collects mileage 
            movb  #0, DCFlag  ;clearing flag
            ldab  mph         ;load b with mph
            ldx   OdoNum      ;load x with OdoNum and add them
            abx
            stx   OdoNum      ;store x back to OdoNum
            cpx   #3000       ;If Odonum is >= 3000 change oil
            bge   ChgOil
            lbra   Start      ;else move on
            
ChgOil:         ;suspend all devices
            movb #2, LCDFlag
            movb #1, OilFlag          
            jsr  LCDOil
            jsr  CompPass
            bra  Switches
            
             

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
                    


;TURNING
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
 Switches:  brset TurnFlag, #2, strturn
            bra   pushbutt
            
 strturn:   movb #0, TurnFlag
            jsr Swich   
            
            
                 

;STEPPER MOTOR
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



;TURNING
;__________________________________________________________________________________


;LED
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     ;turn signal

;____________________________________________________________________________________



;LCD
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~












;PUSH BUTTON
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   pushbutt:





;SPEAKER
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
                      
                      