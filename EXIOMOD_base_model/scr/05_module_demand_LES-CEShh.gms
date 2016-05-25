* File:   EXIOMOD_base_model/scr/05_module_demand_LES-CEShh.gms
* Author: Tatyana Bulavskaya
* Date:   7 August 2015

* gams-master-file: phase.gms

$ontext startdoc
This is a module describing demand side equations of the base CGE model. The
code includes all the required elements (calibration, equations definition,
model statement) for the demand side. The following elements of the model are
described within the demand module:

- Demand functions of households, government and investment agent; in other
  words, how much products they want to buy, given the market prices and their
  consumption budgets. In this version, for households the first order
  conditions from 'flexible' LES-CES preferences are used, for other types of
  final consumers CES preferences are used.
- How the income of households, government and investment agent is formed.
- How the budget available for consumption of households, government and
  investment agent is formed.
- Budget constraint: consumption expenditures are equal to consumption budget.

As with all the other modules, different phases of the code are being called
from 00_base_model_prepare.gms via phase.gms.

Please see the description of the modular approach in philosophy.html and of
phase.gms for more details.
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ==================== Phase 1: Additional sets and subsets ====================
$if not '%phase%' == 'additional_sets' $goto end_additional_sets

$label end_additional_sets

* ===================== Phase 2: Declaration of parameters =====================
$if not '%phase%' == 'parameters_declaration' $goto end_parameters_declaration

Parameters
    elasFU_data(fd,*)           data on substitution elasticities (final demand)
    elasINC_data(prd,*)         data on income elasticities (household demand)
    elasFU_H(regg)              substitution elasticity between products for
                                # household final use
    elasFU_G(regg)              substitution elasticity between products for
                                # government final use
    elasFU_I(regg)              substitution elasticity between products for
                                # capital formation final use
    CONS_H_T(prd,regg)          household consumption on product level (volume)
    CONS_G_T(prd,regg)          government consumption on product level (volume)
    GFCF_T(prd,regg)            investment (gross fixed capital formation) on
                                # product level (volume)
    CBUD_H(regg)                total budget available for household consumption
                                # (value)
    CBUD_G(regg)                total budget available for government
                                # consumption (value)
    CBUD_I(regg)                total budget available for gross fixed capital
                                # formation (value)
    GRINC_H(regg)               gross income of households from production
                                # factors (value)
    GRINC_G(regg)               gross income of government from production
                                # factors and taxes on products and production
                                # (value)
    GRINC_I(regg)               gross income of investment agent from production
                                # factors (value)
    tc_h(prd,regg)              tax and subsidies on products rates for
                                # household consumption (relation in value)
    tc_g(prd,regg)              tax and subsidies on products rates for
                                # government consumption (relation in value)
    tc_gfcf(prd,regg)           tax and subsidies on products rates for
                                # gross fixed capital formation (relation in
                                # value)
    alpha_h(prd,regg)           share of household expenditure on each product
                                # in total household demand (relation in volume)
    alpha_h_les(prd,regg)       share of household expenditure on each product
                                # corrected for LES
    CONS_H_T_MIN(prd,regg)      subsistence level of household consumption for
                                # each product (volume)
    theta_h_les(prd,regg)       relative share parameter of household
                                # consumption above subsistence level on product
                                # level (relation in volume)
    theta_g(prd,regg)           relative share parameter of government
                                # consumption on product level in total
                                # government demand (relation in volume)
    theta_gfcf(prd,regg)        relative share parameter of gross fixed capital
                                # formation on product level in total investment
                                # demand (relation in volume)
    k_distr_h(reg,regg)         distribution shares of capital income to
                                # household budget (shares in value)
    k_distr_g(reg,regg)         distribution shares of capital income to
                                # government budget (shares in value)
    k_distr_gfcf(reg,regg)      distribution shares of capital income to
                                # investment agent budget (shares in value)
    l_distr_h(reg,regg)         distribution shares of labour income to
                                # household budget (shares in value)
    l_distr_g(reg,regg)         distribution shares of labour income to
                                # government budget (shares in value)
    l_distr_gfcf(reg,regg)      distribution shares of labour income to
                                # investment agent budget (shares in value)
    ty(regg)                    household income tax rate
    mps(regg)                   household marginal propensity to save
    GTRF(regg)                  government social transfers
    GSAV(regg)                  government savings

    tc_h_0(prd,regg)            calibrated tax and subsidies on products rates
                                # for household consumption (relation in value)
    tc_g_0(prd,regg)            calibrated tax and subsidies on products rates
                                # for government consumption (relation in value)
    tc_gfcf_0(prd,regg)         calibrated tax and subsidies on products rates
                                # for gross fixed capital formation (relation in
                                # value)
;

$label end_parameters_declaration

* ====================== Phase 3: Definition of parameters =====================
$if not '%phase%' == 'parameters_calibration' $goto end_parameters_calibration

* Here project-specific data are read in. Data should be placed in
* %project%/00_base_model_setup/data/.

*## Elasticities ##

$libinclude xlimport elasFU_data   %project%/00_base_model_setup/data/Eldata.xlsx elasFU_CES!a1..zz10000 ;
$libinclude xlimport elasINC_data  %project%/00_base_model_setup/data/Eldata.xlsx elasFU_LES!a1..c10000 ;


* Substitution elasticity between aggregated products in volume for final use of
* households. The elasticity value can be different in each region (regg).
elasFU_H(regg)
    = sum(fd$fd_assign(fd,'Households'), elasFU_data(fd,'elasTOT') ) ;

* Substitution elasticity between aggregated products in volume for final use of
* government. The elasticity value can be different in each region (regg).
elasFU_G(regg)
    = sum(fd$fd_assign(fd,'Government'), elasFU_data(fd,'elasTOT') ) ;

* Substitution elasticity between aggregated products in volume for final use of
* investment agent for gross fixed capital formation. The elasticity value can
* be different in each region (regg).
elasFU_I(regg)
    = sum(fd$fd_assign(fd,'GrossFixCapForm'), elasFU_data(fd,'elasTOT') ) ;


*## Data aggregates ##

* Household consumption of aggregated products in volume of each product (prd)
* in each region (regg), the corresponding basic price in the calibration year
* is equal to 1, purchaser's price can be different from 1 in case of non-zero
* taxes on products.
CONS_H_T(prd,regg)
     = sum(fd$fd_assign(fd,'Households'), FINAL_USE_D(prd,regg,fd) )
     + sum(fd$fd_assign(fd,'Households'), FINAL_USE_M(prd,regg,fd) ) ;

* Government consumption of aggregated products in volume of each product (prd)
* in each region (regg), the corresponding basic price in the calibration year
* is equal to 1, purchaser's price can be different from 1 in case of non-zero
* taxes on products.
CONS_G_T(prd,regg)
     = sum(fd$fd_assign(fd,'Government'), FINAL_USE_D(prd,regg,fd) )
     + sum(fd$fd_assign(fd,'Government'), FINAL_USE_M(prd,regg,fd) ) ;

