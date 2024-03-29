* File:   EXIOMOD_base_model/scr/06_module_production_KL.gms
* Author: Trond Husby
* Organization: TNO, Netherlands 
* Date:   22 April 2015
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
This is a module describing production side equations of the base CGE and
Input-Output model. The code includes all the required elements (calibration,
equations definition, model statement) for the production side. The following
elements of the model are described within the production module:

- Product market balance: supply equals demand (CGE and IO).
- Link between output by product and output by activity (CGE and IO).
- Demand functions for intermediate inputs; in other words, how much products
  the producers want to buy, given the market prices. In this version, the first
  order conditions from Leontief production function are used (CGE and IO).
- Demand functions for factors of production. In this version, the first order
  conditions from 'flexible' CES production function are used (only CGE).
- Calculation of GDP in constant and current prices (only CGE).

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
    elasPROD_data(ind,*)        data on substitution elasticities in production
                                # nests
    FPROD_data(ind,va)          data on initial level of factor productivity
    elasKL(regg,ind)            substitution elasticity between capital and
                                # labour
    prodK(regg,ind)             parameter on productivity on capital in the nest
                                # of aggregated factors of production
    prodL(regg,ind)             parameter on productivity on labour in the nest
                                # of aggregated factors of production
    Y(regg,ind)                 output vector by activity (volume)
    X(reg,prd)                  output vector by product (volume)
    INTER_USE_T(prd,regg,ind)   intermediate use on product level (volume)

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
    aKL(regg,ind)               technical input coefficients for aggregated
                                # factors of production (relation in volume)
    aK(reg,regg,ind)            relative share parameter for capital within the
                                # capital-labour nest (relation in volume)
    aL(reg,regg,ind)            relative share parameter for labour within the
                                # capital-labour nest (relation in volume)
    tc_ind_0(prd,regg,ind)      calibrated tax and subsidies on products rates
                                # for industries (relation in value)
    ;
$label end_parameters_declaration

* ====================== Phase 3: Definition of parameters =====================
$if not '%phase%' == 'parameters_calibration' $goto end_parameters_calibration

* Here project-specific data are read in. Data should be placed in
* %project%/00_base_model_setup/data/.

*## Elasticities and factor productivity ##

$libinclude xlimport elasPROD_data %project%/00_base_model_setup/data/Eldata.xlsx elasKL!a1..zz10000 ;

$libinclude xlimport FPROD_data %project%/00_base_model_setup/data/Eldata.xlsx prodKL!a1..zz10000 ;

loop((ind,va)$(k(va) or l(va)),
        ABORT$( FPROD_data(ind,va) eq 0 )
            "Initial level of factor productivity cannot be 0. See file Eldata.xlsx sheet prodKL" ;
) ;


* Substitution elasticity between capital and labour inputs in volume. The
* elasticity value can be different in each industry (ind) in each region
* (regg).
elasKL(regg,ind)
    = elasPROD_data(ind,'elasKL') ;

* Parameter with initial level of productivity of individual factors of
* production. The parameter value is usually calibrated to 1 for each factor
* type (capital and labour) in each industry (ind) in each region (regg).
prodK(regg,ind)
    = sum(k,FPROD_data(ind,k)) ;

prodL(regg,ind)
    = sum(l,FPROD_data(ind,l)) ;


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

Display
INTER_USE_T
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
ioc(prd,regg,ind)$INTER_USE_T(prd,regg,ind)
    = INTER_USE_T(prd,regg,ind) / Y(regg,ind) ;

* Leontief technical input coefficients for the nest of aggregated factors of
* production (capital and labour) in each industry (ind) in each region (regg).
aKL(regg,ind)$sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) )
    = sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) ) /
    Y(regg,ind) ;

* Relative share parameter for factors of production within the aggregated nest
* for each type of production factor (reg,kl) in each industry (ind) in each
* region (regg).
aK(reg,regg,ind)$sum(k, VALUE_ADDED(reg,k,regg,ind) )
    = sum(k, VALUE_ADDED(reg,k,regg,ind) ) /
    ( sum((reggg,va)$(k(va) or l(va)), VALUE_ADDED(reggg,va,regg,ind) ) /
    prodK(regg,ind) )  *
    prodK(regg,ind)**( -elasKL(regg,ind) ) ;

aL(reg,regg,ind)$sum(l, VALUE_ADDED(reg,l,regg,ind) )
    = sum(l, VALUE_ADDED(reg,l,regg,ind) ) /
    ( sum((reggg,va)$(k(va) or l(va)), VALUE_ADDED(reggg,va,regg,ind) ) /
    prodL(regg,ind) )  *
    prodL(regg,ind)**( -elasKL(regg,ind) ) ;

