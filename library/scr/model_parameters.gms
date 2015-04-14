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
    elasIMP_ROW(prd,regg)       substitution elasticity between imports from
                                # rest of the world and aggregated import from
                                # modeled regions
    elasTRD(prd,regg)           substitution elasticity between imports from
                                # different modeled regions
    fprod(va,regg,ind)          parameter on productivity on individual factors
                                # in the nest of aggregated factors of
                                # production

    elasFU_data(fd,*)           data on elasticities (final demand)
    elasTRADE_data(prd,*)       data on elasticities of import or domestic
                                #supply (Armington)
    elasPROD_data(ind,*)        data on substitution elasticities in production
                                #nests

    FPROD_data(ind,va)          data on initial level of factor productivity

    Y(regg,ind)                 output vector by activity (volume)
    X(reg,prd)                  output vector by product (volume)
    INTER_USE_T(prd,regg,ind)   intermediate use on product level (volume)
    INTER_USE(reg,prd,regg,ind) intermediate use of products on the level of
                                # product and producing region (volume)

    CONS_H_D(prd,regg)          household consumption of domestic products
                                # (volume)
    CONS_H_M(prd,regg)          household consumption of imported products (from
                                # modeled and rest of the world regions)
                                # (volume)
    CONS_H_T(prd,regg)          household consumption on product level (volume)
    CONS_H(reg,prd,regg)        household consumption of products on the level
                                # of product and producing region (volume)

    CONS_G_D(prd,regg)          government consumption of domestic products
                                # (volume)
    CONS_G_M(prd,regg)          government consumption of imported products
                                # (from modeled and rest of the world regions)
                                # (volume)
    CONS_G_T(prd,regg)          government consumption on product level (volume)
    CONS_G(reg,prd,regg)        government consumption of products on the level
                                # of product and producing region (volume)

    GFCF_D(prd,regg)            investment (gross fixed capital formation) in
                                # domestic products (volume)
    GFCF_M(prd,regg)            investment (gross fixed capital formation) in
                                # imported products (from modeled and rest of
                                # the world regions) (volume)
    GFCF_T(prd,regg)            investment (gross fixed capital formation) on
                                # product level (volume)
    GFCF(reg,prd,regg)          investment (gross fixed capital formation) in
                                # products on the level of product and producing
                                # region (volume)

    SV(reg,prd,regg)            stock changes of products on the level of
                                # product and producing region (volume)
    SV_ROW(prd,regg)            stock changes of products imported from rest of
                                # the world regions (volume)

    IMPORT_T(prd,regg)          total import of products into a region (from
                                # modeled and rest of the world regions) for
                                # intermediate use, household and government
                                # consumption and investments (volume)
    IMPORT_MOD(prd,regg)        import of products into a region from modeled
                                # regions for intermediate use, household and
                                # government consumption and investments
                                # (volume)
    TRADE(reg,prd,regg)         trade of products between modeled regions for
                                # intermediate use, household and government
                                #consumption and investments (volume)

    KLS(reg,va)                 supply of production factors (volume)
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

    GDP(regg)                   gross domestic product (value)

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
    alpha(reg,va,regg,ind)      relative share parameter for factors of
                                # production within the aggregated nest
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
    theta_g(prd,regg)           relative share parameter of government
                                # consumption on product level in total
                                # government demand (relation in volume)
    theta_g_dom(prd,regg)       relative share parameter for government
                                # consumption of domestic products (relation in
                                # volume)
    theta_g_imp(prd,regg)       relative share parameter for government
                                # consumption of products imported from modeled
                                # regions (relation in volume)
    theta_gfcf(prd,regg)        relative share parameter of gross fixed capital
                                # formation on product level in total investment
                                # demand (relation in volume)
    theta_gfcf_dom(prd,regg)    relative share parameter for gross fixed capital
                                # formation of domestic products (relation in
                                # volume)
    theta_gfcf_imp(prd,regg)    relative share parameter for gross fixed capital
                                # formation of products imported from modeled
                                # regions (relation in volume)
    theta_sv(reg,prd,regg)      share coefficients for stock changes in products
                                # produced in the modeled regions (relation in
                                # volume)

    gamma_mod(prd,regg)         relative share parameter for imports originating
                                # from one of the modeled regions (relation in
                                # volume)
    gamma_row(prd,regg)         relative share parameter for imports originating
                                # from rest of the world region (relation in
                                # volume)
    gamma_trd(reg,prd,regg)     relative share parameter for origin region of
                                # import (relation in volume)
    gamma_exp(reg,prd)          share coefficients for export to rest of the
                                # world regions (relation in volume)
    fac_distr_h(reg,va,regg)    distribution shares of factor income to
                                # household budget (shares in value)
    fac_distr_g(reg,va,regg)    distribution shares of factor income to
                                # government budget (shares in value)
    fac_distr_gfcf(reg,va,regg) distribution shares of factor income to
                                # gross fixed capital formation budget (shares
                                # in value)
    ty(regg)                    household income tax rate
    mps(regg)                   household marginal propensity to save
    GTRF(regg)                  government social transfers
    GSAV(regg)                  government savings

    tc_ind_0(prd,regg,ind)      calibrated tax and subsidies on products rates
                                # for industries (relation in value)
    tc_h_0(prd,regg)            calibrated tax and subsidies on products rates
                                # for household consumption (relation in value)
    tc_g_0(prd,regg)            calibrated tax and subsidies on products rates
                                # for government consumption (relation in value)
    tc_gfcf_0(prd,regg)         calibrated tax and subsidies on products rates
                                # for gross fixed capital formation (relation in
                                # value)
    tc_sv_0(prd,regg)           calibrated tax and subsidies on products rates
                                # for stock changes (relation in value)
;

* ========================== Definition of parameters ==========================

*Here project-specific data are read in. Data should be placed in %project%/data/.

*## Elasticities ##

$libinclude xlimport elasFU_data ././%project%/data/Eldata.xlsx elasFU!a1..zz10000 ;
$libinclude xlimport elasTRADE_data ././%project%/data/Eldata.xlsx elasTRADE!a1..zz10000 ;
$libinclude xlimport elasPROD_data ././%project%/data/Eldata.xlsx elasPROD!a1..zz10000 ;

*## Total Factor Productivity ##

$libinclude xlimport FPROD_data ././%project%/data/Eldata.xlsx FPROD!a1..zz10000 ;

loop((ind,kl),
    ABORT$( FPROD_data(ind,kl) eq 0 )
        "Initial level of factor productivity cannot be 0. See file Eldata.xlsx sheet FPROD" ;

) ;


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

* Substitution elasticity between imports in volume from rest of the world
* region and aggregated import from modeled regions. The elasticity value can be
* different for each product (prd) and each importing region (regg)
elasIMP_ROW(prd,regg)
    = elasTRADE_data(prd,'elasIMP_ROW') ;

* Substitution elasticity between imports in volume from different modeled
* regions. The elasticity value can be different for each product (prd) and each
* importing region (regg)
elasTRD(prd,regg)
    = elasTRADE_data(prd,'elasTRD') ;

* Parameter on initial level of productivity of individual factors of
* production. The parameter value is usually calibrated to 1 for each factor
* type (kl) in each industry (ind) in each region (regg)
fprod(kl,regg,ind)
    = FPROD_data(ind,kl) ;


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
    ( sum(reggg, TRADE(reggg,prd,regg) ) +
    IMPORT_ROW(prd,regg) ) )$(not sameas(reg,regg)) ;

Display
INTER_USE_T
INTER_USE
;


* Household consumption of domestic products in volume of each product (prd) in
* each region (regg), the corresponding basic price in the calibration year is
* equal to 1
CONS_H_D(prd,regg)
    = sum(fd$fd_assign(fd,'Households'), FINAL_USE_D(prd,regg,fd) ) ;

* Household consumption of imported products in volume of each product (prd) in
* each region (regg), the corresponding basic price in the calibration year is
* equal to 1
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
    ( sum(reggg, TRADE(reggg,prd,regg) ) +
    IMPORT_ROW(prd,regg) ) )$(not sameas(reg,regg)) ;

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

