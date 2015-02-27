* File:   library/scr/model_parameters.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 9 June 2014 (simple CGE formulation)

* gams-master-file: main.gms

$ontext startdoc
This GAMS file defines the parameters that are used in the model. Please start from `main.gms`.

Parameters are fixed and are declared (in a first block) and defined (in the second block) in this file.

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
    elasFU_H(regg)              substitution elasticity between products for
                                # household final use
    elasFU_G(regg)              substitution elasticity between products for
                                # government final use
    elasFU_C(regg)              substitution elasticity between products for
                                # capital formation final use
    elasFU_DM(prd,regg)         substitution elasticity between domestic and
                                # imported final use for all categories
    elasIMP(prd,regg)           substitution elasticity between imports from
                                # different regions

    Y(regg,ind)                 output vector by activity (volume)
    X(reg,prd)                  output vector by product (volume)
    INTER_USE_T(prd,regg,ind)   intermediate use on product level (volume)
    INTER_USE(reg,prd,regg,ind) intermediate use of products on the level of
                                # product and producing region (volume)

    CONS_H_D(prd,regg)          household consumption of domestic products
                                # (volume)
    CONS_H_M(prd,regg)          household consumption of products imported from
                                # modeled regions (volume)
    CONS_H_T(prd,regg)          household consumption on product level (volume)
    CONS_H(reg,prd,regg)        household consumption of products on the level
                                # of product and producing region (volume)

    CONS_G_D(prd,regg)          government consumption of domestic products
                                # (volume)
    CONS_G_M(prd,regg)          government consumption of products imported from
                                # modeled regions (volume)
    CONS_G_T(prd,regg)          government consumption on product level (volume)
    CONS_G(reg,prd,regg)        government consumption of products on the level
                                # of product and producing region (volume)

    GFCF_D(prd,regg)            investment (gross fixed capital formation) in
                                # domestic products (volume)
    GFCF_M(prd,regg)            investment (gross fixed capital formation) in
                                # products imported from modeled regions
                                # (volume)
    GFCF_T(prd,regg)            investment (gross fixed capital formation) on
                                # product level (volume)
    GFCF(reg,prd,regg)          investment (gross fixed capital formation) in
                                # products on the level of product and producing
                                # region (volume)

    SV(reg,prd,regg)            stock changes of products on the level of
                                # product and producing region (volume)

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
    = elasPROD_data(ind,'elasKL') ;

* Substitution elasticity between domestic and aggregated imported products in
* volume for intermediate use. The elasticity value can be different for each
* product (prd) in each industry (ind) in each region (regg)
elasIU_DM(prd,regg,ind)
    = elasTRADE_data(prd,'elasIU_DM') ;

* Substitution elasticity between aggregated products in volume for final use of
* households. The elasticity value can be different in each region (regg)
elasFU_H(regg)
    = sum(fd$fd_assign(fd,'Households'), elasFU_data(fd,'elasTOT') ) ;

* Substitution elasticity between aggregated products in volume for final use of
* government. The elasticity value can be different in each region (regg)
elasFU_G(regg)
    = sum(fd$fd_assign(fd,'Government'), elasFU_data(fd,'elasTOT') ) ;

* Substitution elasticity between aggregated products in volume for final use of
* investment agent for gross fixed capital formation. The elasticity value can
* be different in each region (regg)
elasFU_C(regg)
    = sum(fd$fd_assign(fd,'GrossFixCapForm'), elasFU_data(fd,'elasTOT') ) ;

* Substitution elasticity between domestic and aggregated imported products in
* volume for final use. The elasticity value can be different for each product
* (prd) in each region (regg)
elasFU_DM(prd,regg)
    = elasTRADE_data(prd,'elasFU_DM') ;

* Substitution elasticity between imports in volume from different regions. The
* elasticity value can be different for each product (prd) and each importing
* region (regg)
elasIMP(prd,regg)
    = elasTRADE_data(prd,'elasIMP') ;



*## Aggregates ##

* Output in volume of each industry (ind) in each region (regg) in the
* calibration year, the corresponding price in the calibration year is equal to
* 1
Y(regg,ind)
    = sum((reg,prd), SUP(reg,prd,regg,ind) ) ;

