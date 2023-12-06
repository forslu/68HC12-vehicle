
;stepper.asm
            XDEF fdelay,sdelay, port_p, Stepper
           
            XREF port_t, SlowTFlag, FastTFlag, IndxFlag, port_s   
            XREF RightT, LeftT, TurnFlag, indexcnt, TurnDurFlag



CONSTANTS:  SECTION
index:      	dc.b 	  $0A,$12,$14,$0C,$0
indexr:       dc.b 	  $0C,$14,$12,$0A,$0

port_p: 	   	equ     $258
DDR_p:        equ     $25A
;port_t:       equ     $240


Variables:  Section
fdelay:       ds.w    1
sdelay:       ds.w    1
temp:         ds.w    1
rotate:       ds.w    1

MyCode:     SECTION
topreturn:  rts
    
resetx:   ldaa #4
          staa indexcnt
   
   ;check x at the very beginning of Stepper if it is 
   ;4 then branch up to reset x above
    
Stepper:    movb #$1E, DDR_p
            brclr TurnDurFlag, #1, topreturn
           ; brclr TurnFlag, #1, topreturn

            brset RightT, #1, CW         ;if flag for right turn is set move to CW
            brset LeftT,  #1, CCW        ;if flag for left turn is set move to CCW
           ; bra   topreturn
            
            
            ;brclr temp, #1, CWspd      ;if temp=%00000010 branch to CWspd
            ;brclr temp, #2, CCWspd     ;if temp=%00000001 branch to CCWspd   
            
                                


           
            
            
;CW PORTION OF CODE           
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
CW:         brset IndxFlag, #1, contin
CWspd:      ldx   #index
            movb  #1, IndxFlag
contin:     ldaa  indexcnt       ;starts at 4
            beq   resetx
            dec   indexcnt
            ldaa  1, x+
            beq   CWspd
            staa  port_p
            staa  port_s
            bra   bottomend
            ;clr   TurnDurFlag

;resetloop:  
 	        ;  ldx  #0
          ;  clr  RightT       ;found in rti
          ;  clr  LeftT        ;found in rti
	        ;  bra  bottomend

            
            
;CCW PORTION OF CODE
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                            
;CCWspd:     brset SlowTFlag, #1, CCWfloop
         ;   brset FastTFlag, #1, CCWfloop 
         ;   bra   topreturn
                            

CCW:	      brset IndxFlag, #1, continccw
CCWspd:     ldx   #index
            movb  #1, IndxFlag
continccw:  ldaa  indexcnt       ;starts at 4
            beq   resetx
            dec   indexcnt
            ldaa  1, x+
            beq   CWspd
            staa  port_p
            staa  port_s
                        
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 


bottomend:  rts