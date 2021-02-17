* File:   %project%/00_base_model_setup/scr/trial_simulation.gms
* Author: Tatyana Bulavskaya
* Date:   11 August 2015
* Adjusted:

* gams-master-file: run_EXIOMOD.gms

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
    coprodB_loop(reg,prd,regg,ind,year)  coprodB over the years
    coprodB_loop_display(reg,ind_elec,year)  display only relevant parts of coprodB_loop
    check_year(year)                  should add up to 1
    year_par(year)
    smooth_time
    coprodB_short(reg,ind_elec,year)
;

$include %project%\03_simulation_results\scr\save_simulation_results_declaration_parameters.gms

* ============================== Simulation setup ==============================


*We want: (eg smooth_time = 5)
* 2011: coprodB = 1.0 * coprodB + 0.0 * WEO
* 2012: coprodB = 0.8 * coprodB + 0.2 * WEO
* 2013: coprodB = 0.6 * coprodB + 0.4 * WEO
* 2014: coprodB = 0.4 * coprodB + 0.6 * WEO
* 2015: coprodB = 0.2 * coprodB + 0.8 * WEO
* 2016: coprodB = 0.0 * coprodB + 1.0 * WEO
smooth_time = 5;

$setglobal      jaartal         '2016'

*Set initial and end value for coprodB_loop
coprodB_loop(reg,prd,regg,ind,year) =  coprodB(reg,prd,regg,ind)  ;


coprodB_short(reg,ind_elec,"2011") = coprodB_loop(reg,"pELCC",reg,ind_elec,"2011") ;

loop ( (reg,ind_elec)$ (coprodB_short(reg,ind_elec,"2011") = 0),
          coprodB_short(reg,ind_elec,"2011") = 0.0001
          );

coprodB_loop(reg,"pELCC",reg,ind_elec,"2011") = coprodB_short(reg,ind_elec,"2011");



coprodB_loop(reg,"pELCC",reg,ind_elec,"%jaartal%") =  elec_WEO_shares(reg,ind_elec,"2016")
    * sum((ind_elecc,reggg), coprodB(reg,"pELCC",reggg,ind_elecc) ) ;
*Same for coprodB_loop_display
*This parameter makes it easier to see the applied changed
* ie changes made in pELCC and ind_elec
coprodB_loop_display(reg,ind_elec,"2011") = coprodB_loop(reg,"pELCC",reg,ind_elec,"2011") ;
coprodB_loop_display(reg,ind_elec,"%jaartal%") = coprodB_loop(reg,"pELCC",reg,ind_elec,"%jaartal%") ;

*Start a loop to change value for years inbetween:
loop(year$( ord(year) ge 2 and ord(year) le smooth_time ),
    year_par(year) = ord(year) ;

*Shock in coprodB
coprodB_loop(reg,"pELCC",reg,ind_elec,year)
    = ( year_par(year) - 1 ) / smooth_time * elec_WEO_shares(reg,ind_elec,"2016")
    * sum((ind_elecc,reggg), coprodB(reg,"pELCC",reggg,ind_elecc) )
    + (smooth_time - (year_par(year)-1) ) / smooth_time * coprodB(reg,"pELCC",reg,ind_elec) ;
coprodB_loop_display(reg,ind_elec,year) = coprodB_loop(reg,"pELCC",reg,ind_elec,year) ;
check_year(year) = ( year_par(year) - 1 ) / smooth_time  + (smooth_time - (year_par(year)-1) ) / smooth_time ;

);



$ontext

Parameter
coprodB_year(reg,prd,reg,ind,year)
coprodB_trial_display(reg,ind_elec,year)
;

coprodB_year(reg,prd,reg,ind,year) = coprodB(reg,prd,reg,ind)   ;

*$libinclude xldump coprodB_year  project_open_entrance/03_simulation_results/output/Results.xlsx    coprodB!    ;
*$libinclude xldump coprodB_loop  project_open_entrance/03_simulation_results/output/Results.xlsx    coprodB_loop! ;

