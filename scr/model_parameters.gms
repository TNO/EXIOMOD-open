* File:   scr/model_parameters.gms
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
    kl(va)    capital and labour categories         /"COE","OPS"/
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
    IU_PRD(prd,regg,ind)        intermediate use on product level (volume)
    IU_DOM(prd,regg,ind)        intermediate use of domestic products on
                                # product level (volume)
    IU_IMP(prd,regg,ind)        intermediate use of imported products on
                                # product level (volume)
    FU_PRD(prd,regg,fd)         final use on product level (volume)
    FU_DOM(prd,regg,fd)         final use of domestic products on product level
                                # (volume)
    FU_IMP(prd,regg,fd)         final use of imported products on product level
                                # (volume)
    IMPORT(prd,regg)            import of products into a region (volume)
    TRADE(reg,prd,regg)         trade of products between regions (volume)
    KLS(reg,kl)                 supply of production factors (volume)
    INC(regg,fd)                total income of final demand categories (value)

    tc_ind(prd,regg,ind)        tax and subsidies on products rates for
                                # industries (relation in value)
    tc_fd(prd,regg,fd)          tax and subsidies on products rates for final
                                # demand (relation in value)
    txd_ind(reg,ntp,regg,ind)   net taxes on production rates (relation in
                                # value)

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

    facC(reg,kl,regg,ind)       Cobb-Douglas share coefficients for factors
                                # of production (relation in value)
    facA(regg,ind)              Cobb-Douglas scale parameter for factors of
                                # production

    gammaCES(reg,kl,regg,ind)   CES share coefficients for factors of production
                                # (relation in value)
    aCES(regg,ind)              CES slace parameter for factos of production

    theta(prd,regg,fd)          relative share parameter of final consumption on
                                # product level in total demand (relation in
                                # volume)
    theta_dom(prd,regg,fd)      relative share parameter for final consumption
                                # of domestic products (relation in volume)
    theta_imp(prd,regg,fd)      relative share parameter for final consumption
                                # of imported products (relation in volume)

    gamma(reg,prd,regg)         relative share parameter for origin region of
                                # import (relation in volume)

    fac_distr(reg,kl,regg,fd)   distribution shares of factor income to budgets
                                # of final demand (shares in value)
    tsp_distr(reg,tsp,regg,fd)  distribution shares of taxes and subsidies on
                                # products income to budgets of final demand
                                # (shares in value)
    ntp_distr(reg,ntp,regg,fd)  distribution shares of taxes and subsidies on
                                # on production income to budgets of final
                                # demand (shares n value)
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
* of non-zero taxes on products
IU_PRD(prd,regg,ind)
    = sum(reg, INTER_USE_bp_model(reg,prd,regg,ind) ) ;

* Intermediate use of domestic products in volume of each product (prd) in each
* industry (ind) in each region (regg), the corresponding basic price in the
* base year is equal to 1
IU_DOM(prd,regg,ind)
    = INTER_USE_bp_model(regg,prd,regg,ind) ;

* Intermediate use of aggregated imported products in volume of each product
* (prd) in each industry (ind) in each region (regg), the corresponding basic
* price in the base year is equal to 1
IU_IMP(prd,regg,ind)
    = sum(reg$(not sameas(reg,regg)), INTER_USE_bp_model(reg,prd,regg,ind) ) ;

Display
IU_PRD
IU_DOM
IU_IMP
;

* Final use of aggregated products in volume of each product (prd) by each
* final demand category (fd) in each region (regg), the corresponding basic
* price in the base year is equal to 1, purchaser's price can be different from
* 1 in case of non-zero taxes on products
FU_PRD(prd,regg,fd)
    = sum(reg, FINAL_USE_bp_model(reg,prd,regg,fd) ) ;

* Final use of domestic products in volume of each product (prd) by each final
* demand category (fd) in each region (regg), the corresponding basic price in
* the base year is equal to 1
FU_DOM(prd,regg,fd)
    = FINAL_USE_bp_model(regg,prd,regg,fd) ;

* Final use of aggregated imported products in volume of each product (prd) by
* each final demand category (fd) in each region (regg), the corresponding basic
* price in the base year is equal to 1
FU_IMP(prd,regg,fd)
    = sum(reg$(not sameas(reg,regg)), FINAL_USE_bp_model(reg,prd,regg,fd) ) ;

Display
FU_PRD
FU_DOM
FU_IMP
;

* Aggregated import of products in volume of each product (prd) into each
* importing region (regg), the corresponding basic price in the base year is
* equal to 1
IMPORT(prd,regg)
    = sum(ind, IU_IMP(prd,regg,ind) ) + sum(fd, FU_IMP(prd,regg,fd) ) ;

* Trade of products for each product (prd) between each region pair (reg-regg),
* the corresponding basic price in the base year is equal to 1, purchaser's
* price can be different from 1 in case of non-zero taxes on products in the
* exporting region. By definition, trade of a region with itself it equal to 0
TRADE(reg,prd,regg)$(not sameas(reg,regg))
    = sum(ind, INTER_USE_bp_model(reg,prd,regg,ind) ) +
    sum(fd, FINAL_USE_bp_model(reg,prd,regg,fd) ) ;

Display
IMPORT
TRADE
;

* Supply in volume of each production factor (kl) in each region (reg), the
* corresponding basic price in the base year is equal to 1, market price can be
* different from 1 in case of non-zero taxes on factors of production
KLS(reg,kl)
    = sum((regg,ind),VALUE_ADDED_model(reg,kl,regg,ind) ) ;

* Total income in value of each final demand category (fd) in each region (regg)
INC(regg,fd)
    = sum((reg,prd), FINAL_USE_bp_model(reg,prd,regg,fd) ) +
    sum((reg,prd), FINAL_USE_ts_model(reg,prd,regg,fd) ) +
    sum((reg,fdd), INCOME_DISTR_model(regg,fd,reg,fdd) ) +
    sum((row,uip), IMPORT_USE_FD_model(regg,fd,row,uip) ) ;

Display
KLS
INC
;



*## Tax rates ##

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of intermediate use, tax rate differs by product (prd) in
* each industry (ind) in each region (regg)
tc_ind(prd,regg,ind)$sum(reg, INTER_USE_ts_model(reg,prd,regg,ind) )
    = sum(reg, INTER_USE_ts_model(reg,prd,regg,ind) ) /
    sum(reg, INTER_USE_bp_model(reg,prd,regg,ind) ) ;

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of final use, tax rate differs by product (prd) by each
* final demand category (fd) in each region (regg)
tc_fd(prd,regg,fd)$sum(reg, FINAL_USE_ts_model(reg,prd,regg,fd) )
    = sum(reg, FINAL_USE_ts_model(reg,prd,regg,fd) ) /
    sum(reg, FINAL_USE_bp_model(reg,prd,regg,fd) ) ;

* Net tax (taxes less subsidies) rates on production activities
txd_ind(reg,ntp,regg,ind)$VALUE_ADDED_model(reg,ntp,regg,ind)
    = VALUE_ADDED_model(reg,ntp,regg,ind) / Y(regg,ind) ;

Display
tc_ind
tc_fd
txd_ind
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
ioc(prd,regg,ind)$IU_PRD(prd,regg,ind)
    = IU_PRD(prd,regg,ind) / Y(regg,ind) ;

* Relative share parameter for intermediate use of domestic products, versus
* aggregated imported products, for each product (prd) in each industry (ind) in
* each region (regg)
phi_dom(prd,regg,ind)$IU_DOM(prd,regg,ind)
    = IU_DOM(prd,regg,ind) / IU_PRD(prd,regg,ind) *
    ( 1 / ( 1 + tc_ind(prd,regg,ind) ) )**( -elasIU_DM(prd,regg,ind) ) ;

* Relative share parameter for intermediate use of aggregated imported products,
* versus domestic products, for each product (prd) in each industry (ind) in
* each region (regg)
phi_imp(prd,regg,ind)$IU_IMP(prd,regg,ind)
    = IU_IMP(prd,regg,ind) / IU_PRD(prd,regg,ind) *
    ( 1 / ( 1 + tc_ind(prd,regg,ind) ) )**( -elasIU_DM(prd,regg,ind) ) ;

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

Display
coprodA
coprodB
ioc
phi_dom
phi_imp
aVA
alpha
;



*## Explicit Cobb-Douglas formulation for production factors nest ##

* Cobb-Douglas share coefficients for factors of production within the
* aggregated nest
facC(reg,kl,regg,ind)$VALUE_ADDED_model(reg,kl,regg,ind)
    = VALUE_ADDED_model(reg,kl,regg,ind) /
    sum((reggg,kll), VALUE_ADDED_model(reggg,kll,regg,ind) ) ;

* Cobb-Douglas scale parameter for the nest of aggregated factors of production
facA(regg,ind)$sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) )
    = sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) ) /
    prod((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind)**facC(reg,kl,regg,ind) ) ;
