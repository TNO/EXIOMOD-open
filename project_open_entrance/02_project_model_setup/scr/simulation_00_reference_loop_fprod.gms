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

;


$include %project%\03_simulation_results\scr\save_simulation_results_declaration_parameters.gms
ENER_time(ener_CO2,regg,ind,year) = 0 ;
* ============================= Simulation preparation =========================


***** What we need for 01_BAU
Parameters
    prodK_change(regg,ind,year)          Change in capital productivity
                                         # obtained in calibrate fprod loop
    prodL_change(regg,ind,year)          Change in labour productivity
                                         # obtained in calibrate fprod loop
;

Parameters
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

sets
    reg_pol_01(reg)
*    ind_01(ind)
;
reg_pol_01(reg)= yes;
reg_pol_01("RWO")= no;
reg_pol_01("RWN")= no;
reg_pol_01("MLT")= no;

*ind_01(ind) = yes;
*ind_01('iH2')= no;

*GDP_scen_change('REF',"RWO",year) = 1;
*GDP_scen_change('REF',"RWN",year) = 1;

***** What we need for 02_elec_mix
Parameters
    sum_coprodB(reg,prd)
    sum_coprodB_elec(reg,prd)
    coprodB_loop(reg,prd,regg,ind,year)     coprodB in loop
;

sets
    reg_pol_02(reg)
;

reg_pol_02(reg)= yes;

Alias
    (ind_elec,indd_elec)
;

sum_coprodB_elec(reg,prd) =
    sum( (regg,indd_elec), coprodB(reg,prd,regg,indd_elec) ) ;

***** What we need for 03_ener_efficiency
sets
    reg_pol_03(reg)
    ind_pol_03(ind)
;

reg_pol_03(reg)    =   yes ;
ind_pol_03(ind)     = yes;
ind_pol_03("iH2")   = no ;
ind_pol_03("iCOIL") = no ;
ind_pol_03("iNGAS") = no ;
ind_pol_03("iELCO") = no ;
ind_pol_03("iELCC") = no ;
ind_pol_03("iELCG") = no ;

***** What we need for 05_CO2cap_CO2_efficiency

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


* ============================= Include constraint =============================
* ================================= Calculate ETS-price=========================
$include    %project%\02_project_model_setup\scr\sub_simulation_CO2_price.gms

CO2cap_perc(reg,year)
    $ CO2budget_aggr('REF',reg,'2011')
    = CO2budget_aggr('REF',reg,year)
        / CO2budget_aggr('REF',reg,'2011') ;


Display CO2cap_perc;

* == Define parameters for storing results after each year in the simulation ===

$include    %project%\03_simulation_results\scr\save_simulation_results_declaration_parameters_CO2cap.gms



* ============================= Include constraint =============================



Model CGE_MCP_COMPLEX
/
CGE_MCP

* 08_transport_loop equation
*-EQENER
*EQENER_new.ENER_V

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

