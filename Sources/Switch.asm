	XDEF	SlowFlag, FastFlag, Swich
	XREF	__SEG_END_SSTACK
	
	
	
My_Constant:    section
port_t:       equ $240
port_t_ddr:   equ $242



My_Var:    section
SlowFlag  ds.b  1
FastFlag  ds.b  1

My_Code:   section
              
Swich:       
               movb #$FF, port_t_ddr
               ldaa port_t	        ;load value from port_t into acc A
               anda #3
               
               cmpa #0              ;turning disabled if 00 
               beq  return
               
               cmpa #3              ;disabled if 11
               beq  return
               
               cmpa #2
               beq  Fastturn

SlowTurn:      movb #1, SlowFlag
               bra return

Fastturn:      movb #1, FastFlag         
               bra return
      
return:        rts
