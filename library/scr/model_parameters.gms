* File:   library/scr/model_parameters.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 9 June 2014 (simple CGE formulation)

* gams-master-file: main.gms

$ontext startdoc
This GAMS file defines the parameters that are used in the model. Please start from `main.gms`.

Parameters are fixed and are declared (in a first block) and defined (in the second block) in this file. The following parameters are defined:

Variable                    | Explanation
--------------------------- |:----------------
`Y(reg,ind)`                | This is the output vector by activity. It is defined from the supply table in model format, by summing `SUP_model(regg,prd,reg,ind)` over `regg` and `prd`.
`X(reg,ind)`                | This is the output vector by product. It is defined from the supply table in model format, by summing `SUP_model(reg,prd,regg,ind)` over `regg` and `ind`.
`coprodA(reg,prd,regg,ind)` | These are the co-production coefficients with mix per industry. Using these coefficients in the analysis corresponds to the product technology assumption. The coefficients are defined as `SUP_model(reg,prd,regg,ind) / Y(regg,ind)`. if `Y(regg,ind)` is nonzero.
`coprodA(reg,prd,regg,ind)` | These are the co-production coefficients with mix per product. Using these coefficients in the analysis corresponds to the industry technology assumption. The coefficients are defined as `SUP_model(reg,prd,regg,ind) / X(reg,prd)`. if `X(reg,prd)` is nonzero.
`a(reg,prd,regg,ind)`       | These are the technical input coefficients. They are defined as `INTER_USE_model(reg,prd,regg,ind) / Y(regg,ind)`.

No changes should be made in this file, as the parameters declared here are all defined using their standard definitions.
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ========================== Declaration of subsets ============================
Sets
    ntp(va)   net taxes on production categories    /"NTP"/
    kl(va)    capital and labour categories         /"COE","GOS"/
    tim(va)   tax on export and international margins categories /"INM","TSE"/
*    kl(va)    capital and labour categories         /"COE"/
;

Alias
    (kl,kll)
;

* ========================= Declaration of parameters ==========================

