* File:   library/scr/06_module_production_KL-E.gms
* Author: Tatyana Bulavskaya
* Date:   12 May 2015
* Adjusted:

* gams-master-file: phase.gms

$ontext startdoc
This is a module describing production side equations of the base CGE with KL-E
production function formulation. The code includes all the required elements
(calibration, equations definition, model statement) for the production side.
The following elements of the model are described within the production module:

- Product market balance: supply equals demand.
- Link between output by product and output by activity.
- Demand functions for intermediate inputs, expect for electricity; in other
  words, how much products the producers want to buy, given the market prices.
  In this version, the first order conditions from Leontief production function
  are used.
- Demand functions for factors of production and electricity. In this version,
  the first order conditions from 'flexible' nested CES production function are
  used. The nested form follows KL-E structure.
- Calculation of GDP in constant and current prices.

As with all the other modules, different phases of the code are being called
from 00_simulation_prepare.gms via phase.gms.

Please see the description of the modular approach in philosophy.html and of
phase.gms for more details.
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ==================== Phase 1: Additional sets and subsets ====================
$if not '%phase%' == 'additional_sets' $goto end_additional_sets

Sets
    elec(prd)    electricity products   / 'p030', 'p034' /
;

Alias
    (elec,elecc)
;

$label end_additional_sets

* ===================== Phase 2: Declaration of parameters =====================
$if not '%phase%' == 'parameters_declaration' $goto end_parameters_declaration

Parameters
    elasPROD_data(ind,*)        data on substitution elasticities in production
                                # nests
    FPROD_data(ind,va)          data on initial level of factor productivity
    elasKLE(regg,ind)           substitution elasticity between capital-labour
                                # and electricity nests
    elasE(regg,ind)             substitution elasticity between types of
                                # electricity
    elasKL(regg,ind)            substitution elasticity between capital and
                                # labour
    fprod(va,regg,ind)          parameter on productivity on individual factors
                                # in the nest of aggregated factors of
                                # production
    Y(regg,ind)                 output vector by activity (volume)
    X(reg,prd)                  output vector by product (volume)
    INTER_USE_T(prd,regg,ind)   intermediate use on product level (volume)
    nELEC(regg,ind)             intermediate use of aggregated electricity
                                # (volume)
    nKLE(regg,ind)              intermediate use of capital-labour-electricity
                                # nest (volume)
    KLS(reg,va)                 supply of production factors (volume)
    GDP(regg)                   gross domestic product (value)

    tc_ind(prd,regg,ind)        tax and subsidies on products rates for
                                # industries (relation in value)
    txd_ind(reg,regg,ind)       net taxes on production rates (relation in
                                # value)
    txd_tim(reg,regg,ind)       rates of net taxes on exports and rates of
                                # international margins (relation in value)

    coprodA(reg,prd,regg,ind)   co-production coefficients with mix per industry
                                # - corresponds to product technology assumption
                                # (relation in volume)
    coprodB(reg,prd,regg,ind)   co-production coefficients with mix per product
                                # - corresponds to industry technology
                                # assumption (relation in volume)
    ioc(prd,regg,ind)           technical input coefficients for intermediate
                                # inputs (relation in volume)
    aKLE(regg,ind)              technical input coefficients for aggregated
                                # capital-labour-electricity nest (relation in
                                # volume)
    aE(regg,ind)                relative share parameter for electricity nest
                                # within the aggregated KLE nest (relation in
                                # volume)
    aKL(regg,ind)               relative share parameter for factors of
                                # production nest with the aggregated KLE nest
                                # (relation in volume)
    alphaE(elec,regg,ind)       relative share parameter for types of
                                # electricity within the aggregated nest
                                # (relation in volume)
    alphaKL(reg,va,regg,ind)     relative share parameter for factors of
                                # production within the aggregated nest
                                # (relation in volume)

    tc_ind_0(prd,regg,ind)      calibrated tax and subsidies on products rates
                                # for industries (relation in value)
;
$label end_parameters_declaration

* ====================== Phase 3: Definition of parameters =====================
$if not '%phase%' == 'parameters_calibration' $goto end_parameters_calibration

* Here project-specific data are read in. Data should be placed in
* %project%/00-principal/data/.

*## Elasticities and factor productivity ##

$libinclude xlimport elasPROD_data %project%/00-principal/data/Eldata.xlsx elasPROD!a1..zz10000 ;

$libinclude xlimport FPROD_data %project%/00-principal/data/Eldata.xlsx FPROD!a1..zz10000 ;

loop((ind,kl),
    ABORT$( FPROD_data(ind,kl) eq 0 )
        "Initial level of factor productivity cannot be 0. See file Eldata.xlsx sheet FPROD" ;

) ;


elasKLE(regg,ind) = 0.5 ;
elasE(regg,ind) = 0.8 ;

* Substitution elasticity between capital and labour inputs in volume. The
* elasticity value can be different in each industry (ind) in each region
* (regg).
elasKL(regg,ind)
    = elasPROD_data(ind,'elasKL') ;

* Parameter with initial level of productivity of individual factors of
* production. The parameter value is usually calibrated to 1 for each factor
* type (kl) in each industry (ind) in each region (regg).
fprod(kl,regg,ind)
    = FPROD_data(ind,kl) ;


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

nELEC(regg,ind)
    = sum(elec, INTER_USE_T(elec,regg,ind) + INTER_USE_dt(elec,regg,ind) ) ;

nKLE(regg,ind)
    = nELEC(regg,ind) + sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) ;


