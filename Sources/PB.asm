;pushbutton.asm

 XDEF  Pbutton


const:  section
port_p:      equ $258
port_p_ddr:  equ $25A
 
 
 code:    section
 
 Pbutton:  
          
          
          ldaa port_p
          cmpa #$20
          beq   Pbutton
          rts  