Display
coprodA
coprodB
ioc
aKL
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
    nKL_V(regg,ind)                 use of aggregated production factors
    K_V(reg,regg,ind)               use of the production factor capital
    L_V(reg,regg,ind)               use of the production factor labour

    PnKL_V(regg,ind)                aggregate production factors price
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
    EQnKL(regg,ind)             demand for aggregated production factors
    EQK(reg,regg,ind)           demand for the production factor capital
    EQL(reg,regg,ind)           demand for the production factor labour

    EQPnKL(regg,ind)            balance between specific production factors
                                # price and aggregate production factors price

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
    ioc(prd,regg,ind) * Y_V(regg,ind) ;

* EQUATION 2.4: Demand for aggregated production factors. The demand function
* follows Leontief form, where the relation between aggregated value added and
* output of the industry (regg,ind) in volume is kept constant.
EQnKL(regg,ind)..
    nKL_V(regg,ind)
    =E=
    aKL(regg,ind) * Y_V(regg,ind) ;

* EQUAION 2.5: Demand for the production factor capital. The demand function
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

* EQUAION 2.6: Demand for the production factor labour. The demand function
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

* EQUATION 2.7: Balance between specific production factors price and aggregate
* production factors price. The aggregate price is different in each industry
* (ind) in each region (regg) and is a weighted average of the price of specific
* production factors, where weights are defined as demand by the industry for
* corresponding production factors.
EQPnKL(regg,ind)..
    PnKL_V(regg,ind) * nKL_V(regg,ind)
    =E=
    sum(reg, PK_V(reg) * K_V(reg,regg,ind) ) +
    sum(reg, PL_V(reg) * L_V(reg,regg,ind) ) ;

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

nKL_V.L(regg,ind)       = sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) ) ;
K_V.L(reg,regg,ind)     = sum(k, VALUE_ADDED(reg,k,regg,ind) ) ;
L_V.L(reg,regg,ind)     = sum(l, VALUE_ADDED(reg,l,regg,ind) ) ;
nKL_V.FX(regg,ind)$(sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) ) eq 0) = 0 ;
K_V.FX(reg,regg,ind)$(sum(k, VALUE_ADDED(reg,k,regg,ind) ) eq 0 ) = 0 ;
L_V.FX(reg,regg,ind)$(sum(l, VALUE_ADDED(reg,l,regg,ind) ) eq 0 ) = 0 ;

* Price variables: level of basic prices is set to one, which also corresponds
* to the price level used in calibration. If the the real variable to which the
* price level is linked is fixed to zero, the price is fixed to one. For zero
* level variables any price level will be a solution and fixing it to one helps
* the solver. Additionally, price of the numéraire is fixed.
PnKL_V.L(regg,ind)      = 1 ;
PnKL_V.FX(regg,ind)$(nKL_V.L(regg,ind) eq 0)                    = 1 ;

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
EQnKL.SCALE(regg,ind)$(nKL_V.L(regg,ind) gt 0)
    = nKL_V.L(regg,ind) ;
nKL_V.SCALE(regg,ind)$(nKL_V.L(regg,ind) gt 0)
    = nKL_V.L(regg,ind) ;

EQnKL.SCALE(regg,ind)$(nKL_V.L(regg,ind) lt 0)
    = -nKL_V.L(regg,ind) ;
nKL_V.SCALE(regg,ind)$(nKL_V.L(regg,ind) lt 0)
    = -nKL_V.L(regg,ind) ;

* EQUATION 2.5
EQK.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) gt 0)
    = K_V.L(reg,regg,ind) ;
K_V.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) gt 0)
    = K_V.L(reg,regg,ind) ;

EQK.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) lt 0)
    = -K_V.L(reg,regg,ind) ;
K_V.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) lt 0)
    = -K_V.L(reg,regg,ind) ;

* EQUATION 2.6
EQL.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) gt 0)
    = L_V.L(reg,regg,ind) ;
L_V.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) gt 0)
    = L_V.L(reg,regg,ind) ;

EQL.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) lt 0)
    = -L_V.L(reg,regg,ind) ;
L_V.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) lt 0)
    = -L_V.L(reg,regg,ind) ;

* EQUATION 2.7
EQPnKL.SCALE(reg,ind)$(nKL_V.L(reg,ind) gt 0)
    = nKL_V.L(reg,ind) ;

EQPnKL.SCALE(reg,ind)$(nKL_V.L(reg,ind) lt 0)
    = -nKL_V.L(reg,ind) ;

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
EQnKL.nKL_V
EQK.K_V
EQL.L_V
EQPnKL.PnKL_V
/
;

$label submodel_declaration