* Investment (gross fixed capital formation) on aggregated product level in
* volume of each product (prd) in each region (regg), the corresponding basic
* price in the calibration year is equal to 1, purchaser's price can be
* different from 1 in case of non-zero taxes on products.
GFCF_T(prd,regg)
     = sum(fd$fd_assign(fd,'GrossFixCapForm'), FINAL_USE_D(prd,regg,fd) )
     + sum(fd$fd_assign(fd,'GrossFixCapForm'), FINAL_USE_M(prd,regg,fd) ) ;

Display
CONS_H_T
CONS_G_T
GFCF_T
;


* Total budget in value available for household consumption in each region
* (regg).
CBUD_H(regg)
    = sum(prd, sum(fd$fd_assign(fd,'Households'), FINAL_USE_D(prd,regg,fd) ) ) +
    sum(prd, sum(fd$fd_assign(fd,'Households'), FINAL_USE_M(prd,regg,fd) ) ) +
    sum(fd$fd_assign(fd,'Households'), sum(prd, FINAL_USE_dt(prd,regg,fd) ) ) ;


* Total budget in value available for government consumption in each region
* (regg).
CBUD_G(regg)
    = sum(prd, sum(fd$fd_assign(fd,'Government'), FINAL_USE_D(prd,regg,fd) ) ) +
    sum(prd, sum(fd$fd_assign(fd,'Government'), FINAL_USE_M(prd,regg,fd) ) ) +
    sum(fd$fd_assign(fd,'Government'), sum(prd, FINAL_USE_dt(prd,regg,fd) ) ) ;

* Total budget in value available for investment agent for gross fixed capital
* formation in each region (regg).
CBUD_I(regg)
    = sum(prd, sum(fd$fd_assign(fd,'GrossFixCapForm'),
    FINAL_USE_D(prd,regg,fd) ) ) +
    sum(prd, sum(fd$fd_assign(fd,'GrossFixCapForm'),
    FINAL_USE_M(prd,regg,fd) ) ) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum(prd, FINAL_USE_dt(prd,regg,fd) ) ) ;

Display
CBUD_H
CBUD_G
CBUD_I
;


* Gross income of households from production factors in each region (regg). The
* gross income value includes only income received from production factors, but
* excludes transfers from other final users in the same region and transfers
* from abroad. The gross income value is used to calculated income tax rate.
GRINC_H(regg)
    = sum((reg,va)$(k(va) or l(va)), sum(fd$fd_assign(fd,'Households'),
    VALUE_ADDED_DISTR(reg,va,regg,fd) ) ) ;

* Gross income of government in each region (regg) from production factors,
* collected taxes on production, international margins and taxes on exports, as
* well as domestically collected taxes on products. The gross income value
* excludes household income taxes and transfers from abroad.
GRINC_G(regg)
    = sum((reg,va)$(k(va) or l(va)), sum(fd$fd_assign(fd,'Government'),
    VALUE_ADDED_DISTR(reg,va,regg,fd) ) ) +
    sum((reg,ntp), sum(fd$fd_assign(fd,'Government'),
    VALUE_ADDED_DISTR(reg,ntp,regg,fd) ) ) +
    sum((reg,inm), sum(fd$fd_assign(fd,'Government'),
    VALUE_ADDED_DISTR(reg,inm,regg,fd) ) ) +
    sum((reg,tse), sum(fd$fd_assign(fd,'Government'),
    VALUE_ADDED_DISTR(reg,tse,regg,fd) ) ) +
    sum((reg,tsp), sum(fd$fd_assign(fd,'Government'),
    TAX_SUB_PRD_DISTR(reg,tsp,regg,fd) ) ) ;

* Gross income of investment agent in each region (regg). The gross income value
* includes only income received from production factors, but excludes transfers
* from other final user in the same region and transfers from abroad.
GRINC_I(regg)
    = sum((reg,va)$(k(va) or l(va)), sum(fd$fd_assign(fd,'GrossFixCapForm'),
    VALUE_ADDED_DISTR(reg,va,regg,fd) ) ) ;

Display
GRINC_H
GRINC_G
GRINC_I
;


* *## Tax rates ##

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of household consumption, tax rate differs by product (prd)
* in each region (regg).
tc_h(prd,regg)$sum(fd$fd_assign(fd,'Households'), FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'Households'), FINAL_USE_dt(prd,regg,fd) ) /
    CONS_H_T(prd,regg) ;

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of government consumption, tax rate differs by product (prd)
* in each region (regg).
tc_g(prd,regg)$sum(fd$fd_assign(fd,'Government'), FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'Government'), FINAL_USE_dt(prd,regg,fd) ) /
    CONS_G_T(prd,regg) ;

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of gross fixed capital formation, tax rate differs by
* product (prd) in each region (regg).
tc_gfcf(prd,regg)$sum(fd$fd_assign(fd,'GrossFixCapForm'),
    FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'GrossFixCapForm'), FINAL_USE_dt(prd,regg,fd) ) /
    GFCF_T(prd,regg) ;

Display
tc_h
tc_g
tc_gfcf
;


*## Parameters of final demand functions ##

* Calibration of household demand function is based on the formulas provided in
* "Worldscan: a model for international economic policy analysis", CPB Document
* 111, pp. 67-68.

* Auxiliary parameter: share of household expenditure on each product in total
* household demand.
alpha_h(prd,regg)
    = CONS_H_T(prd,regg) * ( 1 + tc_h(prd,regg) ) /
    sum(prdd, CONS_H_T(prdd,regg) * ( 1 + tc_h(prdd,regg) ) ) ;

* Auxiliary parameter: share of household expenditure corrected with income
* elasticity
alpha_h_les(prd,regg)
    = alpha_h(prd,regg) * elasINC_data(prd,"elasINC") ;

* Rescale auxiliry parameter to sum up to 1.
alpha_h_les(prd,regg)
    = alpha_h_les(prd,regg) / sum(prdd, alpha_h_les(prdd,regg) ) ;

* Parameter for subsistence level of household consumption of aggregated
* products for each product (prd) in each region (regg). Here frisch parameter
* is specified with product dimension, but the value should be the same for all
* products.
CONS_H_T_MIN(prd,regg) = ( alpha_h(prd,regg) + alpha_h_les(prd,regg) /
    elasINC_data(prd,"frisch") ) *
    sum(prdd, CONS_H_T(prdd,regg) * ( 1 + tc_h(prdd,regg) ) ) /
    ( 1 + tc_h(prd,regg) ) ;

* Relative share parameter for household consumption of aggregated products
* above subsistence level for each product (prd) in each region (regg).
theta_h_les(prd,regg)$CONS_H_T(prd,regg)
    = ( CONS_H_T(prd,regg) - CONS_H_T_MIN(prd,regg) ) /
    sum(prdd, CONS_H_T(prdd,regg) - CONS_H_T_MIN(prdd,regg) ) *
    ( 1 / ( 1 + tc_h(prd,regg) ) )**( -elasFU_H(regg) ) ;

