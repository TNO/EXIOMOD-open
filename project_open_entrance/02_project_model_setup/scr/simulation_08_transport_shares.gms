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

* Extra parameters for in loop
    coprodB_loop(reg,prd,regg,ind,year)     coprodB in loop

    GDP_scen_change_KS(reg,year)        Change in KS
;


$include %project%\03_simulation_results\scr\save_simulation_results_declaration_parameters.gms



* ============================= Simulation preparation =========================


sets
    reg_pol_08(reg)
;

reg_pol_08(reg)= yes;
reg_pol_08("RWO") = no;
reg_pol_08("RWN") = no;
* ener_ind('pELEC')= no;

Parameters
    ener_factor_change(regg,ind,year)       Change in energy factor
                                            # obtained in loop
    ener_factor(regg,ind)

;

* Read in productivity values for GDP loop
$libinclude xlimport ener_factor_change %project%\02_project_model_setup\data\%OEscen%_ener_factor.xlsx ener_factor!a1:ap100000

ener_factor(regg,ind)
    $sum(ener,ENER_V.L(ener,regg,ind))     = 1 ;


* For DT and SC the trans-shock is too big for commodity pNG and country ROU
ener_use_tran_change('SC','pNG','ROU','iTRAN','2021') = 1 ;
ener_use_tran_change('DT','pNG','ROU','iTRAN','2021') = 1 ;

ener_use_serv_change('SC','pCOA','FRA','iSERV',year)$(ord(year) gt 10) = 1 ;
ener_use_serv_change('SC','pOIL','FRA','iSERV',year)$(ord(year) gt 10) = 1 ;

ener_use_serv_change('DT','pCOA','FRA','iSERV',year)$(ord(year) gt 10) = 1 ;
ener_use_serv_change('DT','pOIL','FRA','iSERV',year)$(ord(year) gt 10) = 1 ;

* In 2021, the industry scenario cannot give a solution. Shocks are too big in that year
ener_use_ind_change('%OEscen%',ener_ind,reg_pol_08,'iINDU','2021') = 1;

* ============================= Include constraint =============================

Equations
    EQENER_new(ener,regg,ind)
;


* EQUATION 2.7: Demand for types of energy. The demand function follows CES
* form, where demand of each industry (regg,ind) for each type of energy (ener)
* depends linearly on the demand of the same industry for aggregated energy nest
* and with certain elasticity on relative prices of energy types. The demand for
* energy types is also augmented with exogenous level of energy productivity.
EQENER_new(ener,regg,ind)..
    ENER_V(ener,regg,ind)
    =E=
    ener_factor(regg,ind) *
    ( nENER_V(regg,ind) / eprod(ener,regg,ind) ) * alphaE(ener,regg,ind) *
    ( PIU_V(ener,regg,ind) * ( 1 + tc_ind(ener,regg,ind) ) /
    ( eprod(ener,regg,ind) * PnENER_V(regg,ind) ) )**( -elasE(regg,ind) ) ;

* EQUATION 2.7
EQENER_new.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) gt 0)
    = ENER_V.L(ener,regg,ind) ;

EQENER_new.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) lt 0)
    = -ENER_V.L(ener,regg,ind) ;


Model CGE_MCP_ENER_LOOP
/
CGE_MCP

-EQENER
EQENER_new.ENER_V

/
;

* ============================== Simulation setup ==============================

loop(year$( ord(year) le 40 ),

* ============================== 08_transport_shares ===========================
*$ontext

alphaE(ener_tran,reg_pol_08,'iTRAN')$ener_use_tran_change('%OEscen%',ener_tran,reg_pol_08,'iTRAN',year)
    = alphaE(ener_tran,reg_pol_08,'iTRAN')
        * ener_use_tran_change('%OEscen%',ener_tran,reg_pol_08,'iTRAN',year);

alphaE(ener_ind,reg_pol_08,'iINDU')$ener_use_ind_change('%OEscen%',ener_ind,reg_pol_08,'iINDU',year)
    = alphaE(ener_ind,reg_pol_08,'iINDU')
        * ener_use_ind_change('%OEscen%',ener_ind,reg_pol_08,'iINDU',year);

alphaE(ener_serv,reg_pol_08,'iSERV')$ener_use_serv_change('%OEscen%',ener_serv,reg_pol_08,'iSERV',year)
    = alphaE(ener_serv,reg_pol_08,'iSERV')
        * ener_use_serv_change('%OEscen%',ener_serv,reg_pol_08,'iSERV',year);

ener_factor(regg,'iTRAN')  = ener_factor(regg,'iTRAN') * ener_factor_change(regg,'iTRAN',year) ;
ener_factor(regg,'iSERV')  = ener_factor(regg,'iSERV') * ener_factor_change(regg,'iSERV',year) ;
ener_factor(regg,'iINDU')  = ener_factor(regg,'iINDU') * ener_factor_change(regg,'iINDU',year) ;

display alphaE;

*$offtext

* =============================== Solve statement ==============================

* To test whether your model is calibrated well, run the model without any
* shocks. It should give an optimal solution even with zero iterations:
*Option iterlim = 0 ;
Option iterlim = 1000 ;
Option reslim  = 1000 ;
Option decimals = 3 ;
Option nlp = conopt3 ;
CGE_MCP_ENER_LOOP.scaleopt = 1 ;
CGE_MCP_ENER_LOOP.optfile = 1;
Solve CGE_MCP_ENER_LOOP using MCP ;
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

$libinclude xldump ENER_time         Results.xlsx  ENER_time!

* Drop all variables in GDX file
EXECUTE_unload "gdx/%OEscen%_%scenario%"
;
