* File:   EXIOMOD_base_model/scr/06_module_production_KL-E.gms
* Author: Tatyana Bulavskaya
* Organization: TNO, Netherlands 
* Date:   12 May 2015
* Adjusted: 17 Februari 2021 by Hettie Boonman

* gams-master-file: phase.gms

********************************************************************************
* THIS MODEL IS A CUSTOM-LICENSE MODEL.
* EXIOMOD 2.0 shall not be used for commercial purposes until an exploitation
* aggreement is signed, subject to similar conditions as for the underlying
* database (EXIOBASE). EXIOBASE limitations are based on open source license
* agreements to be found here:
* http://exiobase.eu/index.php/terms-of-use

* For information on a license, please contact: hettie.boonman@tno.nl
********************************************************************************

$ontext startdoc
This is a module describing production side equations of the base CGE with KL-E
production function formulation. The code includes all the required elements
(calibration, equations definition, model statement) for the production side.
The following elements of the model are described within the production module:

- Product market balance: supply equals demand.
- Link between output by product and output by activity.
- Demand functions for intermediate inputs, except for energy; in other words,
  how much products the producers want to buy, given the market prices. In this
  version, the first order conditions from Leontief production function are
  used.
- Demand functions for factors of production and energy. In this version, the
  first order conditions from 'flexible' nested CES production function are
  used. The nested form follows KL-E structure. The energy types within E nest
  are all substitutable between each other, meaning no further structure in
  energy substitution is introduced.
- Calculation of GDP in constant and current prices.

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

$if not exist "%project%/00_base_model_setup/sets/products_model_energy.txt" $abort "Energy products are not defined. Create %project%/00_base_model_setup/sets/products_model_energy.txt"


Sets
    ener(prd)    energy products
/
$include %project%/00_base_model_setup/sets/products_model_energy.txt
/
;

Alias
    (ener,enerr)
;

$label end_additional_sets

* ===================== Phase 2: Declaration of parameters =====================
$if not '%phase%' == 'parameters_declaration' $goto end_parameters_declaration