Display
INTER_USE_T
nELEC
nKLE
;

* Supply in volume of each production factor (kl) in each region (reg), the
* corresponding basic price in the base year is equal to 1, market price can be
* different from 1 in case of non-zero taxes on factors of production.
KLS(reg,kl)
    = sum((regg,ind),VALUE_ADDED(reg,kl,regg,ind) ) ;

Display
KLS
;

* Gross domestic product in each region (regg). GDP calculated as difference
* between total output and intermediate inputs plus taxes on products paid by
* final consumers.
GDP(regg)
    = sum(ind, Y(regg,ind) ) -
    sum((prd,ind), INTER_USE_T(prd,regg,ind) ) +
    sum((prd,fd), FINAL_USE_dt(prd,regg,fd) ) ;

Display
GDP
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

* Rates of net taxes paid to exporting regions on import and rates of
* international margins paid to exporting regions. Taxes on exports and
* international margins are modeled as ad valorem tax on value of output,
* tax rates differs by exporting region (reg) and by industry (ind) and region
* of consumption (regg).
txd_tim(reg,regg,ind)$sum(tim, VALUE_ADDED(reg,tim,regg,ind) )
    = sum(tim, VALUE_ADDED(reg,tim,regg,ind) ) / Y(regg,ind) ;

Display
tc_ind
txd_ind
txd_tim
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
ioc(prd,regg,ind)$( INTER_USE_T(prd,regg,ind) and not elec(prd) )
    = INTER_USE_T(prd,regg,ind) / Y(regg,ind) ;

aKLE(regg,ind)$nKLE(regg,ind)
    = nKLE(regg,ind) / Y(regg,ind) ;

aE(regg,ind)$nELEC(regg,ind)
    = nELEC(regg,ind) / nKLE(regg,ind) ;

aKL(regg,ind)$sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) )
    = sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) / nKLE(regg,ind) ;

alphaE(elec,regg,ind)$INTER_USE_T(elec,regg,ind)
    = INTER_USE_T(elec,regg,ind) / nELEC(regg,ind) *
    ( 1 / ( 1 + tc_ind(elec,regg,ind) ) )**( -elasE(regg,ind) ) ;

* Leontief technical input coefficients for the nest of aggregated factors of
* production in each industry (ind) in each region (regg).
*aVA(regg,ind)$sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) )
*    = sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) / Y(regg,ind) ;

