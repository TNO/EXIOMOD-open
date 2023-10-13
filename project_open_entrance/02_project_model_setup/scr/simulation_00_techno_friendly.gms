********** CHANGES WITH RESPECT TO GRADUAL DEVELOPMENT: ***********************
$ontext
04_energy_share_hh
DT does NOT have the following code:
if(ord(year) ge 10 ,
reg_pol_04("LVA")= no;
);

05_CO2_cap_CO2_efficiency
Country SVK keeps cap until 2050, contrary to GD.
if(ord(year) gt 39 ,
    reg_pol_05("PRT") = no ;
    reg_pol_05("FRA") = no ;
*    reg_pol_05("SVK") = no ;
);

09_gas_mix
For finland, only gasmix change until 2048
if(ord(year) ge 38 ,
reg_pol_09("FIN")= no;
);
$offtext

*******************************************************************************



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
ENER_time(ener_CO2,regg,ind,year) = 0 ;

* ============================= Climate effect on lab eff ======================

Parameters
    lab_prod_decr(reg,*)
    lab_prod_decr_yr(reg,year)
    prodL_help(reg,ind)
;

$libinclude xlimport lab_prod_decr   %project%\02_project_model_setup\data\ProdChangeBAU.xlsx Result!b1:e31

* Set year 2020 and year 2050
lab_prod_decr_yr(reg,'2050') = lab_prod_decr(reg,"SC, DT, TF") ;

* interpolate between 2021 (=0) and 2030
lab_prod_decr_yr(reg,year)$(ord(year) gt 10 and ord(year) lt 40)
    = lab_prod_decr_yr(reg,'2020')
        + (ord(year)-10)/(2050-2020)
        * ( lab_prod_decr_yr(reg,'2050')
            - lab_prod_decr_yr(reg,'2020') )  ;

*
prodL_help(reg,ind) = prodL(reg,ind) ;

Display lab_prod_decr_yr ;

* ============================= Simulation preparation =========================

***** What we need for 01_BAU
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
    ind_01a(ind)
;
reg_pol_01(reg)= yes;
reg_pol_01("RWO")= no;
reg_pol_01("RWN")= no;
reg_pol_01("MLT")= no;

ind_01(ind) = yes;
ind_01('iH2')= no;

ind_01a('iAGRI')=yes;
ind_01a('iINDU')=yes;
ind_01a('iALUM')=yes;
ind_01a('iTRAN')=yes;
ind_01a('iCOAL')=yes;
ind_01a('iCOIL')=yes;
ind_01a('iNGAS')=yes;

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

Parameters
    eprod_time(ener,reg,ind,year)
;

reg_pol_03(reg)    =   yes ;
ind_pol_03(ind)     = yes;
ind_pol_03("iH2")   = no ;
ind_pol_03("iCOIL") = no ;
ind_pol_03("iNGAS") = no ;
ind_pol_03("iELCO") = no ;
ind_pol_03("iELCC") = no ;
ind_pol_03("iELCG") = no ;

***** What we need for 04_energy_share_hh
Parameters
        sum_theta_h(regg)
;

sets
    reg_pol_04(reg)

;
reg_pol_04(reg)    =   yes ;
*reg_pol_04('LVA')  =   no ;

* Luxembourg gives problems for pBIO??
ener_use_hh_shares('%OEscen%','pBIO','LUX',year)= ener_use_hh_shares('%OEscen%','pBIO','LUX','2011');


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
*reg_pol_05("CYP")= no;
*reg_pol_05("LUX")= no;
*reg_pol_05("LVA")= no;
*reg_pol_05("MLT")= no;

coef_emis_c_year('%OEscen%',prd,"BEL","iTRDI",'CO2_c',year) = coef_emis_c(prd,"BEL","iTRDI",'CO2_c');
coef_emis_c_year('%OEscen%',prd,"FIN","iTRAN",'CO2_c',year) = coef_emis_c(prd,"FIN","iTRAN",'CO2_c');

* ONLY FOR REFERENCE
*$ontext
loop(year$( ord(year) ge 10 ),
coef_emis_c_year('REF',prd,reg,ind,emis,year) = coef_emis_c_year('REF',prd,reg,ind,emis,'2020');
coef_emis_c_year('REF',prd,reg,ind,emis,year) = coef_emis_c_year('REF',prd,reg,ind,emis,'2020');
);

***** What we need for 06_mat_reduction

Parameters
    ioc_sum(reg,ind)                     Sum over all products
    ioc_missing(reg,ind)
    ioc_sum_check(reg,ind)
;

sets
    reg_pol_06(reg)

    prd_mat_input(prd)
/pINDU, pALUM  /

;

reg_pol_06(reg)=yes;
reg_pol_06('GBR')=no;
reg_pol_06('RWO')=no;
reg_pol_06('RWN')=no;

