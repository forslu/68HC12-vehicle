                                ;RTI_ISR
               
 XDEF RTI_ISR, sum, rtiCount, port_t, secCount, sec5Count, 
 XDEF TurnFlag, OilFlag, ODOFlag, LLEDtmp, RLEDtmp
 XREF ton, toff, DCFlag, RTI_CTL,  port_t_ddr, IRQFlag, LeftT, RightT, index
 XREF indexr, indexcnt,  CrsLED, SlowFlag, FastFlag, port_p, port_s, LEDFlag
 XREF TurnFlag, ODOFlag, OilFlag, TurnDurFlag, secCount, sec5Count
; RLED, LLED,
Const:    section
CRGFLG:     equ  $37 
port_t:     equ  $240


myvar:  section

sum:         ds.b 1
rtiCount:    ds.w 1
count:       ds.b 1
stepdelay:   ds.b 1

;DCount:      ds.b 1
RLEDtmp:     ds.b 1 
LLEDtmp:	   ds.b 1
LEDcnt:		   ds.b 1

Turncnt:	   ds.b 1
            
;not sure if needed//MotorFlag   ds.b 1


 
mycode:  section
         
RTI_ISR:                    
          
          
   
;NOTICE: Potentially need to move flag checks here.to branch to them.
          
          ;brset IRQFlag, #1, endrti
          ldaa Turncnt
          adda #1
		      staa Turncnt
		      cmpa #10
		      ble chkled
		      ldaa #0
		      staa Turncnt
		      movb #1, TurnFlag
        
chkled:	  ldaa LEDcnt
		      adda #1
		      staa LEDcnt
		      cmpa #122		  
		      ble  checksec
		      ldaa  #0
		      staa  LEDcnt
		      movb  #1, LEDFlag
  
checksec: ldd rtiCount
		      addd #1
          std rtiCount
          cpd #977
          ble clrdur
          inc secCount
          ldd #0
          std rtiCount
;setting second flags 
		  
 clrdur:  brset TurnDurFlag, #1, clearDurflag
          bra setoil
                         ;movb #1, TurnDurFlag   ;set second flag (execute at 1 second: turn duration(stepper)  
                           ;movb #1, RightT
                          ;clr      LeftT
                        
clearDurflag: ;clr  TurnDurFlag
          ;movb #1, LeftT
          ;clr  RightT         
setoil:   brset OilFlag, #1, skipodo
          movb #1, ODOFlag               ;ODO flag count miles
          

;5 second check          
skipodo:  ldaa secCount
          cmpa #5
          bne  chkdc
          inc  sec5Count
          clr  secCount
          movb #1, TurnDurFlag ;changed from TurnFlag  ;set 5 second flag (execute turn)  clr for R and L turn

;Alternate R L          
Alternate:brset LeftT, #1, turnright
          clr  RightT
          movb #1, LeftT
          bra  chkdc
turnright:clr  LeftT 
          movb #1, RightT
          ;not sure if needed//movb #1, MotorFlag            
          
chkdc:    brset DCFlag, #1, DCmotor           ;if dcmotor isnt set skip the code, also skip step motor bc you cant turn if you arent moving
          lbra endrti

    

;DC MOTOR     
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DCmotor:    ;brset OilFlag, #1, endrti
            ldaa ton                      
            ldab toff
RTon:	      
	          inc  count
	          ldaa count
	          
	          cmpa #15         ;if counter > 15 exit
	          bge  reset        ;~~~~~~~~~~~~~~~~
	          
	          cmpa ton            ;if counter is greater than ton branch to RToff
	          bge  RToff          ;~~~~~~~~~~~
	          
	          bset port_t, #$8    ;set motor
	          lbra Stepper
	        
	          
	    
	          
RToff:      bclr port_t, #$8
            movb #0, DCFlag
                      
reset:      movb #0, count
            bra  Stepper

midendrti:  bset CRGFLG, #$80
            rti              
                                 
              
;STEP MOTOR
;Vars: crrntindexR,crrntindexL both pointers to current index value
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            
   Stepper: 
			      brclr TurnFlag, #1, midendrti  
            brclr TurnDurFlag, #1, midendrti       
            brset RightT, #1, CW         ;if flag for right turn is set move to CW
            brset LeftT,  #1, CCW        ;if flag for left turn is set move to CCW
			
;CW PORTION OF CODE  
         
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
CW:	brset SlowFlag, #1, CWstart
		brset FastFlag, #1, CWstart
		lbra   endrti
		
CWstart:			;indexcnt 0-3
         ldx indexcnt
         cpx #4
         bge  resetindxCW
         ldaa index, x
         inx
         staa port_p
         clr TurnFlag
         bra RLED

resetindxCW:	 ldx #0
			 stx indexcnt
			 bra CW
	    	 
CCW:	brset SlowFlag, #1, CCWstart
	  	brset FastFlag, #1, CCWstart
	  	bra   endrti		

CCWstart:		;indexcnt 0-3
  ldx  indexcnt
  cpx  #4
  bge  resetindxCCW
  ldaa indexr, x
  inx
  staa port_p
  clr  TurnFlag
  bra  LLED

resetindxCCW:	 ldx #0
			 stx   indexcnt
			 bra   CCW




	RLED: brclr LEDFlag, #1, endrti
		  ldaa #0
		  ldab RLEDtmp
		  ldx #2
		  idiv 	 
		  cpx  #1
		  beq  resetledR
		  stx  port_s		  
		  bra  endrti

resetledR:ldaa #255
		  staa RLEDtmp
		  clr LEDFlag
		  bra endrti
		  
	LLED: brclr LEDFlag, #1, endrti
		  ldaa LLEDtmp
		  ldab #2
		  mul 
		  cpd  #255
		  bge  resetledL
		  std  port_s		 
		  bra  endrti

resetledL:ldaa #1
          staa LLEDtmp
		      clr LEDFlag
		      bra endrti



endrti:     bset CRGFLG, #$80
            rti              
              
              
              
              
              
              
              
              
              
              
              
              