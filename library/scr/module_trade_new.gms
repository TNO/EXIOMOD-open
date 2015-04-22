* File:   library/scr/module_.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 9 June 2014 (simple CGE formulation)

* gams-master-file: main.gms

$ontext startdoc
This GAMS file defines the parameters that are used in the model. Please start from `main.gms`.

This `.gms` file is one of the `.gms` files part of the `main.gms` file and includes the equations and model formulation. Please start from `main.gms`.

No changes should be made in this file, as the parameters declared here are all defined using their standard definitions.

This `.gms` file consists of the following parts:

Phase 1: Additional sets and subsets

Phase 2: Declaration of parameters

Phase 3: Calibration of parameters

Phase 4: Declaration of variables and equations

Phase 5: Definition of equations 

Phase 6: Setting levels, lower and upper bounds, fixed variables, and scale variables

$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ========================= Phase 1: Additional sets and subsets ===============
$if not '%phase%' == 'additional_sets' $goto end_additional_sets

$label end_additional_sets

* ========================= Phase 2: Declaration of parameters =================
$if not '%phase%' == 'parameters_declaration' $goto end_parameters_declaration

* ========================= Declaration of parameters ==========================

Parameters
    elasIU_DM(prd,regg,ind)     substitution elasticity between domestic and
                                # imported intermediate use
    elasFU_DM(prd,regg)         substitution elasticity between domestic and
                                # imported final use for all categories
    elasIMP_ROW(prd,regg)       substitution elasticity between imports from
                                # rest of the world and aggregated import from
                                # modeled regions
    elasTRD(prd,regg)           substitution elasticity between imports from
                                # different modeled regions
    elasTRADE_data(prd,*)       data on elasticities of import or domestic
                                #supply (Armington)
    CONS_H_D(prd,regg)          household consumption of domestic products
                                # (volume)
    CONS_H_M(prd,regg)          household consumption of imported products (from
                                # modeled and rest of the world regions)
                                # (volume)
    CONS_H(reg,prd,regg)        household consumption of products on the level
                                # of product and producing region (volume)

    CONS_G_D(prd,regg)          government consumption of domestic products
                                # (volume)
    CONS_G_M(prd,regg)          government consumption of imported products
                                # (from modeled and rest of the world regions)
                                # (volume)
    CONS_G(reg,prd,regg)        government consumption of products on the level
                                # of product and producing region (volume)

    GFCF_D(prd,regg)            investment (gross fixed capital formation) in
                                # domestic products (volume)
    GFCF_M(prd,regg)            investment (gross fixed capital formation) in
                                # imported products (from modeled and rest of
                                # the world regions) (volume)
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
    tc_sv(prd,regg)             tax and subsidies on products rates for
                                # stock changes (relation in value)
    txd_tim(reg,regg,ind)       rates of net taxes on exports and rates of
                                # international margins (relation in value)
    phi_dom(prd,regg,ind)       relative share parameter for intermediate use
                                # of domestic products (relation in volume)
    phi_imp(prd,regg,ind)       relative share parameter for intermediate use
                                # of imported products (relation in volume)
    theta_h_dom(prd,regg)       relative share parameter for household
                                # consumption of domestic products (relation in
                                # volume)
    theta_h_imp(prd,regg)       relative share parameter for household
                                # consumption of products imported from modeled
                                # regions (relation in volume)
    theta_g_dom(prd,regg)       relative share parameter for government
                                # consumption of domestic products (relation in
                                # volume)
    theta_g_imp(prd,regg)       relative share parameter for government
                                # consumption of products imported from modeled
                                # regions (relation in volume)
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
    tc_sv_0(prd,regg)           calibrated tax and subsidies on products rates
                                # for stock changes (relation in value)
;

$label end_parameters_declaration

* ========================== Phase 3: Definition of parameters ==========================
$if not '%phase%' == 'parameters_calibration' $goto end_parameters_calibration

*Here project-specific data are read in. Data should be placed in %project%/data/.

*## Elasticities ##

$libinclude xlimport elasTRADE_data %project%/data/Eldata.xlsx elasTRADE!a1..zz10000 ;

* Substitution elasticity between domestic and aggregated imported products in
* volume for intermediate use. The elasticity value can be different for each
* product (prd) in each industry (ind) in each region (regg)
elasIU_DM(prd,regg,ind)
    = elasTRADE_data(prd,'elasIU_DM') ;

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

* *## Aggregates ##

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

*## Tax rates ##

* Net tax (taxes less subsidies) rates on aggregated products included into
* purchaser's price of stock changes, tax rate differs by product (prd) in each
* region (regg)
tc_sv(prd,regg)$sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_dt(prd,regg,fd) ) /
    ( sum(reg, SV(reg,prd,regg) ) + SV_ROW(prd,regg) ) ;

