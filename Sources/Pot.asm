
            INCLUDE 'derivative.inc'

; export symbols
             XDEF GetSpd, 
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on

            XREF __SEG_END_SSTACK, DCFlag, mph, ton, toff, read_pot, display_string, pot_value,   ; symbol defined by the linker for the end of the stack
            
            ; LCD References
	         

            ; Potentiometer References
          



; variable/data section
my_variable: SECTION

;temp:	ds.b 1

;potval: ds.b 1



; code section
MyCode:     SECTION

GetSpd:       jsr read_pot
             
sortpot:      ldd  pot_value         ;is pot_value 0   
              cpd  #0
              beq   Pot0        ;if so branch to end
                
              cpd  #31          ;is potval < or >= 31
              bge   MidPotChk    ;if >= branch to UpotChk
                                                
;potval is < 31              
              movb  #15, mph      ;mph = 15              
              movb  #4,  ton      ;ton = 4
              movb  #11, toff     ;toff = 11
              bra   PotFound       ;bra pot                 
                            
                                   
MidPotChk:    cpd  #61                ;is potval < or >= 61      
              bge   HiPotChk           ;if >= branch to HiPotChk
                                 
;potval is < 61              
              movb  #30, mph      ;mph = 30             
              movb  #8,  ton      ;ton = 8
              movb  #7,  toff     ;toff = 7
              bra   PotFound      ;bra pot                      
                                      
                                
HiPotChk:     cpd #91            ;is potval < or >= 91
              bge  MaxPot         ;if >= branch to MaxPot
              
;potval is < 91              
              movb  #45, mph      ;mph = 45             
              movb  #12, ton     ;ton = 12
              movb  #3,  toff     ;toff = 3
              bra   PotFound      ;bra pot                    
                                         
                                          
MaxPot:                                        
;potval is >= 91  
              movb  #60, mph      ;mph = 60             
              movb  #15, ton     ;ton = 15
              movb  #0,  toff     ;toff =0
              bra   PotFound      ;bra potFound                                          
Pot0:
;(potval=0) ton = 0 toff = 15 
              movb  #0, mph      ;mph = 0             
              movb  #0, ton      ;ton = 0
              movb  #0, toff     ;toff =0
              bra   PotFound     ;bra potFound 
                                                       
PotFound:
              ;jsr   DCMOTOR
              movb  #1,  DCFlag
              rts
              