Display
alpha_h
alpha_h_les
CONS_H_T_MIN
theta_h_les
;

loop((prd,regg),
    ABORT$( CONS_H_T_MIN(prd,regg) lt 0 )
        "Subsistence level of consumption is negative. Check income elasticities" ;
) ;

loop((prd,regg),
    ABORT$( CONS_H_T_MIN(prd,regg) gt CONS_H_T(prd,regg) )
        "Subsistence level of consumption is more than 100%. Check income elasticities" ;
) ;

* Relative share parameter for government consumption of aggregated products
* for each product (prd) in each region (regg).
theta_g(prd,regg)$CONS_G_T(prd,regg)
    = CONS_G_T(prd,regg) / sum(prdd, CONS_G_T(prdd,regg) ) *
    ( 1 / ( 1 + tc_g(prd,regg) ) )**( -elasFU_G(regg) ) ;

* Relative share parameter for gross fixed capital formation of aggregated
* products for each product (prd) in each region (regg).
theta_gfcf(prd,regg)$GFCF_T(prd,regg)
    = GFCF_T(prd,regg) / sum(prdd, GFCF_T(prdd,regg) ) *
    ( 1 / ( 1 + tc_gfcf(prd,regg) ) )**( -elasFU_I(regg) ) ;

Display
theta_g
theta_gfcf
;


*## Distribution of value added revenues to final consumers ##

* Distribution shares of capital revenues to household budget for each factor
* type (reg) in each region (regg).
k_distr_h(reg,regg)$sum((k,fd)$fd_assign(fd,'Households'),
    VALUE_ADDED_DISTR(reg,k,regg,fd) )
    = sum((k,fd)$fd_assign(fd,'Households'), VALUE_ADDED_DISTR(reg,k,regg,fd) ) /
    sum((k,reggg,fdd), VALUE_ADDED_DISTR(reg,k,reggg,fdd) ) ;

* Distribution shares of capital revenues to government budget for each factor
* type (reg) in each region (regg).
k_distr_g(reg,regg)$sum((k,fd)$fd_assign(fd,'Government'),
    VALUE_ADDED_DISTR(reg,k,regg,fd) )
    = sum((k,fd)$fd_assign(fd,'Government'), VALUE_ADDED_DISTR(reg,k,regg,fd) ) /
    sum((k,reggg,fdd), VALUE_ADDED_DISTR(reg,k,reggg,fdd) ) ;

* Distribution shares of capital revenues to investment agent budget for each
* factor type (reg) in each region (regg).
k_distr_gfcf(reg,regg)$sum((k,fd)$fd_assign(fd,'GrossFixCapForm'),
    VALUE_ADDED_DISTR(reg,k,regg,fd) )
    = sum((k,fd)$fd_assign(fd,'GrossFixCapForm'),
    VALUE_ADDED_DISTR(reg,k,regg,fd) ) /
    sum((k,reggg,fdd), VALUE_ADDED_DISTR(reg,k,reggg,fdd) ) ;


* Distribution shares of labour revenues to household budget for each factor
* type (reg) in each region (regg).
l_distr_h(reg,regg)$sum((l,fd)$fd_assign(fd,'Households'),
    VALUE_ADDED_DISTR(reg,l,regg,fd) )
    = sum((l,fd)$fd_assign(fd,'Households'), VALUE_ADDED_DISTR(reg,l,regg,fd) ) /
    sum((l,reggg,fdd), VALUE_ADDED_DISTR(reg,l,reggg,fdd) ) ;

* Distribution shares of labour revenues to government budget for each factor
* type (reg) in each region (regg).
l_distr_g(reg,regg)$sum((l,fd)$fd_assign(fd,'Government'),
    VALUE_ADDED_DISTR(reg,l,regg,fd) )
    = sum((l,fd)$fd_assign(fd,'Government'), VALUE_ADDED_DISTR(reg,l,regg,fd) ) /
    sum((l,reggg,fdd), VALUE_ADDED_DISTR(reg,l,reggg,fdd) ) ;

* Distribution shares of labour revenues to investment agent budget for each
* factor type (reg) in each region (regg).
l_distr_gfcf(reg,regg)$sum((l,fd)$fd_assign(fd,'GrossFixCapForm'),
    VALUE_ADDED_DISTR(reg,l,regg,fd) )
    = sum((l,fd)$fd_assign(fd,'GrossFixCapForm'),
    VALUE_ADDED_DISTR(reg,l,regg,fd) ) /
    sum((l,reggg,fdd), VALUE_ADDED_DISTR(reg,l,reggg,fdd) ) ;

Display
k_distr_h
k_distr_g
k_distr_gfcf
l_distr_h
l_distr_g
l_distr_gfcf
;


*## Income transfers between final consumers ##

* Income tax rate, income tax is a transfer from households to the government
* in the same region (regg). Income tax rate is calculated as percentage of
* household gross income from factors of production.
ty(regg)
    = sum(fd$fd_assign(fd,'Households'),
    sum(fdd$fd_assign(fdd,'Government'), INCOME_DISTR(regg,fd,regg,fdd) ) ) /
    GRINC_H(regg) ;

* Household marginal propensity to save, households saving is a transfer from
* households to the investment agent in the same region (regg). Marginal
* propensity to save is calculated as percentage of household net income (gross
* income minus income tax).
mps(regg)
    = sum(fd$fd_assign(fd,'Households'),
    sum(fdd$fd_assign(fdd,'GrossFixCapForm'),
    INCOME_DISTR(regg,fd,regg,fdd) ) ) /
    ( GRINC_H(regg) * ( 1 - ty(regg) ) ) ;

* Social transfers from government to households in the same region (regg). This
* value will be taken as exogenous in the model.
GTRF(regg)
    = sum(fd$fd_assign(fd,'Government'),
    sum(fdd$fd_assign(fdd,'Households'),
    INCOME_DISTR(regg,fd,regg,fdd) ) ) ;

* Government savings, which is a transfer from from government to the investment
* agent in the same region (regg). This value will be taken as exogenous in the
* model.
GSAV(regg)
    = sum(fd$fd_assign(fd,'Government'),
    sum(fdd$fd_assign(fdd,'GrossFixCapForm'),
    INCOME_DISTR(regg,fd,regg,fdd) ) ) ;

Display
ty
mps
GTRF
GSAV
;


*## Store calibrated values in separated parameters ##

* Save calibrated values of tax rates separately. Change in a tax rate can be a
* part of a simulation set-up and the initial calibrated tax rates are then
* needed for correct calculation of price indexes.
tc_h_0(prd,regg)       = tc_h(prd,regg) ;
tc_g_0(prd,regg)       = tc_g(prd,regg) ;
tc_gfcf_0(prd,regg)    = tc_gfcf(prd,regg) ;

$label end_parameters_calibration

* =============== Phase 4: Declaration of variables and equations ==============
$if not '%phase%' == 'variables_equations_declaration' $goto end_variables_equations_declaration

* ========================== Declaration of variables ==========================

