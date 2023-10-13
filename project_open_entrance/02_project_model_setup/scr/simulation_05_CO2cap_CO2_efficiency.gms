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
    CO2cap_perc(reg,year)
    P_hulp(regg,year)
    CO2gap(regg)
    INTER_USE_T_gap(prd,regg,ind)
;

sets
    reg_pol_05(reg)
*/ HUN /

;

reg_pol_05(reg)= yes;
reg_pol_05("RWN")= no;
reg_pol_05("RWO")= no;

coef_emis_c_year('%OEscen%',prd,"BEL","iTRDI",'CO2_c',year) = coef_emis_c(prd,"BEL","iTRDI",'CO2_c');
coef_emis_c_year('%OEscen%',prd,"FIN","iTRAN",'CO2_c',year) = coef_emis_c(prd,"FIN","iTRAN",'CO2_c');

* ONLY FOR REFERENCE
*$ontext
loop(year$( ord(year) ge 10 ),
coef_emis_c_year('REF',prd,reg,ind,emis,year) = coef_emis_c_year('REF',prd,reg,ind,emis,'2020');
coef_emis_c_year('REF',prd,reg,ind,emis,year) = coef_emis_c_year('REF',prd,reg,ind,emis,'2020');
);
*$offtext


* ================================= Calculate ETS-price=========================
$include    %project%\02_project_model_setup\scr\sub_simulation_CO2_price.gms


* Define carboncap  in 2050 in share of CO2 emissions compared to baseyear_sim
CO2cap_perc(reg,year)
    $ CO2budget_aggr('%OEscen%',reg,'2011')
    = CO2budget_aggr('%OEscen%',reg,year)
        / CO2budget_aggr('%OEscen%',reg,'2011') ;

Display CO2cap_perc;


* == Define parameters for storing results after each year in the simulation ===

$include    %project%\03_simulation_results\scr\save_simulation_results_declaration_parameters_CO2cap.gms

* ============================= Include constraint =============================

Model CGE_MCP_COMPLEX
/
CGE_MCP

*$ontext
* CO2 price equations
-EQGRINC_G
-EQPY
-EQENER
-EQPnENER
-EQCONS_H_T
-EQCONS_G_T
-EQSCLFD_H
-EQSCLFD_G
EQGRINC_G_CO2.GRINC_G_V
EQPY_CO2
EQENER_CO2.ENER_V
EQPnENER_CO2.PnENER_V
EQCONS_H_T_CO2.CONS_H_T_V
EQCONS_G_T_CO2.CONS_G_T_V
EQSCLFD_H_CO2.SCLFD_H_V
EQSCLFD_G_CO2.SCLFD_G_V

EQCO2_C.CO2_C_V
EQCO2_C_FD.CO2_C_FD_V
EQCO2_NC.CO2_NC_V
EQCO2REV.CO2REV_V
EQPCO2.PCO2_V
*$offtext



/
;


