* File:   %project%/00-principal/scr/trial_simulation.gms
* Author: Tatyana Bulavskaya
* Date:   11 August 2015
* Adjusted:

* gams-master-file: main.gms

$ontext startdoc
This code can be used for making small trial simluations with base CGE model.
The code is useful when we want to test some new features of the model.
$offtext


* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ====== Declaration of parameters for saving result for post-processing =======

Parameter
    Y_time(regg,ind,year)       industry output over time
    X_time(reg,prd,year)        product output over time
    Y_change(regg,ind,year)     change in industry output over time due to shock
    X_change(reg,prd,year)      change in product output over time due to shock
    Yreg_change(regg,year)      change in country output over time due to shock
    CBUD_H_check(regg,year)     check that budget constraint for households holds
    CBUD_G_check(regg,year)     check that budget constraint for government holds
    CBUD_I_check(regg,year)     check that budget constraint for investment agent holds
    numer_check(regg,ind,year)  check that the numeraire equation holds
;

* ============================== Simulation setup ==============================

loop(year$( ord(year) le 3 ),

*$ontext
* CEPII baseline
KLS(reg,kl)             = KLS_V.L(reg,kl) ;
KLS_V.FX(reg,"GOS")     = KLS(reg,"GOS") * KS_CEPII_change(reg,year) ;
KLS_V.FX(reg,"COE")     = KLS(reg,"COE") * LS_CEPII_change(reg,year) ;
fprod(kl,regg,ind)      = fprod(kl,regg,ind) * PRODKL_CEPII_change(regg,year) ;
*$offtext

* Additional trial shock
KLS_V.FX('WEU','COE')$(ord(year) eq 2 ) = 1.1 * KLS('WEU','COE') ;


* =============================== Solve statement ==============================

* Option with 0 iterations can be used to check calibration of the model, i.e.
* with without any shock
*Option iterlim = 0 ;
Option iterlim = 20000000 ;
Option decimals = 7 ;
option nlp = conopt3 ;
CGE_MCP.scaleopt = 1 ;

Solve CGE_MCP using MCP ;

* =========================== Save selected results ============================

Y_time(regg,ind,year) = Y_V.L(regg,ind) ;
X_time(reg,prd,year) = X_V.L(reg,prd) ;

Y_change(regg,ind,year)$Y(regg,ind) = Y_V.L(regg,ind) / Y(regg,ind) ;
X_change(reg,prd,year)$X(reg,prd)   = X_V.L(reg,prd) / X(reg,prd) ;

Yreg_change(regg,year) = sum(ind, Y_V.L(regg,ind) ) - sum(ind, Y(regg,ind) ) ;

CBUD_H_check(regg,year)
    = ( sum(prd, CONS_H_T_V.L(prd,regg) * PC_H_V.L(prd,regg) *
    ( 1 + tc_h(prd,regg) ) ) ) / CBUD_H_V.L(regg) ;

CBUD_G_check(regg,year)
    = ( sum(prd, CONS_G_T_V.L(prd,regg) * PC_G_V.L(prd,regg) *
    ( 1 + tc_g(prd,regg) ) ) ) / CBUD_G_V.L(regg) ;

CBUD_I_check(regg,year)
    = ( sum(prd, GFCF_T_V.L(prd,regg) * PC_I_V.L(prd,regg) *
    ( 1 + tc_gfcf(prd,regg) ) ) ) / CBUD_I_V.L(regg) ;

numer_check(regg,ind,year)$Y(regg,ind) =  Y_V.L(regg,ind) * PY_V.L(regg,ind) *
    ( 1 - sum(reg, txd_ind(reg,regg,ind) ) -
    sum(reg, txd_tim(reg,regg,ind) ) ) /
    ( sum(prd, INTER_USE_T_V.L(prd,regg,ind) * PIU_V.L(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((reg,kl), KL_V.L(reg,kl,regg,ind) * PKL_V.L(reg,kl) ) +
    sum(tim, TAX_INTER_USE_ROW(tim,regg,ind) * PROW_V.L ) ) ;

* end loop over years
) ;

* ========================= Post-processing of results =========================

Display
Y_time
X_time
Y_change
X_change
Yreg_change
CBUD_H_check
CBUD_G_check
CBUD_I_check
numer_check
;

* Calculate new CO2 emissions
Parameter
    CO2_c_time(regg,ind,year)   combustion C02 emissions over time
    CO2reg_c_time(regg,year)    combustion C02 emissions on region level
;

CO2_c_time(regg,ind,year)$Y_time(regg,ind,year) = Y_time(regg,ind,year) *
    EMIS_model(regg,ind,'CO2_c') / Y(regg,ind) ;

CO2reg_c_time(regg,year) = sum(ind, CO2_c_time(regg,ind,year) ) ;

Display
CO2_c_time
CO2reg_c_time
;