* Sum over all products in ioc table
ioc_sum(reg,ind) = sum(prd, ioc(prd,reg,ind) ) ;

***** What we need for 08_transport_shares

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

* In 2021, the industry scenario cannot give a solution. Shocks are too big in that year
ener_use_ind_change('%OEscen%',ener_ind,reg_pol_08,'iINDU','2021') = 1;

***** What we need for 09_gas_mix

Parameters
    sum_coprodB_ng(reg,prd)
;

sets
    reg_pol_09(reg)
;

reg_pol_09(reg)= yes;
reg_pol_09('ROU')= no;
reg_pol_09('GRC')= no;
reg_pol_09('ITA')= no;


sum_coprodB_ng(reg,prd) =
    sum( (regg,indd_ng), coprodB(reg,prd,regg,indd_ng) ) ;


* ============================= Include constraint =============================
* ================================= Calculate ETS-price=========================
$include    %project%\02_project_model_setup\scr\sub_simulation_CO2_price.gms

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



* ============================== Simulation setup ==============================
*prodK_change(reg,ind,'2035') = 1;
*prodL_change(reg,ind,'2035') = 1;
loop(year$( ord(year) le 40 ),

* Fix some variables before next  loop:
$include %project%/02_project_model_setup/scr/fixing_variables_before_next_loop.gms


* ============================== 01_BAU ========================================
* We do not need this anymore, when labor supply is endogenous.
*$ontext
LS(reg)                          = LS_V.L(reg) ;
LS_V.FX(reg)                     = LS(reg) * POP_scen_change('%OEscen%',reg,year) ;

KS(reg)             = KS_V.L(reg) ;
LS(reg)             = LS_V.L(reg) ;

if(ord(year) gt 10,
prodK(reg_pol_01,ind_01)      = prodK(reg_pol_01,ind_01) *
                          prodK_change(reg_pol_01,ind_01,year) ;
prodL_help(reg_pol_01,ind_01) = prodL_help(reg_pol_01,ind_01) *
                             prodL_change(reg_pol_01,ind_01,year) ;
prodL(reg_pol_01,ind)          = prodL_help(reg_pol_01,ind) ;
prodL(reg_pol_01,ind_01a)      = prodL(reg_pol_01,ind_01a)
                                 + 3* lab_prod_decr_yr(reg_pol_01,year)  ;

);

if(ord(year) lt 11,
prodK(reg_pol_01,ind)        = prodK(reg_pol_01,ind) *
                            prodK_change(reg_pol_01,ind,year) ;
prodL_help(reg_pol_01,ind) = prodL_help(reg_pol_01,ind) *
                             prodL_change(reg_pol_01,ind,year) ;
prodL(reg_pol_01,ind)          = prodL_help(reg_pol_01,ind) ;
prodL(reg_pol_01,ind_01a)      = prodL(reg_pol_01,ind_01a)
                                 + 3* lab_prod_decr_yr(reg_pol_01,year)  ;
);


* transfers from the government to the households grows at the rate of population
GTRF(reg)           = GTRF(reg) * POP_scen_change('%OEscen%',reg,year) ;

* additional baseline assumption
* reduce the share of output that is inventories
if(ord(year) gt 1,
* Phase out share of changes in inventories
    theta_sv(reg,prd,regg) = theta_sv(reg,prd,regg) * 0.97 ;
) ;
*$offtext
* ============================== 02_elec_mix ===================================
*$ontext
coprodB(reg_pol_02,'pELEC',reg_pol_02,ind_elec)$techmix_shares('%OEscen%',reg_pol_02,ind_elec,year)
    = techmix_shares('%OEscen%',reg_pol_02,ind_elec,year) ;

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
reg_pol_03("RWO")    =   yes ;
if(ord(year) eq 11,
reg_pol_03("RWO")    =   no ;
);

eprod(ener,reg_pol_03,ind_pol_03)$ener_eff_change('%OEscen%',reg_pol_03,year)
    = eprod(ener,reg_pol_03,ind_pol_03) * (1 / ener_eff_change('%OEscen%',reg_pol_03,year) ) ;

eprod_time(ener,reg,ind,year)=eprod(ener,reg,ind);

Display
    eprod
;
*$offtext

* ============================== 04_energy_share_hh ============================
*$ontext
* For now, the model has been runned with simple demand formula, not the
* LES-CES formulation. This can be changed later on. Then: also change the
* way how scenario data is processed for the model.

theta_h(ener_hh,reg_pol_04)$( ener_use_hh_shares('%OEscen%',ener_hh,reg_pol_04,year) and ord(year) gt 10)
    = sum(enerr_hh, theta_h(enerr_hh,reg_pol_04))
        * ener_use_hh_shares('%OEscen%',ener_hh,reg_pol_04,year) ;

sum_theta_h(regg)=sum(prd,theta_h(prd,regg)) ;

* Between 2046-2050, model finds it hard to find a solution.
* LVA has been commented out, this helped a bit.
Display
    theta_h
    sum_theta_h
;
*$offtext

* ============================== 05_CO2_cap_CO2_efficiency =====================
*$ontext

if(ord(year) gt 39 ,
    reg_pol_05("BEL") = no ;
    reg_pol_05("LUX") = no ;
    reg_pol_05("GBR") = no ;
    reg_pol_05("FRA") = no ;
    reg_pol_05("CYP") = no ;
    reg_pol_05("PRT") = no;
);

* Reduce CO2 emission coefficient over time:
coef_emis_c(prd,regg,ind,emis) = coef_emis_c_year('%OEscen%',prd,regg,ind,emis,year) ;
coef_emis_c(prd,regg,fd,emis) = coef_emis_c_year('%OEscen%',prd,regg,fd,emis,year) ;
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


* For initialization
PCO2_time(regg,'2011')=0;

if(ord(year) eq 2 ,
    PCO2_V.L(regg)$(PCO2_V.L(regg) le 0.02)  = 0.001 ;
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

* ============================== 06_mat_reduction ==============================
* Reduce all materials from type XX
* Increase services
*$ontext
* 1. (Reduction of materials for all sectors)
ioc(prd_mat_input,reg_pol_06,ind)
    $( mat_red_change('%OEscen%',reg_pol_06,year) and ioc(prd_mat_input,reg_pol_06,ind) )
    = ioc(prd_mat_input,reg_pol_06,ind)
        * mat_red_change('%OEscen%',reg_pol_06,year) ;

ioc_missing(reg_pol_06,ind)
    = ioc_sum(reg_pol_06,ind) - sum(prd,ioc(prd,reg_pol_06,ind)) ;

* 2. (Increase service sectors with amount that materials has decreased)
ioc('pSERV',reg_pol_06,ind) = ioc('pSERV',reg_pol_06,ind) + ioc_missing(reg_pol_06,ind) ;

ioc_sum_check(reg_pol_06,ind)
    = sum(prd,ioc(prd,reg_pol_06,ind))-ioc_sum(reg_pol_06,ind);

ioc_sum_check(reg,ind)$(abs(ioc_sum_check(reg,ind)) lt 0.000000001) = 0;


Display
    ioc_missing
    ioc
    ioc_sum_check
;
*$offtext

* ============================== 08_transport_shares ===========================
*$ontext

alphaE(ener_tran,reg_pol_08,'iTRAN')$ener_use_tran_change('%OEscen%',ener_tran,reg_pol_08,'iTRAN',year)
    = alphaE(ener_tran,reg_pol_08,'iTRAN')
        * ener_use_tran_change('%OEscen%',ener_tran,reg_pol_08,'iTRAN',year);
ener_factor(regg,'iTRAN')  = ener_factor(regg,'iTRAN') * ener_factor_change(regg,'iTRAN',year) ;

alphaE(ener_serv,reg_pol_08,'iSERV')$ener_use_serv_change('%OEscen%',ener_serv,reg_pol_08,'iSERV',year)
    = alphaE(ener_serv,reg_pol_08,'iSERV')
        * ener_use_serv_change('%OEscen%',ener_serv,reg_pol_08,'iSERV',year);
ener_factor(regg,'iSERV')  = ener_factor(regg,'iSERV') * ener_factor_change(regg,'iSERV',year) ;

alphaE(ener_ind,reg_pol_08,'iINDU')$ener_use_ind_change('%OEscen%',ener_ind,reg_pol_08,'iINDU',year)
    = alphaE(ener_ind,reg_pol_08,'iINDU')
        * ener_use_ind_change('%OEscen%',ener_ind,reg_pol_08,'iINDU',year);
ener_factor(regg,'iINDU')  = ener_factor(regg,'iINDU') * ener_factor_change(regg,'iINDU',year) ;

display alphaE;

*$offtext


* ============================== 09_gas_mix ====================================

if(ord(year) ge 38 ,
reg_pol_09("FIN")= no;
);


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

* Bring growth in GDP (by changing parameters prodK and prodL) as close as
* possible to the growth in GDP in policy scenario. In general it holds that
* deltaGDP=deltaPopulation+deltafprod. By use of a loop with at most 10 iterations
* we find the fprod that gives us the best fitting GDP growth.


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


* Store simulation results after each year
$include %project%\03_simulation_results\scr\save_simulation_results.gms
$include %project%\03_simulation_results\scr\save_simulation_results_CO2cap.gms

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


Display
GDPCONST_time
;

* Estimate results on physical indicators:
$include  %project%\03_simulation_results\scr\save_results_physical_extensions.gms

* ========================= Exporting of results ===============================


* ========================== Create aggregated results =========================

* Drop all variables in GDX file
EXECUTE_unload "gdx/%OEscen%_%scenario%"
;