* Endogenous variables
Variables
    CONS_H_T_V(prd,regg)            household consumption on aggregated product
                                    # level
    CONS_G_T_V(prd,regg)            government consumption on aggregated product
                                    # level
    GFCF_T_V(prd,regg)              gross fixed capital formation on aggregated
                                    # product level

    CAPREV_V(reg)                   revenue from capital
    LABREV_V(reg)                   revenue from labour
    TSPREV_V(reg)                   revenue from net tax on products
    NTPREV_V(reg)                   revenue from net tax on production
    INMREV_V(reg)                   revenue from international margins
    TSEREV_V(reg)                   revenue from tax on export

    GRINC_H_V(regg)                 gross income of households
    GRINC_G_V(regg)                 gross income of government
    GRINC_I_V(regg)                 gross income of investment agent
    CBUD_H_V(regg)                  budget available for household consumption
    CBUD_G_V(regg)                  budget available for government consumption
    CBUD_I_V(regg)                  budget available for gross fixed capital
                                    # formation

    SCLFD_H_V(regg)                 scale parameter for household consumption
    SCLFD_G_V(regg)                 scale parameter for government consumption
    SCLFD_I_V(regg)                 scale parameter for gross fixed capital
                                    # formation
;

* Exogenous variables
Variables
    INCTRANSFER_V(reg,fd,regg,fdd)  income transfers
    TRANSFERS_ROW_V(reg,fd)         income trasnfers from rest of the world
                                    # regions
;

* ========================== Declaration of equations ==========================

Equations
    EQCONS_H_T(prd,regg)        demand of households for products on aggregated
                                # product level
    EQCONS_G_T(prd,regg)        demand of government for products on aggregated
                                # product level
    EQGFCF_T(prd,regg)          demand of investment agent for products on
                                # aggregated product level

    EQCAPREV(reg)               revenue from capital
    EQLABREV(reg)               revenue from labour
    EQTSPREV(reg)               revenue from net tax on products
    EQNTPREV(reg)               revenue from net tax on production
    EQINMREV(reg)               revenue from international margins
    EQTSEREV(reg)               revenue from tax on export

    EQGRINC_H(regg)             gross income of households
    EQGRINC_G(regg)             gross income of government
    EQGRINC_I(regg)             gross income of investment agent
    EQCBUD_H(regg)              budget available for household consumption
    EQCBUD_G(regg)              budget available for government consumption
    EQCBUD_I(regg)              budget available for gross fixed capital
                                # formation

    EQSCLFD_H(regg)             budget constraint of households
    EQSCLFD_G(regg)             budget constraint of government
    EQSCLFD_I(regg)             budget constraint of investment agent
;

$label end_variables_equations_declaration

* ====================== Phase 5: Definition of equations ======================
$if not '%phase%' == 'equations_definition' $goto end_equations_definition

* EQUATION 1.1: Household demand for aggregated products. The demand function
* follows LES-CES form, where demand by households in each region (regg) for
* each aggregated product (prd) consists of subsistence and variable parts.
* The volume of subsistence part is given exogenously and the volume of variable
* part depends with certain elasticity on relative prices of different
* aggregated products. The final demand function is derived from utility
* optimization, but there is no market for utility and corresponding price
* doesn't exist, contrary to CES demand functions derived from optimization of a
* production function. Scaling parameter (SCLDF_H_V) is introduced in order to
* ensure budget constraint (see EQUATION 1.16).
EQCONS_H_T(prd,regg)..
    CONS_H_T_V(prd,regg)
    =E=
    CONS_H_T_MIN(prd,regg) +
    SCLFD_H_V(regg) * theta_h_les(prd,regg) *
    ( PC_H_V(prd,regg) * ( 1 + tc_h(prd,regg) ) )**( -elasFU_H(regg) ) ;

* EQUATION 1.2: Government demand for aggregated products. The demand function
* follows CES form, where demand by government in each region (regg) for each
* aggregated product (prd) depends, with certain elasticity, on relative prices
* of different aggregated products. Scaling parameter (SCLDF_G_V) is
* introduced in order to ensure budget constraint (see EQUATION 1.17).
EQCONS_G_T(prd,regg)..
    CONS_G_T_V(prd,regg)
    =E=
    SCLFD_G_V(regg) * theta_g(prd,regg) *
    ( PC_G_V(prd,regg) * ( 1 + tc_g(prd,regg) ) )**( -elasFU_G(regg) ) ;

* EQUATION 1.3: Investment agent demand for aggregated products. The demand
* function follows CES form, where demand by investment agent in each region
* (regg) for each aggregated product (prd) depends, with certain elasticity, on
* relative prices of different aggregated products. Scaling parameter
* (SCLDF_I_V) is introduced in order to ensure budget constraint (see EQUATION
* 1.18).
EQGFCF_T(prd,regg)..
    GFCF_T_V(prd,regg)
    =E=
    SCLFD_I_V(regg) * theta_gfcf(prd,regg) *
    ( PC_I_V(prd,regg) * ( 1 + tc_gfcf(prd,regg) ) )**( -elasFU_I(regg) ) ;

* EQUATION 1.4: Revenue from production factor capital. The revenue of capital
* (reg) is a sum of revenues earned by the corresponding factor in each
* industry (ind) in each region (regg).
EQCAPREV(reg)..
    CAPREV_V(reg)
    =E=
    sum((regg,ind), K_V(reg,regg,ind) * PK_V(reg) ) ;

* EQUATION 1.5: Revenue from production factor labour. The revenue of labour
* (reg) is a sum of revenues earned by the corresponding factor in each
* industry (ind) in each region (regg).
EQLABREV(reg)..
    LABREV_V(reg)
    =E=
    sum((regg,ind), L_V(reg,regg,ind) * PL_V(reg) ) ;

* EQUATION 1.6: Revenue from net taxes on products. The revenue in each region
* (reg) is a sum of revenues earned from sales of products to industries (ind)
* for intermediate use, households, government, investment agent in the same
* region.
EQTSPREV(reg)..
    TSPREV_V(reg)
    =E=
    sum((prd,ind), INTER_USE_T_V(prd,reg,ind) * PIU_V(prd,reg,ind) *
    tc_ind(prd,reg,ind) ) +
    sum(prd, CONS_H_T_V(prd,reg) * PC_H_V(prd,reg) * tc_h(prd,reg) ) +
    sum(prd, CONS_G_T_V(prd,reg) * PC_G_V(prd,reg) * tc_g(prd,reg) ) +
    sum(prd, GFCF_T_V(prd,reg) * PC_I_V(prd,reg) * tc_gfcf(prd,reg) ) +
    sum((regg,prd), SV_V(regg,prd,reg) * P_V(regg,prd) * tc_sv(prd,reg) ) +
    sum(prd, SV_ROW_V(prd,reg) * PROW_V * tc_sv(prd,reg) ) ;

