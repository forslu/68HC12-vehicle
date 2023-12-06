 ;RTI_ISR
 
 XDEF RTI_ISR, sum, rtiCount, secCount, sec5Count, TurnFlag, DCFlag, TurnDurFlag, DCount,
 XREF __SEG_END_SSTACK, RTI_CTL, Ton, Toff,   
 
Const:    section
RTIFLG:     equ  $37
CRGINT:     equ  $38 
;CRGFLG:     equ  
port_t:     equ  $240
port_t_ddr: equ  $242

myvar:  section

sum         ds.b 1
rtiCount    ds.b 1
secCount    ds.b 1
sec5Count   ds.b 1
DCount      ds.b 1 

;not sure if needed//MotorFlag   ds.b 1
DCFlag      ds.b 1
TurnFlag    ds.b 1
TurnDurFlag ds.b 1 
 
mycode:  section
         
RTI_ISR:  bset port_t_ddr, #$8
          movb #$80, CRGINT
          movb #$60, RTI_CTL
   
;NOTICE: Potentially need to move flag checks here.to branch to them.
          
          ;LDS  #__SEG_END_SSTACK
          ldd rtiCount
          incb
          cpd #977
          bne endrti
          inc secCount
      
      ;setting flags
          movb #1, TurnDurFlag          ;set second flag (execute at 1 second: turn duration(stepper), Blinker duration (LED), count miles (DCMotor) 
          movb #1, DCFlag               ;DC motor flag
          ;not sure if needed//movb #1, MotorFlag            
          
          ldaa sec5Count
          cmpa #5
          bne endrti
          inc sec5Count
          movb #1, TurnFlag                 ;set 5 second flag (execute turn)
          bra endrti
          
endrti:   ;bset CRGFLG, #$80
          rti
          

          

;WIP//DC MOTOR     do i put this in rti or dcmotor.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DCmotor:    ldaa Ton                      
            ldab Toff
RTon:	      
	          inc  DCount
	          ldaa DCount
	          
	          cmpa #15         ;if counter > 15 exit
	          bge  reset        ;~~~~~~~~~~~~~~~~
	          
	          cmpa Ton            ;if counter is greater than ton branch to RToff
	          bge  RToff          ;~~~~~~~~~~~
	          
	          bset port_t, #$8    ;set motor
	          bra  endrti
	        
	          
	    
	          
RToff:      bclr port_t, #$8
           
            


reset:      movb #0, DCount
            bra endrti         ;takes frequency from main to happen every second
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              