Parameters
    elasPROD_data(ind,*)        data on substitution elasticities in production
                                # nests
    FPROD_data(ind,*)          data on initial level of factor productivity
    elasKLE(regg,ind)           substitution elasticity between capital-labour
                                # and energy nests
    elasE(regg,ind)             substitution elasticity between types of energy
    elasKL(regg,ind)            substitution elasticity between capital and
                                # labour
    prodK(regg,ind)             parameter on productivity of capital in the nest
                                # of aggregated factors of production
    prodL(regg,ind)             parameter on productivity of labour in the nest
                                # of aggregated factors of production
    eprod(prd,regg,ind)         energy productivity
    Y(regg,ind)                 output vector by activity (volume)
    X(reg,prd)                  output vector by product (volume)
    INTER_USE_T(prd,regg,ind)   intermediate use on product level (volume)
    nENER(regg,ind)             intermediate use of aggregated energy (volume)
    nKLE(regg,ind)              intermediate use of capital-labour-energy nest
                                # (volume)

    tc_ind(prd,regg,ind)        tax and subsidies on products rates for
                                # industries (relation in value)
    txd_ind(reg,regg,ind)       net taxes on production rates (relation in
                                # value)
    txd_inm(reg,regg,ind)       rates of international margins (relation in
                                # value)
    txd_tse(reg,regg,ind)       rates of net taxes on exports (relation in
                                # value)

    coprodA(reg,prd,regg,ind)   co-production coefficients with mix per industry
                                # - corresponds to product technology assumption
                                # (relation in volume)
    coprodB(reg,prd,regg,ind)   co-production coefficients with mix per product
                                # - corresponds to industry technology
                                # assumption (relation in volume)
    ioc(prd,regg,ind)           technical input coefficients for intermediate
                                # inputs (relation in volume)
    aKLE(regg,ind)              technical input coefficients for aggregated
                                # capital-labour-energy nest (relation in
                                # volume)
    aE(regg,ind)                relative share parameter for energy nest within
                                # the aggregated KL-E nest (relation in volume)
    aKL(regg,ind)               relative share parameter for factors of
                                # production nest with the aggregated KL-E nest
                                # (relation in volume)
    alphaE(ener,regg,ind)       relative share parameter for types of energy
                                # within the aggregated nest (relation in
                                # volume)
    aK(reg,regg,ind)            relative share parameter for production factor
                                # capital within the aggregated nest
                                # (relation in volume)
    aL(reg,regg,ind)            relative share parameter for production factor
                                # labour within the aggregated nest
                                # (relation in volume)

    tc_ind_0(prd,regg,ind)      calibrated tax and subsidies on products rates
                                # for industries (relation in value)
;
$label end_parameters_declaration

* ====================== Phase 3: Definition of parameters =====================
$if not '%phase%' == 'parameters_calibration' $goto end_parameters_calibration

* Here project-specific data are read in. Data should be placed in
* %project%/00_base_model_setup/data/.

*## Elasticities and factor productivity ##

$libinclude xlimport elasPROD_data %project%/00_base_model_setup/data/Eldata.xlsx elasKL-E!a1..zz10000 ;

$libinclude xlimport FPROD_data %project%/00_base_model_setup/data/Eldata.xlsx prodKL-E!a1..zz10000 ;

loop((ind,va)$(k(va) or l(va)),
    ABORT$( FPROD_data(ind,va) eq 0 )
        "Initial level of factor productivity cannot be 0. See file Eldata.xlsx sheet prodKL-E" ;
) ;

loop(ind,
    ABORT$( FPROD_data(ind,"ENER") eq 0 )
        "Initial level of energy productivity cannot be 0. See file Eldata.xlsx sheet prodKL-E" ;
) ;


* Substitution elasticity between capital-labour and energy inputs in volume.
* The elasticity value can be different in each industry (ind) in each region
* (regg).
elasKLE(regg,ind)
    = elasPROD_data(ind,'elasKLE') ;

* Substitution elasticity between capital and labour inputs in volume. The
* elasticity value can be different in each industry (ind) in each region
* (regg).
elasKL(regg,ind)
    = elasPROD_data(ind,'elasKL') ;

* Substitution elasticity between energy types in volume. The elasticity value
* can be different in each industry (ind) in each region (regg).
elasE(regg,ind)
    = elasPROD_data(ind,'elasE') ;

* Parameter with initial level of productivity of individual factors of
* production. The parameter value is usually calibrated to 1 for each factor
* type (capital and labour) in each industry (ind) in each region (regg).
prodK(regg,ind)
    = sum(k, FPROD_data(ind,k) ) ;

prodL(regg,ind)
    = sum(l, FPROD_data(ind,l) ) ;

* Parameter with initial level of productivity of energy products within the E
* nest. The parameter value is usually calibrated to 1 for each energy type
* (ener) in each industry (ind) in each region (regg).
eprod(ener,regg,ind)
    = FPROD_data(ind,"ENER") ;


*## Aggregates ##

* Output in volume of each industry (ind) in each region (regg) in the
* calibration year, the corresponding price in the calibration year is equal to
* 1.
Y(regg,ind)
    = sum((reg,prd), SUP(reg,prd,regg,ind) ) ;

* Output in volume of each product (prd) in each region (reg) in the calibration
* year, the corresponding price in the calibration year is equal to 1.
X(reg,prd)
    = sum((regg,ind), SUP(reg,prd,regg,ind) ) ;

Display
Y
X
;

* Intermediate use of aggregated products in volume of each product (prd) in
* each industry (ind) in each region (regg), the corresponding basic price in
* the calibration year is equal to 1, purchaser's price can be different from 1
* in case of non-zero taxes on products.
INTER_USE_T(prd,regg,ind)
    = INTER_USE_D(prd,regg,ind) + INTER_USE_M(prd,regg,ind) ;

* Aggregate intermediate consumption of energy in each industry (ind) in each
* region (regg), the corresponding basic price in the calibration year is equal
* to 1.
nENER(regg,ind)
    = sum(ener, INTER_USE_T(ener,regg,ind) + INTER_USE_dt(ener,regg,ind) ) ;

* Aggregate intermediate consumption of capital-labour-energy bundle in each
* industry (ind) in each region (regg), the corresponding basic price in the
* calibration year is equal to 1.
nKLE(regg,ind)
    = nENER(regg,ind) + sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) ) ;

Display
INTER_USE_T
nENER
nKLE
;


*## Tax rates ##

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of intermediate use, tax rate differs by product (prd) in
* each industry (ind) in each region (regg).
tc_ind(prd,regg,ind)$INTER_USE_dt(prd,regg,ind)
    = INTER_USE_dt(prd,regg,ind) / INTER_USE_T(prd,regg,ind) ;

* Net tax (taxes less subsidies) rates on production activities, tax rate
* differs in each industry (ind) in each region (regg) and by the region of
* government which collects the taxes (reg).
txd_ind(reg,regg,ind)$sum(ntp, VALUE_ADDED(reg,ntp,regg,ind) )
    = sum(ntp, VALUE_ADDED(reg,ntp,regg,ind) ) / Y(regg,ind) ;

* Rates of international margins paid to exporting regions. International
* margins are modeled as ad valorem tax on value of output, rates differ by
* exporting region (reg) and by industry (ind) and region of consumption (regg).
txd_inm(reg,regg,ind)$sum(inm, VALUE_ADDED(reg,inm,regg,ind) )
    = sum(inm, VALUE_ADDED(reg,inm,regg,ind) ) / Y(regg,ind) ;

* Rates of net taxes paid to exporting regions. Taxes on exports are modeled as
* ad valorem tax on value of output, tax rates differs by exporting region (reg)
* and by industry (ind) and region of consumption (regg).
txd_tse(reg,regg,ind)$sum(tse, VALUE_ADDED(reg,tse,regg,ind) )
    = sum(tse, VALUE_ADDED(reg,tse,regg,ind) ) / Y(regg,ind) ;


Display
tc_ind
txd_ind
txd_inm
txd_tse
;


*## Parameters of production function ##

* Leontief co-production coefficients according to product technology assumption
* (not used at the moment in the CGE version).
coprodA(reg,prd,regg,ind)$Y(regg,ind)
    = SUP(reg,prd,regg,ind) / Y(regg,ind) ;

* Leontief co-production coefficients according to industry technology
* assumption.
coprodB(reg,prd,regg,ind)$SUP(reg,prd,regg,ind)
    = SUP(reg,prd,regg,ind) / X(reg,prd) ;

* Leontief technical input coefficients for intermediate inputs of aggregated
* products for each product (prd) in each industry (ind) in each region (regg).
ioc(prd,regg,ind)$( INTER_USE_T(prd,regg,ind) and not ener(prd) )
    = INTER_USE_T(prd,regg,ind) / Y(regg,ind) ;

* Leontief technical input coefficients for the nest of capital-labour-energy
* bundle in each industry (ind) in each region (regg).
aKLE(regg,ind)$nKLE(regg,ind)
    = nKLE(regg,ind) / Y(regg,ind) ;

* Relative share parameter for the nest of aggregated energy within the
* capital-labour-energy nest in each industry (ind) in each region (regg).
aE(regg,ind)$nENER(regg,ind)
    = nENER(regg,ind) / nKLE(regg,ind) ;

* Relative share parameter for the nest of aggregated factors of production
* within the capital-labour-energy nest in each industry (ind) in each region
* (regg).
aKL(regg,ind)$sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) )
    = sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) ) / nKLE(regg,ind) ;

