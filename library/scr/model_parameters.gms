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
    elasFU_I(regg)              substitution elasticity between products for
                                # capital formation final use
    elasFU_DM(prd,regg)         substitution elasticity between domestic and
                                # imported final use for all categories
    elasIMP(prd,regg)           substitution elasticity between imports from
                                # different regions
    tfp(regg,ind)               total factor productivity parameter in the
                                # nest of aggregated factors of production

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
    CONS_H_ROW(row,prd,regg)    household consumption of products imported from
                                # rest of the world regions (volume)

    CONS_G_D(prd,regg)          government consumption of domestic products
                                # (volume)
    CONS_G_M(prd,regg)          government consumption of products imported from
                                # modeled regions (volume)
    CONS_G_T(prd,regg)          government consumption on product level (volume)
    CONS_G(reg,prd,regg)        government consumption of products on the level
                                # of product and producing region (volume)
    CONS_G_ROW(row,prd,regg)    government consumption of products imported from
                                # rest of the world regions (volume)

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
    GFCF_ROW(row,prd,regg)      investment (gross fixed capital formation) in
                                # products imported from rest of the world
                                # regions (volume)

    SV(reg,prd,regg)            stock changes of products on the level of
                                # product and producing region (volume)
    SV_ROW(row,prd,regg)        stock changes of products imported from rest of
                                # the world regions (volume)

    IMPORT(prd,regg)            import of products into a region from modeled
                                # regions for intermediate use, household and
                                # government consumption and investments
                                # (volume)
    TRADE(reg,prd,regg)         trade of products between modeled regions for
                                # intermediate use, household and government
                                #consumption and investments (volume)

    KLS(reg,kl)                 supply of production factors (volume)
    CBUD_H(regg)                total budget available for household consumption
                                # (value)
    CBUD_G(regg)                total budget available for government
                                # consumption (value)
    CBUD_I(regg)                total budget available for gross fixed capital
                                # formation (value)
    INC_H(regg)                 total income of households (value)
    INC_G(regg)                 total income of government (value)
    INC_I(regg)                 total income of investment agent (value)

    tc_ind(prd,regg,ind)        tax and subsidies on products rates for
                                # industries (relation in value)
    tc_h(prd,regg)              tax and subsidies on products rates for
                                # household consumption (relation in value)
    tc_g(prd,regg)              tax and subsidies on products rates for
                                # government consumption (relation in value)
    tc_gfcf(prd,regg)           tax and subsidies on products rates for
                                # gross fixed capital formation (relation in
                                # value)
    tc_sv(prd,regg)             tax and subsidies on products rates for
                                # stock changes (relation in value)
    txd_ind(reg,regg,ind)       net taxes on production rates (relation in
                                # value)
    txd_tim(reg,regg,ind)       rates of net taxes on exports and rates of
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
                                # production within the aggregated nest
                                # (relation in volume)
    phi_row(row,prd,regg,ind)   input coefficients for intermediate use of
                                # products imported from the rest of the world
                                # (relation in volume)

    theta_h(prd,regg)           relative share parameter of household
                                # consumption on product level in total
                                # household demand (relation in volume)
    theta_h_dom(prd,regg)       relative share parameter for household
                                # consumption of domestic products (relation in
                                # volume)
    theta_h_imp(prd,regg)       relative share parameter for household
                                # consumption of products imported from modeled
                                # regions (relation in volume)
    theta_h_row(row,prd,regg)   coefficients for household consumption of
                                # products imported from the rest of the world
                                # regions (relation in value)
    theta_g(prd,regg)           relative share parameter of government
                                # consumption on product level in total
                                # government demand (relation in volume)
    theta_g_dom(prd,regg)       relative share parameter for government
                                # consumption of domestic products (relation in
                                # volume)
    theta_g_imp(prd,regg)       relative share parameter for government
                                # consumption of products imported from modeled
                                # regions (relation in volume)
    theta_g_row(row,prd,regg)   coefficients for government consumption of
                                # products imported from the rest of the world
                                # regions (relation in value)
    theta_gfcf(prd,regg)        relative share parameter of gross fixed capital
                                # formation on product level in total investment
                                # demand (relation in volume)
    theta_gfcf_dom(prd,regg)    relative share parameter for gross fixed capital
                                # formation of domestic products (relation in
                                # volume)
    theta_gfcf_imp(prd,regg)    relative share parameter for gross fixed capital
                                # formation of products imported from modeled
                                # regions (relation in volume)
    theta_gfcf_row(row,prd,regg)    coefficients for gross fixed capital
                                # formation of products imported from the rest
                                # of the world regions (relation in value)
    theta_sv(reg,prd,regg)      share coefficients for stock changes in products
                                # produced in the modeled regions (relation in
                                # volume)

    gamma(reg,prd,regg)         relative share parameter for origin region of
                                # import (relation in volume)
    gammaE(reg,prd,row)         share coefficients for export (relation in
                                # volume)
    fac_distr_h(reg,kl,regg)    distribution shares of factor income to
                                # household budget (shares in value)
    fac_distr_g(reg,kl,regg)    distribution shares of factor income to
                                # government budget (shares in value)
    fac_distr_gfcf(reg,kl,regg) distribution shares of factor income to
                                # gross fixed capital formation budget (shares
                                # in value)
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
elasFU_I(regg)
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

* Total factor productivity parameter, productivity of aggregated nest of
* factors of production. The parameter value is calibrated to 1 in each industry
* (ind) in each region (regg)
tfp(regg,ind)
    = TFP_data(ind,'TFP') ;


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

* Household consumption of products imported from rest of the world regions in
* volume of each product (prd) produced in each rest of the world region (row)
* consumed in each region (regg), the corresponding basic price in the
* calibration year is equal to 1
CONS_H_ROW(row,prd,regg)
    = sum(fd$fd_assign(fd,'Households'), FINAL_USE_ROW(row,prd,regg,fd) ) ;

Display
CONS_H_D
CONS_H_M
CONS_H_T
CONS_H
CONS_H_ROW
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

* Government consumption of products imported from rest of the world regions in
* volume of each product (prd) produced in each rest of the world region (row)
* consumed in each region (regg), the corresponding basic price in the
* calibration year is equal to 1
CONS_G_ROW(row,prd,regg)
    = sum(fd$fd_assign(fd,'Government'), FINAL_USE_ROW(row,prd,regg,fd) ) ;

Display
CONS_G_D
CONS_G_M
CONS_G_T
CONS_G
CONS_G_ROW
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

* Investment (gross fixed capital formation) in products imported from rest of
* the world regions in volume of each product (prd) produced in each rest of the
* world region (row) consumed in each region (regg), the corresponding basic
* price in the calibration year is equal to 1
GFCF_ROW(row,prd,regg)
    = sum(fd$fd_assign(fd,'GrossFixCapForm'), FINAL_USE_ROW(row,prd,regg,fd) ) ;

Display
GFCF_D
GFCF_M
GFCF_T
GFCF
GFCF_ROW
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

* Stock change in products imported from rest of the world regions in volume of
* each product (prd) produced in each rest of the world region (row) consumed in
* each region (regg), the corresponding basic price in the calibration year is
* equal to 1
SV_ROW(row,prd,regg)
    = sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_ROW(row,prd,regg,fd) ) ;


Display
SV
SV_ROW
;


* Aggregated import of products in volume of each product (prd) into each
* importing region (regg), the corresponding basic price in the base year is
* equal to 1. This import value includes only trade with modeled regions and
* only intended for intermediate use, household and government consumption and
* investments in gross fixed capital formation
IMPORT(prd,regg)
    = sum(ind, INTER_USE_M(prd,regg,ind) ) +
    CONS_H_M(prd,regg) + CONS_G_M(prd,regg) + GFCF_M(prd,regg) ;

* Trade of products for each product (prd) between each region pair (reg-regg),
* the corresponding basic price in the base year is equal to 1, purchaser's
* price can be different from 1 in case of non-zero taxes on products in the
* exporting region. By definition, trade of a region with itself it equal to 0.
* This includes only trade with modeled regions and only intended for
* intermediate use, household and government consumption and investments in
* gross fixed capital formation.
TRADE(reg,prd,regg)
    = sum(ind, INTER_USE(reg,prd,regg,ind) ) + CONS_H(reg,prd,regg) +
    CONS_G(reg,prd,regg) + GFCF(reg,prd,regg) ;
TRADE(reg,prd,reg) = 0 ;

Display
IMPORT
TRADE
;


* Supply in volume of each production factor (kl) in each region (reg), the
* corresponding basic price in the base year is equal to 1, market price can be
* different from 1 in case of non-zero taxes on factors of production
KLS(reg,kl)
    = sum((regg,ind),VALUE_ADDED(reg,kl,regg,ind) ) ;

* Total budget in value available for household consumption in each region
* (regg)
CBUD_H(regg)
    = sum(prd, CONS_H_D(prd,regg) ) + sum(prd, CONS_H_M(prd,regg) ) +
    sum((row,prd), CONS_H_ROW(row,prd,regg) ) +
    sum(fd$fd_assign(fd,'Households'), sum(prd, FINAL_USE_dt(prd,regg,fd) ) ) ;

* Total budget in value available for government consumption in each region
* (regg)
CBUD_G(regg)
    = sum(prd, CONS_G_D(prd,regg) ) + sum(prd, CONS_G_M(prd,regg) ) +
    sum((row,prd), CONS_G_ROW(row,prd,regg) ) +
    sum(fd$fd_assign(fd,'Government'), sum(prd, FINAL_USE_dt(prd,regg,fd) ) ) ;

* Total budget in value available for investment agent for gross fixed capital
* formation in each region (regg)
CBUD_I(regg)
    = sum(prd, GFCF_D(prd,regg) ) + sum(prd, GFCF_M(prd,regg) ) +
    sum((row,prd), GFCF_ROW(row,prd,regg) ) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum(prd, FINAL_USE_dt(prd,regg,fd) ) ) ;

