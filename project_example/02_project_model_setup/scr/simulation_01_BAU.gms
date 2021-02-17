* File:   %project%/02_project_model_setup/scr/simulation_01_BAU.gms
* Author: Hettie Boonman
* Date:   08 December 2017
* Adjusted:

* gams-master-file: run_EXIOMOD.gms

$ontext startdoc
This simulation file runs the baseline, it includes
* growth in GDP
* growth in population
* transfers from the government to the households grows at the rate of
*   population
* reduce the share of output that is inventories
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
    LS_ENDO_time(reg,year)      Endogenous Labor supply over time

    check_neg_Y(reg,ind,year)           check for any negatives due to shock
    check_neg_X(reg,prd,year)           check for any negatives due to shock
    check_neg_CBUD_H(reg,year)          check for any negatives due to shock
    check_neg_CBUD_G(reg,year)          check for any negatives due to shock
    check_neg_CBUD_I(reg,year)          check for any negatives due to shock

;


$include %project%\03_simulation_results\scr\save_simulation_results_declaration_parameters.gms


* ============================= Simulation preparation =========================

Parameters
    prodK_change(regg,ind,year)          Change in capital productivity
                                         # obtained in calibrate fprod loop
    prodL_change(regg,ind,year)          Change in labour productivity
                                         # obtained in calibrate fprod loop

;


* Read in productivity values for GDP loop
$libinclude xlimport prodK_change %project%\02_project_model_setup\data\prodKL.xlsx prodK!a1:ap100000
$libinclude xlimport prodL_change %project%\02_project_model_setup\data\prodKL.xlsx prodL!a1:ap100000

Display
prodK_change
prodL_change
;

* ============================= Include constraint =============================
* Possibly add additional equations to the model

* ============================== Simulation setup ==============================

* Run simulation for 2011-2050
loop(year$( ord(year) le 40 ),

* ============================== Baseline scenario =============================


* increase in population results in increase in total spend on wages
LS(reg)                          = LS_V.L(reg) ;
LS_V.FX(reg)                     = LS(reg) * POP_scen_change(reg,year) ;

KS(reg)             = KS_V.L(reg) ;
LS(reg)             = LS_V.L(reg) ;


* Forecasted GDP increase via prodK and prodL
prodK(regg,ind)      = prodK(regg,ind) * prodK_change(regg,ind,year) ;
prodL(regg,ind)      = prodL(regg,ind) * prodL_change(regg,ind,year) ;



Display prodK, prodL;

* transfers from the government to the households grows at the rate of population
GTRF(reg) = GTRF(reg) * POP_scen_change(reg,year) ;

* additional baseline assumption
* reduce the share of output that is inventories
if(ord(year) gt 1,
* Phase out share of changes in inventories
    theta_sv(reg,prd,regg) = theta_sv(reg,prd,regg) * 0.97 ;
) ;



* =============================== Solve statement ==============================

* To test whether your model is calibrated well, run the model without any
* shocks. It should give an optimal solution even with zero iterations:
*Option iterlim = 0 ;
Option iterlim = 1000 ;
Option reslim  = 1000 ;
Option decimals = 3 ;
Option nlp = conopt3 ;
CGE_MCP.scaleopt = 1 ;
Solve CGE_MCP using MCP ;


* Store simulation results after each year
$include %project%\03_simulation_results\scr\save_simulation_results.gms


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

*$include %project%\03_simulation_results\scr\save_simulation_results.gms


* Abort if negative values occur in output or CBUD.
check_neg_Y(regg,ind,year)$
   (Y_time(regg,ind,year) lt 0)
        = Y_time(regg,ind,year) ;

check_neg_X(regg,prd,year)$
    (X_time(regg,prd,year) lt 0)
        = X_time(regg,prd,year) ;

check_neg_CBUD_H(regg,year)$
    (CBUD_H_time(regg,year) lt 0)
        = CBUD_H_time(regg,year) ;

check_neg_CBUD_G(regg,year)$
    (CBUD_G_time(regg,year) lt 0)
        = CBUD_G_time(regg,year) ;

check_neg_CBUD_I(regg,year)$
    (CBUD_I_time(regg,year) lt 0)
        = CBUD_I_time(regg,year) ;

Loop(reg,
    if( check_neg_CBUD_H(reg,year) or check_neg_CBUD_H(reg,year) or check_neg_CBUD_H(reg,year),
        display check_neg_CBUD_H, check_neg_CBUD_G, check_neg_CBUD_I ;
        abort "negative values in CBUD" ;
    ) ;
    loop(ind, if( check_neg_Y(reg,ind,year),
        display check_neg_Y ;
        abort "negative values in Y" ;
    ) ; ) ;
    loop(prd, if( check_neg_X(reg,prd,year),
        display check_neg_X ;
        abort "negative values in X" ;
    ) ; ) ;
) ;




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





* ========================= Exporting of results ===============================
* selection of variables exported to excel
$libinclude xldump Y_time            %project%/03_simulation_results/output/Results_%scenario%.xlsx  Y_time!
$libinclude xldump X_time            %project%/03_simulation_results/output/Results_%scenario%.xlsx  X_time!
$libinclude xldump INTER_USE_T_time  %project%/03_simulation_results/output/Results_%scenario%.xlsx  INTER_USE_T_time!
$libinclude xldump INTER_USE_M_time  %project%/03_simulation_results/output/Results_%scenario%.xlsx  INTER_USE_M_time!
$libinclude xldump INTER_USE_D_time  %project%/03_simulation_results/output/Results_%scenario%.xlsx  INTER_USE_D_time!
$libinclude xldump P_time            %project%/03_simulation_results/output/Results_%scenario%.xlsx  P_time!
$libinclude xldump PY_time           %project%/03_simulation_results/output/Results_%scenario%.xlsx  PY_time!
$libinclude xldump PIU_time          %project%/03_simulation_results/output/Results_%scenario%.xlsx  PIU_time!
$libinclude xldump PIMP_T_time       %project%/03_simulation_results/output/Results_%scenario%.xlsx  PIMP_T_time!
$libinclude xldump IMPORT_T_time     %project%/03_simulation_results/output/Results_%scenario%.xlsx  IMPORT_T_time!
$libinclude xldump PL_time           %project%/03_simulation_results/output/Results_%scenario%.xlsx  PL_time!

* Drop all variables in GDX file
EXECUTE_unload "gdx/%scenario%"