* Relative share parameter for types of energy within the aggregated energy nest
* for each type of energy (ener) in each industry (ind) in each region (regg).
alphaE(ener,regg,ind)$INTER_USE_T(ener,regg,ind)
    = INTER_USE_T(ener,regg,ind) / ( nENER(regg,ind) / eprod(ener,regg,ind) ) *
    ( 1 * eprod(ener,regg,ind) /
    ( 1 + tc_ind(ener,regg,ind) ) )**( -elasE(regg,ind) ) ;

* Relative share parameter for factors of production within the aggregated nest
* for each type of production factor (reg) in each industry (ind) in each
* region (regg).
aK(reg,regg,ind)$sum(va$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) )
    = sum(k, VALUE_ADDED(reg,k,regg,ind) ) /
    ( sum((reggg,va)$(k(va) or l(va)), VALUE_ADDED(reggg,va,regg,ind) ) /
    prodK(regg,ind) )  *
    prodK(regg,ind)**( -elasKL(regg,ind) ) ;

aL(reg,regg,ind)$sum(va$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) )
    = sum(l, VALUE_ADDED(reg,l,regg,ind) ) /
    ( sum((reggg,va)$(k(va) or l(va)), VALUE_ADDED(reggg,va,regg,ind) ) /
    prodL(regg,ind) )  *
    prodL(regg,ind)**( -elasKL(regg,ind) ) ;