* Total income in value of households in each region (regg), the total income
* consists of the consumption budget plus all the transfers from households to
* other agents and payments to other regions for international margin and taxes
* export
INC_H(regg)
    = CBUD_H(regg) +
    sum(fd$fd_assign(fd,'Households'),
    sum((reg,fdd), INCOME_DISTR(regg,fd,reg,fdd) ) +
    sum((reg,tim), TAX_FINAL_USE(reg,tim,regg,fd) ) +
    sum((row,tim), TAX_FINAL_USE_ROW(row,tim,regg,fd) ) ) ;

* Total income in value of government in each region (regg), the total income
* consists of the consumption budget plus all the transfers from government to
* other agents and payments to other regions for international margin and taxes
* export
INC_G(regg)
    = CBUD_G(regg) +
    sum(fd$fd_assign(fd,'Government'),
    sum((reg,fdd), INCOME_DISTR(regg,fd,reg,fdd) ) +
    sum((reg,va), TAX_FINAL_USE(reg,va,regg,fd) ) +
    sum((row,va), TAX_FINAL_USE_ROW(row,va,regg,fd) ) ) ;

* Total income in value of investment agent in each region (regg), the total
* income consists of the investment budget plus all the transfers from the
* investment agent to other agents (including for stock changes) and payments to
* other regions for international margins and taxes on export
INC_I(regg)
    = CBUD_I(regg) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum((reg,fdd), INCOME_DISTR(regg,fd,reg,fdd) ) +
    sum((reg,va), TAX_FINAL_USE(reg,va,regg,fd) ) +
    sum((row,va), TAX_FINAL_USE_ROW(row,va,regg,fd) ) ) ;