Parameters
    elasKL(regg,ind)            substitution elasticity between capital and
                                # labour
    elasIU_DM(prd,regg,ind)     substitution elasticity between domestic and
                                # imported intermediate use
    elasFU(regg,fd)             substitution elasticity between products for
                                # final use
    elasFU_DM(prd,regg,fd)      substitution elasticity between domestic and
                                # imported final use
    elasIMP(prd,regg)           substitution elasticity between imports from
                                # different regions

    Y(regg,ind)                 output vector by activity (volume)
    X(reg,prd)                  output vector by product (volume)
    INTER_USE_T(prd,regg,ind)   intermediate use on product level (volume)
    INTER_USE_D(prd,regg,ind)   intermediate use of domestic products on
                                # product level (volume)
    INTER_USE_M(prd,regg,ind)   intermediate use of imported products on
                                # product level (volume)
    INTER_USE(reg,prd,regg,ind) intermediate use of products on the level of
                                # product and producing region (volume)
    FINAL_USE_T(prd,regg,fd)    final use on product level (volume)
    FINAL_USE_D(prd,regg,fd)    final use of domestic products on product level
                                # (volume)
    FINAL_USE_M(prd,regg,fd)    final use of imported products on product level
                                # (volume)
    FINAL_USE(reg,prd,regg,fd)  final use of products on the level of product
                                # and producing region (volume)
    IMPORT(prd,regg)            import of products into a region (volume)
    TRADE(reg,prd,regg)         trade of products between regions (volume)
    KLS(reg,kl)                 supply of production factors (volume)
    CBUD(regg,fd)               total budget available for final consumption
                                # (value)
    INC(regg,fd)                total income of final demand categories (value)

    tc_ind(prd,regg,ind)        tax and subsidies on products rates for
                                # industries (relation in value)
    tc_fd(prd,regg,fd)          tax and subsidies on products rates for final
                                # demand (relation in value)
    txd_ind(reg,ntp,regg,ind)   net taxes on production rates (relation in
                                # value)
    txd_tim(reg,tim,regg,ind)   rates of net taxes on exports and rates of
                                # international margins (relation in value)

    coprodA(reg,prd,regg,ind)   co-production coefficients with mix per industry
                                # - corresponds to product technology assumption
    coprodB(reg,prd,regg,ind)   co-production coefficients with mix per product
                                # - corresponds to industry technology
                                # assumption (relation in volume)
    ioc(prd,regg,ind)           technical input coefficients for intermediate
                                # inputs (relation in volume)
    phi_dom(prd,regg,ind)       relative share parameter for intermediate use
                                # of domestic products (relation in volume)
    phi_imp(prd,regg,ind)       relative share parameter for intermediate use
                                # of imported products (relation in volume)
    aVA(regg,ind)               technical input coefficients for aggregated
                                # factors of production (relation in volume)
    alpha(reg,kl,regg,ind)      relative share parameter for factors of
                                # production within the aggregated next
                                # (relation in volume)
    phi_row(row,prd,regg,ind)   input coefficients for intermediate use of
                                # products imported from the rest of the world
                                # (relation in volume)

    theta(prd,regg,fd)          relative share parameter of final consumption on
                                # product level in total demand (relation in
                                # volume)
    theta_dom(prd,regg,fd)      relative share parameter for final consumption
                                # of domestic products (relation in volume)
    theta_imp(prd,regg,fd)      relative share parameter for final consumption
                                # of imported products (relation in volume)
    theta_row(row,prd,regg,fd)  coefficients for final consumption of products
                                # imported from the rest of the world (relation
                                # in value)

    gamma(reg,prd,regg)         relative share parameter for origin region of
                                # import (relation in volume)
    gammaE(reg,prd,row)         share coefficients for export (relation in
                                # volume)

    fac_distr(reg,kl,regg,fd)   distribution shares of factor income to budgets
                                # of final demand (shares in value)
    tsp_distr(reg,tsp,regg,fd)  distribution shares of taxes and subsidies on
                                # products income to budgets of final demand
                                # (shares in value)
    ntp_distr(reg,ntp,regg,fd)  distribution shares of taxes and subsidies on
                                # on production income to budgets of final
                                # demand (shares in value)
    tim_distr(reg,tim,regg,fd)  distribution shares of taxes on export and
                                # international margins income to budgets of
                                # final demand (shares n value)

;

* ========================== Definition of parameters ==========================



*## Elasticities ##

* Substitution elasticity between capital and labour inputs in volume. The
* elasticity value can be different in each industry (ind) in each region (regg)
elasKL(regg,ind)
    = 0.5 ;

* Substitution elasticity between domestic and aggregated imported products in
* volume for intermediate use. The elasticity value can be different for each
* product (prd) in each industry (ind) in each region (regg)
elasIU_DM(prd,regg,ind)
    = 0.0 ;

* Substitution elasticity between aggregated products in volume for final use.
* The elasticity value can be different for each final demand category (fd) in
* each region (regg)
elasFU(regg,fd)
    = 1.0 ;

* Substitution elasticity between domestic and aggregated imported products in
* volume for final use. The elasticity value can be different for each product
* (prd) for each final demand category (fd) in each region (regg)
elasFU_DM(prd,regg,fd)
    = 0.0 ;

* Substitution elasticity between imports in volume from different regions. The
* elasticity value can be different for each product (prd) and each importing
* region (regg)
elasIMP(prd,regg)
    = 0.0 ;



*## Aggregates ##

* Output in volume of each industry (ind) in each region (regg) in the base
* year, the corresponding price in the base year is equal to 1
Y(regg,ind)
    = sum((reg,prd), SUP_model(reg,prd,regg,ind) ) ;

* Output in volume of each product (prd) in each region (reg) in the base year,
* the corresponding price in the base year is equal to 1
X(reg,prd)
    = sum((regg,ind), SUP_model(reg,prd,regg,ind) ) ;

Display
Y
X
;

* Intermediate use of aggregated products in volume of each product (prd) in
* each industry (ind) in each region (regg), the corresponding basic price in
* the base year is equal to 1, purchaser's price can be different from 1 in case
* of non-zero taxes on products.
INTER_USE_T(prd,regg,ind)
    = INTER_USE_D_model(prd,regg,ind) + INTER_USE_M_model(prd,regg,ind) ;

* Intermediate use of domestic products in volume of each product (prd) in each
* industry (ind) in each region (regg), the corresponding basic price in the
* base year is equal to 1
INTER_USE_D(prd,regg,ind)
    = INTER_USE_D_model(prd,regg,ind) ;

* Intermediate use of aggregated imported products in volume of each product
* (prd) in each industry (ind) in each region (regg), the corresponding basic
* price in the base year is equal to 1.
INTER_USE_M(prd,regg,ind)
    = INTER_USE_M_model(prd,regg,ind) ;

* Intermediate use of products on the level of product (prd) and producing
* region (reg) in each industry (ind) in each region (regg), the corresponding
* basic price in the base year is equal to 1.
INTER_USE(reg,prd,regg,ind)$( sameas(reg,regg) or TRADE_model(reg,prd,regg) )
    = ( INTER_USE_D(prd,regg,ind) )$sameas(reg,regg) +
    ( INTER_USE_M(prd,regg,ind) * TRADE_model(reg,prd,regg) /
    sum(reggg, TRADE_model(reggg,prd,regg) ) )$(not sameas(reg,regg)) ;

Display
INTER_USE_T
INTER_USE_D
INTER_USE_M
INTER_USE
;

* Final use of aggregated products in volume of each product (prd) by each
* final demand category (fd) in each region (regg), the corresponding basic
* price in the base year is equal to 1, purchaser's price can be different from
* 1 in case of non-zero taxes on products.
FINAL_USE_T(prd,regg,fd)
    = FINAL_USE_D_model(prd,regg,fd) + FINAL_USE_M_model(prd,regg,fd) ;

* Final use of domestic products in volume of each product (prd) by each final
* demand category (fd) in each region (regg), the corresponding basic price in
* the base year is equal to 1
FINAL_USE_D(prd,regg,fd)
    = FINAL_USE_D_model(prd,regg,fd) ;

* Final use of aggregated imported products in volume of each product (prd) by
* each final demand category (fd) in each region (regg), the corresponding basic
* price in the base year is equal to 1.
FINAL_USE_M(prd,regg,fd)
    = FINAL_USE_M_model(prd,regg,fd) ;

* Final use of products on the level of product (prd) and producing region (reg)
* in each industry (ind) in each region (regg), the corresponding basic price in
* the base year is equal to 1.
FINAL_USE(reg,prd,regg,fd)$( sameas(reg,regg) or TRADE_model(reg,prd,regg) )
    = ( FINAL_USE_D(prd,regg,fd) )$sameas(reg,regg) +
    ( FINAL_USE_M(prd,regg,fd) * TRADE_model(reg,prd,regg) /
    sum(reggg, TRADE_model(reggg,prd,regg) ) )$(not sameas(reg,regg)) ;

Display
FINAL_USE_T
FINAL_USE_D
FINAL_USE_M
FINAL_USE
;

* Aggregated import of products in volume of each product (prd) into each
* importing region (regg), the corresponding basic price in the base year is
* equal to 1
IMPORT(prd,regg)
    = sum(ind, INTER_USE_M(prd,regg,ind) ) + sum(fd, FINAL_USE_M(prd,regg,fd) ) ;

* Trade of products for each product (prd) between each region pair (reg-regg),
* the corresponding basic price in the base year is equal to 1, purchaser's
* price can be different from 1 in case of non-zero taxes on products in the
* exporting region. By definition, trade of a region with itself it equal to 0
TRADE(reg,prd,regg)
    = TRADE_model(reg,prd,regg) ;

Display
IMPORT
TRADE
;


* Supply in volume of each production factor (kl) in each region (reg), the
* corresponding basic price in the base year is equal to 1, market price can be
* different from 1 in case of non-zero taxes on factors of production
KLS(reg,kl)
    = sum((regg,ind),VALUE_ADDED_model(reg,kl,regg,ind) ) ;

* Total budget in value available for final consumption of each final demand
* category (fd) in each region (regg)
CBUD(regg,fd)
    = sum(prd, FINAL_USE_D(prd,regg,fd) ) +
    sum(prd, FINAL_USE_M(prd,regg,fd) ) +
    sum((row,prd), FINAL_USE_ROW_model(row,prd,regg,fd) ) +
    sum(prd, FINAL_USE_dt_model(prd,regg,fd) ) ;

* Total income in value of each final demand category (fd) in each region (regg)
INC(regg,fd)
    = CBUD(regg,fd) +
    sum((reg,fdd), INCOME_DISTR_model(regg,fd,reg,fdd) ) +
    sum((reg,va), TAX_FINAL_USE_model(reg,va,regg,fd) ) +
    sum((row,va), TAX_FINAL_USE_ROW_model(row,va,regg,fd) ) ;

Display
KLS
CBUD
INC
;



*## Tax rates ##

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of intermediate use, tax rate differs by product (prd) in
* each industry (ind) in each region (regg)
tc_ind(prd,regg,ind)$INTER_USE_dt_model(prd,regg,ind)
    = INTER_USE_dt_model(prd,regg,ind) /
    ( INTER_USE_T(prd,regg,ind) +
    sum(row, INTER_USE_ROW_model(row,prd,regg,ind) ) ) ;


* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of final use, tax rate differs by product (prd) by each
* final demand category (fd) in each region (regg)
tc_fd(prd,regg,fd)$FINAL_USE_dt_model(prd,regg,fd)
    = FINAL_USE_dt_model(prd,regg,fd) /
    ( FINAL_USE_T(prd,regg,fd) +
    sum(row, FINAL_USE_ROW_model(row,prd,regg,fd) ) ) ;

* Net tax (taxes less subsidies) rates on production activities
txd_ind(reg,ntp,regg,ind)$VALUE_ADDED_model(reg,ntp,regg,ind)
    = VALUE_ADDED_model(reg,ntp,regg,ind) / Y(regg,ind) ;

* Rates of net taxes paid on import to exporting regions and rates of
* international margins paid to exporting regions. Taxes on exports and
* international margins are modeled as ad valorem tax on value of output,
* tax rates differs by industry (ind) and region of consumption (regg).
txd_tim(reg,tim,regg,ind)$VALUE_ADDED_model(reg,tim,regg,ind)
    = VALUE_ADDED_model(reg,tim,regg,ind) / Y(regg,ind) ;

Display
tc_ind
tc_fd
txd_ind
txd_tim
;



*## Parameters of production function ##

* Leontief co-production coefficients according to product technology assumption
* (not used at the moment in the CGE version)
coprodA(reg,prd,regg,ind)$Y(regg,ind)
    = SUP_model(reg,prd,regg,ind) / Y(regg,ind) ;

* Leontief co-production coefficients according to industry technology
* assumption
coprodB(reg,prd,regg,ind)$SUP_model(reg,prd,regg,ind)
    = SUP_model(reg,prd,regg,ind) / X(reg,prd) ;

* Leontief technical input coefficients for intermediate inputs of aggregated
* products for each product (prd) in each industry (ind) in each region (regg)
ioc(prd,regg,ind)$INTER_USE_T(prd,regg,ind)
    = INTER_USE_T(prd,regg,ind) / Y(regg,ind) ;

* Relative share parameter for intermediate use of domestic products, versus
* aggregated imported products, for each product (prd) in each industry (ind) in
* each region (regg)
phi_dom(prd,regg,ind)$INTER_USE_D(prd,regg,ind)
    = INTER_USE_D(prd,regg,ind) / INTER_USE_T(prd,regg,ind) *
    ( ( 1 + tc_ind(prd,regg,ind) ) / 1 )**( -elasIU_DM(prd,regg,ind) ) ;

* Relative share parameter for intermediate use of aggregated imported products,
* versus domestic products, for each product (prd) in each industry (ind) in
* each region (regg)
phi_imp(prd,regg,ind)$INTER_USE_M(prd,regg,ind)
    = INTER_USE_M(prd,regg,ind) / INTER_USE_T(prd,regg,ind) *
    ( ( 1 + tc_ind(prd,regg,ind) ) / 1 )**( -elasIU_DM(prd,regg,ind) ) ;

* Leontief technical input coefficients for the nest of aggregated factors of
* production in each industry (ind) in each region (regg)
aVA(regg,ind)$sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) )
    = sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) ) / Y(regg,ind) ;

