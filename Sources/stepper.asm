
;stepper.asm
            XDEF fdelay,sdelay, port_p, Stepper
           
            XREF port_t, SlowTFlag, FastTFlag   
            XREF RightT, LeftT, TurnFlag



CONSTANTS:  SECTION
index:      	dc.b 	  $0A,$12,$14,$0C
indexr:       dc.b 	  $0C,$14,$12,$0A
port_p: 	   	equ     $258
DDR_p:        equ     $25A
;port_t:       equ     $240


Variables:  Section
fdelay:       ds.w    1
sdelay:       ds.w    1
temp:         ds.w    1
rotate:       ds.w    1

MyCode:     SECTION
topreturn:  rts
    
resetx:   ldx #0
           
     ;NOTE: if pshx and pulx doesnt work have code
     ;check x at the very beginning of Stepper if it is 
     ;4 then branch up to reset x above
    
Stepper:    brset TurnDurFlag, #1, topreturn
            brclr TurnFlag, #1, topreturn
            pulx
            cpx #4
            beq resetx
           
            movb #$1E, DDR_p         ;Initialize motor bits 1-4
            
start:    ;	ldaa port_t              ;load a with port_t
            ;anda #3                  ;clear bits 3-7
            
            ;staa  temp
           ; brclr temp,   #3, topreturn     ;if temp=%00000000 branch to end
           ; brset temp,   #3, topreturn     ;if temp=%00000011 branch to end
            brset RightT, #1, CWspd         ;if flag for right turn is set move to CW
            brset LeftT,  #1, CCWspd        ;if flag for left turn is set move to CCW
            bra   topreturn
            
            
            ;brclr temp, #1, CWspd      ;if temp=%00000010 branch to CWspd
            ;brclr temp, #2, CCWspd     ;if temp=%00000001 branch to CCWspd   
            
                                


;CCW PORTION OF CODE
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                            
CCWspd:     brset SlowTFlag, #1, CCWfloop
            brset FastTFlag, #1, CCWfloop 
            bra   topreturn
                            

CCWfloop:	  ldaa indexr             ;Load index into a
           	                
CCWfloop1:  staa port_p        ;store what's in a to port_p                                 
            inx                 ;increment x 
            ldaa indexr,x       ;increment index
	        	

            cpx  #4             ;if x != 4 
	         	bge  resetloop		  	;branch to loop1
	         
	         
            bra  bottomend      	  ; branch to end
            
                        
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
            
            
;CW PORTION OF CODE           
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
 
CWspd:      brset SlowTFlag, #1, CWfloop  ;found in switch
            brset FastTFlag, #1, CWfloop  ;found in switch
            bra   bottomend                

CWfloop:	  ldaa index             ;Load index into a
           	                
CWfloop1:   staa port_p        ;store what's in a to port_p                                 
            inx                 ;increment x 
            ldaa index,x       ;increment index
	        	

            cpx  #4             ;if x != 4 
	         	bge  resetloop		  	;branch to loop1
	         
	         
            bra  bottomend      	  ; branch to end
            
;CWsloop:	  ldaa index             ;Load index into a
                                   ;Set x to 0
            

;CWsloop1:   staa port_p              ;store what's in a to port_p                                 
           ; inx                     ;increment x 
          ;  ldaa index,x
	                             ;jumps to slowdelay in other file

           	 	   ;branch to loop1
	             
resetloop:  
 	          ldx  #0
            clr  RightT       ;found in rti
            clr  LeftT        ;found in rti
	          
bottomend:  rts
            
            
