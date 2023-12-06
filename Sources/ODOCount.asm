;ODOCount
    XDEF  ODOCount
    XREF  OilFlag, ODOFlag,OdoNum, mph



 code:    section


ODOCount:          ;brclr ODOFlag, #1, ChangeOilNow
                   brset OilFlag, #1, return
                   ldd #0                 
                   ldab mph            ;load mph
                   addd OdoNum        ;add to Odometer
                   cpd #2999        ;compare to 3000
                   ble  return        ;if less than bra return
                                      ;if greater
                   movb #1, OilFlag     ;set OilFlag
                  ; clr  ODOFlag         
                   bra ChangeOilNow
             
                 
                 

return:          std OdoNum
                 
ChangeOilNow:    clr  ODOFlag
                 rts