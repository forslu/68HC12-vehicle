 ;RTI_ISR
               
 XDEF RTI_ISR, sum, rtiCount, port_t, secCount, sec5Count, TurnFlag, OilFlag, TurnDurFlag, DCount, ODOFlag
 XREF ton, toff, DCFlag, RTI_CTL,  port_t_ddr, IRQFlag, LeftT, RightT
 
Const:    section
CRGFLG:     equ  $37 
port_t:     equ  $240


myvar:  section

sum         ds.b 1
rtiCount    ds.w 1
count       ds.b 1
stepdelay:  ds.b 1
secCount    ds.b 1
sec5Count   ds.b 1
DCount      ds.b 1
 

;not sure if needed//MotorFlag   ds.b 1
OilFlag      ds.b 1
ODOFlag      ds.b 1
TurnFlag     ds.b 1
TurnDurFlag  ds.b 1 
 
mycode:  section
         
RTI_ISR:                    
          
          
   
;NOTICE: Potentially need to move flag checks here.to branch to them.
          
          ;brset IRQFlag, #1, endrti
          ldd rtiCount
          incb
          std rtiCount
           
          cpd #977
          
          bge endrti
          inc secCount
          ldd #0
          std rtiCount
;setting second flags 
          brset TurnDurFlag, #1, clearflag
          movb #1, TurnDurFlag   ;set second flag (execute at 1 second: turn duration(stepper)  
          ;movb #1, RightT
          ;clr      LeftT
          bra  setoil
clearflag:clr  TurnDurFlag
          ;movb #1, LeftT
          ;clr  RightT         
setoil:   brset OilFlag, #1, skipodo
          movb #1, ODOFlag               ;ODO flag count miles
          ;movb #1, OilFlag                      ;Blinker duration (LED)
          
skipodo:  ldaa secCount
          cmpa #5
          bne  endrti
          inc  sec5Count
          clr  secCount
          movb #1, TurnFlag   ;set 5 second flag (execute turn)  clr for R and L turn
          brset LeftT, #1, turnright
          clr  RightT
          movb #1, LeftT
turnright:movb #1, RightT
          clr  LeftT
          ;not sure if needed//movb #1, MotorFlag            
          
          brclr DCFlag, #1, endrti            ;if dcmotor isnt set skip the code
         ; bra endrti
          
          

;DC MOTOR     do i put this in rti or dcmotor.asm
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
	          bra  endrti
	        
	          
	    
	          
RToff:      bclr port_t, #$8
            movb #0, DCFlag
           
            


reset:      movb #0, count
            bra endrti         
              
              
              













endrti:     bset CRGFLG, #$80
            rti              
              
              
              
              
              
              
              
              
              
              
              
              