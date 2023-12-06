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
            XDEF Entry, IndxFlag, indexcnt, RightT, LeftT, _Startup, main, ton, toff, DCFlag,  LCDFlag,mph
            XDEF tempstring, SlowFlag, FastFlag,  RTI_CTL ,RTIFLG, port_t_ddr, OdoNum, IRQFlag, port_p,DDR_p
            XDEF  TurnFlag, ODOFlag, OilFlag, TurnDurFlag, port_s, indexr, index, indexcnt, LEDFlag
        ;  LLED, RLED, HLED,
            XREF init_LCD, read_pot, display_string, TurnChk,   
            XREF __SEG_END_SSTACK, JUMPASS, hexval, Pbutton ,RTI_ISR, ODOCount
            ;  TurnFlag, TurnDurFlag, SLCDCrash  
            XREF pot_value, speed_str, GetSpd,  SendsChr.c, secCount, sec5Count, rtiCount
           ;  sum
            XREF potentiometer.c, LCD, enterpass_str, wrongpass_str, buttpass_str, LLEDtmp, RLEDtmp
            XREF port_t, Left_str, Right_str, crash_str, chngoil_str, disp, clearLCD_str, string_copy
            XREF pass1_str, pass11_str, pass111_str, pass1111_str, 
	         

         
          
   ;for LCD statements enter:
   ;         ldx  #*_str   ;call LCD to display               
           ; jsr  LCD


; variable/data section
my_variable: SECTION


passtemp:       ds.b  4
passkey:        ds.b  4
;LLED:           ds.b  1 
;RLED:           ds.b  1
;HLED:           ds.b  1
indexcnt:       ds.b  1
IndxFlag:       ds.b  1
RightT:         ds.b  1
LeftT:          ds.b  1
FastFlag:       ds.b  1
SlowFlag:       ds.b  1
IRQFlag:        ds.b  1
LCDFlag:        ds.b  1
LEDFlag:        ds.b 1
DCFlag:         ds.b  1
OilFlag      ds.b 1
ODOFlag      ds.b 1
TurnFlag     ds.b 1
TurnDurFlag  ds.b 1
ton:            ds.b  1
toff:           ds.b  1
mph:            ds.b  1
OdoNum:         ds.w  1
DCount:         ds.b  1
tempstring:     ds.b 33

;constant section
my_constant: SECTION
RTIFLG:     equ  $0037
RGINT:      equ  $0038  
RTI_CTL:    equ  $003B
port_s:     equ  $248
DDR_S:      equ  $24A
port_t_ddr: equ  $242
port_p:     equ  $258
DDR_p:      equ  $25A
index:      dc.b  $0A,$12,$14,$0C,$0
indexr:     dc.b  $0C,$14,$12,$0A,$0


constant_string dc.b  'The value of the pot is:        ',0
strtpass        dc.b   $1, $2, $3, $4
oilpass         dc.b   $1, $2, $3



; code section
MyCode:     SECTION
Entry:
_Startup:
main:
            ;movb #$8, port_t_ddr     ;OR bset port_t_ddr, #$8	 ;set bit 3 of port t 
            ;bset port_t, #$8    ;set motor
            lds #__SEG_END_SSTACK			;initializes stack pointer	
            movb  #0, LCDFlag
            movb  #$C0, INTCR
            movb  #$80, RGINT
            movb  #$40, RTI_CTL
            movb  #$1E, DDR_p
            movb  #$FF, DDR_S
            movb  #$FC, port_t_ddr     ;OR bset port_t_ddr, #$8	 ;set bit 3 of port t
            clr   IRQFlag
reset:      ldd   #0            
            std   OdoNum
            std   rtiCount
            ldaa  #$FF
		      	staa  RLEDtmp
		      	ldaa  #0
		      	staa  LLEDtmp
            staa  indexcnt
            clr   LEDFlag
            clr   IndxFlag
            clr   LeftT
            clr   RightT
            clr   OilFlag
            clr   ODOFlag
            clr   TurnDurFlag
            clr   TurnFlag
            clr   secCount
            clr   sec5Count
            brset IRQFlag, #1, WrongPass
    ;clear LCD        
            ldx   #clearLCD_str
            ldy   #disp
            jsr   init_LCD
            jsr   string_copy
            ldd   #disp
            jsr   display_string
           
            
                
Start:        
            
            brset OilFlag, #1, GetOilPass
            
            ldx  #enterpass_str   ;call LCD to display               
            jsr  LCD

WrongPass:  ldy   #0
            brset OilFlag, #1, GetOilPass
GetPass:    clr   IRQFlag
            pshy
            jsr   JUMPASS
            puly            ;call keypad for password
            ldaa  hexval     ;load keypad value to a
            staa  passtemp, y   ;store keypad val to passtemp
						
Fill:   cpy #0
		 	  bne pass11
	      ldx #pass1_str
			  jsr LCD
			  iny
		    bra GetPass
			
pass11: cpy #1
			  bne pass111
			  ldx #pass11_str
			 ; pshy 
			  jsr LCD
			 ; puly
			  iny
			  bra GetPass
			
pass111: cpy #2
			   bne next
			   ldx #pass111_str
			   ;pshy
			   jsr LCD
			   ;puly
			   iny
			   bra GetPass
            
next:                 
			ldx #pass1111_str
		;pshy
			jsr LCD
		 ; puly
      bra CompPass

GetOilPass: ldx  #0
            stx  OdoNum
           
Oilloop:    jsr  JUMPASS     ;call keypad for password
            ldaa hexval     ;load keypad value  to a
            staa passtemp, x   ;store keypad val to passtemp
            inx              ;
            cpx  #3
            bne  Oilloop
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
            cpx   #4
            bne   ButtPass
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
            brclr OilFlag, #1, Push2strt             ;bra to push2start if oilflag is clear (didnt change oil)
            clr   OilFlag
            lbra   Start
                      
BadPass:    ;WIP//jsr SadSound                  ;speaker for incorrect 
            ldx   #wrongpass_str            ;call LCD to display "wrong password"
            jsr   LCD           
            lbra  WrongPass          ;return to start 
                      
Push2strt:  ldx   #buttpass_str      ;call LCD to display "press button to start"
            jsr   LCD 
            jsr   Pbutton            ;button to start

            
                      
                           


;RUN CAR
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            ldx   #0      ;Set x to 0 for step motor
            
  StartCar: cli
            brset IRQFlag,#1, crash 
            jsr   GetSpd
            jsr   TurnChk       
            jsr   LCD
            jsr   ODOCount
            
     ;check oil flag      
            brset OilFlag, #1, chngoill ;ldaa OilFlag    ;long brset 
             
            bra   StartCar
            

chngoill:   bclr  port_t, #$8
            ldd   #0
            std   OdoNum
            ldx   #chngoil_str
            jsr   LCD
            lbra  GetOilPass

crash:      bclr  port_t, #$8    ;stop dcmotor
                           ;stop stepper
            ldx   #crash_str
            jsr   LCD
          
            lbra  reset




