loop(year$( ord(year) le 40 ),

* Fix some variables before next  loop:
$include %project%/02_project_model_setup/scr/fixing_variables_before_next_loop.gms


* ============================== 01_BAU ========================================
* We do not need this anymore, when labor supply is endogenous.

LS(reg)                          = LS_V.L(reg) ;
LS_V.FX(reg)                     = LS(reg) * POP_scen_change('REF',reg,year) ;

KS(reg)             = KS_V.L(reg) ;
LS(reg)             = LS_V.L(reg) ;

prodK(reg_pol_01,ind)
                    = prodK(reg_pol_01,ind) *
                          ( 1 + (GDP_scen_change('%OEscen%',reg_pol_01,year) -1)
                          - (POP_scen_change('REF',reg_pol_01,year) -1) );
prodL(reg_pol_01,ind)      = prodL(reg_pol_01,ind)*
                          (1 + (GDP_scen_change('%OEscen%',reg_pol_01,year) -1)
                          - (POP_scen_change('REF',reg_pol_01,year) -1) );

* transfers from the government to the households grows at the rate of population
GTRF(reg)           = GTRF(reg) * POP_scen_change('REF',reg,year) ;

* additional baseline assumption
* reduce the share of output that is inventories
if(ord(year) gt 1,
* Phase out share of changes in inventories
    theta_sv(reg,prd,regg) = theta_sv(reg,prd,regg) * 0.97 ;
) ;

* ============================== 02_elec_mix ===================================
*$ontext
coprodB(reg_pol_02,'pELEC',reg_pol_02,ind_elec)$techmix_shares("REF",reg_pol_02,ind_elec,year)
    = techmix_shares('REF',reg_pol_02,ind_elec,year) ;

coprodB(reg_pol_02,'pELEC',reg_pol_02,ind_elec)
    $sum( (regg,indd_elec), coprodB(reg_pol_02,'pELEC',regg,indd_elec) )
    = coprodB(reg_pol_02,'pELEC',reg_pol_02,ind_elec)
        / sum( (regg,indd_elec), coprodB(reg_pol_02,'pELEC',regg,indd_elec) )
        * sum_coprodB_elec(reg_pol_02,'pELEC') ;

sum_coprodB(reg,prd) =
    sum((regg,ind),coprodB(reg,prd,regg,ind)) ;

coprodB_loop(reg,prd,regg,ind,year) =  coprodB(reg,prd,regg,ind) ;

Display coprodB, sum_coprodB ;
*$offtext
* ============================== 03_ener_efficiency ============================
*$ontext
eprod(ener,reg_pol_03,ind_pol_03)$ener_eff_change('%OEscen%',reg_pol_03,year)
    = eprod(ener,reg_pol_03,ind_pol_03) * (1 / ener_eff_change('%OEscen%',reg_pol_03,year) ) ;

Display
    eprod
;
*$offtext
* ============================== 05_CO2_cap_CO2_efficiency =====================

*$ontext
* Reduce CO2 emission coefficient over time:
coef_emis_c(prd,regg,ind,emis) = coef_emis_c_year('REF',prd,regg,ind,emis,year) ;
coef_emis_c(prd,regg,fd,emis) = coef_emis_c_year('REF',prd,regg,fd,emis,year) ;
coef_emis_nc(regg,ind,emis) = coef_emis_nc_year('REF',regg,ind,emis,year) ;


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


* For initialization
PCO2_time(regg,'2011')=0;

if(ord(year) eq 2 ,
    PCO2_V.L(regg)$(PCO2_V.L(regg) le 0.02)  = 0.0001 ;
);

* Make a better guess for PCO2
if(ord(year) gt 2 ,

    PCO2_V.L(reg_pol_05)$(PCO2_V.L(reg_pol_05) le 8)
        = (PCO2_time(reg_pol_05,year-1) + PCO2_time(reg_pol_05,year-1)
            - PCO2_time(reg_pol_05,year-2) ) ;

);


P_hulp(regg,year) = PCO2_V.L(regg) ;

Display P_hulp;
*$offtext


* =============================== Solve statement ==============================

* Bring growth in GDP (by changing parameters prodK and prodL) as close as
* possible to the growth in GDP in policy scenario. In general it holds that
* deltaGDP=deltaPopulation+deltafprod. By use of a loop with at most 10 iterations
* we find the fprod that gives us the best fitting GDP growth.

GDP_change(reg_pol_01,'2011')=1;
GDP_check_min =1;
GDP_check(reg_pol_01,year)=0;
nr_loops=0;

while(nr_loops le 10 and GDP_check_min ge 0.00005,

* Fix some variables before next  loop:
$include %project%/02_project_model_setup/scr/fixing_variables_before_next_loop.gms

*fprod(kl,regg,ind)       = fprod(kl,regg,ind)*(1-GDP_check(regg,year)) ;
*fprod_year(kl,regg,ind,year)  = fprod(kl,regg,ind);
prodK(reg_pol_01,ind)            = prodK(reg_pol_01,ind)*(1-GDP_check(reg_pol_01,year)) ;
prodK_year(reg_pol_01,ind,year)  = prodK(reg_pol_01,ind);
prodL(reg_pol_01,ind)            = prodL(reg_pol_01,ind)*(1-GDP_check(reg_pol_01,year)) ;
prodL_year(reg_pol_01,ind,year)  = prodL(reg_pol_01,ind);

* For nrloops>1 we need to reset the first guess of PCO2. Because in loop 1 this
* might have been set to zero. In loop 2, the program finds it hard to find a
* solution again.
*$ontext
* Make a better guess for PCO2
if(ord(year) eq 2 ,
    PCO2_V.L(regg)$(PCO2_V.L(regg) le 0.02)  = 0.0001 ;
);

* Make a better guess for PCO2
if(ord(year) gt 2 ,

    PCO2_V.L(reg_pol_05)$(PCO2_V.L(reg_pol_05) le 8 )
        = (PCO2_time(reg_pol_05,year-1) + PCO2_time(reg_pol_05,year-1)
            - PCO2_time(reg_pol_05,year-2) ) ;

);

*$offtext

* To test whether your model is calibrated well, run the model without any
* shocks. It should give an optimal solution even with zero iterations:
*Option iterlim = 0 ;
Option iterlim = 1000 ;
Option reslim  = 1000 ;
Option decimals = 3 ;
Option nlp = conopt3 ;
CGE_MCP_COMPLEX.scaleopt = 1 ;
Solve CGE_MCP_COMPLEX using MCP ;


* Store simulation results after each year
$include %project%\03_simulation_results\scr\save_simulation_results_calibrate_fprod.gms
$include %project%\03_simulation_results\scr\save_simulation_results_CO2cap.gms

GDP_change(reg_pol_01,year)$GDPCONST_time(reg_pol_01,year-1)
                        = GDPCONST_time(reg_pol_01,year)
                           / GDPCONST_time(reg_pol_01,year-1) ;

GDP_check(reg_pol_01,year)     = GDP_change(reg_pol_01,year)
                          - GDP_scen_change('%OEscen%',reg_pol_01,year) ;

GDP_check_min           = abs(smax((reg_pol_01),GDP_check(reg_pol_01,year)));

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


* ========================== Create aggregated results =========================
Parameter
      prodK_change(regg,ind,year)          prodK in level compared
                                           # to last year

      prodL_change(regg,ind,year)          prodL in level compared
                                           # to last year
;


prodK_change(regg,ind,year)$(ord(year) gt 1 and prodK_year(regg,ind,year-1))
         = prodK_year(regg,ind,year)
                 / prodK_year(regg,ind,year-1) ;

prodL_change(regg,ind,year)$(ord(year) gt 1 and prodK_year(regg,ind,year-1))
         = prodL_year(regg,ind,year)
                 / prodL_year(regg,ind,year-1) ;

prodK_change(regg,ind,year)$(ord(year) eq 1)
         = 1 ;

prodL_change(regg,ind,year)$(ord(year) eq 1)
         = 1 ;

* ========================= Export results to xlsx-file ========================
$libinclude xldump prodK_change %project%\02_project_model_setup\data\prodKL_%OEscen%.xlsx prodK!
$libinclude xldump prodL_change %project%\02_project_model_setup\data\prodKL_%OEscen%.xlsx prodL!



* Drop all variables in GDX file
EXECUTE_unload "gdx/%OEscen%_%scenario%"
;