* Output in volume of each product (prd) in each region (reg) in the calibration
* year, the corresponding price in the calibration year is equal to 1
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

* Intermediate use of products on the level of product (prd) and producing
* region (reg) in each industry (ind) in each region (regg), the corresponding
* basic price in the calibration year is equal to 1.
INTER_USE(reg,prd,regg,ind)$( sameas(reg,regg) or TRADE(reg,prd,regg) )
    = ( INTER_USE_D(prd,regg,ind) )$sameas(reg,regg) +
    ( INTER_USE_M(prd,regg,ind) * TRADE(reg,prd,regg) /
    sum(reggg, TRADE(reggg,prd,regg) ) )$(not sameas(reg,regg)) ;

Display
INTER_USE_T
INTER_USE
;


* Household consumption of domestic products in volume of each product (prd) in
* each region (regg), the corresponding basic price in the calibration year is
* equal to 1
CONS_H_D(prd,regg)
    = sum(fd$fd_assign(fd,'Households'), FINAL_USE_D(prd,regg,fd) ) ;

* Household consumption of products imported from modeled regions in volume of
* each product (prd) in each region (regg), the corresponding basic price in the
* calibration year is equal to 1
CONS_H_M(prd,regg)
    = sum(fd$fd_assign(fd,'Households'), FINAL_USE_M(prd,regg,fd) ) ;

* Household consumption of aggregated products in volume of each product (prd)
* in each region (regg), the corresponding basic price in the calibration year
* is equal to 1, purchaser's price can be different from 1 in case of non-zero
* taxes on products.
CONS_H_T(prd,regg)
    = CONS_H_D(prd,regg) + CONS_H_M(prd,regg) ;

* Household consumption of products on the level of product (prd) and producing
* region (reg) in each region (regg), the corresponding basic price in the
* calibration year is equal to 1.
CONS_H(reg,prd,regg)$( sameas(reg,regg) or TRADE(reg,prd,regg) )
    = ( CONS_H_D(prd,regg) )$sameas(reg,regg) +
    ( CONS_H_M(prd,regg) * TRADE(reg,prd,regg) /
    sum(reggg, TRADE(reggg,prd,regg) ) )$(not sameas(reg,regg)) ;

Display
CONS_H_D
CONS_H_M
CONS_H_T
CONS_H
;


* Government consumption of domestic products in volume of each product (prd) in
* each region (regg), the corresponding basic price in the calibration year is
* equal to 1
CONS_G_D(prd,regg)
    = sum(fd$fd_assign(fd,'Government'), FINAL_USE_D(prd,regg,fd) ) ;

* Government consumption of products imported from modeled regions in volume of
* each product (prd) in each region (regg), the corresponding basic price in the
* calibration year is equal to 1
CONS_G_M(prd,regg)
    = sum(fd$fd_assign(fd,'Government'), FINAL_USE_M(prd,regg,fd) ) ;

* Government consumption of aggregated products in volume of each product (prd)
* in each region (regg), the corresponding basic price in the calibration year
* is equal to 1, purchaser's price can be different from 1 in case of non-zero
* taxes on products.
CONS_G_T(prd,regg)
    = CONS_G_D(prd,regg) + CONS_G_M(prd,regg) ;

* Government consumption of products on the level of product (prd) and producing
* region (reg) in each region (regg), the corresponding basic price in the
* calibration year is equal to 1.
CONS_G(reg,prd,regg)$( sameas(reg,regg) or TRADE(reg,prd,regg) )
    = ( CONS_G_D(prd,regg) )$sameas(reg,regg) +
    ( CONS_G_M(prd,regg) * TRADE(reg,prd,regg) /
    sum(reggg, TRADE(reggg,prd,regg) ) )$(not sameas(reg,regg)) ;

Display
CONS_G_D
CONS_G_M
CONS_G_T
CONS_G
;


* Investment (gross fixed capital formation) in domestic products in volume of
* each product (prd) in each region (regg), the corresponding basic price in the
* calibration year is equal to 1
GFCF_D(prd,regg)
    = sum(fd$fd_assign(fd,'GrossFixCapForm'), FINAL_USE_D(prd,regg,fd) ) ;

