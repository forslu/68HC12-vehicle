;LED.asm

    XDEF  LED
    XREF  LLED, RLED, HLED
    
 vars:  section
 LEDtemp:  ds.w 1   
    
    
LED:  brset RLED,   #1, left2right
      brset LLED,   #1, right2left
      brset CrsLED, #1, crashleds
      
      
      
      
      
left2right:  ldaa 



                rts
                
         
right2left:



                rts
                
crashleds:
                rts