* Relative share parameter for factors of production within the aggregated nest
* for each type of production factor (reg,kl) in each industry (ind) in each
* region (regg).
alphaKL(reg,kl,regg,ind)$VALUE_ADDED(reg,kl,regg,ind)
    = VALUE_ADDED(reg,kl,regg,ind) /
    ( sum((reggg,kll), VALUE_ADDED(reggg,kll,regg,ind) ) /
    fprod(kl,regg,ind) )  *
    fprod(kl,regg,ind)**( -elasKL(regg,ind) ) ;

Display
coprodA
coprodB
ioc
aKLE
aE
aKL
*aVA
alphaE
alphaKL
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
    nKLE_V(regg,ind)                use of aggregated capital-labour-electricity
                                    # nest
    nELEC_V(regg,ind)               use of aggregated electricity nest
    VA_V(regg,ind)                  use of aggregated production factors
    ELEC_V(prd,regg,ind)            use of electricity types
    KL_V(reg,va,regg,ind)           use of specific production factors

    PELEC_V(regg,ind)               aggregate electricity price
    PKLE_V(regg,ind)                aggregate capital-labour-electricity price

    GDPCUR_V(regg)                  GDP in current prices (value)
    GDPCONST_V(regg)                GDP in constant prices (volume)
;

* Exogenous variables
Variables
    KLS_V(reg,va)                   supply of production factors
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
    EQnKLE(regg,ind)            demand for aggregated capital-labour-electricity
                                # nest
    EQnELEC(regg,ind)           demand for aggregated electricity nest
    EQnKL(regg,ind)             demand for aggregated production factors
    EQELEC(prd,regg,ind)        demand for electricity types
    EQKL(reg,va,regg,ind)       demand for specific production factors

    EQPELEC(regg,ind)           balance between price per electricity type and
                                # aggregate electricity price
    EQPKLE(regg,ind)            balance between aggregate electricity price,
                                # aggregate production factors price and
                                # aggregate capital-labour-electricity price

    EQGDPCUR(regg)              GDP in current prices (value)
    EQGDPCONST(regg)            GDP in constant prices (volume)
    EQOBJ                       artificial objective function
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


* EQUATION 2.3: Demand for intermediate inputs on aggregated product level. The
* demand function follows Leontief form, where the relation between intermediate
* inputs of aggregated product (prd) and output of the industry (regg,ind) in
* volume is kept constant.
EQINTU_T(prd,regg,ind)..
    INTER_USE_T_V(prd,regg,ind)
    =E=
    ioc(prd,regg,ind) * Y_V(regg,ind)$( not elec(prd) ) +
    ELEC_V(prd,regg,ind)$elec(prd) ;

EQnKLE(regg,ind)..
    nKLE_V(regg,ind)
    =E=
    aKLE(regg,ind) * Y_V(regg,ind) ;

EQnELEC(regg,ind)..
    nELEC_V(regg,ind)
    =E=
    nKLE_V(regg,ind) * aE(regg,ind) *
    ( PELEC_V(regg,ind) / PKLE_V(regg,ind) )**( -elasKLE(regg,ind) ) ;

EQnKL(regg,ind)..
    VA_V(regg,ind)
    =E=
    nKLE_V(regg,ind) * aKL(regg,ind) *
    ( PVA_V(regg,ind) / PKLE_V(regg,ind) )**( -elasKLE(regg,ind) ) ;

EQELEC(elec,regg,ind)..
    ELEC_V(elec,regg,ind)
    =E=
    nELEC_V(regg,ind) * alphaE(elec,regg,ind) *
    ( PIU_V(elec,regg,ind) * ( 1 + tc_ind(elec,regg,ind) ) /
    PELEC_V(regg,ind) )**( -elasE(regg,ind) ) ;




* EQUATION 2.4: Demand for aggregated production factors. The demand function
* follows Leontief form, where the relation between aggregated value added and
* output of the industry (regg,ind) in volume is kept constant.
*EQVA(regg,ind)..
*    VA_V(regg,ind)
*    =E=
*    aVA(regg,ind) * Y_V(regg,ind) ;