* Rates of net taxes paid on import to exporting regions and rates of
* international margins paid to exporting regions. Taxes on exports and
* international margins are modeled as ad valorem tax on value of output,
* tax rates differs by industry (ind) and region of consumption (regg).
txd_tim(reg,regg,ind)$sum(tim, VALUE_ADDED(reg,tim,regg,ind) )
    = sum(tim, VALUE_ADDED(reg,tim,regg,ind) ) / Y(regg,ind) ;

Display
tc_sv
txd_tim
;



* *## Parameters of production function ##

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

Display
phi_dom
phi_imp
;

*## Parameters of final demand function ##

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


* * Relative share parameter for government consumption of aggregated products
* * for each product (prd) in each region (regg)
* theta_g(prd,regg)$CONS_G_T(prd,regg)
*     = CONS_G_T(prd,regg) / sum(prdd, CONS_G_T(prdd,regg) ) *
*     ( 1 / ( 1 + tc_g(prd,regg) ) )**( -elasFU_G(regg) ) ;

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
theta_h_dom
theta_h_imp
theta_g_dom
theta_g_imp
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

*## Store calibrated values in separated parameters ##
* Save calibrated values of tax rates separately. Change in a tax rate can be a
* part of simulation set-up and the initial calibrated tax rates are then needed
* for correct calculation of price indexes.
 tc_sv_0(prd,regg)      = tc_sv(prd,regg) ;

$label end_parameters_calibration

* ========================== Phase 4: Declaration of variables ==========================
$if not '%phase%' == 'equations_declaration' $goto end_equations_declaration

* ========================== 1. Declaration of variables ==========================

$ontext
Output by activity and product are here the variables which can be adjusted in the model. The variable `Cshock` is defined later in the `%simulation%` gms file.
$offtext

* Endogenous variables
Variables
    INTER_USE_D_V(prd,regg,ind)     use of domestically produced intermediate
                                    # inputs
    INTER_USE_M_V(prd,regg,ind)     use of aggregated imported intermediate
                                    # inputs
    CONS_H_D_V(prd,regg)            household consumption of domestically
                                    # produced products
    CONS_H_M_V(prd,regg)            household consumption of aggregated products
                                    # imported from modeled regions
    CONS_G_D_V(prd,regg)            government consumption of domestically
                                    # produced products
    CONS_G_M_V(prd,regg)            government consumption of aggregated
                                    # product imported from modeled regions
    GFCF_D_V(prd,regg)              gross fixed capital formation of
                                    # domestically produced products
    GFCF_M_V(prd,regg)              gross fixed capital formation of aggregated
                                    # product imported from modeled regions
    SV_V(reg,prd,regg)              stock changes of products on the most
                                    # detailed level
    IMPORT_T_V(prd,regg)            total use of aggregated imported products
    IMPORT_MOD_V(prd,regg)          aggregated import from modeled regions
    IMPORT_ROW_V(prd,regg)          import from rest of the world region
    TRADE_V(reg,prd,regg)           bi-lateral trade flows
    EXPORT_ROW_V(reg,prd)           export to the rest of the world regions
;

* Exogenous variables
Variables
    SV_ROW_V(prd,regg)              stock changes of rest of the world products
;

* ========================== Declaration of equations ============================

