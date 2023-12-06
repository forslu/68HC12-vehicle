	XDEF	SlowTFlag, FastTFlag, TurnChk
	XREF	TurnFlag, SlowFlag, FastFlag , port_t, Stepper
	
	
My_Constant:    section

;FastTFlag and SlowTFlag are used to 


My_Var:    section
SlowTFlag  ds.b  1
FastTFlag  ds.b  1

My_Code:   section
              
TurnChk:       ;brclr TurnFlag, #1, return
               
               ldaa port_t	        ;load value from port_t into acc A
               anda #3
               
               cmpa #0              ;turning disabled if 00 
               beq  noturn
               
               cmpa #3              ;disabled if 11
               beq  noturn
               
               cmpa #2                ;fast turn if 10
               beq  Fastturn

SlowTurn:      brclr SlowFlag, #1,return   ;fall into slowturn, branch if slowflag is cleared
               movb  #1, SlowTFlag         ;if slowflag is set, set slowturnflag               
              ; jsr   Stepper
               clr   FastTFlag
               ;clr   TurnFlag                  ;clear turn flag
               bra   return

Fastturn:     brclr FastFlag, #1, return    ;branched to fasturn,leave if fastflag is cleared
	            movb  #1, FastTFlag           ;if set, set the fastturnflag
              
              ; jsr   Stepper
               clr   SlowTFlag             
              ; clr   TurnFlag         
               bra   return

return:	       rts
      
noturn:        clr SlowTFlag
               clr FastTFlag  
	             rts
