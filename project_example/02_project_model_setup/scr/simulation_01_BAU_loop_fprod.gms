* File:   %project%/02_project_model_setup/scr/simulation_BL.gms
* Author: Hettie Boonman
* Date:   08 December 2017
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
    LS_ENDO_time(reg,year)      Endogenous Labor supply over time

    check_neg_Y(reg,ind,year)           check for any negatives due to shock
    check_neg_X(reg,prd,year)           check for any negatives due to shock
    check_neg_CBUD_H(reg,year)          check for any negatives due to shock
    check_neg_CBUD_G(reg,year)          check for any negatives due to shock
    check_neg_CBUD_I(reg,year)          check for any negatives due to shock

    value_added_time(regg,ind,year)     value added
    FINAL_USE_time(reg,prd,reg,year)    final demand

    prodK_year(regg,ind,year)           Save prodK by year
    prodL_year(regg,ind,year)           Save prodL by year
    GDP_change(reg,year)                Check how much GDP differs from value
                                        # that is aimed at
    GDP_check(regg,year)                Check if GDP is correct in the loop

;

scalars
    GDP_check_min                        Minimium of GDP_check
    nr_loops                             Number of iterations in loop to find
                                         # best fitting prodK and prodL for
                                         # correct change in GDP
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
*$libinclude xlimport prodK_change %project%\02_project_model_setup\data\prodKL.xlsx prodK!a1:ap100000
*$libinclude xlimport prodL_change %project%\02_project_model_setup\data\prodKL.xlsx prodL!a1:ap100000


* ============================= Include constraint =============================
* Possibly add the labour model

* ============================== Simulation setup ==============================

loop(year$( ord(year) le 40 ),
* There is an error after year 37. Figure out why this happens?

* ============================== Baseline scenario =============================

* Baseline
* We do not need this anymore, when labor supply is endogenous.

LS(reg)                          = LS_V.L(reg) ;
LS_V.FX(reg)                     = LS(reg) * POP_scen_change(reg,year) ;

KS(reg)             = KS_V.L(reg) ;
LS(reg)             = LS_V.L(reg) ;

prodK(reg,ind)
                    = prodK(reg,ind) *
                          ( 1 + (GDP_scen_change(reg,year) -1)
                          - (POP_scen_change(reg,year) -1) );
prodL(reg,ind)      = prodL(reg,ind)*
                          (1 + (GDP_scen_change(reg,year) -1)
                          - (POP_scen_change(reg,year) -1) );

* transfers from the government to the households grows at the rate of population
GTRF(reg)           = GTRF(reg) * POP_scen_change(reg,year) ;

* additional baseline assumption
* reduce the share of output that is inventories
if(ord(year) gt 1,
* Phase out share of changes in inventories
    theta_sv(reg,prd,regg) = theta_sv(reg,prd,regg) * 0.97 ;
) ;



* =============================== Solve statement ==============================


* Bring growth in GDP (by changing parameters prodK and prodL) as close as
* possible to the growth in GDP in policy scenario. In general it holds that
* deltaGDP=deltaPopulation+deltafprod. By use of a loop with at most 10 iterations
* we find the fprod that gives us the best fitting GDP growth.

GDP_change(regg,'2011')=1;
GDP_check_min =1;
GDP_check(regg,year)=0;
nr_loops=0;

while(nr_loops le 10 and GDP_check_min ge 0.00001,

*fprod(kl,regg,ind)       = fprod(kl,regg,ind)*(1-GDP_check(regg,year)) ;
*fprod_year(kl,regg,ind,year)  = fprod(kl,regg,ind);
prodK(regg,ind)            = prodK(regg,ind)*(1-GDP_check(regg,year)) ;
prodK_year(regg,ind,year)  = prodK(regg,ind);
prodL(regg,ind)            = prodL(regg,ind)*(1-GDP_check(regg,year)) ;
prodL_year(regg,ind,year)  = prodL(regg,ind);

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
$include %project%\03_simulation_results\scr\save_simulation_results_calibrate_fprod.gms

GDP_change(regg,year)$GDPCONST_time(regg,year-1)
                        = GDPCONST_time(regg,year)
                           / GDPCONST_time(regg,year-1) ;

GDP_check(regg,year)     = GDP_change(regg,year)
                          - GDP_scen_change(regg,year) ;

GDP_check_min           = abs(smax((regg),GDP_check(regg,year)));

nr_loops                = nr_loops+1 ;

Display nr_loops;
Display GDP_check, GDP_check_min;

);



* =========================== Save selected results ============================

Y_time(regg,ind,year) = Y_V.L(regg,ind) ;
X_time(reg,prd,year) = X_V.L(reg,prd) ;
*LS_ENDO_time(reg,year) = LS_ENDO_V.L(reg) ;

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
*LS_ENDO_time
Y_change
X_change
Yreg_change
CBUD_H_check
CBUD_G_check
CBUD_I_check
numer_check
;


value_added_time(regg,ind,year)  =
    Y_time(regg,ind,year)
    - sum(prd, INTER_USE_T_time(prd,regg,ind,year) *
    ( 1 + tc_ind(prd,regg,ind) ) ) ;

FINAL_USE_time(reg,prd,reg,year)
                = CONS_H_D_time(prd,reg,year)
                + CONS_G_D_time(prd,reg,year)
                + GFCF_D_time(prd,reg,year)
                + SV_time(reg,prd,reg,year)
                + EXPORT_ROW_time(reg,prd,year) ;


Display
GDPCONST_time
;

* ========================= Exporting of results ===============================

$include %project%\03_simulation_results\scr\export_simulation_results_calibrate_fprod.gms