Equations
    EQINTU_D(prd,regg,ind)      demand for domestically produced intermediate
                                # inputs
    EQINTU_M(prd,regg,ind)      demand for aggregated imported intermediate
                                # inputs
    EQCONS_H_D(prd,regg)        demand of households for domesrically produced
                                # products
    EQCONS_H_M(prd,regg)        demand of households for aggregated products
                                # imported from modeled regions
    EQCONS_G_D(prd,regg)        demand of government for domesrically produced
                                # products
    EQCONS_G_M(prd,regg)        demand of government for aggregated products
                                # imported from modeled regions
    EQGFCF_D(prd,regg)          demand of investment agent for domesrically
                                # produced products
    EQGFCF_M(prd,regg)          demand of investment agent for aggregated
                                # products imported from modeled regions
    EQSV(reg,prd,regg)          demand for stock changes of products on the
                                # most detailed level
    EQIMP_T(prd,regg)           total demand for aggregared imported products
    EQIMP_MOD(prd,regg)         demand for aggregated import from modeled
                                # regions
    EQIMP_ROW(prd,regg)         demand for import from rest of the world region
    EQTRADE(reg,prd,regg)       demand for bi-lateral trade transactions
    EQEXP(reg,prd)              export supply to the rest of the world region
;

$label end_equations_declaration

* ========================== Phase 5: Definition of equations ===================
$if not '%phase%' == 'equations_definition' $goto end_equations_definition

* ## Beginning Block 1: Input-output ##

* EQUATION 1.4: Demand for domestically produced intermediate inputs. The demand
* function follows CES form, where demand of each industry (regg,ind) for each
* domestically produced product (prd) depends linearly on the demand of the same
* industry for the corresponding aggregated product and with certain elasticity
* on relative prices of domestically produced product and aggregated imported
* product.
EQINTU_D(prd,regg,ind)..
    INTER_USE_D_V(prd,regg,ind)
    =E=
    INTER_USE_T_V(prd,regg,ind) * phi_dom(prd,regg,ind) *
    ( P_V(regg,prd) /
    ( PIU_V(prd,regg,ind) * ( 1 + tc_ind(prd,regg,ind) ) ) )**
    ( -elasIU_DM(prd,regg,ind) ) ;

* EQUAION 1.5: Demand for aggregated imported intermediate inputs. The demand
* function follows CES form, where demand of each industry (regg,ind) for each
* aggregated imported product (prd) depends linearly on the demand of the same
* industry for the corresponding aggregated product and with certain elasticity
* on relative prices of aggregated imported product and domestically produced
* product.
EQINTU_M(prd,regg,ind)..
    INTER_USE_M_V(prd,regg,ind)
    =E=
    INTER_USE_T_V(prd,regg,ind) * phi_imp(prd,regg,ind) *
    ( PIMP_T_V(prd,regg) /
    ( PIU_V(prd,regg,ind) * ( 1 + tc_ind(prd,regg,ind) ) ) )**
    ( -elasIU_DM(prd,regg,ind) ) ;

* ## End Block 1: Input-output ##

* ## Beginning Block 3: Household demand for products ##

* EQUATION 3.2: Household demand for domestically produced products. The demand
* function follows CES form, where demand by households in each regions (regg)
* for each domestically produced product (prd) depends linearly on the demand by
* the same households for the corresponding aggregated product and with certain
* elasticity on relative prices of domestically produced products and aggregated
* imported product.
EQCONS_H_D(prd,regg)..
    CONS_H_D_V(prd,regg)
    =E=
    CONS_H_T_V(prd,regg) * theta_h_dom(prd,regg) *
    ( P_V(regg,prd) /
    ( PC_H_V(prd,regg) * ( 1 + tc_h(prd,regg) ) ) )**
    ( -elasFU_DM(prd,regg) ) ;

