;ODOCount
    XDEF  ODOCount
    XREF  OilFlag, ODOFlag,OdoNum, mph



 code:    section


ODOCount:          brclr ODOFlag, #1, ChangeOilNow
                   ;brclr OilFlag, #1, return
                   ldd #0                 
                   ldab mph            ;load mph
                   addd OdoNum        ;add to Odometer
                   cpd #2999        ;compare to 3000
                   ble  return        ;if less than bra return
                   movb #1, OilFlag    ;if greater
                   clr  ODOFlag        ;set OilFlag 
                   bra ChangeOilNow
             
                 
                 

return:          staa OdoNum
                 clr  ODOFlag
ChangeOilNow:    rts