* Government consumption of imported products in volume of each product (prd) in
* each region (regg), the corresponding basic price in the calibration year is
* equal to 1
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
    ( sum(reggg, TRADE(reggg,prd,regg) ) +
    IMPORT_ROW(prd,regg) ) )$(not sameas(reg,regg)) ;

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

* Investment (gross fixed capital formation) in imported products in volume of
* each product (prd) in each region (regg), the corresponding basic price in the
* calibration year is equal to 1
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
    ( sum(reggg, TRADE(reggg,prd,regg) ) +
    IMPORT_ROW(prd,regg) ) )$(not sameas(reg,regg)) ;

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
    ( sum(reggg, TRADE(reggg,prd,regg) ) +
    IMPORT_ROW(prd,regg) ) )$(not sameas(reg,regg)) ;

* Stock change in products imported from rest of the world regions in volume of
* each product (prd) consumed in each region (regg), the corresponding basic
* price in the calibration year is equal to 1
SV_ROW(prd,regg)$IMPORT_ROW(prd,regg)
    = sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_M(prd,regg,fd) ) *
    IMPORT_ROW(prd,regg) /
    ( sum(reggg, TRADE(reggg,prd,regg) ) + IMPORT_ROW(prd,regg) ) ;


Display
SV
SV_ROW
;


