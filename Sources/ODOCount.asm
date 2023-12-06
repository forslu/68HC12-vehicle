;ODOCount
    XDEF  ODOCount
    XREF  OilFlag, ODOFlag



 code:    section


ODOCount:    brclr ODOFlag, #1, return
                    
                    ;load mph
                    ;add to Odometer
                    ;compare to 3000
                    ;if less than bra return
                    ;if greater
                    ;set OilFlag to need to change oil
             
             
             movb #1, OilFlag
             clr  ODOFlag

return:     rts