Display
coprodA
coprodB
ioc
aKLE
aE
aKL
alphaE
aK
aL
;


*## Store calibrated values in separated parameters ##

* Save calibrated values of tax rates separately. Change in a tax rate can be a
* part of simulation set-up and the initial calibrated tax rates are then needed
* for correct calculation of price indexes.
tc_ind_0(prd,regg,ind) = tc_ind(prd,regg,ind) ;

$label end_parameters_calibration

* =============== Phase 4: Declaration of variables and equations ==============
$if not '%phase%' == 'variables_equations_declaration' $goto end_variables_equations_declaration

* ========================== Declaration of variables ==========================

* Endogenous variables
Variables
    Y_V(regg,ind)                   output vector on industry level
    X_V(reg,prd)                    output vector on product level

    INTER_USE_T_V(prd,regg,ind)     use of intermediate inputs on aggregated
                                    # product level
    nKLE_V(regg,ind)                use of aggregated capital-labour-energy nest
    nENER_V(regg,ind)               use of aggregated energy nest
    nKL_V(regg,ind)                 use of aggregated production factors
    ENER_V(prd,regg,ind)            use of energy types
    K_V(reg,regg,ind)               use of production factor capital
    L_V(reg,regg,ind)               use of production factor labour

    PnKL_V(regg,ind)                aggregate production factors price
    PnENER_V(regg,ind)              aggregate energy price
    PnKLE_V(regg,ind)               aggregate capital-labour-energy price
;

* Artificial objective
Variables
    OBJ                             artificial objective value
;

* ========================== Declaration of equations ==========================

Equations
    EQBAL(reg,prd)              product market balance
    EQX(reg,prd)                supply of products with mix per industry
    EQY(regg,ind)               supply of activities with mix per product

    EQINTU_T(prd,regg,ind)      demand for intermediate inputs on aggregated
                                # product level
    EQnKLE(regg,ind)            demand for aggregated capital-labour-energy nest
    EQnENER(regg,ind)           demand for aggregated energy nest
    EQnKL(regg,ind)             demand for aggregated production factors
    EQENER(prd,regg,ind)        demand for energy types
    EQK(reg,regg,ind)           demand for production factor capital
    EQL(reg,regg,ind)           demand for production factor labour

    EQPnKL(regg,ind)            balance between specific production factors
                                # price and aggregate production factors price
    EQPnENER(regg,ind)          balance between price per energy type and
                                # aggregate energy price
    EQPnKLE(regg,ind)           balance between aggregate energy price and
                                # aggregate production factors price and
                                # aggregate capital-labour-energy price
;

$label end_variables_equations_declaration

* ====================== Phase 5: Definition of equations ======================
$if not '%phase%' == 'equations_definition' $goto end_equations_definition

* EQUATION 2.1: Product market balance: product output is equal to total uses,
* including domestic intermediate use, household consumption, government
* consumption, gross fixed capital formation, trade with modeled regions, stock
* changes and, in case of an open economy, export to the rest of the world
* region. Product market balance is expressed in volume. Product market balance
* should hold for each product (prd) produced in each region (reg).
EQBAL(reg,prd)..
    sum(ind, INTER_USE_D_V(prd,reg,ind) ) +
    CONS_H_D_V(prd,reg) +
    CONS_G_D_V(prd,reg) +
    GFCF_D_V(prd,reg) +
    sum(regg, TRADE_V(reg,prd,regg) ) +
    sum((regg), SV_V(reg,prd,regg) ) +
    EXPORT_ROW_V(reg,prd)
    =E=
    X_V(reg,prd) ;