Display
KLS
CBUD_H
CBUD_G
CBUD_I
INC_H
INC_G
INC_I
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
* purchaser's price of household consumption, tax rate differs by product (prd)
* in each region (regg)
tc_h(prd,regg)$sum(fd$fd_assign(fd,'Households'), FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'Households'), FINAL_USE_dt(prd,regg,fd) ) /
    ( CONS_H_T(prd,regg) + sum(row, CONS_H_ROW(row,prd,regg) ) ) ;

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of government consumption, tax rate differs by product (prd)
* in each region (regg)
tc_g(prd,regg)$sum(fd$fd_assign(fd,'Government'), FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'Government'), FINAL_USE_dt(prd,regg,fd) ) /
    ( CONS_G_T(prd,regg) + sum(row, CONS_G_ROW(row,prd,regg) ) ) ;

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of gross fixed capital formation, tax rate differs by
* product (prd) in each region (regg)
tc_gfcf(prd,regg)$sum(fd$fd_assign(fd,'GrossFixCapForm'),
    FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'GrossFixCapForm'), FINAL_USE_dt(prd,regg,fd) ) /
    ( GFCF_T(prd,regg) + sum(row, GFCF_ROW(row,prd,regg) ) ) ;

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of stock changes, tax rate differs by product (prd) in each
* region (regg)
tc_sv(prd,regg)$sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_dt(prd,regg,fd) ) /
    ( sum(reg, SV(reg,prd,regg) ) + sum(row, SV_ROW(row,prd,regg) ) ) ;