* EQUAION 2.5: Demand for specific production factors. The demand function
* follows CES form, where demand of each industry (regg,ind) for each factor of
* production (reg,kl) depends linearly on the demand of the same industry for
* aggregated production factors and, with certain elasticity, on relative prices
* of specific factors of production.
EQKL(reg,kl,regg,ind)$VALUE_ADDED(reg,kl,regg,ind)..
    KL_V(reg,kl,regg,ind)
    =E=
    ( VA_V(regg,ind) / fprod(kl,regg,ind) ) * alphaKL(reg,kl,regg,ind) *
    ( PKL_V(reg,kl) /
    ( fprod(kl,regg,ind) * PVA_V(regg,ind) ) )**( -elasKL(regg,ind) ) ;


EQPELEC(regg,ind)..
    PELEC_V(regg,ind) * nELEC_V(regg,ind)
    =E=
    sum(elec, PIU_V(elec,regg,ind) * ( 1 + tc_ind(elec,regg,ind) ) *
    ELEC_V(elec,regg,ind) ) ;

EQPKLE(regg,ind)..
    PKLE_V(regg,ind) * nKLE_V(regg,ind)
    =E=
    PELEC_V(regg,ind) * nELEC_V(regg,ind) + PVA_V(regg,ind) * VA_V(regg,ind) ;



* EQUATION 2.6: Gross domestic product calculated in current prices. GDP is
* calculated separately for each modeled region (regg).
EQGDPCUR(regg)..
    GDPCUR_V(regg)
    =E=
    sum(ind, Y_V(regg,ind) * PY_V(regg,ind) ) -
    sum((prd,ind), INTER_USE_T_V(prd,regg,ind) * PIU_V(prd,regg,ind) ) +
    sum(prd, CONS_H_T_V(prd,regg) * PC_H_V(prd,regg) * tc_h(prd,regg) ) +
    sum(prd, CONS_G_T_V(prd,regg) * PC_G_V(prd,regg) * tc_g(prd,regg) ) +
    sum(prd, GFCF_T_V(prd,regg) * PC_I_V(prd,regg) * tc_gfcf(prd,regg) ) +
    sum((reg,prd), SV_V(reg,prd,regg) * P_V(reg,prd) * tc_sv(prd,regg) ) +
    sum(prd, SV_ROW_V(prd,regg) * PROW_V * tc_sv(prd,regg) ) ;

* EQUATION 2.7: Gross domestic product calculated in constant prices of the
* base year. GDP is calculated separately for each modeled region (regg).
EQGDPCONST(regg)..
    GDPCONST_V(regg)
    =E=
    sum(ind, Y_V(regg,ind) ) -
    sum((prd,ind), INTER_USE_T_V(prd,regg,ind) ) +
    sum(prd, CONS_H_T_V(prd,regg) * tc_h_0(prd,regg) ) +
    sum(prd, CONS_G_T_V(prd,regg) * tc_g_0(prd,regg) ) +
    sum(prd, GFCF_T_V(prd,regg) * tc_gfcf_0(prd,regg) ) +
    sum((reg,prd), SV_V(reg,prd,regg) * tc_sv_0(prd,regg) ) +
    sum(prd, SV_ROW_V(prd,regg) * tc_sv_0(prd,regg) ) ;

* EQUATION 2.8: Artificial objective function: only relevant for users of conopt
* solver in combination with NLP type of mathematical problem.
EQOBJ..
    OBJ
    =E=
    1 ;

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
nELEC_V.L(regg,ind)     = nELEC(regg,ind)  ;
VA_V.L(regg,ind)        = sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) ;
ELEC_V.L(elec,regg,ind) = INTER_USE_T(elec,regg,ind) ;
KL_V.L(reg,kl,regg,ind) = VALUE_ADDED(reg,kl,regg,ind) ;

nKLE_V.FX(regg,ind)$(nKLE(regg,ind) eq 0)                             = 0 ;
nELEC_V.FX(regg,ind)$(nELEC(regg,ind) eq 0)                           = 0 ;
VA_V.FX(regg,ind)$(sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) eq 0) = 0 ;
ELEC_V.FX(elec,regg,ind)$(INTER_USE_T(elec,regg,ind) eq 0)            = 0 ;
KL_V.FX(reg,kl,regg,ind)$(VALUE_ADDED(reg,kl,regg,ind) eq 0 )         = 0 ;