* EQUATION 3.3: Household demand for aggregated imported products. The demand
* function follows CES form, where demand by households in each region (regg)
* for each aggregated imported product (prd) depends linearly on the demand by
* the same households for the corresponding aggregated product and with certain
* elasticity on relative prices of aggregated imported product and domestically
* produced products.
EQCONS_H_M(prd,regg)..
    CONS_H_M_V(prd,regg)
    =E=
    CONS_H_T_V(prd,regg) * theta_h_imp(prd,regg) *
    ( PIMP_T_V(prd,regg) /
    ( PC_H_V(prd,regg) * ( 1 + tc_h(prd,regg) ) ) )
    **( -elasFU_DM(prd,regg) ) ;

* ## End Block 3: Household demand for products ##

* ## Beginning Block 4: Government demand for products ##

* EQUATION 4.2: Government demand for domestically produced products. The demand
* function follows CES form, where demand by government in each regions (regg)
* for each domestically produced product (prd) depends linearly on the demand by
* the same government for the corresponding aggregated product and with certain
* elasticity on relative prices of domestically produced products and aggregated
* imported product.
EQCONS_G_D(prd,regg)..
    CONS_G_D_V(prd,regg)
    =E=
    CONS_G_T_V(prd,regg) * theta_g_dom(prd,regg) *
    ( P_V(regg,prd) /
    ( PC_G_V(prd,regg) * ( 1 + tc_g(prd,regg) ) ) )**
    ( -elasFU_DM(prd,regg) ) ;

* EQUATION 4.3: Government demand for aggregated imported products. The demand
* function follows CES form, where demand by government in each region (regg)
* for each aggregated imported product (prd) depends linearly on the demand by
* the same government for the corresponding aggregated product and with certain
* elasticity on relative prices of aggregated imported product and domestically
* produced products.
EQCONS_G_M(prd,regg)..
    CONS_G_M_V(prd,regg)
    =E=
    CONS_G_T_V(prd,regg) * theta_g_imp(prd,regg) *
    ( PIMP_T_V(prd,regg) /
    ( PC_G_V(prd,regg) * ( 1 + tc_g(prd,regg) ) ) )
    **( -elasFU_DM(prd,regg) ) ;

* ## End Block 4: Government demand for products ##

* ## Beginning Block 5: Investment agent demand for products ##

* EQUATION 5.2: Investment agent demand for domestically produced products. The
* demand function follows CES form, where demand by investment agent in each
* region (regg) for each domestically produced product (prd) depends linearly on
* the demand by the same investment agent for the corresponding aggregated
* product and with certain elasticity on relative prices of domestically
* produced products and aggregated imported product.
EQGFCF_D(prd,regg)..
    GFCF_D_V(prd,regg)
    =E=
    GFCF_T_V(prd,regg) * theta_gfcf_dom(prd,regg) *
    ( P_V(regg,prd) /
    ( PC_I_V(prd,regg) * ( 1 + tc_gfcf(prd,regg) ) ) )**
    ( -elasFU_DM(prd,regg) ) ;

* EQUATION 5.3: Investment agent demand for aggregated imported products. The
* demand function follows CES form, where demand by investment agent in each
* region (regg) for each aggregated imported product (prd) depends linearly on
* the demand by the same investment agent for the corresponding aggregated
* product and with certain elasticity on relative prices of aggregated imported
* product and domestically produced products.
EQGFCF_M(prd,regg)..
    GFCF_M_V(prd,regg)
    =E=
    GFCF_T_V(prd,regg) * theta_gfcf_imp(prd,regg) *
    ( PIMP_T_V(prd,regg) /
    ( PC_I_V(prd,regg) * ( 1 + tc_gfcf(prd,regg) ) ) )
    **( -elasFU_DM(prd,regg) ) ;

* ## End Block 5: Investment agent demand for products ##

* ## Beginning Block 6: Stock changes of product ##

* EQUATION 6.1: Stock changes of products. Stock changes of each  product (prd)
* produced in each region (reg) supplied to each region (regg) is a share of the
* corresponding product output. It is assumed that the stock changes are covered
* from income of the investment agent in the same region (regg).
EQSV(reg,prd,regg)..
    SV_V(reg,prd,regg)
    =E=
    theta_sv(reg,prd,regg) * X_V(reg,prd) ;

* ## End Block 6: Stock changes of product ##

* ## Beginning Block 7: Inter-regional trade ##

