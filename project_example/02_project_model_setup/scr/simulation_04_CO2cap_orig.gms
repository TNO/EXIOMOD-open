
* File:   project_COMPLEX/02_project_model_setup/simulation_framework_BL.gms
* Author: Jinxue Hu
* Date:   15 October 2015

$ontext startdoc
This file sets up the EXIOMOD baseline simulation run:

Firstly simulation specific parameters are defined.
Then the components are included, incl. shock values depending on the scenario.
This is followed by the assembly of equations for the CGE_MCP_POLFREE model.
The time loop starts:
    -shock values are linked to the model variables
    -model is solved
    -model checks
    -simulation results are saved
Budget constraint and numeraire checks
Processing of results
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ======== Declaration and definition of simulation specific parameters ========
* The base year for implementation of the policy measures
* The measures are implemented after this year.
$setglobal baseyear_sim  2010
$setglobal SSP           SSP2
*$setglobal SC_GCAM       Ref_SSP2

*Sets

*    EU(reg)
*/
*$include    %project%/02_project_model_setup/sets/regions_EU_model.txt
*/
*;


Parameters
    Y_change(regg,ind,year)             change in industry output due to shock
    X_change(reg,prd,year)              change in product output due to shock
    Yreg_change(regg,year)              change in country output due to shock
    Yreg(regg,year)                     total country output sum over industries
    CBUD_H_check(regg,year)             check that budget constraint holds
    CBUD_G_check(regg,year)             check that budget constraint holds
    CBUD_I_check(regg,year)             check that budget constraint holds
    numer_check(regg,ind,year)          check that the numeraire equation holds

    check_neg_Y(reg,ind,year)           check for any negatives due to shock
    check_neg_X(reg,prd,year)           check for any negatives due to shock
    check_neg_CBUD_H(reg,year)          check for any negatives due to shock
    check_neg_CBUD_G(reg,year)          check for any negatives due to shock
    check_neg_CBUD_I(reg,year)          check for any negatives due to shock

    GDP_change(regg,year)               change in GDP due to population shock
    GDP_check(regg,year)                check difference in change in GDP from
                                        # SSP database compared to model result
    prodK_change(regg,ind,year)         prodK by annual change calculated using
                                        # the following gms file
                                        # simulation_framework_calibrate_prodK_prod_L
    prodL_change(regg,ind,year)         prodL by annual change calculated using
                                        # the following gms file
                                        # simulation_framework_calibrate_prodK_prod_L
    coprodB_0(reg,prd,reg,ind)          original coproduction coefficients
    txd_ind_0(reg,reg,ind)              original production tax
    CO2cap_perc(year)                   CO2 cap in percentage compared to 2007
    CO2surplus(regg,year)               CO2surplus is equal to one when the
                                        # the full carbon budget is used
    CO2_year(regg,year)                 CO2 emissions by region and year
    Carbon_efficiency(regg,year)        Carbon Efficiency
    CBUD_H_part1_time(regg,year)        Split up CBUD_H_time into three parts
    CBUD_H_part2_time(regg,year)        Split up CBUD_H_time into three parts
    CBUD_H_part3_time(regg,year)        Split up CBUD_H_time into three parts
;

scalars
    GDP_check_min                        Minimium of GDP_check
    nr_loops                             Number of iterations in loop to find
                                         # best fitting prodK and prodL for
                                         # correct change in GDP
;


* ======================= Define new variables / equations =====================

Sets
energy_hh(prd)      energy products that households consume
                    /pCREF,pELEC,pGAWA/
energy_ind(ind)     energy producing industries
                    /iCREF,iELNC,iELFF,iELRE/
;

Alias
     (elec_ind,elec_indd)
;


coprodB_0(reg,prd,regg,ind) = coprodB(reg,prd,regg,ind) ;
txd_ind_0(reg,reg,ind)      = txd_ind(reg,reg,ind)      ;

* Read in productivity values
$libinclude xlimport prodK_change %project%\02_project_model_setup\data\prodKL.xlsx prodK_%SSP%!a1:at100000
$libinclude xlimport prodL_change %project%\02_project_model_setup\data\prodKL.xlsx prodL_%SSP%!a1:at100000

