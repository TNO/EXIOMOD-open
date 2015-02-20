* include definition of parameters, variables and equations from the base model
$include ../library/scr/model_parameters.gms
$include ../library/scr/model_variables_equations.gms


* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

KLS_V.FX('EU27','COE')                 = 1.1 * KLS('EU27','COE')                      ;


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

Y_change(regg,ind)
    = Y_V.L(regg,ind) / Y(regg,ind) ;
X_change(reg,prd)
    = X_V.L(reg,prd) / X(reg,prd) ;

Display
Y_change
X_change
;

Parameter
    CBUD_check(regg,fd)         check that budget constraint holds
;

CBUD_check(regg,fd)
    = ( sum((reg,prd)$sameas(reg,regg), FINAL_USE_V.L(reg,prd,regg,fd) *
    P_V.L(reg,prd) * ( 1 + tc_fd(prd,regg,fd) ) ) +
    sum((reg,prd)$( not sameas(reg,regg) ), FINAL_USE_V.L(reg,prd,regg,fd) *
    P_V.L(reg,prd) * ( 1 + tx_exp(reg,prd) ) *( 1 + tc_fd(prd,regg,fd) ) ) +
    sum((row,prd), FINAL_USE_ROW_V.L(row,prd,regg,fd) * PROW_V.L(row) *
    ( 1 + tc_fd(prd,regg,fd) ) ) ) / CBUD_V.L(regg,fd) ;

Display
CBUD_check
;

Parameter
    numer_check(regg,ind)       check that the numeraire equation holds
;

numer_check(regg,ind) =  Y_V.L(regg,ind) * PY_V.L(regg,ind) *
    ( 1 - sum((reg,ntp), txd_ind(reg,ntp,regg,ind) ) ) /
    ( sum((reg,prd)$sameas(reg,regg), INTER_USE_V.L(reg,prd,regg,ind) *
    P_V.L(reg,prd) * ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((reg,prd)$( not sameas(reg,regg) ), INTER_USE_V.L(reg,prd,regg,ind) *
    P_V.L(reg,prd)* ( 1 + tx_exp(reg,prd) ) * ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((row,prd), INTER_USE_ROW_V.L(row,prd,regg,ind) * PROW_V.L(row) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((reg,kl), KL_V.L(reg,kl,regg,ind) * PKL_V.L(reg,kl) ) ) ;

Display
numer_check
;