* EQUATION 7.1: Total demand for aggregate imported products from rest of the
* world and modeled regions. The demand for each aggregated imported product
* (prd) in each region (regg) is a sum of the corresponding demand of
* industries, household, government and investment agent in this region.
EQIMP_T(prd,regg)..
    IMPORT_T_V(prd,regg)
    =E=
    sum(ind, INTER_USE_M_V(prd,regg,ind) ) +
    CONS_H_M_V(prd,regg) + CONS_G_M_V(prd,regg) + GFCF_M_V(prd,regg) ;

* EQUATION 7.2: Demand for aggregated import from modeled regions. The demand
* function follows CES form, where demand from each importing region (regg)
* for each product type (prd) produced in modeled regions depends linearly
* on the total demand for aggregated imported product in the same importing
* region and with certain elasticity on relative prices of the same
* product between rest of the world region and modeled regions.
EQIMP_MOD(prd,regg)..
    IMPORT_MOD_V(prd,regg)
    =E=
    IMPORT_T_V(prd,regg) * gamma_mod(prd,regg) *
    ( PIMP_MOD_V(prd,regg) / PIMP_T_V(prd,regg) )**
    ( -elasIMP_ROW(prd,regg) ) ;

* EQUATION 7.3: Demand for import from rest of the world region. The demand
* function follows CES form, where demand from each importing region (regg)
* for each product type (prd) produced in rest of the world region depends
* linearly on the total demand for aggregated imported product in the same
* importing region and with certain elasticity on relative prices of the same
* product between rest of the world region and modeled regions.
EQIMP_ROW(prd,regg)..
    IMPORT_ROW_V(prd,regg)
    =E=
    IMPORT_T_V(prd,regg) * gamma_row(prd,regg) *
    ( PROW_V / PIMP_T_V(prd,regg) )**
    ( -elasIMP_ROW(prd,regg) ) ;

* EQUATION 7.4: Demand for bi-lateral trade transactions. The demand function
* follows CES form, where demand from each importing region (regg) for each
* product type (prd) produced in each exporting region (reg) depends linearly
* on the total demand for aggregated imported product (only from modeled
* regions) in the same importing region and with certain elasticity on relative
* prices of the same product types produced by different exporting regions.
EQTRADE(reg,prd,regg)..
    TRADE_V(reg,prd,regg)
    =E=
    IMPORT_MOD_V(prd,regg) * gamma_trd(reg,prd,regg) *
    ( P_V(reg,prd) / PIMP_MOD_V(prd,regg) )**
    ( -elasTRD(prd,regg) ) ;

* EQUATION 7.5: Export supply to the rest of the world regions. Export of each
* product (prd) produced in each region (reg) supplied to rest of the world
* region is a share of the corresponding product output. It is assumed that the
* rest of the world region is buying all the export supplied to them.
EQEXP(reg,prd)..
    EXPORT_ROW_V(reg,prd)
    =E=
    gamma_exp(reg,prd) * X_V(reg,prd) ;

* ## End Block 7: Inter-regional trade ##

$label end_equations_definition

* ======== Phase 6: Define levels and lower and upper bounds and fixed variables ====
$if not '%phase%' == 'equations_bounds' $goto end_equations_bounds