* EQUATION 2.2A: Output level of products: given total amount of output per
* activity, output per product (reg,prd) is derived based on fixed output shares
* of each industry (regg,ind). EQUATION 2.2A corresponds to product technology
* assumption in input-output analysis, EQUATION 2.2B corresponds to industry
* technology assumption in input-output analysis. EQUATION 2.2A is only suitable
* for input-output analysis where number of products (prd) is equal to number
* of industries (ind). EQUATION 2.2A cannot be used in MCP setup.
EQX(reg,prd)..
    X_V(reg,prd)
    =E=
    sum((regg,ind), coprodA(reg,prd,regg,ind) * Y_V(regg,ind) ) ;

* EQUATION 2.2B: Output level of activities: given total amount of output per
* product, required output per activity (regg,ind) is derived based on fixed
* sales structure on each product market (reg,prd). EQUATION 2.2A corresponds to
* product technology assumption in input-output analysis, EQUATION 2.2B
* corresponds to industry technology assumption in input-output analysis.
* EQUATION 2.2B is suitable for input-output and CGE analysis.
EQY(regg,ind)..
    Y_V(regg,ind)
    =E=
    sum((reg,prd), coprodB(reg,prd,regg,ind) * X_V(reg,prd) ) ;

* EQUATION 2.3: Demand for intermediate inputs on aggregated product level. For
* non-energy products the demand function follows Leontief form, where the
* relation between intermediate inputs of aggregated product (prd) and output of
* the industry (regg,ind) in volume is kept constant. The demand for energy
* products (ener) comes from the solution for capital-labour-energy nest.
EQINTU_T(prd,regg,ind)..
    INTER_USE_T_V(prd,regg,ind)
    =E=
    ioc(prd,regg,ind) * Y_V(regg,ind)$( not ener(prd) ) +
    ENER_V(prd,regg,ind)$ener(prd) ;

* EQUATION 2.4: Demand for aggregated capital-labour-energy nest. The demand
* function follows Leontief form, where the relation between aggregated KL-E and
* output of the industry (regg,ind) in volume is kept constant.
EQnKLE(regg,ind)..
    nKLE_V(regg,ind)
    =E=
    aKLE(regg,ind) * Y_V(regg,ind) ;

* EQUATION 2.5: Demand for aggregated energy nest. The demand function follows
* CES form, where demand for aggregated energy of each industry (regg,ind)
* depends linearly on the demand of the same industry for aggregated KL-E nest
* and with certain elasticity on relative prices of energy, capital and labour.
EQnENER(regg,ind)..
    nENER_V(regg,ind)
    =E=
    nKLE_V(regg,ind) * aE(regg,ind) *
    ( PnENER_V(regg,ind) / PnKLE_V(regg,ind) )**( -elasKLE(regg,ind) ) ;

* EQUATION 2.6: Demand for aggregated production factors (capital-labour). The
* demand function follows CES form, where demand for aggregated production
* factors of each industry (regg,ind) depends linearly on the demand of the same
* industry for aggregated KL-E nest and with certain elasticity on relative
* prices of energy, capital and labour.
EQnKL(regg,ind)..
    nKL_V(regg,ind)
    =E=
    nKLE_V(regg,ind) * aKL(regg,ind) *
    ( PnKL_V(regg,ind) / PnKLE_V(regg,ind) )**( -elasKLE(regg,ind) ) ;

* EQUATION 2.7: Demand for types of energy. The demand function follows CES
* form, where demand of each industry (regg,ind) for each type of energy (ener)
* depends linearly on the demand of the same industry for aggregated energy nest
* and with certain elasticity on relative prices of energy types. The demand for
* energy types is also augmented with exogenous level of energy productivity.
EQENER(ener,regg,ind)..
    ENER_V(ener,regg,ind)
    =E=
    ( nENER_V(regg,ind) / eprod(ener,regg,ind) ) * alphaE(ener,regg,ind) *
    ( PIU_V(ener,regg,ind) * ( 1 + tc_ind(ener,regg,ind) ) /
    ( eprod(ener,regg,ind) * PnENER_V(regg,ind) ) )**( -elasE(regg,ind) ) ;