* EQUATION 1.7: Revenue from net taxes on production. The revenue in each region
* (reg) is a sum of revenues earned from production activities of each industry
* (ind,regg).
EQNTPREV(reg)..
    NTPREV_V(reg)
    =E=
    sum((regg,ind), Y_V(regg,ind) * PY_V(regg,ind) *
    txd_ind(reg,regg,ind) ) ;

* EQUATION 1.8: Revenue from international margins. The revenue in each region
* (reg) is a sum of revenues earned from production activities of each industry
* (ind,regg) and from final consumers in each modeled region (regg) and rest of
* the world region. The revenues from final consumers and rest of the world are
* not explicitly modeled and taken as exogenous values from the calibration
* year. The exogenous values are are multiplied by a price index in order to
* preserve model homogeneity in prices of degree zero.
EQINMREV(reg)..
    INMREV_V(reg)
    =E=
    sum((regg,ind), Y_V(regg,ind) * PY_V(regg,ind) *
    txd_inm(reg,regg,ind) ) +
    sum((inm,regg,fd), TIM_FINAL_USE(reg,inm,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum(inm, TIM_EXPORT_ROW(reg,inm) * PROW_V ) ;

* EQUATION 1.9: Revenue from tax on export. The revenue in each region (reg) is
* a sum of revenues earned from production activities of each industry
* (ind,regg) and from final consumers in each modeled region (regg) and rest of
* the world region. The revenues from final consumers and rest of the world are
* not explicitly modeled and taken as exogenous values from the calibration
* year. The exogenous values are are multiplied by a price index in order to
* preserve model homogeneity in prices of degree zero.
EQTSEREV(reg)..
    TSEREV_V(reg)
    =E=
    sum((regg,ind), Y_V(regg,ind) * PY_V(regg,ind) *
    txd_tse(reg,regg,ind) ) +
    sum((tse,regg,fd), TIM_FINAL_USE(reg,tse,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum((tse), TIM_EXPORT_ROW(reg,tse) * PROW_V ) ;


* EQUATION 1.10: Gross income of households from factors of production. Gross
* income is composed of shares of factor revenues attributable to households
* in each region (regg).
EQGRINC_H(regg)..
    GRINC_H_V(regg)
    =E=
    sum(reg, CAPREV_V(reg) * k_distr_h(reg,regg) ) +
    sum(reg, LABREV_V(reg) * l_distr_h(reg,regg) ) ;

* EQUATION 1.11: Gross income of government. Gross income is composed of
* shares of factor revenues attributable to government in each region (regg),
* tax revenues from production, international trade and from sale of products
* (domestically and exported). Tax revenues from household income are not
* included.
EQGRINC_G(regg)..
    GRINC_G_V(regg)
    =E=
    sum(reg, CAPREV_V(reg) * k_distr_g(reg,regg) ) +
    sum(reg, LABREV_V(reg) * l_distr_g(reg,regg) ) +
    TSPREV_V(regg) + NTPREV_V(regg) + INMREV_V(regg) + TSEREV_V(regg) ;

* EQUATION 1.12: Gross income of investment agent. Gross income is composed of
* shares of factor revenues attributable to investment agent in each region
* (regg).
EQGRINC_I(regg)..
    GRINC_I_V(regg)
    =E=
    sum(reg, CAPREV_V(reg) * k_distr_gfcf(reg,regg) ) +
    sum(reg, LABREV_V(reg) * l_distr_gfcf(reg,regg) ) ;

* EQUATION 1.13: Budget available for household consumption. Budget is composed
* of (1) gross income of households in each region (regg) plus (2) net income
* transfers from other final users and less (3) international margin and tax on
* export paid by household. At the moment income transfers is one of the
* exogenous variables of the model, therefore it is multiplied by a price index
* in order to preserve model homogeneity in prices of degree zero. The
* endogenous income transfers are income tax to the government in the same
* region and savings to the investment agent in the same region.
EQCBUD_H(regg)..
    CBUD_H_V(regg)
    =E=
*   (1)
    GRINC_H_V(regg) +
*   (2)
    ( GTRF(regg) * LASPEYRES_V(regg) +
    sum(fd$fd_assign(fd,'Households'), sum((reg,fdd)$( not sameas(reg,regg) ),
    INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) ) +
    sum(fd$fd_assign(fd,'Households'), TRANSFERS_ROW_V(regg,fd) * PROW_V ) -
    ty(regg) * GRINC_H_V(regg) -
    mps(regg) * ( GRINC_H_V(regg) * ( 1 - ty(regg) ) ) -
    sum(fd$fd_assign(fd,'Households'), sum((reg,fdd)$( not sameas(reg,regg) ),
    INCTRANSFER_V(regg,fd,reg,fdd) * LASPEYRES_V(regg) ) ) ) -
*   (3)
    sum(fd$fd_assign(fd,'Households'),
    sum((reg,inm), TIM_FINAL_USE(reg,inm,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum((reg,tse), TIM_FINAL_USE(reg,tse,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum(inm, TIM_FINAL_USE_ROW(inm,regg,fd) * PROW_V ) +
    sum(tse, TIM_FINAL_USE_ROW(tse,regg,fd) * PROW_V ) ) ;

* EQUATION 1.14: Budget available for government consumption. Budget is composed
* of (1) gross income of government in each region (regg) plus (2) household
* income tax revenue plus (3) net income transfers from other final users and
* less (4) international margin and tax on export paid by government. At the
* moment income transfers is one of the exogenous variables of the model,
* therefore it is multiplied by a price index in order to preserve model
* homogeneity in prices of degree zero.
EQCBUD_G(regg)..
    CBUD_G_V(regg)
    =E=
*   (1)
    GRINC_G_V(regg) +
*   (2)
    ty(regg) * GRINC_H_V(regg) +
*   (3)
    ( sum(fd$fd_assign(fd,'Government'), sum((reg,fdd)$( not sameas(reg,regg) ),
    INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) ) +
    sum(fd$fd_assign(fd,'Government'), TRANSFERS_ROW_V(regg,fd) * PROW_V ) -
    GTRF(regg) * LASPEYRES_V(regg) -
    GSAV(regg) * LASPEYRES_V(regg) -
    sum(fd$fd_assign(fd,'Government'), sum((reg,fdd)$( not sameas(reg,regg) ),
    INCTRANSFER_V(regg,fd,reg,fdd) * LASPEYRES_V(regg) ) ) ) -
*   (4)
    sum(fd$fd_assign(fd,'Government'),
    sum((reg,inm), TIM_FINAL_USE(reg,inm,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum((reg,tse), TIM_FINAL_USE(reg,tse,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum(inm, TIM_FINAL_USE_ROW(inm,regg,fd) * PROW_V ) +
    sum(tse, TIM_FINAL_USE_ROW(tse,regg,fd) * PROW_V ) ) ;

* EQUATION 1.15: Budget available for gross fixed capital formation. Budget is
* composed of (1) gross income of investment agent in each region (regg) plus
* (2) net income transfers from other final users less (3) expenditures on stock
* changes, and less (4) international margin and tax on export on gross fixed
* capital formation and on (5) stock change. At the moment income transfers is
* one of the exogenous variables of the model, therefore it is multiplied by a
* price index in order to preserve model homogeneity in prices of degree zero.
* The endogenous income transfer is household savings in the same region.
EQCBUD_I(regg)..
    CBUD_I_V(regg)
    =E=
*   (1)
    GRINC_I_V(regg) +
*   (2)
    ( mps(regg) * ( GRINC_H_V(regg) * ( 1 - ty(regg) ) ) +
    GSAV(regg) * LASPEYRES_V(regg) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum((reg,fdd)$( not sameas(reg,regg) ),
    INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) ) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    TRANSFERS_ROW_V(regg,fd) * PROW_V ) -
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum((reg,fdd)$( not sameas(reg,regg) ),
    INCTRANSFER_V(regg,fd,reg,fdd) * LASPEYRES_V(regg) ) ) ) -
*   (3)
    sum((reg,prd), SV_V(reg,prd,regg) * P_V(reg,prd) *
    ( 1 + tc_sv(prd,regg) ) ) -
    sum(prd, SV_ROW_V(prd,regg) * PROW_V * ( 1 + tc_sv(prd,regg) ) ) -
*   (4)
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum((reg,inm), TIM_FINAL_USE(reg,inm,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum((reg,tse), TIM_FINAL_USE(reg,tse,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum(inm, TIM_FINAL_USE_ROW(inm,regg,fd) * PROW_V ) +
    sum(tse, TIM_FINAL_USE_ROW(tse,regg,fd) * PROW_V ) ) -
*   (5)
    sum(fd$fd_assign(fd,'StockChange'),
    sum((reg,inm), TIM_FINAL_USE(reg,inm,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum((reg,tse), TIM_FINAL_USE(reg,tse,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum(inm, TIM_FINAL_USE_ROW(inm,regg,fd) * PROW_V ) +
    sum(tse, TIM_FINAL_USE_ROW(tse,regg,fd) * PROW_V ) ) ;


* EQUATION 1.16: Budget constraint of households. The equation ensures that the
* total budget available for household consumption is spent on purchase of
* products. The equation defines scaling parameter of households, see also
* explanation for EQUATION 1.1.
EQSCLFD_H(regg)..
    CBUD_H_V(regg)
    =E=
    sum(prd, CONS_H_T_V(prd,regg) * PC_H_V(prd,regg) *
    ( 1 + tc_h(prd,regg) ) ) ;

* EQUATION 1.17: Budget constraint of government. The equation ensures that the
* total budget available for government consumption is spent on purchase of
* products. The equation defines scaling parameter of government.
EQSCLFD_G(regg)..
    CBUD_G_V(regg)
    =E=
    sum(prd, CONS_G_T_V(prd,regg) * PC_G_V(prd,regg) *
    ( 1 + tc_g(prd,regg) ) ) ;

* EQUATION 1.18: Budget constraint of investment agent. The equation ensures
* that the total budget available for gross fixed capital formation is spent on
* purchase of products. The equation defines scaling parameter of investment
* agent.
EQSCLFD_I(regg)..
    CBUD_I_V(regg)
    =E=
    sum(prd, GFCF_T_V(prd,regg) * PC_I_V(prd,regg) *
    ( 1 + tc_gfcf(prd,regg) ) ) ;

$label end_equations_definition

* ===== Phase 6: Define levels, bounds and fixed variables, scale equations ====
$if not '%phase%' == 'bounds_and_scales' $goto end_bounds_and_scales

* ==================== Define level and bounds of variables ====================

* Endogenous variables
* Variables in real terms: level is set to the calibrated value of the
* corresponding parameter. If the the calibrated value is equal to zero, the
* variable value is also fixed to zero. The equation setup will lead to zero
* solution for this variable and fixing it at this point helps the solver.
CONS_H_T_V.L(prd,regg) = CONS_H_T(prd,regg) ;
CONS_G_T_V.L(prd,regg) = CONS_G_T(prd,regg) ;
GFCF_T_V.L(prd,regg)   = GFCF_T(prd,regg) ;

CONS_H_T_V.FX(prd,regg)$(CONS_H_T(prd,regg) eq 0) = 0 ;
CONS_G_T_V.FX(prd,regg)$(CONS_G_T(prd,regg) eq 0) = 0 ;
GFCF_T_V.FX(prd,regg)$(GFCF_T(prd,regg) eq 0)     = 0 ;

CAPREV_V.L(reg)    = sum((k,regg,fd), VALUE_ADDED_DISTR(reg,k,regg,fd) ) ;
LABREV_V.L(reg)    = sum((l,regg,fd), VALUE_ADDED_DISTR(reg,l,regg,fd) ) ;
TSPREV_V.L(reg)    = sum((tsp,regg,fd), TAX_SUB_PRD_DISTR(reg,tsp,regg,fd) ) ;
NTPREV_V.L(reg)    = sum((ntp,regg,fd), VALUE_ADDED_DISTR(reg,ntp,regg,fd) ) ;
INMREV_V.L(reg)    = sum((inm,regg,fd), VALUE_ADDED_DISTR(reg,inm,regg,fd) ) ;
TSEREV_V.L(reg)    = sum((tse,regg,fd), VALUE_ADDED_DISTR(reg,tse,regg,fd) ) ;

CAPREV_V.FX(reg)$(sum((k,regg,fd), VALUE_ADDED_DISTR(reg,k,regg,fd) ) eq 0)    = 0 ;
LABREV_V.FX(reg)$(sum((l,regg,fd), VALUE_ADDED_DISTR(reg,l,regg,fd) ) eq 0)    = 0 ;
TSPREV_V.FX(reg)$(sum((tsp,regg,fd), TAX_SUB_PRD_DISTR(reg,tsp,regg,fd) )  eq 0) = 0 ;
NTPREV_V.FX(reg)$(sum((ntp,regg,fd), VALUE_ADDED_DISTR(reg,ntp,regg,fd) )  eq 0) = 0 ;
INMREV_V.FX(reg)$(sum((inm,regg,fd), VALUE_ADDED_DISTR(reg,inm,regg,fd) )  eq 0) = 0 ;
TSEREV_V.FX(reg)$(sum((tse,regg,fd), VALUE_ADDED_DISTR(reg,tse,regg,fd) )  eq 0) = 0 ;

GRINC_H_V.L(regg) = GRINC_H(regg) ;
GRINC_G_V.L(regg) = GRINC_G(regg) ;
GRINC_I_V.L(regg) = GRINC_I(regg) ;
CBUD_H_V.L(regg)  = CBUD_H(regg) ;
CBUD_G_V.L(regg)  = CBUD_G(regg) ;
CBUD_I_V.L(regg)  = CBUD_I(regg) ;

GRINC_H_V.FX(regg)$(GRINC_H(regg) eq 0) = 0 ;
GRINC_G_V.FX(regg)$(GRINC_G(regg) eq 0) = 0 ;
GRINC_I_V.FX(regg)$(GRINC_I(regg) eq 0) = 0 ;
CBUD_H_V.L(regg)$(CBUD_H(regg) eq 0)    = 0 ;
CBUD_G_V.L(regg)$(CBUD_G(regg) eq 0)    = 0 ;
CBUD_I_V.L(regg)$(CBUD_I(regg) eq 0)    = 0 ;

SCLFD_H_V.L(regg) = sum(prd, CONS_H_T(prd,regg) - CONS_H_T_MIN(prd,regg) ) ;
SCLFD_G_V.L(regg) = sum(prd, CONS_G_T(prd,regg) ) ;
SCLFD_I_V.L(regg) = sum(prd, GFCF_T(prd,regg) ) ;

SCLFD_H_V.FX(regg)$(SCLFD_H_V.L(regg) eq 0) = 0 ;
SCLFD_G_V.FX(regg)$(SCLFD_G_V.L(regg) eq 0) = 0 ;
SCLFD_I_V.FX(regg)$(SCLFD_I_V.L(regg) eq 0) = 0 ;

* Exogenous variables
* Exogenous variables are fixed to their calibrated value.
INCTRANSFER_V.FX(reg,fd,regg,fdd) = INCOME_DISTR(reg,fd,regg,fdd) ;
TRANSFERS_ROW_V.FX(reg,fd)        = TRANSFERS_ROW(reg,fd) ;

* ======================= Scale variables and equations ========================

* Scaling of variables and equations is done in order to help the solver to
* find the solution quicker. The scaling should ensure that the partial
* derivative of each variable evaluated at their current level values is within
* the range between 0.1 and 100. The values of partial derivatives can be seen
* in the equation listing. In general, the rule is that the variable and the
* equation linked to this variables in MCP formulation should both be scaled by
* the initial level of the variable.

* EQUATION 1.1
EQCONS_H_T.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) gt 0)
    = CONS_H_T_V.L(prd,regg) ;
CONS_H_T_V.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) gt 0)
    = CONS_H_T_V.L(prd,regg) ;

EQCONS_H_T.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) lt 0)
    = -CONS_H_T_V.L(prd,regg) ;
CONS_H_T_V.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) lt 0)
    = -CONS_H_T_V.L(prd,regg) ;

* EQUATION 1.2
EQCONS_G_T.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) gt 0)
    = CONS_G_T_V.L(prd,regg) ;
CONS_G_T_V.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) gt 0)
    = CONS_G_T_V.L(prd,regg) ;

EQCONS_G_T.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) lt 0)
    = -CONS_G_T_V.L(prd,regg) ;
CONS_G_T_V.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) lt 0)
    = -CONS_G_T_V.L(prd,regg) ;

