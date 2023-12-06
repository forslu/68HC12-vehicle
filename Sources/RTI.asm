                                ;RTI_ISR
               
 XDEF RTI_ISR,  
 XREF ton, toff, Turncnt,LEDcnt , DCFlag, RTI_CTL,  port_t_ddr, IRQFlag, LeftT, RightT, index
 XREF indexr, indexcnt, SlowTFlag, FastTFlag,   SlowFlag, FastFlag, port_p, port_s, LEDFlag
 XREF TurnFlag, port_t,  speakflag, LLEDtmp, RLEDtmp, ODOFlag, mocount, OilFlag,  TurnDurFlag, rtiCount, secCount, sec5Count
; RLED, LLED,  CrsLED,
Const:    section
CRGFLG:     equ  $37 



myvar:  section

;stepdelay:   ds.b 1

;DCount:      ds.b 1


            
;not sure if needed//MotorFlag   ds.b 1


 
mycode:  section
         
RTI_ISR:                    
          
          
   
;NOTICE: Potentially need to move flag checks here.to branch to them.
          
          ;brset IRQFlag, #1, midendrti
          ldaa   IRQFlag
          cmpa   #1
          lbeq endrti  
          ldaa Turncnt
          adda #1
		      staa Turncnt
		      cmpa #10
		      blt chkled
		      ldaa #0
		      staa Turncnt
		      movb #1, TurnFlag
        
chkled:	  ldaa LEDcnt
		      adda #1
		      staa LEDcnt
		      cmpa #122		  
		      blt  checksec
		      ldaa  #0
		      staa  LEDcnt
		      movb  #1, LEDFlag
  
checksec: ldd rtiCount
		      addd #1
          std rtiCount
          cpd #977
          ble chkdc
          inc secCount
          ldd #0
          std rtiCount
;setting second flags 
		  
 clrdur:  brset TurnDurFlag, #1, clearDurflag
          bra setoil
                         ;movb #1, TurnDurFlag   ;set second flag (execute at 1 second: turn duration(stepper)  
                           ;movb #1, RightT
                          ;clr      LeftT
                        
clearDurflag: clr  TurnDurFlag
          ;movb #1, LeftT
          ;clr  RightT         
setoil:   brset OilFlag, #1, skipodo
          movb #1, ODOFlag               ;ODO flag count miles
          

;5 second check          
skipodo:  ldaa secCount
          cmpa #5
          blt  chkdc
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
          brset speakflag, #1, speaker
          lbra endrti

speaker: lbra speakflagbra    

;DC MOTOR     
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DCmotor:    brset OilFlag, #1, midendrti
            ldaa ton                      
            ldab toff
RTon:	      
	          inc  mocount
	          ldaa mocount
	         ; staa port_s
	          
	          cmpa #15         ;if counter > 15 exit
	          bge  reset        ;~~~~~~~~~~~~~~~~
	          
	          cmpa ton            ;if counter is greater than ton branch to RToff
	          bge  RToff          ;~~~~~~~~~~~
	          
	          bset port_t, #$8    ;set motor
	          lbra Stepper
	        
	          
	    
	          
RToff:      bclr port_t, #$8
            ;movb #0, DCFlag
            lbra Stepper
                      
reset:      movb #0, mocount
            ldaa  mocount
            staa  port_s
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
       ; test: movb #$FF, port_s
         ;   bra test
			
;CW PORTION OF CODE  
         
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
CW:	brset SlowTFlag, #1, CWstart
		brset FastTFlag, #1, CWstart
		brset speakflag, #1, speaker	
		lbra  endrti
		
CWstart:			;indexcnt 0-3
         ldx indexcnt
         cpx #4
         bge  resetindxCW
         ldaa index, x
         inx
         staa port_p
         ldaa #$0F
         staa port_s
         stx indexcnt
         clr TurnFlag
         bra RLED

resetindxCW:	ldx #0
			        stx indexcnt
			        bra CW
	    	 
CCW:	brset SlowTFlag, #1, CCWstart
	  	brset FastTFlag, #1, CCWstart
	  	brset speakflag, #1, speaklf
	  	lbra   endrti		

CCWstart:		;indexcnt 0-3
  ldx  indexcnt
  cpx  #4
  bge  resetindxCCW
  ldaa indexr, x
  inx
  staa port_p
  ldaa #$F0
  staa port_s
  stx indexcnt
  clr  TurnFlag
  bra  LLED

resetindxCCW:	 ldx #0
			 stx   indexcnt
			 bra   CCW

speaklf: lbra speakflagbra



	RLED: brclr LEDFlag, #1, endrti
		  ldaa #0
		  ldab RLEDtmp
		  ldx #2
		  idiv 	
		  tfr x, d
		  stab RLEDtmp
		  cmpb  #1
		  blt  resetledR
		  cmpb  #255
		  bgt   resetledR		  
		  stab  port_s
		  cmpb  #1
		  beq   resetledR
		  brset speakflag, #1, speakflagbra		  
		  bra  endrti

resetledR:ldaa #255
		  staa RLEDtmp
		  clr LEDFlag
		  brset speakflag, #1, speakflagbra
		  bra endrti
		  
	LLED: brclr LEDFlag, #1, endrti
		  ldaa LLEDtmp
		  ldab LLEDtmp
		  aba 
		  staa LLEDtmp
		  cmpa  #255
		  bgt  resetledL
		  staa  port_s
		  cmpa  #255
		  bgt   resetledL
		  brset speakflag, #1, speakflagbra		 
		  bra  endrti

resetledL:ldaa #1
          staa LLEDtmp
		      clr LEDFlag
		      brset speakflag, #1, speakflagbra
		      bra endrti
		      

speakflagbra: bra endrti
	SendMessageInfo:	ldy 3,sp
		
;ldx 5,sp
loaddata:	ldaa 1,x+
		psha
	;	call SendsChr
		leas 1,sp
		dey
		cpy #0
		bne loaddata
		bra endrti






endrti:     bset CRGFLG, #$80
            rti              
              
              
              
              
              
              
              
              
              
              
              
              