* Endogenous variables
* Variables in real terms: level is set to the calibrated value of the
* corresponding parameter. In the the calibrated value is equal to zero, the
* variable value is also fixed to zero. The equation setup will led to zero
* solution for this variable and fixing it at this point help the solver.
INTER_USE_D_V.L(prd,regg,ind)       = INTER_USE_D(prd,regg,ind) ;
INTER_USE_M_V.L(prd,regg,ind)       = INTER_USE_M(prd,regg,ind) ;
INTER_USE_D_V.FX(prd,regg,ind)$(INTER_USE_D(prd,regg,ind) eq 0)                   = 0 ;
INTER_USE_M_V.FX(prd,regg,ind)$(INTER_USE_M(prd,regg,ind) eq 0)                   = 0 ;
CONS_H_D_V.L(prd,regg)       = CONS_H_D(prd,regg) ;
CONS_H_M_V.L(prd,regg)       = CONS_H_M(prd,regg) ;
CONS_H_D_V.FX(prd,regg)$(CONS_H_D(prd,regg) eq 0)             = 0 ;
CONS_H_M_V.FX(prd,regg)$(CONS_H_M(prd,regg) eq 0)             = 0 ;
CONS_G_D_V.L(prd,regg)       = CONS_G_D(prd,regg) ;
CONS_G_M_V.L(prd,regg)       = CONS_G_M(prd,regg) ;
CONS_G_D_V.FX(prd,regg)$(CONS_G_D(prd,regg) eq 0)             = 0 ;
CONS_G_M_V.FX(prd,regg)$(CONS_G_M(prd,regg) eq 0)             = 0 ;
GFCF_D_V.L(prd,regg)       = GFCF_D(prd,regg) ;
GFCF_M_V.L(prd,regg)       = GFCF_M(prd,regg) ;
GFCF_D_V.FX(prd,regg)$(GFCF_D(prd,regg) eq 0)             = 0 ;
GFCF_M_V.FX(prd,regg)$(GFCF_M(prd,regg) eq 0)             = 0 ;
SV_V.L(reg,prd,regg) = SV(reg,prd,regg) ;
SV_V.FX(reg,prd,regg)$(SV(reg,prd,regg) eq 0) = 0 ;
IMPORT_T_V.L(prd,regg)   = IMPORT_T(prd,regg) ;
IMPORT_MOD_V.L(prd,regg) = IMPORT_MOD(prd,regg) ;
IMPORT_ROW_V.L(prd,regg) = IMPORT_ROW(prd,regg) ;
TRADE_V.L(reg,prd,regg)  = TRADE(reg,prd,regg) ;
EXPORT_ROW_V.L(reg,prd)  = EXPORT_ROW(reg,prd) ;
IMPORT_T_V.FX(prd,regg)$(IMPORT_T(prd,regg) eq 0)     = 0 ;
IMPORT_MOD_V.FX(prd,regg)$(IMPORT_MOD(prd,regg) eq 0) = 0 ;
IMPORT_ROW_V.FX(prd,regg)$(IMPORT_ROW(prd,regg) eq 0) = 0 ;
TRADE_V.FX(reg,prd,regg)$(TRADE(reg,prd,regg) eq 0)   = 0 ;
EXPORT_ROW_V.FX(reg,prd)$(EXPORT_ROW(reg,prd) eq 0)   = 0 ;

* Exogenous variables
* Exogenous variables are fixed to their calibrated value.
SV_ROW_V.FX(prd,regg)             = SV_ROW(prd,regg) ;
* ======================= 5. Scale variables and equations ========================

* Scaling of variables and equations is done in order to help the solver to
* find the solution quicker. The scaling should ensure that the partial
* derivative of each variable evaluated at their current level values is within
* the range between 0.1 and 100. The values of partial derivatives can be seen
* in the equation listing. In general, the rule is that the variable and the
* equation linked to this variables in MCP formulation should both be scaled by
* the initial level of the variable.

* EQUATION 1.4
EQINTU_D.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) gt 0)
    = INTER_USE_D_V.L(prd,regg,ind) ;
INTER_USE_D_V.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) gt 0)
    = INTER_USE_D_V.L(prd,regg,ind) ;

EQINTU_D.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_D_V.L(prd,regg,ind) ;
INTER_USE_D_V.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_D_V.L(prd,regg,ind) ;

* EQUATION 1.5
EQINTU_M.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) gt 0)
    = INTER_USE_M_V.L(prd,regg,ind) ;
INTER_USE_M_V.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) gt 0)
    = INTER_USE_M_V.L(prd,regg,ind) ;

EQINTU_M.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_M_V.L(prd,regg,ind) ;
INTER_USE_M_V.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_M_V.L(prd,regg,ind) ;

* EQUATION 3.2
EQCONS_H_D.SCALE(prd,regg)$(CONS_H_D_V.L(prd,regg) gt 0)
    = CONS_H_D_V.L(prd,regg) ;