* Include equations for income quantiles
$include    %project%\02_project_model_setup\scr\sub_simulation_income_quantiles.gms

Parameter
    CONS_Hinc_T_MIN_year(prd,regg,inc,year) subsistence level of consumption by
                                        # year
;

* These parameters are needed when looping over the years.
CONS_Hinc_T_MIN_year(prd,regg,inc,"2007")    =   CONS_Hinc_T_MIN(prd,regg,inc) ;

* For all energy products, minimum consumption level increases with increase
* in energy intensity
Loop(prd$energy_hh(prd),
    Loop(year$(ord(year) gt 7),
        CONS_Hinc_T_MIN_year(prd,regg,inc,year)
*            = CONS_Hinc_T_MIN_year(prd,regg,inc,year-1) * GCAM_ener_int_hh_change('Emi_GDP_lowNUC_lowCCS_LowRen',regg,year);
            = CONS_Hinc_T_MIN_year(prd,regg,inc,year-1) * GCAM_ener_int_hh_change('%scenario%',regg,year) ;
) ; ) ;

* For all products, minimum consumption level increases with increase in
* population.
Loop(prd,
    Loop(year$(ord(year) gt 7),
        CONS_Hinc_T_MIN_year(prd,regg,inc,year)
            = CONS_Hinc_T_MIN_year(prd,regg,inc,year-1) * %SSP%_POP_change('OECD Env-Growth',regg,year) ;
) ; ) ;

* Read in energy mix
$set include_variables_equations      YES
*$include    %project%\02_project_model_setup\scr\sub_simulation_energy_mix.gms
*$include    %project%\02_project_model_setup\scr\sub_simulation_ETS_price.gms



* ================================= Calculate ETS-price=========================
$include    %project%\02_project_model_setup\scr\sub_simulation_CO2_price.gms


* Define carboncap  in 2050 in share of CO2 emissions compared to baseyear_sim
CO2cap_perc(year)
    $ sum(reg,GCAM_CO2_spline('%scenario%',reg,'2007') )
    = sum(reg,GCAM_CO2_spline('%scenario%',reg,year) )
        / sum(reg,GCAM_CO2_spline('%scenario%',reg,'2007') ) ;


* Years between 2007 and base year should have value 1
*CO2cap_perc(year)$
*    (ord(year) ge 7 and ord(year) le sum(yearr$sameas(yearr,"%baseyear_sim%"),ord(yearr)) )
*        = 1 ;


*CO2cap_perc('2007')=1;
*loop(year$(ord(year) ge 8),
*    CO2cap_perc(year)=CO2cap_perc(year-1)-0.01;
*);


*Display CO2cap_perc;

* == Define parameters for storing results after each year in the simulation ===


$include    %project%\03_simulation_results\scr\save_simulation_results_declaration_parameters.gms
$include    %project%\03_simulation_results\scr\save_simulation_results_declaration_parameters_CO2cap.gms


* ================== Assembly equations for CGE_MCP_POLFREE ====================

Model CGE_MCP_COMPLEX
/
CGE_MCP

*Example of adding or removing equations:
*-EQCONS_H_T
*EQCONS_H_T_les.CONS_H_T_V

* ETS price equations
*-EQnENER
*-EQGRINC_G
*-EQPY
*EQCO2.CO2_V
*EQTOTCO2.TOTCO2_V
*EQCO2REV.CO2REV_V
*EQnENER_CO2.nENER_V
*EQGRINC_G_CO2.GRINC_G_V
*EQPY_CO2

* CO2 price equations
-EQGRINC_G
-EQPY
EQCO2.CO2_V
EQCO2REV.CO2REV_V
EQGRINC_G_CO2.GRINC_G_V
EQPY_CO2
EQPCO2.PCO2_V

*Income equations
-EQCONS_H_T
-EQSCLFD_H

EQCONS_H_T_inc.CONS_H_T_V
EQCONS_Hinc_T.CONS_Hinc_T_V
EQSCLFD_Hinc.SCLFD_Hinc_V
EQPAASCHEinc.PAASCHEinc_V
/
;

* ===================Scenario assumptions before the loop=======================