* Relative share parameter for factors of production within the aggregated nest
* for each type of production factor (kl) in each industry (ind) in each region
* (reg,regg)
alpha(reg,kl,regg,ind)$VALUE_ADDED_model(reg,kl,regg,ind)
    = VALUE_ADDED_model(reg,kl,regg,ind) /
    sum((reggg,kll), VALUE_ADDED_model(reggg,kll,regg,ind) ) ;

* Input coefficients of products imported from the rest of the world for each
* type of product (prd) from each rest of the world region (row) for
* intermediate use in each industry (ind) in each region (regg)
phi_row(row,prd,regg,ind)$INTER_USE_ROW_model(row,prd,regg,ind)
    = INTER_USE_ROW_model(row,prd,regg,ind) / Y(regg,ind) ;

Display
coprodA
coprodB
ioc
phi_dom
phi_imp
aVA
alpha
phi_row
;



*## Parameters of final demand function ##

* Relative share parameter for final consumption of aggregated products for each
* product (prd) by each final demand category (fd) in each region (reg)
theta(prd,regg,fd)$FINAL_USE_T(prd,regg,fd)
    = FINAL_USE_T(prd,regg,fd) / sum(prdd, FINAL_USE_T(prdd,regg,fd) ) *
    ( 1 / ( 1 + tc_fd(prd,regg,fd) ) )**( -elasFU(regg,fd) ) ;

