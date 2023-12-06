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
            XDEF Entry, _Startup, main, ton, toff, DCFlag, LCDFlag,mph, CRGFLG, tempstring
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on

            XREF init_LCD, read_pot, display_string,       ; symbol defined by the linker for the end of the stack
            XREF __SEG_END_SSTACK, JUMPASS, hexval, Pbutton ,RTI_ISR,
            ; Swich, TurnFlag, DCFlag, TurnDurFlag, SLCDCrash
            XREF pot_value, speed_str, GetSpd  
           ;  sum,  SendsChr.c
            XREF potentiometer.c, LCD, enterpass_str, wrongpass_str, buttpass_str
            XREF Left_str, Right_str, crash_str, chngoil_str, disp
            ; LCD References
	         

            ; Potentiometer References
          
   ;for LCD statements enter:
   ;         ldx  #*_str   ;call LCD to display               
           ; jsr  LCD


; variable/data section
my_variable: SECTION

passtemp:       ds.b  4
passkey:        ds.b  4
OilFlag:        ds.b  1
LCDFlag:        ds.b  1
DCFlag:         ds.b  1
ton:            ds.b  1
toff:           ds.b  1
mph:            ds.b  1
OdoNum:         ds.w  1
DCount:         ds.b  1
tempstring:     ds.b 33

;constant section
my_constant: SECTION

constant_string dc.b  'The value of the pot is:        ',0
strtpass        dc.b   $1, $2, $3, $4
oilpass         dc.b   $1, $2, $3


; code section
MyCode:     SECTION
Entry:
_Startup:
main:
            jsr init_LCD
          	lds #__SEG_END_SSTACK			;initializes stack pointer	
           ; cli


Start:      
            
            ;brset OilFlag, #1, GetOilPass
            
            ldx  #enterpass_str   ;call LCD to display               
            jsr  LCD

WrongPass:  ldx  #0
GetPass:    
            jsr  JUMPASS     ;call keypad for password
            ldaa hexval     ;load keypad value to a
            staa passtemp, x   ;store keypad val to passtemp
            inx              ;
            cpx  #4
            bne  GetPass
            bra  CompPass

GetOilPass: ldx #0
;Oilloop:    jsr  JUMPASS     ;call keypad for password
;            ldaa hexval     ;load keypad value  to a
            staa passtemp, x   ;store keypad val to passtemp
            inx              ;
            cpx  #3
;            bne  Oilloop
            bra  OilCh        ;branch to OilCh 
            
            
;compare password with entry          
CompPass:   ldx   #0                ;x is counter for pass digits
            bra   ButtPass           ; branch to ButtPass
            
OilCh:      ldx   #0
                           ;check one less digit (3)
Oipass:     ldaa  oilpass, x   ;maybe immediate?       ;set passkey to Oilpassword
            staa  passkey, x
            inx
            cpx   #3
            bne   Oipass
            bra   chkpass          ;branch to check password
                        
ButtPass:   ldaa  strtpass, x        ;set passkey to startpassword
            staa  passkey, x
            inx
            cpx #4
            bne ButtPass
            bra   chkpass           ;branch to check password
                 
chkpass:    ldx   #0
chkloop:    cpx   #4
            beq   GoodPass
            ldaa  passtemp, x  ;this or do y+
            ldab  passkey, x  ;and x
            inx
            cba
            beq   chkloop
            bra   BadPass
            
            
GoodPass:   ;WIP//jsr HappySound                  ;speaker for correct
            movb  #0, OilFlag
            bra   Push2strt
                      
BadPass:    ;WIP//jsr SadSound                  ;speaker for incorrect 
            ldx   #wrongpass_str            ;call LCD to display "wrong password"
            jsr   LCD           
            lbra  WrongPass          ;return to start 
                      
Push2strt:  ldx   #buttpass_str    ;call LCD to display "press button to start"
            jsr   LCD 
            jsr   Pbutton       ;button to start

            
                      
                           


;POT
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  StartCar:
            jsr GetSpd
            ;jsr DCMotor
            
            jsr LCD
            
            bra StartCar
            



























