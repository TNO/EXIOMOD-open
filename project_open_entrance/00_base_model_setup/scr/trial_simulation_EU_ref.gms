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

* ======================== Set for non-problematic countries ===================
Set reg_min_problems(reg)
/
$include %project%/00_base_model_setup/sets/regions_model.txt
/
;
Alias
(reg_min_problems, reg_min_problemss)
;
* Choose which countries to exclude
reg_min_problems('MLT') = no ;
*reg_min_problems('CYP') = no ;

Display
reg_min_problems
;


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
    numer_check_num(regg,ind,year)  check that the numeraire equation holds (numerator)
    numer_check_den(regg,ind,year)  check that the numeraire equation holds (denominator)
    numer_check_den1(regg,ind,year) check that the first part of the numeraire equation holds (denominator)
    numer_check_den2(regg,ind,year) check that the second part of the numeraire equation holds (denominator)
    numer_check_den3(regg,ind,year) check that the thrid part of the numeraire equation holds (denominator)
    numer_check_den4(regg,ind,year) check that the fourth part of the numeraire equation holds (denominator)
    numer_check_den5(regg,ind,year) check that the fifth part of the numeraire equation holds (denominator)
    coprodB_loop(reg,prd,regg,ind,year)  coprodB over the years
    coprodB_loop_display(reg,ind_ref,year)  display only relevant parts of coprodB_loop
;

$include %project%\03_simulation_results\scr\save_simulation_results_declaration_parameters.gms

* ============================== Simulation setup ==============================

loop(year$( ord(year) le 6),

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

coprodB(reg_min_problems,"pELCC",reg_min_problems,ind_ref) =
    elec_ref_shares_yr(reg_min_problems,ind_ref,year) *
    sum((ind_reff,reg_min_problemss), coprodB(reg_min_problems,"pELCC",reg_min_problemss,ind_reff) ) ;
coprodB_loop(reg,prd,regg,ind,year) = coprodB(reg,prd,regg,ind) ;
coprodB_loop_display(reg,ind_ref,year) = coprodB_loop(reg,"pELCC",reg,ind_ref,year) ;

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

numer_check(regg,ind,year)$Y_V.L(regg,ind) =  Y_V.L(regg,ind) * PY_V.L(regg,ind) *
    ( 1 - sum(reg, txd_ind(reg,regg,ind) ) -
    sum(reg, txd_inm(reg,regg,ind) ) - sum(reg, txd_tse(reg,regg,ind) ) ) /
    ( sum(prd, INTER_USE_T_V.L(prd,regg,ind) * PIU_V.L(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum(reg, K_V.L(reg,regg,ind) * PK_V.L(reg) ) +
    sum(reg, L_V.L(reg,regg,ind) * PL_V.L(reg) ) +
    sum(inm, TIM_INTER_USE_ROW(inm,regg,ind) * PROW_V.L ) +
    sum(tse, TIM_INTER_USE_ROW(tse,regg,ind) * PROW_V.L ) ) ;

numer_check_num(regg,ind,year)$Y(regg,ind) =  Y_V.L(regg,ind) * PY_V.L(regg,ind) *
    ( 1 - sum(reg, txd_ind(reg,regg,ind) ) -
    sum(reg, txd_inm(reg,regg,ind) ) - sum(reg, txd_tse(reg,regg,ind) ) ) ;

numer_check_den(regg,ind,year)$Y(regg,ind) =
    ( sum(prd, INTER_USE_T_V.L(prd,regg,ind) * PIU_V.L(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum(reg, K_V.L(reg,regg,ind) * PK_V.L(reg) ) +
    sum(reg, L_V.L(reg,regg,ind) * PL_V.L(reg) ) +
    sum(inm, TIM_INTER_USE_ROW(inm,regg,ind) * PROW_V.L ) +
    sum(tse, TIM_INTER_USE_ROW(tse,regg,ind) * PROW_V.L ) ) ;

numer_check_den1(regg,ind,year)$Y(regg,ind) = sum(prd, INTER_USE_T_V.L(prd,regg,ind) * PIU_V.L(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) ;
numer_check_den2(regg,ind,year)$Y(regg,ind) = sum(reg, K_V.L(reg,regg,ind) * PK_V.L(reg) ) ;
numer_check_den3(regg,ind,year)$Y_V.L(regg,ind) = sum(reg, L_V.L(reg,regg,ind) * PL_V.L(reg) ) ;
numer_check_den4(regg,ind,year)$Y(regg,ind) = sum(inm, TIM_INTER_USE_ROW(inm,regg,ind) * PROW_V.L ) ;
numer_check_den5(regg,ind,year)$Y(regg,ind) = sum(tse, TIM_INTER_USE_ROW(tse,regg,ind) * PROW_V.L ) ;

$include %project%\03_simulation_results\scr\save_simulation_results.gms

* end loop over years
) ;

* ========================= Post-processing of results =========================

Display
K_V.L
PK_V.L
L_V.L
PL_V.L
Y_time
X_time
Y_change
X_change
Yreg_change
CBUD_H_check
CBUD_G_check
CBUD_I_check
numer_check_num
numer_check_den
numer_check_den1
numer_check_den2
numer_check_den3
numer_check_den4
numer_check_den5
coprodB_loop_display
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