* Relative share parameter for final consumption of domestic products, versus
* aggregated imported products, for each product (prd) by each final demand
* category (fd) in each region (regg)
theta_dom(prd,regg,fd)$FINAL_USE_D(prd,regg,fd)
    = FINAL_USE_D(prd,regg,fd) / FINAL_USE_T(prd,regg,fd) *
    ( ( 1 + tc_fd(prd,regg,fd) ) / 1 )**( -elasFU_DM(prd,regg,fd) ) ;

* Relative share parameter for final consumption of aggregated imported
* products, versus domestic products, for each product (prd) by each final
* demand category (fd) in each region (regg)
theta_imp(prd,regg,fd)$FINAL_USE_M(prd,regg,fd)
    = FINAL_USE_M(prd,regg,fd) / FINAL_USE_T(prd,regg,fd) *
    ( ( 1 + tc_fd(prd,regg,fd) ) / 1 )**( -elasFU_DM(prd,regg,fd) ) ;

* Coefficients for final consumption of products imported from the rest of the
* world for each type of product (prd) from each rest of the world regions (row)
* by each final demand category (fd) in each region (regg)
theta_row(row,prd,regg,fd)$FINAL_USE_ROW_model(row,prd,regg,fd)
    = FINAL_USE_ROW_model(row,prd,regg,fd) / CBUD(regg,fd) ;