* EQUAION 2.8: Demand for production factor capital. The demand function
* follows CES form, where demand of each industry (regg,ind) for each factor of
* production (reg) depends linearly on the demand of the same industry for
* aggregated production factors and, with certain elasticity, on relative prices
* of specific factors of production.
EQK(reg,regg,ind)$sum(k, VALUE_ADDED(reg,k,regg,ind) )..
    K_V(reg,regg,ind)
    =E=
    ( nKL_V(regg,ind) / prodK(regg,ind) ) * aK(reg,regg,ind) *
    ( PK_V(reg) /
    ( prodK(regg,ind) * PnKL_V(regg,ind) ) )**( -elasKL(regg,ind) ) ;

* EQUAION 2.9: Demand for production factor labour. The demand function
* follows CES form, where demand of each industry (regg,ind) for each factor of
* production (reg) depends linearly on the demand of the same industry for
* aggregated production factors and, with certain elasticity, on relative prices
* of specific factors of production.
EQL(reg,regg,ind)$sum(l, VALUE_ADDED(reg,l,regg,ind) )..
    L_V(reg,regg,ind)
    =E=
    ( nKL_V(regg,ind) / prodL(regg,ind) ) * aL(reg,regg,ind) *
    ( PL_V(reg) /
    ( prodL(regg,ind) * PnKL_V(regg,ind) ) )**( -elasKL(regg,ind) ) ;

* EQUATION 2.10: Balance between specific production factors price and aggregate
* production factors price. The aggregate price is different in each industry
* (ind) in each region (regg) and is a weighted average of the price of specific
* production factors, where weights are defined as demand by the industry for
* corresponding production factors.
EQPnKL(regg,ind)..
    PnKL_V(regg,ind) * nKL_V(regg,ind)
    =E=
    sum(reg, PK_V(reg) * K_V(reg,regg,ind) ) +
    sum(reg, PL_V(reg) * L_V(reg,regg,ind) ) ;

* EQUATION 2.11: Balance between price per energy type and aggregate energy
* price. The aggregate price is different in each industry (ind) in each region
* (regg) and is a weighted average of the price per type of energy, where
* weights are defined as demand by the industry for the corresponding types of
* energy.
EQPnENER(regg,ind)..
    PnENER_V(regg,ind) * nENER_V(regg,ind)
    =E=
    sum(ener, PIU_V(ener,regg,ind) * ( 1 + tc_ind(ener,regg,ind) ) *
    ENER_V(ener,regg,ind) ) ;

* EQUATION 2.12: Balance between aggregate energy price, aggregate production
* factors price and aggregate capital-labour-energy price. The aggregate KL-E
* price is different in each industry (ind) in each region (regg) and is a
* weighted average KL and E prices, where weights are defined as demand by the
* industry for the corresponding nests.
EQPnKLE(regg,ind)..
    PnKLE_V(regg,ind) * nKLE_V(regg,ind)
    =E=
    PnENER_V(regg,ind) * nENER_V(regg,ind) +
    PnKL_V(regg,ind) * nKL_V(regg,ind) ;

$label end_equations_definition

* ===== Phase 6: Define levels, bounds and fixed variables, scale equations ====
$if not '%phase%' == 'bounds_and_scales' $goto end_bounds_and_scales

* ==================== Define level and bounds of variables ====================

* Endogenous variables
* Variables in real terms: level is set to the calibrated value of the
* corresponding parameter. If the the calibrated value is equal to zero, the
* variable value is also fixed to zero. The equation setup will lead to zero
* solution for this variable and fixing it at this point helps the solver.
Y_V.L(regg,ind) = Y(regg,ind) ;
X_V.L(reg,prd)  = X(reg,prd) ;
Y_V.FX(regg,ind)$(Y(regg,ind) eq 0) = 0 ;
X_V.FX(reg,prd)$(X(reg,prd) eq 0)   = 0 ;

INTER_USE_T_V.L(prd,regg,ind) = INTER_USE_T(prd,regg,ind) ;
INTER_USE_T_V.FX(prd,regg,ind)$(INTER_USE_T(prd,regg,ind) eq 0) = 0 ;