* ============================== Simulation setup ==============================
* start loop over years
loop(year$( ord(year) ge 7 and ord(year) le %end_year% ),


* ========================= Baseline scenario assumptions ======================
* always use baseline independent of the %scenario%

KS(reg)             = KS_V.L(reg) ;
LS(reg)             = LS_V.L(reg) ;

* CEPII baseline
KS_V.FX(reg)     = KS(reg) * KS_CEPII_change(reg,year) ;
*LS_V.FX(reg)     = KS(reg) * LS_CEPII_change(reg,year) ;
*prodK(regg,ind)      = prodK(regg,ind) * PRODKL_CEPII_change(regg,year) ;
*prodL(regg,ind)      = prodL(regg,ind) * PRODKL_CEPII_change(regg,year) ;
*eprod(ener,regg,ind)    = eprod(ener,regg,ind) * PRODE_CEPII_change(regg,year) ;

* SSP baseline
LS_V.FX(reg)     = LS(reg) * %SSP%_POP_change('OECD Env-Growth',reg,year);
*adjust fprod_change:
prodK(regg,ind)      = prodK(regg,ind) * prodK_change(regg,ind,year) ;
prodL(regg,ind)      = prodL(regg,ind) * prodL_change(regg,ind,year) ;


* CO2 coeficients, adjusted to GCAM carbon intensity.
coef_emis_c(reg,ind,'CO2_c')     = coef_emis_c_year('%scenario%',reg,ind,"CO2_c",year) ;
coef_emis_c(reg,fd,'CO2_c')      = coef_emis_c_year('%scenario%',reg,fd,"CO2_c",year) ;
coef_emis_nc(reg,ind,'CO2_nc')   = coef_emis_nc_year('%scenario%',reg,ind,"CO2_nc",year);


* ADDITIONAL BASELINE ASSUMPTIONS
* reduce the share of output that is inventories
if(ord(year) gt 7,
* Phase out share of changes in inventories
    theta_sv(reg,prd,regg) = theta_sv(reg,prd,regg) * 0.97 ;


* Energy intensity improvements lead to a decrease in energy price
* Offset this effect by an additional tax. This can be seen as a trajectory for
* increasing energy prices.
* Energy prices should increase with 0.8% annually in the baseline and should
* accordingly be 1.42 in 2050.
* See page 41 of International Energy Agency (2012), "World Energy Outlook"
* This might have to be programmed as a loop later on. (Electricity prices)
*    txd_ind(reg,regg,energy_ind)$txd_ind(reg,regg,energy_ind)
*                         =   txd_ind(reg,regg,energy_ind) + 0.006 ;
) ;

* transfers from the government to the households grows at the rate of population
GTRF(reg) = GTRF(reg) * %SSP%_POP_change('OECD Env-Growth',reg,year) ;

$ontext
* Improvement in energy intensity according to GCAM data
* Notice that there is no energy efficiency for renewables, this gives negatives
* in both efficiencies and aE.
aE(regg,ind)            = aE(regg,ind) * GCAM_ener_int_change('%scenario%',regg,ind,year) ;

* This code below should be removed, because otherwise it is not energy
* efficiency anymore, because we replace the energy with capital and labour.
*aKL(regg,ind)       =       1 - aE(regg,ind) ;
* Energy efficiency can also be programmed using eprod.


* Minimum level of consumption for household is scaled with population growth
* and includes annual 1% improvement in energy efficiency.
CONS_Hinc_T_MIN(prd,regg,inc)  = CONS_Hinc_T_MIN_year(prd,regg,inc,year) ;


* Energy mix for the production of electricity

coprodB(reg,elec_prd,reg,elec_ind)
    = sum(elec_indd,coprodB_0(reg,elec_prd,reg,elec_indd))
          * GCAM_elec_gen_share_spline('%scenario%',reg,elec_ind,year) ;


loop((reg,elec_prd),
    if(abs( sum(ind, coprodB(reg,elec_prd,reg,ind) ) - 1 ) gt 1e-8,
        abort "co-production coefficients for electricity are not equal to 1"
    ) ;
) ;



* GCAM - Electricity prices
* Shock to electricity price is included as addition tax
* txd_ind = tax / (base+tax)
* If we would have no futher policy shock, the price PY should for industries
* elec_ind give approximately GCAM_elec_price_index_spline. However, because
* we also adjust aE, producers price change, and are different from the GCAM
* price.

txd_ind(regg,regg,elec_ind) =
    ( GCAM_elec_price_index_spline('%scenario%',regg,"electricity",year)
    - 1 + txd_ind_0(regg,regg,elec_ind) ) /
    GCAM_elec_price_index_spline('%scenario%',regg,"electricity",year) ;

Display
txd_ind
GCAM_elec_price_index_spline
;
$offtext
* ========================= Policy scenario assumptions ========================

* GCAM emissions decrease with respect to the baseyear (2007).
* CO2cap_perc is a percentage difference in CO2 between 'year' and 2007.
CO2S_V.FX(regg)
    = CO2cap_perc(year) * sum(ind,
      (EMIS_model(regg,ind,"CO2_c") + EMIS_model(regg,ind,"CO2_nc") )
      /1000 ) ;

PCO2_time(regg,'2007')=0;
*if(ord(year) eq 8 ,
if(ord(year) ge 7 ,
    PCO2_V.L(regg)$(PCO2_V.L(regg) ge 8 and PCO2_time(regg,year-2))  = PCO2_V.L(regg)**2/PCO2_time(regg,year-2);
    PCO2_V.L(regg)$(PCO2_V.L(regg) le 8)  = 0.01 ;
) ;


*if(ord(year) eq 11 ,
*    PCO2_V.L('JAP')  = 0.01 ;
*) ;

* =============================== Solve statement ==============================

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
$include %project%\03_simulation_results\scr\save_simulation_results.gms
$include %project%\03_simulation_results\scr\save_simulation_results_CO2cap.gms


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


CBUD_H_part1_time(regg,year)
    =
*   (1)
    GRINC_H_time(regg,year)  ;

CBUD_H_part2_time(regg,year)
    =
*   (2)
    ( GTRF(regg) * LASPEYRES_time(regg,year) +
    sum(fd$fd_assign(fd,'Households'), sum((reg,fdd)$( not sameas(reg,regg) ),
    INCTRANSFER_time(reg,fdd,regg,fd,year) * LASPEYRES_time(reg,year) ) ) +
    sum(fd$fd_assign(fd,'Households'), TRANSFERS_ROW_time(regg,fd,year) * PROW_time ) -
    ty(regg) * GRINC_H_time(regg,year) -
    mps(regg) * ( GRINC_H_time(regg,year) * ( 1 - ty(regg) ) ) -
    sum(fd$fd_assign(fd,'Households'), sum((reg,fdd)$( not sameas(reg,regg) ),
    INCTRANSFER_time(regg,fd,reg,fdd,year) * LASPEYRES_time(regg,year) ) ) ) ;

CBUD_H_part3_time(regg,year)
    =
*   (1)
    sum(fd$fd_assign(fd,'Households'),
    sum((reg,inm), TIM_FINAL_USE(reg,inm,regg,fd) *
    LASPEYRES_time(regg,year) ) +
    sum((reg,tse), TIM_FINAL_USE(reg,tse,regg,fd) *
    LASPEYRES_time(regg,year) ) +
    sum(inm, TIM_FINAL_USE_ROW(inm,regg,fd) * PROW_time ) +
    sum(tse, TIM_FINAL_USE_ROW(tse,regg,fd) * PROW_time ) ) ;



Loop(reg,
    if( check_neg_CBUD_H(reg,year) or check_neg_CBUD_H(reg,year) or check_neg_CBUD_H(reg,year),
        display check_neg_CBUD_H, check_neg_CBUD_G, check_neg_CBUD_I, CBUD_H_time, CBUD_H_part1_time, CBUD_H_part2_time, CBUD_H_part3_time ;
        abort "negative values in CBUD" ;
    ) ;
    loop(ind, if( check_neg_Y(reg,ind,year),
        display check_neg_Y ;
        display check_neg_X ;
        abort "negative values in Y" ;
    ) ; ) ;
    loop(prd, if( check_neg_X(reg,prd,year),
        display check_neg_X ;
        abort "negative values in X" ;
    ) ; ) ;
) ;


CO2surplus(regg,year) = sum(ind, CO2_V.L(regg,ind) ) / CO2S_V.L(regg) ;
CO2_year(regg,year) = sum(ind, CO2_V.L(regg,ind) ) ;
* end loop over years
) ;

* ========================= Post-processing of results =========================


Y_change(regg,ind,year)$Y(regg,ind)
    = Y_time(regg,ind,year) / Y(regg,ind) ;
X_change(reg,prd,year)$X(reg,prd)
    = X_time(reg,prd,year) / X(reg,prd) ;

*GDP_change(regg,year)
*    = GDPCUR_time(regg,year) / GDPCUR_time(regg,year-1) ;


Yreg_change(regg,year)$
    sum(ind, Y_time(regg,ind,year) )
         = sum(ind, Y_time(regg,ind,year) ) - sum(ind, Y(regg,ind) ) ;

Yreg(regg,year)$
    sum(ind, Y_time(regg,ind,year) )
         = sum(ind, Y_time(regg,ind,year) ) ;


CBUD_H_check(regg,year)$
    CBUD_H_time(regg,year)
         = ( sum(prd, CONS_H_T_time(prd,regg,year) * PC_H_time(prd,regg,year) *
         ( 1 + tc_h_time(prd,regg,year) ) ) ) / CBUD_H_time(regg,year) ;

CBUD_G_check(regg,year)$
    CBUD_G_time(regg,year)
         = ( sum(prd, CONS_G_T_time(prd,regg,year) * PC_G_time(prd,regg,year) *
         ( 1 + tc_g_time(prd,regg,year) ) ) ) / CBUD_G_time(regg,year) ;

CBUD_I_check(regg,year)$
    CBUD_I_time(regg,year)
         = ( sum(prd, GFCF_T_time(prd,regg,year) * PC_I_time(prd,regg,year) *
         ( 1 + tc_gfcf_time(prd,regg,year) ) ) ) / CBUD_I_time(regg,year) ;

Display
CBUD_H_check
CBUD_G_check
CBUD_I_check
;


numer_check(regg,ind,year)$Y_time(regg,ind,year) =
    Y_time(regg,ind,year) * PY_time(regg,ind,year) *
    ( 1 - sum(reg, txd_ind_time(reg,regg,ind,year) ) -
    sum(reg, txd_inm(reg,regg,ind) + txd_tse(reg,regg,ind) ) ) /
    ( sum(prd, INTER_USE_T_time(prd,regg,ind,year) * PIU_time(prd,regg,ind,year) *
    ( 1 + tc_ind_time(prd,regg,ind,year) ) ) +
    sum(reg, K_time(reg,regg,ind,year) * PK_time(reg,year) ) +
    sum(reg, L_time(reg,regg,ind,year) * PL_time(reg,year) ) ) ;


Carbon_efficiency(regg,year)
    $ GDPCONST_time(regg,year)
    = CO2_year(regg,year)*PCO2_time(regg,year)
      / GDPCONST_time(regg,year) ;




Display
Y_change
X_change
;

Display
Yreg_change
Yreg
;

Display
numer_check
;

Display
Carbon_efficiency
CBUD_H_part1_time
CBUD_H_part2_time
CBUD_H_part3_time
CO2surplus
CO2cap_perc
CO2_year
CO2_time
CO2S_time
PCO2_time
CO2REV_time
Y_time
X_time
PY_time
;

$libinclude xldump PCO2_time                  CO2_results_CO2cap_perc_year.xlsx  PCO2_time!
$libinclude xldump CO2_year                   CO2_results_CO2cap_perc_year.xlsx  CO2_year!
$libinclude xldump CO2S_time                  CO2_results_CO2cap_perc_year.xlsx  CO2S_time!

* Include result processing files:
$include %project%\02_project_model_setup\scr\sub_simulation_additional_reporting_var.gms

$include %project%\02_project_model_setup\scr\sub_simulation_analysis_ABM_var.gms

*===========================Export results =====================================

$include %project%\03_simulation_results\scr\export_simulation_results.gms