Display
facC
facA
;

*## Explicit CES formulation for production factors nest ##

* CES share parameters
gammaCES(reg,kl,regg,ind)
    = VALUE_ADDED_model(reg,kl,regg,ind)**( 1 / elasKL(regg,ind) ) /
    sum((reggg,kll),
    VALUE_ADDED_model(reggg,kll,regg,ind)**( 1 / elasKL(regg,ind) ) ) ;

* CES scale parameters
aCES(regg,ind)
    = sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) ) /
    sum((reg,kl), gammaCES(reg,kl,regg,ind) *
    VALUE_ADDED_model(reg,kl,regg,ind)**
    ( ( elasKL(regg,ind) - 1 ) / elasKL(regg,ind) ))**
    ( elasKL(regg,ind) / ( elasKL(regg,ind) - 1 ) );

Display
gammaCES,
aCES ;



*## Parameters of final demand function ##

* Relative share parameter for final consumption of aggregated products for each
* product (prd) by each final demand category (fd) in each region (reg)
theta(prd,regg,fd)$FU_PRD(prd,regg,fd)
    = FU_PRD(prd,regg,fd) / sum(prdd, FU_PRD(prdd,regg,fd) ) *
    ( 1 + tc_fd(prd,regg,fd) )**( -elasFU(regg,fd) ) ;

