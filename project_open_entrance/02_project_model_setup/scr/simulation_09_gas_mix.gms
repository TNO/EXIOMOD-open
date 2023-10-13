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

* Extra parameters for in loop
    coprodB_loop(reg,prd,regg,ind,year)     coprodB in loop

    GDP_scen_change_KS(reg,year)        Change in KS

    coef_emis_c_t(*,prd,regg,*,emis,year)
    coef_emis_nc_t(*,regg,ind,emis,year)
;


$include %project%\03_simulation_results\scr\save_simulation_results_declaration_parameters.gms



* ============================= Simulation preparation =========================


Parameters
    sum_coprodB(reg,prd)
    sum_coprodB_ng(reg,prd)
;

sets
    reg_pol_09(reg)
    ind_09(ind)
;

reg_pol_09(reg)= yes;
reg_pol_09('ROU')= no;
reg_pol_09('GRC')= no;
reg_pol_09('ITA')= no;

sum_coprodB_ng(reg,prd) =
    sum( (regg,indd_ng), coprodB(reg,prd,regg,indd_ng) ) ;

*gas_use_share('%OEscen%','RWO',ind_ng,year) = 0 ;

* ============================= Include constraint =============================


* ============================== Simulation setup ==============================

loop(year$( ord(year) le 40 ),

* ============================== 09_gas_mix ====================================

$if not '%OEscen%' == 'SC' $goto end_09_SC_adjustment
if(ord(year) ge 38 ,
reg_pol_09("FIN")= no;
);
$label end_09_SC_adjustment

*$ontext
if(ord(year) gt 10,
coprodB(reg_pol_09,'pNG',reg_pol_09,ind_ng)$gas_use_share('%OEscen%',reg_pol_09,ind_ng,year)
    = gas_use_share('%OEscen%',reg_pol_09,ind_ng,year) ;

coprodB(reg_pol_09,'pNG',reg_pol_09,ind_ng)
    $sum( (regg,indd_ng), coprodB(reg_pol_09,'pNG',regg,indd_ng) )
    = coprodB(reg_pol_09,'pNG',reg_pol_09,ind_ng)
        / sum( (regg,indd_ng), coprodB(reg_pol_09,'pNG',regg,indd_ng) )
        * sum_coprodB_ng(reg_pol_09,'pNG') ;

sum_coprodB(reg,prd) =
    sum((regg,ind),coprodB(reg,prd,regg,ind)) ;

coprodB_loop(reg,prd,regg,ind,year) =  coprodB(reg,prd,regg,ind) ;

Display coprodB, sum_coprodB ;
);
*$offtext

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
*CGE_MCP.scaleopt = 1 ;
*Solve CGE_MCP using MCP ;

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


* Estimate results on physical indicators:
$include  %project%\03_simulation_results\scr\save_results_physical_extensions.gms


Display
GDPCONST_time
;


Display
    Y_time
    Y_change
;

* ========================= Exporting of results ===============================

* Drop all variables in GDX file
EXECUTE_unload "gdx/%OEscen%_%scenario%"
;