* Aggregated total import of products in volume of each product (prd) into each
* importing region (regg), the corresponding basic price in the base year is
* equal to 1. This import value includes only trade intended for intermediate
* use, household and government consumption and investments in gross fixed
* capital formation, so excluding stock changes
IMPORT_T(prd,regg)
    = sum(ind, INTER_USE_M(prd,regg,ind) ) +
    CONS_H_M(prd,regg) + CONS_G_M(prd,regg) + GFCF_M(prd,regg) ;

* Recalculate import volume from rest of the world so that it excludes values
* intended for stock changes
IMPORT_ROW(prd,regg)
    = IMPORT_ROW(prd,regg) - SV_ROW(prd,regg) ;

* Aggregated import of products from modeled regions in volume of each product
* (prd) into each importing region (regg), the corresponding basic price in the
* base year is equal to 1. This import value includes only trade intended for
* intermediate use, household and government consumption and investments in
* gross fixed capital formation, so excluding stock changes
IMPORT_MOD(prd,regg)
    = IMPORT_T(prd,regg) - IMPORT_ROW(prd,regg) ;

* Trade of products for each product (prd) between each region pair (reg-regg),
* the corresponding basic price in the base year is equal to 1, purchaser's
* price can be different from 1 in case of non-zero taxes on products in the
* exporting region. By definition, trade of a region with itself it equal to 0.
* This includes only trade with modeled regions and only intended for
* intermediate use, household and government consumption and investments in
* gross fixed capital formation, so excluding stock changes
TRADE(reg,prd,regg)
    = sum(ind, INTER_USE(reg,prd,regg,ind) ) + CONS_H(reg,prd,regg) +
    CONS_G(reg,prd,regg) + GFCF(reg,prd,regg) ;
TRADE(reg,prd,reg) = 0 ;

Display
IMPORT_T
IMPORT_ROW
IMPORT_MOD
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
    sum(fd$fd_assign(fd,'Households'), sum(prd, FINAL_USE_dt(prd,regg,fd) ) ) ;