* EQUATION 1.3
EQGFCF_T.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) gt 0)
    = GFCF_T_V.L(prd,regg) ;
GFCF_T_V.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) gt 0)
    = GFCF_T_V.L(prd,regg) ;

EQGFCF_T.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) lt 0)
    = -GFCF_T_V.L(prd,regg) ;
GFCF_T_V.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) lt 0)
    = -GFCF_T_V.L(prd,regg) ;

* EQUATION 1.4
EQCAPREV.SCALE(reg)$(CAPREV_V.L(reg) gt 0)
    = CAPREV_V.L(reg) ;
CAPREV_V.SCALE(reg)$(CAPREV_V.L(reg) gt 0)
    = CAPREV_V.L(reg) ;

EQCAPREV.SCALE(reg)$(CAPREV_V.L(reg) lt 0)
    = -CAPREV_V.L(reg) ;
CAPREV_V.SCALE(reg)$(CAPREV_V.L(reg) lt 0)
    = -CAPREV_V.L(reg) ;

* EQUATION 1.5
EQLABREV.SCALE(reg)$(LABREV_V.L(reg) gt 0)
    = LABREV_V.L(reg) ;
LABREV_V.SCALE(reg)$(LABREV_V.L(reg) gt 0)
    = LABREV_V.L(reg) ;