CONS_H_D_V.SCALE(prd,regg)$(CONS_H_D_V.L(prd,regg) gt 0)
    = CONS_H_D_V.L(prd,regg) ;

EQCONS_H_D.SCALE(prd,regg)$(CONS_H_D_V.L(prd,regg) lt 0)
    = -CONS_H_D_V.L(prd,regg) ;
CONS_H_D_V.SCALE(prd,regg)$(CONS_H_D_V.L(prd,regg) lt 0)
    = -CONS_H_D_V.L(prd,regg) ;

* EQUATION 3.3
EQCONS_H_M.SCALE(prd,regg)$(CONS_H_M_V.L(prd,regg) gt 0)
    = CONS_H_M_V.L(prd,regg) ;
CONS_H_M_V.SCALE(prd,regg)$(CONS_H_M_V.L(prd,regg) gt 0)
    = CONS_H_M_V.L(prd,regg) ;

EQCONS_H_M.SCALE(prd,regg)$(CONS_H_M_V.L(prd,regg) lt 0)
    = -CONS_H_M_V.L(prd,regg) ;
CONS_H_M_V.SCALE(prd,regg)$(CONS_H_M_V.L(prd,regg) lt 0)
    = -CONS_H_M_V.L(prd,regg) ;

* EQUATION 4.2
EQCONS_G_D.SCALE(prd,regg)$(CONS_G_D_V.L(prd,regg) gt 0)
    = CONS_G_D_V.L(prd,regg) ;
CONS_G_D_V.SCALE(prd,regg)$(CONS_G_D_V.L(prd,regg) gt 0)
    = CONS_G_D_V.L(prd,regg) ;

EQCONS_G_D.SCALE(prd,regg)$(CONS_G_D_V.L(prd,regg) lt 0)
    = -CONS_G_D_V.L(prd,regg) ;
CONS_G_D_V.SCALE(prd,regg)$(CONS_G_D_V.L(prd,regg) lt 0)
    = -CONS_G_D_V.L(prd,regg) ;

* EQUATION 4.3
EQCONS_G_M.SCALE(prd,regg)$(CONS_G_M_V.L(prd,regg) gt 0)
    = CONS_G_M_V.L(prd,regg) ;
CONS_G_M_V.SCALE(prd,regg)$(CONS_G_M_V.L(prd,regg) gt 0)
    = CONS_G_M_V.L(prd,regg) ;

EQCONS_G_M.SCALE(prd,regg)$(CONS_G_M_V.L(prd,regg) lt 0)
    = -CONS_G_M_V.L(prd,regg) ;
CONS_G_M_V.SCALE(prd,regg)$(CONS_G_M_V.L(prd,regg) lt 0)
    = -CONS_G_M_V.L(prd,regg) ;

* EQUATION 5.2
EQGFCF_D.SCALE(prd,regg)$(GFCF_D_V.L(prd,regg) gt 0)
    = GFCF_D_V.L(prd,regg) ;
GFCF_D_V.SCALE(prd,regg)$(GFCF_D_V.L(prd,regg) gt 0)
    = GFCF_D_V.L(prd,regg) ;

EQGFCF_D.SCALE(prd,regg)$(GFCF_D_V.L(prd,regg) lt 0)
    = -GFCF_D_V.L(prd,regg) ;
GFCF_D_V.SCALE(prd,regg)$(GFCF_D_V.L(prd,regg) lt 0)
    = -GFCF_D_V.L(prd,regg) ;

* EQUATION 5.3
EQGFCF_M.SCALE(prd,regg)$(GFCF_M_V.L(prd,regg) gt 0)
    = GFCF_M_V.L(prd,regg) ;
GFCF_M_V.SCALE(prd,regg)$(GFCF_M_V.L(prd,regg) gt 0)
    = GFCF_M_V.L(prd,regg) ;

EQGFCF_M.SCALE(prd,regg)$(GFCF_M_V.L(prd,regg) lt 0)
    = -GFCF_M_V.L(prd,regg) ;