* Total budget in value available for government consumption in each region
* (regg)
CBUD_G(regg)
    = sum(prd, CONS_G_D(prd,regg) ) + sum(prd, CONS_G_M(prd,regg) ) +
    sum(fd$fd_assign(fd,'Government'), sum(prd, FINAL_USE_dt(prd,regg,fd) ) ) ;

* Total budget in value available for investment agent for gross fixed capital
* formation in each region (regg)
CBUD_I(regg)
    = sum(prd, GFCF_D(prd,regg) ) + sum(prd, GFCF_M(prd,regg) ) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum(prd, FINAL_USE_dt(prd,regg,fd) ) ) ;

* Gross income of households from production factors in each region (regg). The
* gross income value includes only income received from production factors, but
* excludes transfers from other final user in the same region and transfers from
* abroad. The gross income value is used to calculated income tax rate
GRINC_H(regg)
    = sum((reg,kl), sum(fd$fd_assign(fd,'Households'),
    VALUE_ADDED_DISTR(reg,kl,regg,fd) ) ) ;

* Gross income of government in each region (regg) from production factors,
* collected taxes on production, international margins and taxes on exports, as
* well as domestically collected taxes on products. The gross income value
* excludes household income taxes
GRINC_G(regg)
    = sum((reg,kl), sum(fd$fd_assign(fd,'Government'),
    VALUE_ADDED_DISTR(reg,kl,regg,fd) ) ) +
    sum((reg,ntp), sum(fd$fd_assign(fd,'Government'),
    VALUE_ADDED_DISTR(reg,ntp,regg,fd) ) ) +
    sum((reg,tim), sum(fd$fd_assign(fd,'Government'),
    VALUE_ADDED_DISTR(reg,tim,regg,fd) ) ) +
    sum((reg,tsp), sum(fd$fd_assign(fd,'Government'),
    TAX_SUB_PRD_DISTR(reg,tsp,regg,fd) ) ) ;

* Gross income of investment agent in each region (regg). The gross income value
* includes only income received from production factors, but excludes transfers
* from other final user in the same region and transfers from abroad.
GRINC_I(regg)
    = sum((reg,kl), sum(fd$fd_assign(fd,'GrossFixCapForm'),
    VALUE_ADDED_DISTR(reg,kl,regg,fd) ) ) ;

Display
KLS
CBUD_H
CBUD_G
CBUD_I
GRINC_H
GRINC_G
GRINC_I
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
* each industry (ind) in each region (regg)
tc_ind(prd,regg,ind)$INTER_USE_dt(prd,regg,ind)
    = INTER_USE_dt(prd,regg,ind) / INTER_USE_T(prd,regg,ind) ;

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of household consumption, tax rate differs by product (prd)
* in each region (regg)
tc_h(prd,regg)$sum(fd$fd_assign(fd,'Households'), FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'Households'), FINAL_USE_dt(prd,regg,fd) ) /
    CONS_H_T(prd,regg) ;

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of government consumption, tax rate differs by product (prd)
* in each region (regg)
tc_g(prd,regg)$sum(fd$fd_assign(fd,'Government'), FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'Government'), FINAL_USE_dt(prd,regg,fd) ) /
    CONS_G_T(prd,regg) ;

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of gross fixed capital formation, tax rate differs by
* product (prd) in each region (regg)
tc_gfcf(prd,regg)$sum(fd$fd_assign(fd,'GrossFixCapForm'),
    FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'GrossFixCapForm'), FINAL_USE_dt(prd,regg,fd) ) /
    GFCF_T(prd,regg) ;

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of stock changes, tax rate differs by product (prd) in each
* region (regg)
tc_sv(prd,regg)$sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_dt(prd,regg,fd) ) /
    ( sum(reg, SV(reg,prd,regg) ) + SV_ROW(prd,regg) ) ;

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
    ( sum((reggg,kll), VALUE_ADDED(reggg,kll,regg,ind) ) /
    fprod(kl,regg,ind) )  *
    fprod(kl,regg,ind)**( -elasKL(regg,ind) ) ;

