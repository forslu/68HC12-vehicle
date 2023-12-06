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
            XDEF JUMPASS, hexval
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on

            XREF __SEG_END_SSTACK     ; symbol defined by the linker for the end of the stack




; variable/data section
MY_EXTENDED_RAM: SECTION
; Insert here your data definition.
;port_s:       equ    $248
;port_s_ddr:   equ    $24A
port_u:       equ    $268
port_u_ddr:   equ    $26A
port_u_pde:   equ    $26C
port_u_psr:   equ    $26D
send:         dc.b   $70, $B0, $D0, $E0, $0      
index:        dc.b   $EB, $77, $7B, $7D, $B7, $BB, $BD, $D7, $DB, $DD, $E7, $ED, $7E, $BE, $DE, $EE

vars:   SECTION
temp    ds.b   1
;loop:   ds.b   1
hexval: ds.b   1

; code section
MyCode:     SECTION

JUMPASS:     pshx
             movb #$F0, port_u_ddr   ;set 0-3 input and 4-7 output
             movb #$F0, port_u_psr   ;set up 0-3 as pullup device
             movb #$0F, port_u_pde   ;activate pullup device on pins 0-3 
             ;movb #$FF, port_s_ddr   ;set port_s as output


;P2. scan all four rows~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             

start:       ldy  #send  ;step counter
             ldaa #0
           
scan:        ldaa 1, y+  ;store y into port_u post dec    prev a
             beq start
             staa port_u
             
             jsr  delay1      ;jump to 1ms delay      BOUNCE: UNCOMMENT WHEN FINISHED
             ldaa port_u
             staa temp    ;DEBUGGING worked before moving here
            
             anda #$F         ;AND to mask off upper
             ;staa temp
             cmpa #$F         ;if lower nib is not 1111
             beq  scan      ;KEY IS PRESSED, branch to check 

;WAIT FOR RELEASE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~             
 release:    ldaa temp
             ldab port_u
             cba
             beq release
            
           
 

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
            ;bra start     ;branch to nomatch
;nomatch:
            ;ldaa #$FF      ;load $ff if no match
            
endloop:    tfr x,d         ;transfer value of index y to d
            tba
            staa hexval            ;take indexvalue in acc B and move it to A
            ;staa port_s       ;store chosen value in the lower nibble portion of LEDs
            pulx
            rts
            
;END OF COORDINATE FINDER~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~           
            
  
  
            
            
          
            


;delay subroutine (memory issue at home system)
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