EQLABREV.SCALE(reg)$(LABREV_V.L(reg) lt 0)
    = -LABREV_V.L(reg) ;
LABREV_V.SCALE(reg)$(LABREV_V.L(reg) lt 0)
    = -LABREV_V.L(reg) ;

* EQUATION 1.6
EQTSPREV.SCALE(reg)$(TSPREV_V.L(reg) gt 0)
    = TSPREV_V.L(reg) ;
TSPREV_V.SCALE(reg)$(TSPREV_V.L(reg) gt 0)
    = TSPREV_V.L(reg) ;

EQTSPREV.SCALE(reg)$(TSPREV_V.L(reg) lt 0)
    = -TSPREV_V.L(reg) ;
TSPREV_V.SCALE(reg)$(TSPREV_V.L(reg) lt 0)
    = -TSPREV_V.L(reg) ;

* EQUATION 1.7
EQNTPREV.SCALE(reg)$(NTPREV_V.L(reg) gt 0)
    = NTPREV_V.L(reg) ;
NTPREV_V.SCALE(reg)$(NTPREV_V.L(reg) gt 0)
    = NTPREV_V.L(reg) ;

EQNTPREV.SCALE(reg)$(NTPREV_V.L(reg) lt 0)
    = -NTPREV_V.L(reg) ;
NTPREV_V.SCALE(reg)$(NTPREV_V.L(reg) lt 0)
    = -NTPREV_V.L(reg) ;

* EQUATION 1.8
EQINMREV.SCALE(reg)$(INMREV_V.L(reg) gt 0)
    = INMREV_V.L(reg) ;
INMREV_V.SCALE(reg)$(INMREV_V.L(reg) gt 0)
    = INMREV_V.L(reg) ;

EQINMREV.SCALE(reg)$(INMREV_V.L(reg) lt 0)
    = -INMREV_V.L(reg) ;
INMREV_V.SCALE(reg)$(INMREV_V.L(reg) lt 0)
    = -INMREV_V.L(reg) ;

* EQUATION 1.9
EQTSEREV.SCALE(reg)$(TSEREV_V.L(reg) gt 0)
    = TSEREV_V.L(reg) ;
TSEREV_V.SCALE(reg)$(TSEREV_V.L(reg) gt 0)
    = TSEREV_V.L(reg) ;

EQTSEREV.SCALE(reg)$(TSEREV_V.L(reg) lt 0)
    = -TSEREV_V.L(reg) ;
TSEREV_V.SCALE(reg)$(TSEREV_V.L(reg) lt 0)
    = -TSEREV_V.L(reg) ;

* EQUATION 1.10
EQGRINC_H.SCALE(reg)$(GRINC_H_V.L(reg) gt 0)
    = GRINC_H_V.L(reg) ;
GRINC_H_V.SCALE(reg)$(GRINC_H_V.L(reg) gt 0)
    = GRINC_H_V.L(reg) ;

EQGRINC_H.SCALE(reg)$(GRINC_H_V.L(reg) lt 0)
    = -GRINC_H_V.L(reg) ;
GRINC_H_V.SCALE(reg)$(GRINC_H_V.L(reg) lt 0)
    = -GRINC_H_V.L(reg) ;