Display
coprodA
coprodB
ioc
phi_dom
phi_imp
aVA
alpha
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


* Share coefficient for stock changes in each product (prd) from each region
* of origin (reg) to each region of destination (regg)
theta_sv(reg,prd,regg)$SV(reg,prd,regg)
    = SV(reg,prd,regg) / X(reg,prd) ;

Display
theta_h
theta_h_dom
theta_h_imp
theta_g
theta_g_dom
theta_g_imp
theta_gfcf
theta_gfcf_dom
theta_gfcf_imp
theta_sv
;



*## Parameters of international trade ##

* Relative share parameter for import originating from one of the modeled
* regions for each product (prd) for each region of destination (regg)
gamma_mod(prd,regg)$IMPORT_MOD(prd,regg)
    = IMPORT_MOD(prd,regg) / IMPORT_T(prd,regg) *
    ( 1 / 1 )**( -elasIMP_ROW(prd,regg) ) ;

* Relative share parameter for import originating from rest of the world region
* for each product (prd) for each region of destination (regg)
gamma_row(prd,regg)$IMPORT_ROW(prd,regg)
    = IMPORT_ROW(prd,regg) / IMPORT_T(prd,regg) *
    ( 1 / 1 )**( -elasIMP_ROW(prd,regg) ) ;

* Relative share parameter for import from different regions for each product
* (prd) for each region of origin (reg) for each region of destination (regg)
gamma_trd(reg,prd,regg)$TRADE(reg,prd,regg)
    = TRADE(reg,prd,regg) / IMPORT_MOD(prd,regg) *
    ( 1 / 1 )**( -elasTRD(prd,regg) ) ;

* Share coefficient for export of each product (prd) from each region of origin
* (prd)
gamma_exp(reg,prd)$EXPORT_ROW(reg,prd)
    = EXPORT_ROW(reg,prd) / X(reg,prd) ;

Display
gamma_mod
gamma_row
gamma_trd
gamma_exp
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



*## Income transfers between final consumers ##

* Income tax rate, income tax is a transfer from households to the government
* in the same region (regg). Income tax rate is calculate as percentage of
* household gross income from factors of production
ty(regg)
    = sum(fd$fd_assign(fd,'Households'),
    sum(fdd$fd_assign(fdd,'Government'), INCOME_DISTR(regg,fd,regg,fdd) ) ) /
    GRINC_H(regg) ;

* Household marginal propensity to save, households saving is a transfer from
* households to the investment agent in the same region (regg). Marginal
* propensity to save is calculated as percentage of household net income (gross
* minus income tax)
mps(regg)
    = sum(fd$fd_assign(fd,'Households'),
    sum(fdd$fd_assign(fdd,'GrossFixCapForm'),
    INCOME_DISTR(regg,fd,regg,fdd) ) ) /
    ( GRINC_H(regg) * ( 1 - ty(regg) ) ) ;

* Social transfers from government to households in the same region (regg). This
* value will be take as exogenous in the model.
GTRF(regg)
    = sum(fd$fd_assign(fd,'Government'),
    sum(fdd$fd_assign(fdd,'Households'),
    INCOME_DISTR(regg,fd,regg,fdd) ) ) ;

* Government savings, which is a transfer from from government to the investment
* agent in the same region (regg). This value will be take as exogenous in the
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
* part of simulation set-up and the initial calibrated tax rates are then needed
* for correct calculation of price indexes.
tc_ind_0(prd,regg,ind) = tc_ind(prd,regg,ind) ;
tc_h_0(prd,regg)       = tc_h(prd,regg) ;
tc_g_0(prd,regg)       = tc_g(prd,regg) ;
tc_gfcf_0(prd,regg)    = tc_gfcf(prd,regg) ;
tc_sv_0(prd,regg)      = tc_sv(prd,regg) ;