Display
theta
theta_dom
theta_imp
theta_row
;



*## Parameters of international trade ##

* Relative share parameter for import from different regions for each product
* (prd) for each region of origin (reg) for each region of destination (regg)
gamma(reg,prd,regg)$TRADE(reg,prd,regg)
    = TRADE(reg,prd,regg) / IMPORT(prd,regg) *
    ( 1 / 1 )**( -elasIMP(prd,regg) );

* Share coefficient for export of each product (prd) from each region of origin
* (prd) to each export destination (row)
gammaE(reg,prd,row)$EXPORT_model(reg,prd,row)
    = EXPORT_model(reg,prd,row) / X(reg,prd) ;

Display
gamma
gammaE
;



*## Distribution of value added and tax revenues to final consumers ##

* Distribution shares of factor revenues to budgets of final consumers for each
* factor type (reg,kl) for each final demand category (fd) in each region (regg)
fac_distr(reg,kl,regg,fd)$VALUE_ADDED_DISTR_model(reg,kl,regg,fd)
    = VALUE_ADDED_DISTR_model(reg,kl,regg,fd) /
    sum((reggg,fdd), VALUE_ADDED_DISTR_model(reg,kl,reggg,fdd) ) ;

* Distribution shares of net tax on products revenues to budgets of final
* consumers for each tax type (reg,tsp) for each final demand category (fd) in
* each region (regg)
tsp_distr(reg,tsp,regg,fd)$TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd)
    = TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd) /
    sum((reggg,fdd), TAX_SUB_PRD_DISTR_model(reg,tsp,reggg,fdd) ) ;

* Distribution shares of net tax on production revenues to budgets of final
* consumers for each tax type (reg,ntp) for each final demand category (fd) in
* each region (regg)
ntp_distr(reg,ntp,regg,fd)$VALUE_ADDED_DISTR_model(reg,ntp,regg,fd)
    = VALUE_ADDED_DISTR_model(reg,ntp,regg,fd) /
    sum((reggg,fdd), VALUE_ADDED_DISTR_model(reg,ntp,reggg,fdd) ) ;

* Distribution shares of tax on export and international margins revenues to
* budgets of final consumers for each earning type (reg,tim) for each final
* demand category (fd) in each region (regg)
tim_distr(reg,tim,regg,fd)$VALUE_ADDED_DISTR_model(reg,tim,regg,fd)
    = VALUE_ADDED_DISTR_model(reg,tim,regg,fd) /
    sum((reggg,fdd), VALUE_ADDED_DISTR_model(reg,tim,reggg,fdd) ) ;



Display
fac_distr
tsp_distr
ntp_distr
tim_distr
;