GDPCUR_V.L(regg)   = GDP(regg) ;
GDPCONST_V.L(regg) = GDP(regg) ;
GDPCUR_V.FX(regg)$( GDP(regg) eq 0 )   = 0 ;
GDPCONST_V.FX(regg)$( GDP(regg) eq 0 ) = 0 ;

* Price variables: level of basic prices is set to one, which also corresponds
* to the price level used in calibration. If the the real variable to which the
* price level is linked is fixed to zero, the price is fixed to one. For zero
* level variables any price level will be a solution and fixing it to one helps
* the solver. Additionally, price of the numéraire is fixed.
PELEC_V.L(regg,ind) = 1 ;
PKLE_V.L(regg,ind)  = 1 ;

PELEC_V.FX(regg,ind)$(nELEC_V.L(regg,ind) eq 0) = 1 ;
PKLE_V.FX(regg,ind)$(nKLE_V.L(regg,ind) eq 0)   = 1 ;

* Exogenous variables
* Exogenous variables are fixed to their calibrated value.
KLS_V.FX(reg,kl)                  = KLS(reg,kl) ;

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


EQnKLE.SCALE(regg,ind)$(nKLE_V.L(regg,ind) gt 0)
    = nKLE_V.L(regg,ind) ;
nKLE_V.SCALE(regg,ind)$(nKLE_V.L(regg,ind) gt 0)
    = nKLE_V.L(regg,ind) ;

EQnKLE.SCALE(regg,ind)$(nKLE_V.L(regg,ind) lt 0)
    = -nKLE_V.L(regg,ind) ;
nKLE_V.SCALE(regg,ind)$(nKLE_V.L(regg,ind) lt 0)
    = -nKLE_V.L(regg,ind) ;


EQnELEC.SCALE(regg,ind)$(nELEC_V.L(regg,ind) gt 0)
    = nELEC_V.L(regg,ind) ;
nELEC_V.SCALE(regg,ind)$(nELEC_V.L(regg,ind) gt 0)
    = nELEC_V.L(regg,ind) ;

EQnELEC.SCALE(regg,ind)$(nELEC_V.L(regg,ind) lt 0)
    = -nELEC_V.L(regg,ind) ;
nELEC_V.SCALE(regg,ind)$(nELEC_V.L(regg,ind) lt 0)
    = -nELEC_V.L(regg,ind) ;


EQnKL.SCALE(regg,ind)$(VA_V.L(regg,ind) gt 0)
    = VA_V.L(regg,ind) ;
VA_V.SCALE(regg,ind)$(VA_V.L(regg,ind) gt 0)
    = VA_V.L(regg,ind) ;

EQnKL.SCALE(regg,ind)$(VA_V.L(regg,ind) lt 0)
    = -VA_V.L(regg,ind) ;
VA_V.SCALE(regg,ind)$(VA_V.L(regg,ind) lt 0)
    = -VA_V.L(regg,ind) ;


EQELEC.SCALE(elec,regg,ind)$(ELEC_V.L(elec,regg,ind) gt 0)
    = ELEC_V.L(elec,regg,ind) ;
ELEC_V.SCALE(elec,regg,ind)$(ELEC_V.L(elec,regg,ind) gt 0)
    = ELEC_V.L(elec,regg,ind) ;

EQELEC.SCALE(elec,regg,ind)$(ELEC_V.L(elec,regg,ind) lt 0)
    = -ELEC_V.L(elec,regg,ind) ;
ELEC_V.SCALE(elec,regg,ind)$(ELEC_V.L(elec,regg,ind) lt 0)
    = -ELEC_V.L(elec,regg,ind) ;




