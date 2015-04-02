* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

*KLS_V.FX('EU27','COE')                 = 1.1 * KLS('EU27','COE')                      ;
KLS_V.FX('WEU','COE')                 = 1.1 * KLS('WEU','COE')                      ;

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
    CBUD_H_check(regg)         check that budget constraint for households holds
    CBUD_G_check(regg)         check that budget constraint for government holds
    CBUD_I_check(regg)         check that budget constraint for investment agent holds
;

CBUD_H_check(regg)
    = ( sum(prd, CONS_H_T_V.L(prd,regg) * PC_H_V.L(prd,regg) *
    ( 1 + tc_h(prd,regg) ) ) ) / CBUD_H_V.L(regg) ;

CBUD_G_check(regg)
    = ( sum(prd, CONS_G_T_V.L(prd,regg) * PC_G_V.L(prd,regg) *
    ( 1 + tc_g(prd,regg) ) ) ) / CBUD_G_V.L(regg) ;

CBUD_I_check(regg)
    = ( sum(prd, GFCF_T_V.L(prd,regg) * PC_I_V.L(prd,regg) *
    ( 1 + tc_gfcf(prd,regg) ) ) ) / CBUD_I_V.L(regg) ;

Display
CBUD_H_check
CBUD_G_check
CBUD_I_check
;

Parameter
    numer_check(regg,ind)       check that the numeraire equation holds
;

numer_check(regg,ind)$Y(regg,ind) =  Y_V.L(regg,ind) * PY_V.L(regg,ind) *
    ( 1 - sum(reg, txd_ind(reg,regg,ind) ) -
    sum(reg, txd_tim(reg,regg,ind) ) ) /
    ( sum(prd, INTER_USE_T_V.L(prd,regg,ind) * PIU_V.L(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((reg,kl), KL_V.L(reg,kl,regg,ind) * PKL_V.L(reg,kl) ) +
    sum(tim, TAX_INTER_USE_ROW(tim,regg,ind) * PROW_V.L ) ) ;


Display
numer_check
;