* EQUATION 1.11
EQGRINC_G.SCALE(reg)$(GRINC_G_V.L(reg) gt 0)
    = GRINC_G_V.L(reg) ;
GRINC_G_V.SCALE(reg)$(GRINC_G_V.L(reg) gt 0)
    = GRINC_G_V.L(reg) ;

EQGRINC_G.SCALE(reg)$(GRINC_G_V.L(reg) lt 0)
    = -GRINC_G_V.L(reg) ;
GRINC_G_V.SCALE(reg)$(GRINC_G_V.L(reg) lt 0)
    = -GRINC_G_V.L(reg) ;

* EQUATION 1.12
EQGRINC_I.SCALE(reg)$(GRINC_I_V.L(reg) gt 0)
    = GRINC_I_V.L(reg) ;
GRINC_I_V.SCALE(reg)$(GRINC_I_V.L(reg) gt 0)
    = GRINC_I_V.L(reg) ;

EQGRINC_I.SCALE(reg)$(GRINC_I_V.L(reg) lt 0)
    = -GRINC_I_V.L(reg) ;
GRINC_I_V.SCALE(reg)$(GRINC_I_V.L(reg) lt 0)
    = -GRINC_I_V.L(reg) ;

* EQUATION 1.13
EQCBUD_H.SCALE(reg)$(CBUD_H_V.L(reg) gt 0)
    = CBUD_H_V.L(reg) ;
CBUD_H_V.SCALE(reg)$(CBUD_H_V.L(reg) gt 0)
    = CBUD_H_V.L(reg) ;

EQCBUD_H.SCALE(reg)$(CBUD_H_V.L(reg) lt 0)
    = -CBUD_H_V.L(reg) ;
CBUD_H_V.SCALE(reg)$(CBUD_H_V.L(reg) lt 0)
    = -CBUD_H_V.L(reg) ;

* EQUATION 1.14
EQCBUD_G.SCALE(reg)$(CBUD_G_V.L(reg) gt 0)
    = CBUD_G_V.L(reg) ;
CBUD_G_V.SCALE(reg)$(CBUD_G_V.L(reg) gt 0)
    = CBUD_G_V.L(reg) ;

EQCBUD_G.SCALE(reg)$(CBUD_G_V.L(reg) lt 0)
    = -CBUD_G_V.L(reg) ;
CBUD_G_V.SCALE(reg)$(CBUD_G_V.L(reg) lt 0)
    = -CBUD_G_V.L(reg) ;

* EQUATION 1.15
EQCBUD_I.SCALE(reg)$(CBUD_I_V.L(reg) gt 0)
    = CBUD_I_V.L(reg) ;
CBUD_I_V.SCALE(reg)$(CBUD_I_V.L(reg) gt 0)
    = CBUD_I_V.L(reg) ;

EQCBUD_I.SCALE(reg)$(CBUD_I_V.L(reg) lt 0)
    = -CBUD_I_V.L(reg) ;
CBUD_I_V.SCALE(reg)$(CBUD_I_V.L(reg) lt 0)
    = -CBUD_I_V.L(reg) ;

* EQUATION 1.16
EQSCLFD_H.SCALE(regg)$(SCLFD_H_V.L(regg) gt 0)
    = SCLFD_H_V.L(regg) ;
SCLFD_H_V.SCALE(regg)$(SCLFD_H_V.L(regg) gt 0)
    = SCLFD_H_V.L(regg) ;

EQSCLFD_H.SCALE(regg)$(SCLFD_H_V.L(regg) lt 0)
    = -SCLFD_H_V.L(regg) ;
SCLFD_H_V.SCALE(regg)$(SCLFD_H_V.L(regg) lt 0)
    = -SCLFD_H_V.L(regg) ;

* EQUATION 1.17
EQSCLFD_G.SCALE(regg)$(SCLFD_G_V.L(regg) gt 0)
    = SCLFD_G_V.L(regg) ;
SCLFD_G_V.SCALE(regg)$(SCLFD_G_V.L(regg) gt 0)
    = SCLFD_G_V.L(regg) ;

EQSCLFD_G.SCALE(regg)$(SCLFD_G_V.L(regg) lt 0)
    = -SCLFD_G_V.L(regg) ;
SCLFD_G_V.SCALE(regg)$(SCLFD_G_V.L(regg) lt 0)
    = -SCLFD_G_V.L(regg) ;

* EQUATION 1.18
EQSCLFD_I.SCALE(regg)$(SCLFD_I_V.L(regg) gt 0)
    = SCLFD_I_V.L(regg) ;
SCLFD_I_V.SCALE(regg)$(SCLFD_I_V.L(regg) gt 0)
    = SCLFD_I_V.L(regg) ;

EQSCLFD_I.SCALE(regg)$(SCLFD_I_V.L(regg) lt 0)
    = -SCLFD_I_V.L(regg) ;
SCLFD_I_V.SCALE(regg)$(SCLFD_I_V.L(regg) lt 0)
    = -SCLFD_I_V.L(regg) ;

* EXOGENOUS VARIABLES
INCTRANSFER_V.SCALE(reg,fd,regg,fdd)$(INCTRANSFER_V.L(reg,fd,regg,fdd) gt 0)
    = INCTRANSFER_V.L(reg,fd,regg,fdd) ;
INCTRANSFER_V.SCALE(reg,fd,regg,fdd)$(INCTRANSFER_V.L(reg,fd,regg,fdd) lt 0)
    = -INCTRANSFER_V.L(reg,fd,regg,fdd) ;

TRANSFERS_ROW_V.SCALE(reg,fd)$(TRANSFERS_ROW_V.L(reg,fd) gt 0)
    = TRANSFERS_ROW_V.L(reg,fd) ;
TRANSFERS_ROW_V.SCALE(reg,fd)$(TRANSFERS_ROW_V.L(reg,fd) lt 0)
    = -TRANSFERS_ROW_V.L(reg,fd) ;

$label end_bounds_and_scales

* ======================== Phase 7: Declare sub-models  ========================
$if not '%phase%' == 'submodel_declaration' $goto submodel_declaration

* Include demand equations that will enter CGE model
Model demand_CGE_MCP
/
EQCONS_H_T.CONS_H_T_V
EQCONS_G_T.CONS_G_T_V
EQGFCF_T.GFCF_T_V
EQCAPREV.CAPREV_V
EQLABREV.LABREV_V
EQTSPREV.TSPREV_V
EQNTPREV.NTPREV_V
EQINMREV.INMREV_V
EQTSEREV.TSEREV_V
EQGRINC_H.GRINC_H_V
EQGRINC_G.GRINC_G_V
EQGRINC_I.GRINC_I_V
EQCBUD_H.CBUD_H_V
EQCBUD_G.CBUD_G_V
EQCBUD_I.CBUD_I_V
EQSCLFD_H.SCLFD_H_V
EQSCLFD_G.SCLFD_G_V
EQSCLFD_I.SCLFD_I_V
/
;

$label submodel_declaration