* Relative share parameter for final consumption of domestic products, versus
* aggregated imported products, for each product (prd) by each final demand
* category (fd) in each region (regg)
theta_dom(prd,regg,fd)$FU_DOM(prd,regg,fd)
    = FU_DOM(prd,regg,fd) / FU_PRD(prd,regg,fd) *
    ( 1 / ( 1 + tc_fd(prd,regg,fd) ) )**( -elasFU_DM(prd,regg,fd) ) ;

* Relative share parameter for final consumption of aggregated imported
* products, versus domestic products, for each product (prd) by each final
* demand category (fd) in each region (regg)
theta_imp(prd,regg,fd)$FU_IMP(prd,regg,fd)
    = FU_IMP(prd,regg,fd) / FU_PRD(prd,regg,fd) *
    ( 1 / ( 1 + tc_fd(prd,regg,fd) ) )**( -elasFU_DM(prd,regg,fd) ) ;

Display
theta
theta_dom
theta_imp
;



*## Parameters of international trade ##

* Relative share parameter for import from different regions for each product
* (prd) for each region of origin (reg) for each region of destination (regg)
gamma(reg,prd,regg)$TRADE(reg,prd,regg)
    = TRADE(reg,prd,regg) / IMPORT(prd,regg) ;

Display
gamma
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


Display
fac_distr
tsp_distr
ntp_distr
;