coprodB_trial(reg,prd,regg,ind,year) = coprodB(reg,prd,regg,ind) ;
coprodB_trial("AUT","pELCC","AUT","iELCN","2012") = 0.100  ;
coprodB_trial("AUT","pELCC","AUT","iELCP","2012") = 0.100  ;
coprodB_trial("AUT","pELCC","AUT","iELCM","2012") = 0.100  ;
coprodB_trial("AUT","pELCC","AUT","iELCH","2012") = coprodB("AUT","pELCC","AUT","iELCH") - 0.300 ;

coprodB_trial("BEL","pELCC","AUT","iELCT","2012") = 0.100  ;
coprodB_trial("BEL","pELCC","AUT","iELCP","2012") = 0.100  ;
coprodB_trial("BEL","pELCC","AUT","iELCM","2012") = 0.100  ;
coprodB_trial("BEL","pELCC","AUT","iELCN","2012") = coprodB("AUT","pELCC","AUT","iELCH") - 0.300 ;

coprodB_trial_display(reg,ind_elec,year)  =  coprodB_trial(reg,"pELCC",reg,ind_elec,year)

Display
coprodB_trial_display
;
$offtext



loop(year$( ord(year) le 2 ),

$ontext
* CEPII baseline
KS(reg)                 = KS_V.L(reg) ;
KS_V.FX(reg)            = KS(reg) * KS_CEPII_change(reg,year) ;
LS(reg)                 = LS_V.L(reg) ;
LS_V.FX(reg)            = LS(reg) * LS_CEPII_change(reg,year) ;
prodK(regg,ind)         = prodK(regg,ind) * PRODKL_CEPII_change(regg,year) ;
prodL(regg,ind)         = prodL(regg,ind) * PRODKL_CEPII_change(regg,year) ;

* additional baseline assumption
* reduce the share of output that is inventories
if(ord(year) gt 1,
* Phase out share of changes in inventories
    theta_sv(reg,prd,regg) = theta_sv(reg,prd,regg) * 0.97 ;
) ;
* Additional trial shock
* LS_V.FX('WEU')$(ord(year) eq 2 ) = 1.1 * LS('WEU') ;

$offtext

coprodB(reg,prd,regg,ind) = coprodB_loop(reg,prd,regg,ind,year)
*coprodB(reg,prd,regg,ind) = coprodB_trial(reg,prd,regg,ind,year) ;

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
    sum(reg, txd_inm(reg,regg,ind) ) - sum(reg, txd_tse(reg,regg,ind) ) ) /
    ( sum(prd, INTER_USE_T_V.L(prd,regg,ind) * PIU_V.L(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum(reg, K_V.L(reg,regg,ind) * PK_V.L(reg) ) +
    sum(reg, L_V.L(reg,regg,ind) * PL_V.L(reg) ) +
    sum(inm, TIM_INTER_USE_ROW(inm,regg,ind) * PROW_V.L ) +
    sum(tse, TIM_INTER_USE_ROW(tse,regg,ind) * PROW_V.L ) ) ;

$include %project%\03_simulation_results\scr\save_simulation_results.gms

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
coprodB_short
*coprodB_loop_display
*year_par
*check_year
;

* Calculate new CO2 emissions
*Parameter
*    CO2_c_time(regg,ind,year)   combustion C02 emissions over time
*    CO2reg_c_time(regg,year)    combustion C02 emissions on region level
*;

*CO2_c_time(regg,ind,year)$Y_time(regg,ind,year) = Y_time(regg,ind,year) *
*    EMIS_model(regg,ind,'CO2_c') / Y(regg,ind) ;

*CO2reg_c_time(regg,year) = sum(ind, CO2_c_time(regg,ind,year) ) ;

*Display
*CO2_c_time
*CO2reg_c_time
*;