* Net tax (taxes less subsidies) rates on production activities
txd_ind(reg,regg,ind)$sum(ntp, VALUE_ADDED(reg,ntp,regg,ind) )
    = sum(ntp, VALUE_ADDED(reg,ntp,regg,ind) ) / Y(regg,ind) ;

* Rates of net taxes paid on import to exporting regions and rates of
* international margins paid to exporting regions. Taxes on exports and
* international margins are modeled as ad valorem tax on value of output,
* tax rates differs by industry (ind) and region of consumption (regg).
txd_tim(reg,regg,ind)$sum(tim, VALUE_ADDED(reg,tim,regg,ind) )
    = sum(tim, VALUE_ADDED(reg,tim,regg,ind) ) / Y(regg,ind) ;

Display
tc_ind
tc_h
tc_g
tc_gfcf
tc_sv
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
    ( sum((reggg,kll), VALUE_ADDED(reggg,kll,regg,ind) ) / tfp(regg,ind) )  *
    tfp(regg,ind)**( -elasKL(regg,ind) ) ;

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

* Relative share parameter for household consumption of aggregated products
* for each product (prd) in each region (regg)
theta_h(prd,regg)$CONS_H_T(prd,regg)
    = CONS_H_T(prd,regg) / sum(prdd, CONS_H_T(prdd,regg) ) *
    ( 1 / ( 1 + tc_h(prd,regg) ) )**( -elasFU_H(regg) ) ;

* Relative share parameter for household consumption of domestic products,
* versus aggregated products imported from modeled regions, for each product
* (prd) in each region (regg)
theta_h_dom(prd,regg)$CONS_H_D(prd,regg)
    = CONS_H_D(prd,regg) / CONS_H_T(prd,regg) *
    ( ( 1 + tc_h(prd,regg) ) / 1 )**( -elasFU_DM(prd,regg) ) ;

* Relative share parameter for household consumption of aggregated products
* imported from modeled regions, versus domestic products, for each product
* (prd) in each region (regg)
theta_h_imp(prd,regg)$CONS_H_M(prd,regg)
    = CONS_H_M(prd,regg) / CONS_H_T(prd,regg) *
    ( ( 1 + tc_h(prd,regg) ) / 1 )**( -elasFU_DM(prd,regg) ) ;

* Coefficients for household consumption of products imported from the rest of
* the world for each type of product (prd) from each rest of the world regions
* (row) in each region (regg)
theta_h_row(row,prd,regg)$CONS_H_ROW(row,prd,regg)
    = CONS_H_ROW(row,prd,regg) / CBUD_H(regg) ;


* Relative share parameter for government consumption of aggregated products
* for each product (prd) in each region (regg)
theta_g(prd,regg)$CONS_G_T(prd,regg)
    = CONS_G_T(prd,regg) / sum(prdd, CONS_G_T(prdd,regg) ) *
    ( 1 / ( 1 + tc_g(prd,regg) ) )**( -elasFU_G(regg) ) ;

* Relative share parameter for government consumption of domestic products,
* versus aggregated products imported from modeled regions, for each product
* (prd) in each region (regg)
theta_g_dom(prd,regg)$CONS_G_D(prd,regg)
    = CONS_G_D(prd,regg) / CONS_G_T(prd,regg) *
    ( ( 1 + tc_g(prd,regg) ) / 1 )**( -elasFU_DM(prd,regg) ) ;

* Relative share parameter for government consumption of aggregated products
* imported from modeled regions, versus domestic products, for each product
* (prd) in each region (regg)
theta_g_imp(prd,regg)$CONS_G_M(prd,regg)
    = CONS_G_M(prd,regg) / CONS_G_T(prd,regg) *
    ( ( 1 + tc_g(prd,regg) ) / 1 )**( -elasFU_DM(prd,regg) ) ;

