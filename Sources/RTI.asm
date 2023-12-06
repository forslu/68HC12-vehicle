 ;RTI_ISR
 
 XDEF RTI_ISR, sum, rtiCount, secCount, sec5Count
 XREF __SEG_END_SSTACK
myvar:  section

sum         ds.b 1
rtiCount    ds.b 1
secCount    ds.b 1
sec5Count   ds.b 1 

MotorFlag   ds.b 1
DCFlag      ds.b 1
StepFlag    ds.b 1
TurnDurFlag ds.b 1 
 
mycode:  section
         
RTI_ISR:
          ;LDS  #__SEG_END_SSTACK
          ldd rtiCount
          incb
          cpd #977
          bne endrti
          inc secCount
      
      ;setting flags
          movb #1, TurnDurFlag          ;set second flag (execute at 1 second: turn duration(stepper), Blinker duration (LED), count miles (DCMotor) 
          movb #1, DCFlag
          movb #1, MotorFlag
          
          ldaa sec5Count
          cmpa #5
          bne endrti
          inc sec5Count
          movb #1, StepFlag                 ;set 5 second flag (execute turn)
          
endrti:   ;bset CRGFLG, #$80
          rti
          


;IRQ_ISR:

                          ;if its on, turn it off

         ; bclr IRQ_ISR
         ; rti

          

;DC MOTOR
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              ;takes frequency from main to happen every second
              ;