* Investment (gross fixed capital formation) in products imported from modeled
* regions in volume of each product (prd) in each region (regg), the
* corresponding basic price in the calibration year is equal to 1
GFCF_M(prd,regg)
    = sum(fd$fd_assign(fd,'GrossFixCapForm'), FINAL_USE_M(prd,regg,fd) ) ;

* Investment (gross fixed capital formation) on aggregated product level in
* volume of each product (prd) in each region (regg), the corresponding basic
* price in the calibration year is equal to 1, purchaser's price can be
* different from 1 in case of non-zero taxes on products.
GFCF_T(prd,regg)
    = GFCF_D(prd,regg) + GFCF_M(prd,regg) ;

* Investment (gross fixed capital formation) in products on the level of product
* (prd) and producing region (reg) in each region (regg), the corresponding
* basic price in the calibration year is equal to 1.
GFCF(reg,prd,regg)$( sameas(reg,regg) or TRADE(reg,prd,regg) )
    = ( GFCF_D(prd,regg) )$sameas(reg,regg) +
    ( GFCF_M(prd,regg) * TRADE(reg,prd,regg) /
    sum(reggg, TRADE(reggg,prd,regg) ) )$(not sameas(reg,regg)) ;

Display
GFCF_D
GFCF_M
GFCF_T
GFCF
;


* Stock change of products on the level of product (prd) and producing region
* (reg) in each region (regg), the corresponding basic price in the calibration
* year is equal to 1.
SV(reg,prd,regg)$( sameas(reg,regg) or TRADE(reg,prd,regg) )
    = ( sum(fd$fd_assign(fd,'StockChange'),
    FINAL_USE_D(prd,regg,fd) ) )$sameas(reg,regg) +
    ( sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_M(prd,regg,fd) ) *
    TRADE(reg,prd,regg) /
    sum(reggg, TRADE(reggg,prd,regg) ) )$(not sameas(reg,regg)) ;

Display
SV
;


* Aggregated import of products in volume of each product (prd) into each
* importing region (regg), the corresponding basic price in the base year is
* equal to 1
IMPORT(prd,regg)
    = sum(ind, INTER_USE_M(prd,regg,ind) ) + sum(fd, FINAL_USE_M(prd,regg,fd) ) ;

Display
IMPORT
TRADE
;

* Supply in volume of each production factor (kl) in each region (reg), the
* corresponding basic price in the base year is equal to 1, market price can be
* different from 1 in case of non-zero taxes on factors of production
KLS(reg,kl)
    = sum((regg,ind),VALUE_ADDED(reg,kl,regg,ind) ) ;

* Total budget in value available for final consumption of each final demand
* category (fd) in each region (regg)
CBUD(regg,fd)
    = sum(prd, FINAL_USE_D(prd,regg,fd) ) +
    sum(prd, FINAL_USE_M(prd,regg,fd) ) +
    sum((row,prd), FINAL_USE_ROW(row,prd,regg,fd) ) +
    sum(prd, FINAL_USE_dt(prd,regg,fd) ) ;

* Total income in value of each final demand category (fd) in each region (regg)
INC(regg,fd)
    = CBUD(regg,fd) +
    sum((reg,fdd), INCOME_DISTR(regg,fd,reg,fdd) ) +
    sum((reg,va), TAX_FINAL_USE(reg,va,regg,fd) ) +
    sum((row,va), TAX_FINAL_USE_ROW(row,va,regg,fd) ) ;

Display
KLS
CBUD
INC
;



*## Tax rates ##

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of intermediate use, tax rate differs by product (prd) in
* each industry (ind) in each region (regg)
tc_ind(prd,regg,ind)$INTER_USE_dt(prd,regg,ind)
    = INTER_USE_dt(prd,regg,ind) /
    ( INTER_USE_T(prd,regg,ind) +
    sum(row, INTER_USE_ROW(row,prd,regg,ind) ) ) ;


* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of final use, tax rate differs by product (prd) by each
* final demand category (fd) in each region (regg)
tc_fd(prd,regg,fd)$FINAL_USE_dt(prd,regg,fd)
    = FINAL_USE_dt(prd,regg,fd) /
    ( FINAL_USE_T(prd,regg,fd) +
    sum(row, FINAL_USE_ROW(row,prd,regg,fd) ) ) ;