* ============================== Simulation setup ==============================
* FOR SC: set last year to 2048
* FOR DT: set last year to 2049
loop(year$( ord(year) le 40 ),

*$ontext
if(ord(year) gt 1 ,
* When quantity of previous year is almost zero, do not try to find a price
*PC_H_V.FX(ener_CO2,regg)$(CONS_H_T_V.L(ener_CO2,regg) lt 0.000001)             = 1 ;
*PC_G_V.FX(ener_CO2,regg)$(CONS_G_T_V.L(ener_CO2,regg) lt 0.000001)             = 1 ;
*CONS_H_T_V.FX(ener_CO2,regg)$(CONS_H_T_V.L(ener_CO2,regg) lt 0.000001)         = 0 ;
*CONS_G_T_V.FX(ener_CO2,regg)$(CONS_G_T_V.L(ener_CO2,regg) lt 0.000001)         = 0 ;

*When quantity of previous year is almost zero, do not try to find a price
PIU_V.FX(ener_CO2,regg,ind)$(ENER_V.L(ener_CO2,regg,ind) lt   0.00000000001)        = 1 ;
ENER_V.FX(ener_CO2,regg,ind)$(ENER_V.L(ener_CO2,regg,ind) lt  0.00000000001)        = 0 ;

);
*$offtext
* ============================== 05_CO2_cap_CO2_efficiency =====================

* DT
*if(ord(year) gt 39 ,
*    reg_pol_05("PRT") = no ;
*    reg_pol_05("FRA") = no ;
*    reg_pol_05("LUX") = no ;
*    reg_pol_05("BEL") = no ;
*    reg_pol_05("ESP") = no ;
*);

*SC
*if(ord(year) gt 38,
*    reg_pol_05("LUX") = no ;
*    reg_pol_05("PRT") = no ;
*);

*if(ord(year) gt 39,
*    reg_pol_05("BEL") = no ;
*);

* TF
if(ord(year) gt 39 ,
    reg_pol_05("BEL") = no ;
    reg_pol_05("LUX") = no ;
    reg_pol_05("GBR") = no ;
    reg_pol_05("FRA") = no ;
    reg_pol_05("CYP") = no ;
    reg_pol_05("PRT") = no;
);

* WAAROM NEEMT CO2 emissions van huishoudens en overheden nog steeds niet af voor Electricity


*$ontext
* Reduce CO2 emission coefficient over time:
coef_emis_c(prd,regg,ind,emis) = coef_emis_c_year('%OEscen%',prd,regg,ind,emis,year) ;
coef_emis_nc(regg,ind,emis) = coef_emis_nc_year('%OEscen%',regg,ind,emis,year) ;


CO2S_V.FX(reg_pol_05)
    =
    CO2cap_perc(reg_pol_05,year) *
    ( sum(ind,
    (
        sum(ener_CO2, Emissions_c_model(ener_CO2,reg_pol_05,ind,"CO2_c","kg CO2-eq") )
    +
        Emissions_model(reg_pol_05,ind,"CO2_nc","kg CO2-eq")
    )
      /1000000 )
    + sum((ener_CO2,fd), Emissions_c_model(ener_CO2,reg_pol_05,fd,"CO2_c","kg CO2-eq") )
     / 1000000
    ) ;


* Baseyear
*PCO2_V.FX(regg)= 0 ;


*if(ord(year) gt 1 ,
* Set product taxes of some problematic products equal to zero:
*tc_ind_0('pBIO','HRV','iELCC') = 0 ;
*tc_ind_0('pGSL','IRL','iALUM') = 0 ;
*);


* For initialization
PCO2_time(regg,'2011')=0;

if(ord(year) gt 1 ,
    PCO2_V.L(regg)$(PCO2_V.L(regg) le 0.02)  = 0.001 ;
);

*if(ord(year) gt 1 ,
*    PCO2_V.L(regg)$(PCO2_V.L(regg) ge 0.02 and PCO2_V.L(regg) le 8)  = 0.04 ;
*);

* Make a better guess for PCO2
if(ord(year) gt 2 ,

    PCO2_V.L(reg_pol_05)$(PCO2_V.L(reg_pol_05) le 8)
        = (PCO2_time(reg_pol_05,year-1) + PCO2_time(reg_pol_05,year-1)
            - PCO2_time(reg_pol_05,year-2) ) ;

);




P_hulp(regg,year) = PCO2_V.L(regg) ;

Display P_hulp;
*$offtext

*tc_ind('pGSL','BEL','iTRAN') = tc_ind('pGSL','BEL','iTRAN') * 1.3 ;


* =============================== Solve statement ==============================

* To test whether your model is calibrated well, run the model without any
* shocks. It should give an optimal solution even with zero iterations:
*Option iterlim = 0 ;
Option iterlim = 1000 ;
Option reslim  = 1000 ;
Option decimals = 3 ;
Option nlp = conopt3 ;
CGE_MCP_COMPLEX.scaleopt = 1 ;
CGE_MCP_COMPLEX.optfile = 1;
Solve CGE_MCP_COMPLEX using MCP ;
*CGE_MCP.scaleopt = 1 ;
*Solve CGE_MCP using MCP ;

* Store simulation results after each year
$include %project%\03_simulation_results\scr\save_simulation_results.gms
$include %project%\03_simulation_results\scr\save_simulation_results_CO2cap.gms

coef_emis_c_t('%OEscen%',prd,regg,ind,emis,year) = coef_emis_c(prd,regg,ind,emis) ;
coef_emis_c_t('%OEscen%',prd,regg,'FCH',emis,year) = coef_emis_c(prd,regg,'FCH',emis) ;
coef_emis_c_t('%OEscen%',prd,regg,'FCG',emis,year) = coef_emis_c(prd,regg,'FCG',emis) ;
coef_emis_nc_t('%OEscen%',regg,ind,emis,year) = coef_emis_nc(regg,ind,emis) ;

CO2gap(regg) =
    CO2S_V.L(regg)
        - sum((ener_CO2,ind), CO2_C_V.L(ener_CO2,regg,ind) ) ;

INTER_USE_T_gap(prd,regg,ind) = INTER_USE_T_V.L(prd,regg,ind) - INTER_USE_T(prd,regg,ind) ;

Display CO2gap, INTER_USE_T_gap;


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
    CO2_C_time
    CO2_NC_time
    CO2REV_time
    CO2S_time
    PCO2_time
    Y_time
    CO2cap_perc
    Y_change
;

* ========================= Exporting of results ===============================
$ontext
$libinclude xldump Y_time               CO2.xlsx  Y_time!
$libinclude xldump X_time               CO2.xlsx  X_time!
$libinclude xldump P_time               CO2.xlsx  P_time!
$libinclude xldump nKLE_time            CO2.xlsx  nKLE_time!
$libinclude xldump PnKLE_time           CO2.xlsx  PnKLE_time!

$libinclude xldump nENER_time           CO2.xlsx  nENER_time!
$libinclude xldump PnENER_time          CO2.xlsx  PnENER_time!

$libinclude xldump nKL_time             CO2.xlsx  nKL_time!

$libinclude xldump CO2S_time            CO2.xlsx  CO2S_time!
$libinclude xldump CO2_C_time           CO2.xlsx  CO2_C_time!
$libinclude xldump PCO2_time            CO2.xlsx  PCO2_time!

$libinclude xldump PIU_time             CO2.xlsx  PIU_time!
$libinclude xldump ENER_time            CO2.xlsx  ENER_time!
$offtext

* Drop all variables in GDX file
EXECUTE_unload "gdx/%OEscen%_%scenario%"
;