nKLE_V.L(regg,ind)      = nKLE(regg,ind) ;
nENER_V.L(regg,ind)     = nENER(regg,ind) ;
nKL_V.L(regg,ind)       = sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) ) ;
ENER_V.L(ener,regg,ind) = INTER_USE_T(ener,regg,ind) ;
K_V.L(reg,regg,ind)     = sum(k, VALUE_ADDED(reg,k,regg,ind) ) ;
L_V.L(reg,regg,ind)     = sum(l, VALUE_ADDED(reg,l,regg,ind) ) ;

nKLE_V.FX(regg,ind)$(nKLE(regg,ind) eq 0)                              = 0 ;
nENER_V.FX(regg,ind)$(nENER(regg,ind) eq 0)                            = 0 ;
nKL_V.FX(regg,ind)$(sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) ) eq 0) = 0 ;
ENER_V.FX(ener,regg,ind)$(INTER_USE_T(ener,regg,ind) eq 0)             = 0 ;
K_V.FX(reg,regg,ind)$(sum(k, VALUE_ADDED(reg,k,regg,ind) ) eq 0 )      = 0 ;
L_V.FX(reg,regg,ind)$(sum(l, VALUE_ADDED(reg,l,regg,ind) ) eq 0 )      = 0 ;


* Price variables: level of basic prices is set to one, which also corresponds
* to the price level used in calibration. If the the real variable to which the
* price level is linked is fixed to zero, the price is fixed to one. For zero
* level variables any price level will be a solution and fixing it to one helps
* the solver. Additionally, price of the numéraire is fixed.
PnKL_V.L(regg,ind)   = 1 ;
PnENER_V.L(regg,ind) = 1 ;
PnKLE_V.L(regg,ind)  = 1 ;

PnKL_V.FX(regg,ind)$(nKL_V.L(regg,ind) eq 0)     = 1 ;
PnENER_V.FX(regg,ind)$(nENER_V.L(regg,ind) eq 0) = 1 ;
PnKLE_V.FX(regg,ind)$(nKLE_V.L(regg,ind) eq 0)   = 1 ;

* ======================= Scale variables and equations ========================

* Scaling of variables and equations is done in order to help the solver to
* find the solution quicker. The scaling should ensure that the partial
* derivative of each variable evaluated at their current level values is within
* the range between 0.1 and 100. The values of partial derivatives can be seen
* in the equation listing. In general, the rule is that the variable and the
* equation linked to this variables in MCP formulation should both be scaled by
* the initial level of the variable.

* EQUATION 2.1 and EQUATION 2.2A
EQBAL.SCALE(reg,prd)$(X_V.L(reg,prd) gt 0)
    = X_V.L(reg,prd) ;
EQX.SCALE(reg,prd)$(X_V.L(reg,prd) gt 0)
    = X_V.L(reg,prd) ;
X_V.SCALE(reg,prd)$(X_V.L(reg,prd) gt 0)
    = X_V.L(reg,prd) ;

EQBAL.SCALE(reg,prd)$(X_V.L(reg,prd) lt 0)
    = -X_V.L(reg,prd) ;
EQX.SCALE(reg,prd)$(X_V.L(reg,prd) lt 0)
    = -X_V.L(reg,prd) ;
X_V.SCALE(reg,prd)$(X_V.L(reg,prd) lt 0)
    = -X_V.L(reg,prd) ;

* EQUATION 2.2B
EQY.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;
Y_V.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;

EQY.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;
Y_V.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;

* EQUATION 2.3
EQINTU_T.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) gt 0)
    = INTER_USE_T_V.L(prd,regg,ind) ;
INTER_USE_T_V.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) gt 0)
    = INTER_USE_T_V.L(prd,regg,ind) ;

EQINTU_T.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_T_V.L(prd,regg,ind) ;
INTER_USE_T_V.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_T_V.L(prd,regg,ind) ;

* EQUATION 2.4
EQnKLE.SCALE(regg,ind)$(nKLE_V.L(regg,ind) gt 0)
    = nKLE_V.L(regg,ind) ;
nKLE_V.SCALE(regg,ind)$(nKLE_V.L(regg,ind) gt 0)
    = nKLE_V.L(regg,ind) ;

EQnKLE.SCALE(regg,ind)$(nKLE_V.L(regg,ind) lt 0)
    = -nKLE_V.L(regg,ind) ;