* Net tax (taxes less subsidies) rates on production activities
txd_ind(reg,ntp,regg,ind)$VALUE_ADDED(reg,ntp,regg,ind)
    = VALUE_ADDED(reg,ntp,regg,ind) / Y(regg,ind) ;

* Rates of net taxes paid on import to exporting regions and rates of
* international margins paid to exporting regions. Taxes on exports and
* international margins are modeled as ad valorem tax on value of output,
* tax rates differs by industry (ind) and region of consumption (regg).
txd_tim(reg,tim,regg,ind)$VALUE_ADDED(reg,tim,regg,ind)
    = VALUE_ADDED(reg,tim,regg,ind) / Y(regg,ind) ;

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
    = SUP(reg,prd,regg,ind) / Y(regg,ind) ;

* Leontief co-production coefficients according to industry technology
* assumption
coprodB(reg,prd,regg,ind)$SUP(reg,prd,regg,ind)
    = SUP(reg,prd,regg,ind) / X(reg,prd) ;

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
aVA(regg,ind)$sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) )
    = sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) / Y(regg,ind) ;

* Relative share parameter for factors of production within the aggregated nest
* for each type of production factor (kl) in each industry (ind) in each region
* (reg,regg)
alpha(reg,kl,regg,ind)$VALUE_ADDED(reg,kl,regg,ind)
    = VALUE_ADDED(reg,kl,regg,ind) /
    sum((reggg,kll), VALUE_ADDED(reggg,kll,regg,ind) ) ;

* Input coefficients of products imported from the rest of the world for each
* type of product (prd) from each rest of the world region (row) for
* intermediate use in each industry (ind) in each region (regg)
phi_row(row,prd,regg,ind)$INTER_USE_ROW(row,prd,regg,ind)
    = INTER_USE_ROW(row,prd,regg,ind) / Y(regg,ind) ;

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
theta_row(row,prd,regg,fd)$FINAL_USE_ROW(row,prd,regg,fd)
    = FINAL_USE_ROW(row,prd,regg,fd) / CBUD(regg,fd) ;

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
gammaE(reg,prd,row)$EXPORT(reg,prd,row)
    = EXPORT(reg,prd,row) / X(reg,prd) ;

Display
gamma
gammaE
;



*## Distribution of value added and tax revenues to final consumers ##

* Distribution shares of factor revenues to budgets of final consumers for each
* factor type (reg,kl) for each final demand category (fd) in each region (regg)
fac_distr(reg,kl,regg,fd)$VALUE_ADDED_DISTR(reg,kl,regg,fd)
    = VALUE_ADDED_DISTR(reg,kl,regg,fd) /
    sum((reggg,fdd), VALUE_ADDED_DISTR(reg,kl,reggg,fdd) ) ;

* Distribution shares of net tax on products revenues to budgets of final
* consumers for each tax type (reg,tsp) for each final demand category (fd) in
* each region (regg)
tsp_distr(reg,tsp,regg,fd)$TAX_SUB_PRD_DISTR(reg,tsp,regg,fd)
    = TAX_SUB_PRD_DISTR(reg,tsp,regg,fd) /
    sum((reggg,fdd), TAX_SUB_PRD_DISTR(reg,tsp,reggg,fdd) ) ;

* Distribution shares of net tax on production revenues to budgets of final
* consumers for each tax type (reg,ntp) for each final demand category (fd) in
* each region (regg)
ntp_distr(reg,ntp,regg,fd)$VALUE_ADDED_DISTR(reg,ntp,regg,fd)
    = VALUE_ADDED_DISTR(reg,ntp,regg,fd) /
    sum((reggg,fdd), VALUE_ADDED_DISTR(reg,ntp,reggg,fdd) ) ;

* Distribution shares of tax on export and international margins revenues to
* budgets of final consumers for each earning type (reg,tim) for each final
* demand category (fd) in each region (regg)
tim_distr(reg,tim,regg,fd)$VALUE_ADDED_DISTR(reg,tim,regg,fd)
    = VALUE_ADDED_DISTR(reg,tim,regg,fd) /
    sum((reggg,fdd), VALUE_ADDED_DISTR(reg,tim,reggg,fdd) ) ;



Display
fac_distr
tsp_distr
ntp_distr
tim_distr
;