GFCF_M_V.SCALE(prd,regg)$(GFCF_M_V.L(prd,regg) lt 0)
    = -GFCF_M_V.L(prd,regg) ;

* EQUATION 6.1
EQSV.SCALE(reg,prd,regg)$(SV_V.L(reg,prd,regg) gt 0)
    = SV_V.L(reg,prd,regg) ;
SV_V.SCALE(reg,prd,regg)$(SV_V.L(reg,prd,regg) gt 0)
    = SV_V.L(reg,prd,regg) ;

EQSV.SCALE(reg,prd,regg)$(SV_V.L(reg,prd,regg) lt 0)
    = -SV_V.L(reg,prd,regg) ;
SV_V.SCALE(reg,prd,regg)$(SV_V.L(reg,prd,regg) lt 0)
    = -SV_V.L(reg,prd,regg) ;

* EQUATION 7.1
EQIMP_T.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) gt 0)
    = IMPORT_T_V.L(prd,regg) ;
IMPORT_T_V.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) gt 0)
    = IMPORT_T_V.L(prd,regg) ;

EQIMP_T.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) lt 0)
    = -IMPORT_T_V.L(prd,regg) ;
IMPORT_T_V.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) lt 0)
    = -IMPORT_T_V.L(prd,regg) ;

* EQUATION 7.2
EQIMP_MOD.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) gt 0)
    = IMPORT_MOD_V.L(prd,regg) ;
IMPORT_MOD_V.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) gt 0)
    = IMPORT_MOD_V.L(prd,regg) ;

EQIMP_MOD.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) lt 0)
    = -IMPORT_MOD_V.L(prd,regg) ;
IMPORT_MOD_V.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) lt 0)
    = -IMPORT_MOD_V.L(prd,regg) ;

* EQUATION 7.3
EQIMP_ROW.SCALE(prd,regg)$(IMPORT_ROW_V.L(prd,regg) gt 0)
    = IMPORT_ROW_V.L(prd,regg) ;
IMPORT_ROW_V.SCALE(prd,regg)$(IMPORT_ROW_V.L(prd,regg) gt 0)
    = IMPORT_ROW_V.L(prd,regg) ;

EQIMP_ROW.SCALE(prd,regg)$(IMPORT_ROW_V.L(prd,regg) lt 0)
    = -IMPORT_ROW_V.L(prd,regg) ;
IMPORT_ROW_V.SCALE(prd,regg)$(IMPORT_ROW_V.L(prd,regg) lt 0)
    = -IMPORT_ROW_V.L(prd,regg) ;

* EQUATION 7.4
EQTRADE.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) gt 0)
    = TRADE_V.L(reg,prd,regg) ;
TRADE_V.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) gt 0)
    = TRADE_V.L(reg,prd,regg) ;

EQTRADE.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) lt 0)
    = -TRADE_V.L(reg,prd,regg) ;
TRADE_V.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) lt 0)
    = -TRADE_V.L(reg,prd,regg) ;

* EQUATION 7.5
EQEXP.SCALE(reg,prd)$(EXPORT_ROW_V.L(reg,prd) gt 0)
    = EXPORT_ROW_V.L(reg,prd) ;
EXPORT_ROW_V.SCALE(reg,prd)$(EXPORT_ROW_V.L(reg,prd) gt 0)
    = EXPORT_ROW_V.L(reg,prd) ;

EQEXP.SCALE(reg,prd)$(EXPORT_ROW_V.L(reg,prd) lt 0)
    = -EXPORT_ROW_V.L(reg,prd) ;
EXPORT_ROW_V.SCALE(reg,prd)$(EXPORT_ROW_V.L(reg,prd) lt 0)
    = -EXPORT_ROW_V.L(reg,prd) ;

SV_ROW_V.SCALE(prd,regg)$(SV_ROW_V.L(prd,regg) gt 0)
    = SV_ROW_V.L(prd,regg) ;
SV_ROW_V.SCALE(prd,regg)$(SV_ROW_V.L(prd,regg) lt 0)
    = -SV_ROW_V.L(prd,regg) ;

$label end_equations_bounds
    