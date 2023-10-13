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

    coef_emis_c_t(*,prd,regg,*,emis,year)
    coef_emis_nc_t(*,regg,ind,emis,year)
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
$libinclude xlimport prodK_change %project%\02_project_model_setup\data\prodKL_REF.xlsx prodK!a1:ap100000
$libinclude xlimport prodL_change %project%\02_project_model_setup\data\prodKL_REF.xlsx prodL!a1:ap100000

sets
    reg_pol_01(reg)
    ind_01(ind)
;
reg_pol_01(reg)= yes;
reg_pol_01("RWO")= no;
reg_pol_01("RWN")= no;
reg_pol_01("MLT")= no;

ind_01(ind) = yes;
ind_01('iH2')= no;

* ============================= Include constraint =============================
* Possibly add the labour model

* ============================== Simulation setup ==============================

loop(year$( ord(year) le 40 ),

* ============================== 01_BAU ========================================
* We do not need this anymore, when labor supply is endogenous.

LS(reg)                          = LS_V.L(reg) ;
LS_V.FX(reg)                     = LS(reg) * POP_scen_change('%OEscen%',reg,year) ;

KS(reg)             = KS_V.L(reg) ;
LS(reg)             = LS_V.L(reg) ;

if(ord(year) gt 10,
prodK(reg_pol_01,ind_01)      = prodK(reg_pol_01,ind_01) *
                          prodK_change(reg_pol_01,ind_01,year) ;
prodL(reg_pol_01,ind_01)      = prodL(reg_pol_01,ind_01)*
                          prodL_change(reg_pol_01,ind_01,year) ;

);

if(ord(year) lt 11,
prodK(reg_pol_01,ind)        = prodK(reg_pol_01,ind) *
                            prodK_change(reg_pol_01,ind,year) ;
prodL(reg_pol_01,ind)       = prodL(reg_pol_01,ind)*
                            prodL_change(reg_pol_01,ind,year) ;
);

* transfers from the government to the households grows at the rate of population
GTRF(reg)           = GTRF(reg) * POP_scen_change('%OEscen%',reg,year) ;

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
CGE_MCP.optfile = 1;
Solve CGE_MCP using MCP ;


* Store simulation results after each year
$include %project%\03_simulation_results\scr\save_simulation_results.gms

coef_emis_c_t('%OEscen%',prd,regg,ind,emis,year) = coef_emis_c(prd,regg,ind,emis) ;
coef_emis_c_t('%OEscen%',prd,regg,'FCH',emis,year) = coef_emis_c(prd,regg,'FCH',emis) ;
coef_emis_c_t('%OEscen%',prd,regg,'FCG',emis,year) = coef_emis_c(prd,regg,'FCG',emis) ;
coef_emis_nc_t('%OEscen%',regg,ind,emis,year) = coef_emis_nc(regg,ind,emis) ;

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

*value_added_time(regg,ind,year)  =
*    sum(reg, Y_time(regg,ind,year) * txd_ind(reg,regg,ind) ) +
*    sum(reg, Y_time(regg,ind,year) * txd_inm(reg,regg,ind) ) +
*    sum(reg, Y_time(regg,ind,year) * txd_tse(reg,regg,ind) ) +
*    sum(reg, K_time(reg,regg,ind,year) ) +
*    sum(reg, L_time(reg,regg,ind,year) ) ;

* Estimate results on physical indicators:
$include  %project%\03_simulation_results\scr\save_results_physical_extensions.gms

* Estimate effect on employment
*$include  %project%\02_project_model_setup\scr\sub_simulation_employment.gms

* Calculate footprint
*$include %project%/02_project_model_setup/scr/footprint.gms



Display
*EMIS_cons
GDPCONST_time
;

* ========================= Exporting of results ===============================

* Drop all variables in GDX file
EXECUTE_unload "gdx/%OEscen%_%scenario%"
;