nKLE_V.SCALE(regg,ind)$(nKLE_V.L(regg,ind) lt 0)
    = -nKLE_V.L(regg,ind) ;

* EQUATION 2.5
EQnENER.SCALE(regg,ind)$(nENER_V.L(regg,ind) gt 0)
    = nENER_V.L(regg,ind) ;
nENER_V.SCALE(regg,ind)$(nENER_V.L(regg,ind) gt 0)
    = nENER_V.L(regg,ind) ;

EQnENER.SCALE(regg,ind)$(nENER_V.L(regg,ind) lt 0)
    = -nENER_V.L(regg,ind) ;
nENER_V.SCALE(regg,ind)$(nENER_V.L(regg,ind) lt 0)
    = -nENER_V.L(regg,ind) ;

* EQUATION 2.6
EQnKL.SCALE(regg,ind)$(nKL_V.L(regg,ind) gt 0)
    = nKL_V.L(regg,ind) ;
nKL_V.SCALE(regg,ind)$(nKL_V.L(regg,ind) gt 0)
    = nKL_V.L(regg,ind) ;

EQnKL.SCALE(regg,ind)$(nKL_V.L(regg,ind) lt 0)
    = -nKL_V.L(regg,ind) ;
nKL_V.SCALE(regg,ind)$(nKL_V.L(regg,ind) lt 0)
    = -nKL_V.L(regg,ind) ;

* EQUATION 2.7
EQENER.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) gt 0)
    = ENER_V.L(ener,regg,ind) ;
ENER_V.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) gt 0)
    = ENER_V.L(ener,regg,ind) ;

EQENER.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) lt 0)
    = -ENER_V.L(ener,regg,ind) ;
ENER_V.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) lt 0)
    = -ENER_V.L(ener,regg,ind) ;

* EQUATION 2.8
EQK.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) gt 0)
    = K_V.L(reg,regg,ind) ;
K_V.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) gt 0)
    = K_V.L(reg,regg,ind) ;

EQK.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) lt 0)
    = -K_V.L(reg,regg,ind) ;
K_V.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) lt 0)
    = -K_V.L(reg,regg,ind) ;

* EQUATION 2.9
EQL.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) gt 0)
    = L_V.L(reg,regg,ind) ;
L_V.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) gt 0)
    = L_V.L(reg,regg,ind) ;

EQL.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) lt 0)
    = -L_V.L(reg,regg,ind) ;
L_V.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) lt 0)
    = -L_V.L(reg,regg,ind) ;

* EQUATION 2.10
EQPnKL.SCALE(reg,ind)$(nKL_V.L(reg,ind) gt 0)
    = nKL_V.L(reg,ind) ;

EQPnKL.SCALE(reg,ind)$(nKL_V.L(reg,ind) lt 0)
    = -nKL_V.L(reg,ind) ;

* EQUATION 2.11
EQPnENER.SCALE(reg,ind)$(nENER_V.L(reg,ind) gt 0)
    = nENER_V.L(reg,ind) ;

EQPnENER.SCALE(reg,ind)$(nENER_V.L(reg,ind) lt 0)
    = -nENER_V.L(reg,ind) ;

* EQUATION 2.12
EQPnKLE.SCALE(reg,ind)$(nKLE_V.L(reg,ind) gt 0)
    = nKLE_V.L(reg,ind) ;

EQPnKLE.SCALE(reg,ind)$(nKLE_V.L(reg,ind) lt 0)
    = -nKLE_V.L(reg,ind) ;

$label end_bounds_and_scales

* ======================== Phase 7: Declare sub-models  ========================
$if not '%phase%' == 'submodel_declaration' $goto submodel_declaration

* Include production equations that will enter CGE model
Model production_CGE_MCP
/
EQBAL.X_V
EQY.Y_V
EQINTU_T.INTER_USE_T_V
EQnKLE.nKLE_V
EQnENER.nENER_V
EQnKL.nKL_V
EQENER.ENER_V
EQK.K_V
EQL.L_V
EQPnKL.PnKL_V
EQPnENER.PnENER_V
EQPnKLE.PnKLE_V
/
;

$label submodel_declaration