* Coefficients for government consumption of products imported from the rest of
* the world for each type of product (prd) from each rest of the world regions
* (row) in each region (regg)
theta_g_row(row,prd,regg)$CONS_G_ROW(row,prd,regg)
    = CONS_G_ROW(row,prd,regg) / CBUD_G(regg) ;

* Coefficients for household consumption of products imported from the rest of
* the world for each type of product (prd) from each rest of the world regions
* (row) in each region (regg)
theta_h_row(row,prd,regg)$CONS_H_ROW(row,prd,regg)
    = CONS_H_ROW(row,prd,regg) / CBUD_H(regg) ;


* Relative share parameter for gross fixed capital formation of aggregated
* products for each product (prd) in each region (regg)
theta_gfcf(prd,regg)$GFCF_T(prd,regg)
    = GFCF_T(prd,regg) / sum(prdd, GFCF_T(prdd,regg) ) *
    ( 1 / ( 1 + tc_gfcf(prd,regg) ) )**( -elasFU_I(regg) ) ;

* Relative share parameter for gross fixed capital formation of domestic
* products, versus aggregated products imported from modeled regions, for each
* product (prd) in each region (regg)
theta_gfcf_dom(prd,regg)$GFCF_D(prd,regg)
    = GFCF_D(prd,regg) / GFCF_T(prd,regg) *
    ( ( 1 + tc_gfcf(prd,regg) ) / 1 )**( -elasFU_DM(prd,regg) ) ;

* Relative share parameter for gross fixed capital formation of aggregated
* products imported from modeled regions, versus domestic products, for each
* product (prd) in each region (regg)
theta_gfcf_imp(prd,regg)$GFCF_M(prd,regg)
    = GFCF_M(prd,regg) / GFCF_T(prd,regg) *
    ( ( 1 + tc_gfcf(prd,regg) ) / 1 )**( -elasFU_DM(prd,regg) ) ;

* Coefficients for gross fixed capital formation of products imported from the
* rest of the world for each type of product (prd) from each rest of the world
* regions (row) in each region (regg)
theta_gfcf_row(row,prd,regg)$GFCF_ROW(row,prd,regg)
    = GFCF_ROW(row,prd,regg) / CBUD_I(regg) ;

* Share coefficient for stock changes in each product (prd) from each region
* of origin (reg) to each region of destination (regg)
theta_sv(reg,prd,regg)$SV(reg,prd,regg)
    = SV(reg,prd,regg) / X(reg,prd) ;

Display
theta_h
theta_h_dom
theta_h_imp
theta_h_row
theta_g
theta_g_dom
theta_g_imp
theta_g_row
theta_gfcf
theta_gfcf_dom
theta_gfcf_imp
theta_gfcf_row
theta_sv
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



*## Distribution of value added revenues to final consumers ##

* Distribution shares of factor revenues to household budget for each factor
* type (reg,kl) in each region (regg)
fac_distr_h(reg,kl,regg)$sum(fd$fd_assign(fd,'Households'),
    VALUE_ADDED_DISTR(reg,kl,regg,fd) )
    = sum(fd$fd_assign(fd,'Households'), VALUE_ADDED_DISTR(reg,kl,regg,fd) ) /
    sum((reggg,fdd), VALUE_ADDED_DISTR(reg,kl,reggg,fdd) ) ;

* Distribution shares of factor revenues to government budget for each factor
* type (reg,kl) in each region (regg)
fac_distr_g(reg,kl,regg)$sum(fd$fd_assign(fd,'Government'),
    VALUE_ADDED_DISTR(reg,kl,regg,fd) )
    = sum(fd$fd_assign(fd,'Government'), VALUE_ADDED_DISTR(reg,kl,regg,fd) ) /
    sum((reggg,fdd), VALUE_ADDED_DISTR(reg,kl,reggg,fdd) ) ;

fac_distr_gfcf(reg,kl,regg)$sum(fd$fd_assign(fd,'GrossFixCapForm'),
    VALUE_ADDED_DISTR(reg,kl,regg,fd) )
    = sum(fd$fd_assign(fd,'GrossFixCapForm'),
    VALUE_ADDED_DISTR(reg,kl,regg,fd) ) /
    sum((reggg,fdd), VALUE_ADDED_DISTR(reg,kl,reggg,fdd) ) ;

Display
fac_distr_h
fac_distr_g
fac_distr_gfcf
;
