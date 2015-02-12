
* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

*KLS_V.FX('EU27','COE')                 = 1.1 * KLS('EU27','COE')                      ;
*KLS_V.FX('WEU','COE')                 = 1.1 * KLS('WEU','COE')                      ;

ioc(prd,'WEU','i001') = ioc(prd,'WEU','i001') * 1.03 ;
ioc(prd,'WEU','i002') = ioc(prd,'WEU','i002') * 1.02 ;
ioc(prd,'WEU','i003') = ioc(prd,'WEU','i003') * 1.01 ;
ioc(prd,'WEU','i004') = ioc(prd,'WEU','i004') * 1.04 ;
ioc(prd,'WEU','i005') = ioc(prd,'WEU','i005') * 1.03 ;
ioc(prd,'WEU','i006') = ioc(prd,'WEU','i006') * 1.02 ;
ioc(prd,'WEU','i007') = ioc(prd,'WEU','i007') * 1.01 ;
ioc(prd,'WEU','i008') = ioc(prd,'WEU','i008') * 1.03 ;

aVA('WEU','i001') = aVA('WEU','i001') * 1.03 ;
aVA('WEU','i002') = aVA('WEU','i002') * 1.02 ;
aVA('WEU','i003') = aVA('WEU','i003') * 1.01 ;
aVA('WEU','i004') = aVA('WEU','i004') * 1.04 ;
aVA('WEU','i005') = aVA('WEU','i005') * 1.03 ;
aVA('WEU','i006') = aVA('WEU','i006') * 1.02 ;
aVA('WEU','i007') = aVA('WEU','i007') * 1.01 ;
aVA('WEU','i008') = aVA('WEU','i008') * 1.03 ;

ioc(prd,'EEU','i001') = ioc(prd,'EEU','i001') * 1.01 ;
ioc(prd,'EEU','i002') = ioc(prd,'EEU','i002') * 1.02 ;
ioc(prd,'EEU','i003') = ioc(prd,'EEU','i003') * 1.03 ;
ioc(prd,'EEU','i004') = ioc(prd,'EEU','i004') * 1.04 ;
ioc(prd,'EEU','i005') = ioc(prd,'EEU','i005') * 1.01 ;
ioc(prd,'EEU','i006') = ioc(prd,'EEU','i006') * 1.02 ;
ioc(prd,'EEU','i007') = ioc(prd,'EEU','i007') * 1.03 ;
ioc(prd,'EEU','i008') = ioc(prd,'EEU','i008') * 1.04 ;

aVA('EEU','i001') = aVA('EEU','i001') * 1.01 ;
aVA('EEU','i002') = aVA('EEU','i002') * 1.02 ;
aVA('EEU','i003') = aVA('EEU','i003') * 1.03 ;
aVA('EEU','i004') = aVA('EEU','i004') * 1.04 ;
aVA('EEU','i005') = aVA('EEU','i005') * 1.01 ;
aVA('EEU','i006') = aVA('EEU','i006') * 1.02 ;
aVA('EEU','i007') = aVA('EEU','i007') * 1.03 ;
aVA('EEU','i008') = aVA('EEU','i008') * 1.04 ;

*Option iterlim = 0 ;
Option iterlim = 20000000 ;
*Option nlp = pathnlp ;
*Option cns = path ;
Option decimals = 7 ;
*CGE_MCP.optfile = 1 ;
*CGE_TRICK.optfile = 1 ;
*option nlp=gamschk ;
option nlp = conopt3 ;
*CGE_TRICK.scaleopt = 1 ;
CGE_MCP.scaleopt = 1 ;


*Solve CGE_TRICK using nlp maximizing obj;
*Solve CGE_TRICK using cns ;
Solve CGE_MCP using MCP ;

Parameter
    Y_change(regg,ind)          change in industry output due to shock
    X_change(reg,prd)           change in product output due to shock
;

Y_change(regg,ind)$Y(regg,ind)
    = Y_V.L(regg,ind) / Y(regg,ind) ;
X_change(reg,prd)$X(reg,prd)
    = X_V.L(reg,prd) / X(reg,prd) ;

Display
Y_change
X_change
;

Parameter
    Yreg_change(regg)           change in country output due to shock
;

Yreg_change(regg) = sum(ind, Y_V.L(regg,ind) ) - sum(ind, Y(regg,ind) ) ;

Display
Yreg_change
;

Parameter
    CBUD_check(regg,fd)         check that budget constraint holds
;

CBUD_check(regg,fd)
    = ( sum((reg,prd), FINAL_USE_V.L(reg,prd,regg,fd) * P_V.L(reg,prd) *
    ( 1 + tc_fd(prd,regg,fd) ) ) +
    sum((row,prd), FINAL_USE_ROW_V.L(row,prd,regg,fd) * PROW_V.L(row) *
    ( 1 + tc_fd(prd,regg,fd) ) ) ) / CBUD_V.L(regg,fd) ;

Display
CBUD_check
;

Parameter
    numer_check(regg,ind)       check that the numeraire equation holds
;

numer_check(regg,ind)$Y(regg,ind) =  Y_V.L(regg,ind) * PY_V.L(regg,ind) *
    ( 1 - sum((reg,ntp), txd_ind(reg,ntp,regg,ind) ) -
    sum((reg,tim), txd_tim(reg,tim,regg,ind) ) ) /
    ( sum((reg,prd), INTER_USE_V.L(reg,prd,regg,ind) * P_V.L(reg,prd) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((row,prd), INTER_USE_ROW_V.L(row,prd,regg,ind) * PROW_V.L(row) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((reg,kl), KL_V.L(reg,kl,regg,ind) * PKL_V.L(reg,kl) ) +
    sum((row,tim), TAX_INTER_USE_ROW_model(row,tim,regg,ind) * PROW_V.L(row) ) ) ;


Display
numer_check
;