* EQUATION 2.4
*EQVA.SCALE(regg,ind)$(VA_V.L(regg,ind) gt 0)
*    = VA_V.L(regg,ind) ;
*VA_V.SCALE(regg,ind)$(VA_V.L(regg,ind) gt 0)
*    = VA_V.L(regg,ind) ;
*
*EQVA.SCALE(regg,ind)$(VA_V.L(regg,ind) lt 0)
*    = -VA_V.L(regg,ind) ;
*VA_V.SCALE(regg,ind)$(VA_V.L(regg,ind) lt 0)
*    = -VA_V.L(regg,ind) ;

* EQUATION 2.5
EQKL.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) gt 0)
    = KL_V.L(reg,kl,regg,ind) ;
KL_V.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) gt 0)
    = KL_V.L(reg,kl,regg,ind) ;

EQKL.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) lt 0)
    = -KL_V.L(reg,kl,regg,ind) ;
KL_V.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) lt 0)
    = -KL_V.L(reg,kl,regg,ind) ;


EQPELEC.SCALE(reg,ind)$(nELEC_V.L(reg,ind) gt 0)
    = nELEC_V.L(reg,ind) ;

EQPELEC.SCALE(reg,ind)$(nELEC_V.L(reg,ind) lt 0)
    = -nELEC_V.L(reg,ind) ;


EQPKLE.SCALE(reg,ind)$(nKLE_V.L(reg,ind) gt 0)
    = nKLE_V.L(reg,ind) ;

EQPKLE.SCALE(reg,ind)$(nKLE_V.L(reg,ind) lt 0)
    = -nKLE_V.L(reg,ind) ;


* EQUATION 2.6
EQGDPCUR.SCALE(regg)$(GDPCUR_V.L(regg) gt 0)
    = GDPCUR_V.L(regg) ;
GDPCUR_V.SCALE(regg)$(GDPCUR_V.L(regg) gt 0)
    = GDPCUR_V.L(regg) ;

EQGDPCUR.SCALE(regg)$(GDPCUR_V.L(regg) lt 0)
    = -GDPCUR_V.L(regg) ;
GDPCUR_V.SCALE(regg)$(GDPCUR_V.L(regg) lt 0)
    = -GDPCUR_V.L(regg) ;

* EQUATION 2.7
EQGDPCONST.SCALE(regg)$(GDPCONST_V.L(regg) gt 0)
    = GDPCONST_V.L(regg) ;
GDPCONST_V.SCALE(regg)$(GDPCONST_V.L(regg) gt 0)
    = GDPCONST_V.L(regg) ;

EQGDPCONST.SCALE(regg)$(GDPCONST_V.L(regg) lt 0)
    = -GDPCONST_V.L(regg) ;
GDPCONST_V.SCALE(regg)$(GDPCONST_V.L(regg) lt 0)
    = -GDPCONST_V.L(regg) ;

* EXOGENOUS VARIBLES
KLS_V.SCALE(reg,kl)$(KLS_V.L(reg,kl) gt 0)
    = KLS_V.L(reg,kl) ;
KLS_V.SCALE(reg,kl)$(KLS_V.L(reg,kl) lt 0)
    = -KLS_V.L(reg,kl) ;

$label end_bounds_and_scales

* ======================== Phase 7: Declare sub-models  ========================
$if not '%phase%' == 'submodel_declaration' $goto submodel_declaration

* Include production equations that will enter IO product technology model
Model production_IO_product_technology
/
EQBAL
EQX
EQINTU_T
EQOBJ
/
;

* Include production equations that will enter IO product technology model
Model production_IO_industry_technology
/
EQBAL
EQY
EQINTU_T
EQOBJ
/
;

* Include production equations that will enter CGE model
Model production_CGE_MCP
/
EQBAL.X_V
EQY.Y_V
EQINTU_T.INTER_USE_T_V
EQnKLE.nKLE_V
EQnELEC.nELEC_V
EQnKL.VA_V
EQELEC.ELEC_V
EQKL.KL_V
EQPELEC.PELEC_V
EQPKLE.PKLE_V
EQGDPCUR.GDPCUR_V
EQGDPCONST.GDPCONST_V
/
;

$label submodel_declaration
