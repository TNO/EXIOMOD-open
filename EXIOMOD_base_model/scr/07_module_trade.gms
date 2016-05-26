* File:   EXIOMOD_base_model/scr/07_module_trade.gms
* Author: Trond Husby
* Date:   22 April 2015
* Adjusted: 6 May 2015

* gams-master-file: phase.gms

$ontext startdoc
This is a module describing interregional trade side equations of the base CGE
and Input-Output model. The code includes all the required elements
(calibration, equations definition, model statement) for the trade side. The
trade formulation is in general following Armington approach. The following
elements of the model are described within the trade module:

- Demand functions for domestic vs. imported products by producers, households,
  government and investment agent. In this version, the first order conditions
  from 'flexible' CES preferences are used (CGE and IO - for producers).
- Demand for products required to cover changes in inventories. In this version,
  the changes in inventories are modeled as a fixed share of product output
  (only CGE).
- Demand for import from the rest of the world region and from the modeled
  regions. In this version, the first order conditions from 'flexible' CES
  preferences are used (CGE and IO - for modeled regions).
- Demand for products to be exported to the rest of the world region. In this
  version, export is modeled as a fixed share of product output (only CGE).

Although the elements describing changes in inventories and export to the rest
of the world could also belong to the demand module, we have decided to include
them into the trade module. Firstly, they are not real demand functions, meaning
that they don't depend of the product prices. Secondly, these demands are
expressed directly on the most detailed level (product and region of
production), therefore there is a better connection with other equations of the
trade module.

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
    elasTRADE_data(prd,*)       data on elasticities of import or domestic
                                # supply (Armington)
    elasIU_DM(prd,regg,ind)     substitution elasticity between domestic and
                                # imported intermediate use
    elasFU_DM(prd,regg)         substitution elasticity between domestic and
                                # imported final use for all categories
    elasIMP_ROW(prd,regg)       substitution elasticity between imports from
                                # rest of the world and aggregated import from
                                # modeled regions
    elasTRD(prd,regg)           substitution elasticity between imports from
                                # different modeled regions

    INTER_USE(reg,prd,regg,ind) intermediate use of products on the level of
                                # product and producing region (volume)

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
    SV_ROW(prd,regg)            stock changes of products imported from the rest
                                # of the world region (volume)

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
                                # consumption and investments (volume)

    tc_sv(prd,regg)             tax and subsidies on products rates for
                                # stock changes (relation in value)

    phi_dom(prd,regg,ind)       relative share parameter for intermediate use
                                # of domestic products (relation in volume)
    phi_imp(prd,regg,ind)       relative share parameter for intermediate use
                                # of imported products (relation in volume)
    theta_h_dom(prd,regg)       relative share parameter for household
                                # consumption of domestic products (relation in
                                # volume)
    theta_h_imp(prd,regg)       relative share parameter for household
                                # consumption of imported products (relation in
                                # volume)
    theta_g_dom(prd,regg)       relative share parameter for government
                                # consumption of domestic products (relation in
                                # volume)
    theta_g_imp(prd,regg)       relative share parameter for government
                                # consumption of imported products (relation in
                                # volume)
    theta_gfcf_dom(prd,regg)    relative share parameter for gross fixed capital
                                # formation of domestic products (relation in
                                # volume)
    theta_gfcf_imp(prd,regg)    relative share parameter for gross fixed capital
                                # formation of imported products (relation in
                                # volume)
    theta_sv(reg,prd,regg)      share coefficients for stock changes in products
                                # produced in the modeled regions (relation in
                                # volume)

    gamma_mod(prd,regg)         relative share parameter for imports originating
                                # from one of the modeled regions (relation in
                                # volume)
    gamma_row(prd,regg)         relative share parameter for imports originating
                                # from the rest of the world region (relation in
                                # volume)
    gamma_trd(reg,prd,regg)     relative share parameter for origin region of
                                # import (relation in volume)
    gamma_exp(reg,prd)          share coefficients for export to rest of the
                                # world regions (relation in volume)

    tc_sv_0(prd,regg)           calibrated tax and subsidies on products rates
                                # for stock changes (relation in value)
;

$label end_parameters_declaration

* ====================== Phase 3: Definition of parameters =====================
$if not '%phase%' == 'parameters_calibration' $goto end_parameters_calibration

* Here project-specific data are read in. Data should be placed in
* %project%/00_base_model_setup/data/.

*## Elasticities ##

$libinclude xlimport elasTRADE_data %project%/00_base_model_setup/data/Eldata.xlsx elasTRADE!a1..e10000 ;

* Substitution elasticity between domestic and aggregated imported products in
* volume for intermediate use. The elasticity value can be different for each
* product (prd) in each industry (ind) in each importing region (regg).
elasIU_DM(prd,regg,ind)
    = elasTRADE_data(prd,'elasIU_DM') ;

* Substitution elasticity between domestic and aggregated imported products in
* volume for final use. The elasticity value can be different for each product
* (prd) in each importing region (regg).
elasFU_DM(prd,regg)
    = elasTRADE_data(prd,'elasFU_DM') ;

* Substitution elasticity between imports in volume from the rest of the world
* region and aggregated import from modeled regions. The elasticity value can be
* different for each product (prd) and each importing region (regg).
elasIMP_ROW(prd,regg)
    = elasTRADE_data(prd,'elasIMP_ROW') ;

* Substitution elasticity between imports in volume from different modeled
* regions. The elasticity value can be different for each product (prd) and each
* importing region (regg).
elasTRD(prd,regg)
    = elasTRADE_data(prd,'elasTRD') ;


* *## Aggregates ##

* Intermediate use of products on the level of product (prd) and producing
* region (reg) in each industry (ind) in each region (regg), the corresponding
* basic price in the calibration year is equal to 1.
INTER_USE(reg,prd,regg,ind)$( sameas(reg,regg) or TRADE(reg,prd,regg) )
    = ( INTER_USE_D(prd,regg,ind) )$sameas(reg,regg) +
    ( INTER_USE_M(prd,regg,ind) * TRADE(reg,prd,regg) /
    ( sum(reggg, TRADE(reggg,prd,regg) ) +
    IMPORT_ROW(prd,regg) ) )$(not sameas(reg,regg)) ;

Display
INTER_USE
;


* Household consumption of domestic products in volume of each product (prd) in
* each region (regg), the corresponding basic price in the calibration year is
* equal to 1.
CONS_H_D(prd,regg)
    = sum(fd$fd_assign(fd,'Households'), FINAL_USE_D(prd,regg,fd) ) ;

* Household consumption of imported products in volume of each product (prd) in
* each region (regg), the corresponding basic price in the calibration year is
* equal to 1.
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
* equal to 1.
CONS_G_D(prd,regg)
    = sum(fd$fd_assign(fd,'Government'), FINAL_USE_D(prd,regg,fd) ) ;

* Government consumption of imported products in volume of each product (prd) in
* each region (regg), the corresponding basic price in the calibration year is
* equal to 1.
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
* calibration year is equal to 1.
GFCF_D(prd,regg)
    = sum(fd$fd_assign(fd,'GrossFixCapForm'), FINAL_USE_D(prd,regg,fd) ) ;

* Investment (gross fixed capital formation) in imported products in volume of
* each product (prd) in each region (regg), the corresponding basic price in the
* calibration year is equal to 1.
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

* Stock change in products imported from the rest of the world region in volume
* of each product (prd) consumed in each region (regg), the corresponding basic
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
* capital formation, so excluding stock changes.
IMPORT_T(prd,regg)
    = sum(ind, INTER_USE_M(prd,regg,ind) ) +
    CONS_H_M(prd,regg) + CONS_G_M(prd,regg) + GFCF_M(prd,regg) ;

* Recalculate import volume from rest of the world so that it excludes values
* intended for stock changes.
IMPORT_ROW(prd,regg)
    = IMPORT_ROW(prd,regg) - SV_ROW(prd,regg) ;

* Aggregated import of products from modeled regions in volume of each product
* (prd) into each importing region (regg), the corresponding basic price in the
* base year is equal to 1. This import value includes only trade intended for
* intermediate use, household and government consumption and investments in
* gross fixed capital formation, so excluding stock changes.
IMPORT_MOD(prd,regg)
    = IMPORT_T(prd,regg) - IMPORT_ROW(prd,regg) ;

* Trade of products for each product (prd) between each region pair (reg,regg),
* the corresponding basic price in the base year is equal to 1, purchaser's
* price can be different from 1 in case of non-zero taxes on products in the
* exporting region. By definition, trade of a region with itself it equal to 0.
* These flows include only trade with modeled regions and only intended for
* intermediate use, household and government consumption and investments in
* gross fixed capital formation, so excluding stock changes.
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
* region (regg).
tc_sv(prd,regg)$sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_dt(prd,regg,fd) )
    = sum(fd$fd_assign(fd,'StockChange'), FINAL_USE_dt(prd,regg,fd) ) /
    ( sum(reg, SV(reg,prd,regg) ) + SV_ROW(prd,regg) ) ;

Display
tc_sv
;

* *## Parameters of interregional trade ##

* Relative share parameter for intermediate use of domestic products, versus
* aggregated imported products, for each product (prd) in each industry (ind) in
* each importing region (regg).
phi_dom(prd,regg,ind)$INTER_USE_D(prd,regg,ind)
    = INTER_USE_D(prd,regg,ind) / INTER_USE_T(prd,regg,ind) *
    ( 1 / 1 )**( -elasIU_DM(prd,regg,ind) ) ;

* Relative share parameter for intermediate use of aggregated imported products,
* versus domestic products, for each product (prd) in each industry (ind) in
* each importing region (regg).
phi_imp(prd,regg,ind)$INTER_USE_M(prd,regg,ind)
    = INTER_USE_M(prd,regg,ind) / INTER_USE_T(prd,regg,ind) *
    ( 1 / 1 )**( -elasIU_DM(prd,regg,ind) ) ;

Display
phi_dom
phi_imp
;


* Relative share parameter for household consumption of domestic products,
* versus aggregated imported products, for each product (prd) in each importing
* region (regg).
theta_h_dom(prd,regg)$CONS_H_D(prd,regg)
    = CONS_H_D(prd,regg) / CONS_H_T(prd,regg) *
    ( 1 / 1 )**( -elasFU_DM(prd,regg) ) ;

* Relative share parameter for household consumption of aggregated imported
* products, versus domestic products, for each product (prd) in each importing
* region (regg).
theta_h_imp(prd,regg)$CONS_H_M(prd,regg)
    = CONS_H_M(prd,regg) / CONS_H_T(prd,regg) *
    ( 1 / 1 )**( -elasFU_DM(prd,regg) ) ;

* Relative share parameter for government consumption of domestic products,
* versus aggregated imported products, for each product (prd) in each importing
* region (regg).
theta_g_dom(prd,regg)$CONS_G_D(prd,regg)
    = CONS_G_D(prd,regg) / CONS_G_T(prd,regg) *
    ( 1 / 1 )**( -elasFU_DM(prd,regg) ) ;

* Relative share parameter for government consumption of aggregated imported
* products, versus domestic products, for each product (prd) in each importing
* region (regg).
theta_g_imp(prd,regg)$CONS_G_M(prd,regg)
    = CONS_G_M(prd,regg) / CONS_G_T(prd,regg) *
    ( 1 / 1 )**( -elasFU_DM(prd,regg) ) ;

* Relative share parameter for gross fixed capital formation of domestic
* products, versus aggregated imported products, for each product (prd) in each
* importing region (regg).
theta_gfcf_dom(prd,regg)$GFCF_D(prd,regg)
    = GFCF_D(prd,regg) / GFCF_T(prd,regg) *
    ( 1 / 1 )**( -elasFU_DM(prd,regg) ) ;

* Relative share parameter for gross fixed capital formation of aggregated
* imported products, versus domestic products, for each product (prd) in each
*importing region (regg).
theta_gfcf_imp(prd,regg)$GFCF_M(prd,regg)
    = GFCF_M(prd,regg) / GFCF_T(prd,regg) *
    ( 1 / 1 )**( -elasFU_DM(prd,regg) ) ;

* Share coefficient for stock changes in each product (prd) from each region
* of origin (reg) to each importing region (regg).
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


* Relative share parameter for import originating from one of the modeled
* regions for each product (prd) for each region of destination (regg).
gamma_mod(prd,regg)$IMPORT_MOD(prd,regg)
    = IMPORT_MOD(prd,regg) / IMPORT_T(prd,regg) *
    ( 1 / 1 )**( -elasIMP_ROW(prd,regg) ) ;

* Relative share parameter for import originating from the rest of the world
* region for each product (prd) for each region of destination (regg).
gamma_row(prd,regg)$IMPORT_ROW(prd,regg)
    = IMPORT_ROW(prd,regg) / IMPORT_T(prd,regg) *
    ( 1 / 1 )**( -elasIMP_ROW(prd,regg) ) ;

* Relative share parameter for import from different regions for each product
* (prd) for each region of origin (reg) for each region of destination (regg).
gamma_trd(reg,prd,regg)$TRADE(reg,prd,regg)
    = TRADE(reg,prd,regg) / IMPORT_MOD(prd,regg) *
    ( 1 / 1 )**( -elasTRD(prd,regg) ) ;

* Share coefficient for export to the rest of the world region of each product
* (prd) from each region of origin (reg).
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

* =============== Phase 4: Declaration of variables and equations ==============
$if not '%phase%' == 'variables_equations_declaration' $goto end_variables_equations_declaration

* ========================== Declaration of variables ==========================

* Endogenous variables
Variables
    INTER_USE_D_V(prd,regg,ind)     use of domestically produced intermediate
                                    # inputs
    INTER_USE_M_V(prd,regg,ind)     use of aggregated imported intermediate
                                    # inputs

    CONS_H_D_V(prd,regg)            household consumption of domestically
                                    # produced products
    CONS_H_M_V(prd,regg)            household consumption of aggregated imported
                                    # products
    CONS_G_D_V(prd,regg)            government consumption of domestically
                                    # produced products
    CONS_G_M_V(prd,regg)            government consumption of aggregated
                                    # imported products
    GFCF_D_V(prd,regg)              gross fixed capital formation of
                                    # domestically produced products
    GFCF_M_V(prd,regg)              gross fixed capital formation of aggregated
                                    # imported products
    SV_V(reg,prd,regg)              stock changes of products on the most
                                    # detailed level from modeled regions

    IMPORT_T_V(prd,regg)            total use of aggregated imported products
    IMPORT_MOD_V(prd,regg)          aggregated import from modeled regions
    IMPORT_ROW_V(prd,regg)          import from the rest of the world region
    TRADE_V(reg,prd,regg)           bi-lateral trade flows
    EXPORT_ROW_V(reg,prd)           export to the rest of the world region

    PIMP_T_V(prd,regg)              aggregate total imported product price
    PIMP_MOD_V(prd,regg)            aggregate imported product price for the
                                    # aggregate imported from modeled regions

;

* Exogenous variables
Variables
    SV_ROW_V(prd,regg)              stock changes of the rest of the world
                                    # products
;

* ========================== Declaration of equations ==========================

Equations
    EQINTU_D(prd,regg,ind)      demand for domestically produced intermediate
                                # inputs
    EQINTU_M(prd,regg,ind)      demand for aggregated imported intermediate
                                # inputs

    EQCONS_H_D(prd,regg)        demand of households for domestically produced
                                # products
    EQCONS_H_M(prd,regg)        demand of households for aggregated imported
                                # products
    EQCONS_G_D(prd,regg)        demand of government for domestically produced
                                # products
    EQCONS_G_M(prd,regg)        demand of government for aggregated imported
                                # products
    EQGFCF_D(prd,regg)          demand of investment agent for domestically
                                # produced products
    EQGFCF_M(prd,regg)          demand of investment agent for aggregated
                                # imported products
    EQSV(reg,prd,regg)          demand for stock changes of products on the
                                # most detailed level from modeled regions

    EQIMP_T(prd,regg)           total demand for aggregared imported products
    EQIMP_MOD(prd,regg)         demand for aggregated import from modeled
                                # regions
    EQIMP_ROW(prd,regg)         demand for import from the rest of the world
                                # region
    EQTRADE(reg,prd,regg)       demand for bi-lateral trade transactions
    EQEXP(reg,prd)              export supply to the rest of the world region
    EQPIMP_T(prd,regg)          balance between specific imported product price
                                # from the rest of the world and modeled regions
                                # and total aggregated imported product price
    EQPIMP_MOD(prd,regg)        balance between specific imported product price
                                # from modeled regions and corresponding
                                # aggregated imported product price

;

$label end_variables_equations_declaration

* ====================== Phase 5: Definition of equations ======================
$if not '%phase%' == 'equations_definition' $goto end_equations_definition

* EQUATION 3.1: Demand for domestically produced intermediate inputs. The demand
* function follows CES form, where demand of each industry (regg,ind) for each
* domestically produced product (prd) depends linearly on the demand of the same
* industry for the corresponding aggregated product and, with certain
* elasticity, on relative prices of domestically produced product and
* aggregated imported product.
EQINTU_D(prd,regg,ind)..
    INTER_USE_D_V(prd,regg,ind)
    =E=
    INTER_USE_T_V(prd,regg,ind) * phi_dom(prd,regg,ind) *
    ( P_V(regg,prd) / PIU_V(prd,regg,ind) )**
    ( -elasIU_DM(prd,regg,ind) ) ;

* EQUAION 3.2: Demand for aggregated imported intermediate inputs. The demand
* function follows CES form, where demand of each industry (regg,ind) for each
* aggregated imported product (prd) depends linearly on the demand of the same
* industry for the corresponding aggregated product and, with certain
* elasticity, on relative prices of aggregated imported product and
* domestically produced product.
EQINTU_M(prd,regg,ind)..
    INTER_USE_M_V(prd,regg,ind)
    =E=
    INTER_USE_T_V(prd,regg,ind) * phi_imp(prd,regg,ind) *
    ( PIMP_T_V(prd,regg) / PIU_V(prd,regg,ind) )**
    ( -elasIU_DM(prd,regg,ind) ) ;


* EQUATION 3.3: Household demand for domestically produced products. The demand
* function follows CES form, where demand by households in each region (regg)
* for each domestically produced product (prd) depends linearly on the demand by
* the same household for the corresponding aggregated product and, with certain
* elasticity, on relative prices of domestically produced product and aggregated
* imported product.
EQCONS_H_D(prd,regg)..
    CONS_H_D_V(prd,regg)
    =E=
    CONS_H_T_V(prd,regg) * theta_h_dom(prd,regg) *
    ( P_V(regg,prd) / PC_H_V(prd,regg) )**
    ( -elasFU_DM(prd,regg) ) ;

* EQUATION 3.4: Household demand for aggregated imported products. The demand
* function follows CES form, where demand by households in each region (regg)
* for each aggregated imported product (prd) depends linearly on the demand by
* the same household for the corresponding aggregated product and, with certain
* elasticity, on relative prices of aggregated imported product and domestically
* produced product.
EQCONS_H_M(prd,regg)..
    CONS_H_M_V(prd,regg)
    =E=
    CONS_H_T_V(prd,regg) * theta_h_imp(prd,regg) *
    ( PIMP_T_V(prd,regg) / PC_H_V(prd,regg) )**
    ( -elasFU_DM(prd,regg) ) ;

* EQUATION 3.5: Government demand for domestically produced products. The demand
* function follows CES form, where demand by government in each region (regg)
* for each domestically produced product (prd) depends linearly on the demand by
* the same government for the corresponding aggregated product and, with certain
* elasticity, on relative prices of domestically produced product and aggregated
* imported product.
EQCONS_G_D(prd,regg)..
    CONS_G_D_V(prd,regg)
    =E=
    CONS_G_T_V(prd,regg) * theta_g_dom(prd,regg) *
    ( P_V(regg,prd) / PC_G_V(prd,regg) )**
    ( -elasFU_DM(prd,regg) ) ;

* EQUATION 3.6: Government demand for aggregated imported products. The demand
* function follows CES form, where demand by government in each region (regg)
* for each aggregated imported product (prd) depends linearly on the demand by
* the same government for the corresponding aggregated product and, with certain
* elasticity, on relative prices of aggregated imported product and domestically
* produced product.
EQCONS_G_M(prd,regg)..
    CONS_G_M_V(prd,regg)
    =E=
    CONS_G_T_V(prd,regg) * theta_g_imp(prd,regg) *
    ( PIMP_T_V(prd,regg) / PC_G_V(prd,regg) )**
    ( -elasFU_DM(prd,regg) ) ;

* EQUATION 3.7: Investment agent demand for domestically produced products. The
* demand function follows CES form, where demand by investment agent in each
* region (regg) for each domestically produced product (prd) depends linearly on
* the demand by the same investment agent for the corresponding aggregated
* product and, with certain elasticity, on relative prices of domestically
* produced product and aggregated imported product.
EQGFCF_D(prd,regg)..
    GFCF_D_V(prd,regg)
    =E=
    GFCF_T_V(prd,regg) * theta_gfcf_dom(prd,regg) *
    ( P_V(regg,prd) / PC_I_V(prd,regg) )**
    ( -elasFU_DM(prd,regg) ) ;

* EQUATION 3.8: Investment agent demand for aggregated imported products. The
* demand function follows CES form, where demand by investment agent in each
* region (regg) for each aggregated imported product (prd) depends linearly on
* the demand by the same investment agent for the corresponding aggregated
* product and, with certain elasticity, on relative prices of aggregated
* imported product and domestically produced product.
EQGFCF_M(prd,regg)..
    GFCF_M_V(prd,regg)
    =E=
    GFCF_T_V(prd,regg) * theta_gfcf_imp(prd,regg) *
    ( PIMP_T_V(prd,regg) / PC_I_V(prd,regg) )**
    ( -elasFU_DM(prd,regg) ) ;

* EQUATION 3.9: Stock changes of products. Stock changes of each  product (prd)
* produced in each region (reg) imported to each region (regg) is a share of the
* corresponding product output. It is assumed that the stock changes are covered
* from income of the investment agent in the same region (regg).
EQSV(reg,prd,regg)..
    SV_V(reg,prd,regg)
    =E=
    theta_sv(reg,prd,regg) * X_V(reg,prd) ;


* EQUATION 3.10: Total demand for aggregated imported products from the rest of
* the world and modeled regions. The demand for each aggregated imported product
* (prd) in each region (regg) is a sum of the corresponding demand of
* industries, household, government and investment agent in this region.
EQIMP_T(prd,regg)..
    IMPORT_T_V(prd,regg)
    =E=
    sum(ind, INTER_USE_M_V(prd,regg,ind) ) +
    CONS_H_M_V(prd,regg) + CONS_G_M_V(prd,regg) + GFCF_M_V(prd,regg) ;

* EQUATION 3.11: Demand for aggregated import from modeled regions. The demand
* function follows CES form, where demand from each importing region (regg)
* for each product type (prd) produced in modeled regions depends linearly
* on the total demand for aggregated imported product in the same importing
* region and, with certain elasticity, on relative prices of the same
* product between the rest of the world region and modeled regions.
EQIMP_MOD(prd,regg)..
    IMPORT_MOD_V(prd,regg)
    =E=
    IMPORT_T_V(prd,regg) * gamma_mod(prd,regg) *
    ( PIMP_MOD_V(prd,regg) / PIMP_T_V(prd,regg) )**
    ( -elasIMP_ROW(prd,regg) ) ;

* EQUATION 3.12: Demand for import from the rest of the world region. The demand
* function follows CES form, where demand from each importing region (regg)
* for each product type (prd) produced in the rest of the world region depends
* linearly on the total demand for aggregated imported product in the same
* importing region and, with certain elasticity, on relative prices of the same
* product between the rest of the world region and modeled regions.
EQIMP_ROW(prd,regg)..
    IMPORT_ROW_V(prd,regg)
    =E=
    IMPORT_T_V(prd,regg) * gamma_row(prd,regg) *
    ( PROW_V / PIMP_T_V(prd,regg) )**
    ( -elasIMP_ROW(prd,regg) ) ;

* EQUATION 3.13: Demand for bi-lateral trade transactions. The demand function
* follows CES form, where demand from each importing region (regg) for each
* product type (prd) produced in each exporting region (reg) depends linearly
* on the total demand for aggregated imported product (only from modeled
* regions) in the same importing region and, with certain elasticity, on
* relative prices of the same product types produced by different exporting
* regions.
EQTRADE(reg,prd,regg)..
    TRADE_V(reg,prd,regg)
    =E=
    IMPORT_MOD_V(prd,regg) * gamma_trd(reg,prd,regg) *
    ( P_V(reg,prd) / PIMP_MOD_V(prd,regg) )**
    ( -elasTRD(prd,regg) ) ;

* EQUATION 3.14: Export supply to the rest of the world regions. Export of each
* product (prd) produced in each region (reg) supplied to the rest of the world
* region is a share of the corresponding product output. It is assumed that the
* rest of the world region is buying all the export supplied to them.
EQEXP(reg,prd)..
    EXPORT_ROW_V(reg,prd)
    =E=
    gamma_exp(reg,prd) * X_V(reg,prd) ;

* EQUATION 3.15: Balance between total aggregated imported price and the price
* of the rest of the world and modeled regions. The aggregate price is different
* for each product (prd) in each importing region (regg) and is a weighed
* average of the price of the rest of the world and of the aggregated price of
* import from modeled regions, where weights are defined as corresponding
* demands for import from rest of the world and modeled regions.
EQPIMP_T(prd,regg)..
    PIMP_T_V(prd,regg) * IMPORT_T_V(prd,regg)
    =E=
    PIMP_MOD_V(prd,regg) * IMPORT_MOD_V(prd,regg) +
    PROW_V * IMPORT_ROW_V(prd,regg) ;

* EQUATION 3.16: Balance between specific imported product price and aggregated
* imported product price. The aggregate price is different for each product
* (prd) in each importing region (regg) and is a weighed average of specific
* product prices of exporting regions, where weights are defined as bi-lateral
* trade flows between the importing regions and the corresponding exporting
* region.
EQPIMP_MOD(prd,regg)..
    PIMP_MOD_V(prd,regg) * IMPORT_MOD_V(prd,regg)
    =E=
    sum(reg, TRADE_V(reg,prd,regg) * P_V(reg,prd) ) ;

$label end_equations_definition

* ===== Phase 6: Define levels, bounds and fixed variables, scale equations ====
$if not '%phase%' == 'bounds_and_scales' $goto end_bounds_and_scales

* ==================== Define level and bounds of variables ====================

* Endogenous variables
* Variables in real terms: level is set to the calibrated value of the
* corresponding parameter. If the the calibrated value is equal to zero, the
* variable value is also fixed to zero. The equation setup will lead to zero
* solution for this variable and fixing it at this point helps the solver.
INTER_USE_D_V.L(prd,regg,ind) = INTER_USE_D(prd,regg,ind) ;
INTER_USE_M_V.L(prd,regg,ind) = INTER_USE_M(prd,regg,ind) ;
INTER_USE_D_V.FX(prd,regg,ind)$(INTER_USE_D(prd,regg,ind) eq 0) = 0 ;
INTER_USE_M_V.FX(prd,regg,ind)$(INTER_USE_M(prd,regg,ind) eq 0) = 0 ;
CONS_H_D_V.L(prd,regg) = CONS_H_D(prd,regg) ;
CONS_H_M_V.L(prd,regg) = CONS_H_M(prd,regg) ;
CONS_H_D_V.FX(prd,regg)$(CONS_H_D(prd,regg) eq 0) = 0 ;
CONS_H_M_V.FX(prd,regg)$(CONS_H_M(prd,regg) eq 0) = 0 ;
CONS_G_D_V.L(prd,regg) = CONS_G_D(prd,regg) ;
CONS_G_M_V.L(prd,regg) = CONS_G_M(prd,regg) ;
CONS_G_D_V.FX(prd,regg)$(CONS_G_D(prd,regg) eq 0) = 0 ;
CONS_G_M_V.FX(prd,regg)$(CONS_G_M(prd,regg) eq 0) = 0 ;
GFCF_D_V.L(prd,regg) = GFCF_D(prd,regg) ;
GFCF_M_V.L(prd,regg) = GFCF_M(prd,regg) ;
GFCF_D_V.FX(prd,regg)$(GFCF_D(prd,regg) eq 0) = 0 ;
GFCF_M_V.FX(prd,regg)$(GFCF_M(prd,regg) eq 0) = 0 ;
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

* Price variables: level of basic prices is set to one, which also corresponds
* to the price level used in calibration. If the the real variable to which the
* price level is linked is fixed to zero, the price is fixed to one. For zero
* level variables any price level will be a solution and fixing it to one helps
* the solver. Additionally, price of the numéraire is fixed.
PIMP_T_V.L(prd,regg)   = 1 ;
PIMP_MOD_V.L(prd,regg) = 1 ;

PIMP_T_V.FX(prd,regg)$(IMPORT_T_V.L(prd,regg)eq 0)            = 1 ;
PIMP_MOD_V.FX(prd,regg)$(IMPORT_MOD_V.L(prd,regg)eq 0)        = 1 ;

* Exogenous variables
* Exogenous variables are fixed to their calibrated value.
SV_ROW_V.FX(prd,regg)             = SV_ROW(prd,regg) ;

* ======================= Scale variables and equations ========================

* Scaling of variables and equations is done in order to help the solver to
* find the solution quicker. The scaling should ensure that the partial
* derivative of each variable evaluated at their current level values is within
* the range between 0.1 and 100. The values of partial derivatives can be seen
* in the equation listing. In general, the rule is that the variable and the
* equation linked to this variables in MCP formulation should both be scaled by
* the initial level of the variable.

* EQUATION 3.1
EQINTU_D.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) gt 0)
    = INTER_USE_D_V.L(prd,regg,ind) ;
INTER_USE_D_V.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) gt 0)
    = INTER_USE_D_V.L(prd,regg,ind) ;

EQINTU_D.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_D_V.L(prd,regg,ind) ;
INTER_USE_D_V.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_D_V.L(prd,regg,ind) ;

* EQUATION 3.2
EQINTU_M.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) gt 0)
    = INTER_USE_M_V.L(prd,regg,ind) ;
INTER_USE_M_V.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) gt 0)
    = INTER_USE_M_V.L(prd,regg,ind) ;

EQINTU_M.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_M_V.L(prd,regg,ind) ;
INTER_USE_M_V.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_M_V.L(prd,regg,ind) ;

* EQUATION 3.3
EQCONS_H_D.SCALE(prd,regg)$(CONS_H_D_V.L(prd,regg) gt 0)
    = CONS_H_D_V.L(prd,regg) ;
CONS_H_D_V.SCALE(prd,regg)$(CONS_H_D_V.L(prd,regg) gt 0)
    = CONS_H_D_V.L(prd,regg) ;

EQCONS_H_D.SCALE(prd,regg)$(CONS_H_D_V.L(prd,regg) lt 0)
    = -CONS_H_D_V.L(prd,regg) ;
CONS_H_D_V.SCALE(prd,regg)$(CONS_H_D_V.L(prd,regg) lt 0)
    = -CONS_H_D_V.L(prd,regg) ;

* EQUATION 3.4
EQCONS_H_M.SCALE(prd,regg)$(CONS_H_M_V.L(prd,regg) gt 0)
    = CONS_H_M_V.L(prd,regg) ;
CONS_H_M_V.SCALE(prd,regg)$(CONS_H_M_V.L(prd,regg) gt 0)
    = CONS_H_M_V.L(prd,regg) ;

EQCONS_H_M.SCALE(prd,regg)$(CONS_H_M_V.L(prd,regg) lt 0)
    = -CONS_H_M_V.L(prd,regg) ;
CONS_H_M_V.SCALE(prd,regg)$(CONS_H_M_V.L(prd,regg) lt 0)
    = -CONS_H_M_V.L(prd,regg) ;

* EQUATION 3.5
EQCONS_G_D.SCALE(prd,regg)$(CONS_G_D_V.L(prd,regg) gt 0)
    = CONS_G_D_V.L(prd,regg) ;
CONS_G_D_V.SCALE(prd,regg)$(CONS_G_D_V.L(prd,regg) gt 0)
    = CONS_G_D_V.L(prd,regg) ;

EQCONS_G_D.SCALE(prd,regg)$(CONS_G_D_V.L(prd,regg) lt 0)
    = -CONS_G_D_V.L(prd,regg) ;
CONS_G_D_V.SCALE(prd,regg)$(CONS_G_D_V.L(prd,regg) lt 0)
    = -CONS_G_D_V.L(prd,regg) ;

* EQUATION 3.6
EQCONS_G_M.SCALE(prd,regg)$(CONS_G_M_V.L(prd,regg) gt 0)
    = CONS_G_M_V.L(prd,regg) ;
CONS_G_M_V.SCALE(prd,regg)$(CONS_G_M_V.L(prd,regg) gt 0)
    = CONS_G_M_V.L(prd,regg) ;

EQCONS_G_M.SCALE(prd,regg)$(CONS_G_M_V.L(prd,regg) lt 0)
    = -CONS_G_M_V.L(prd,regg) ;
CONS_G_M_V.SCALE(prd,regg)$(CONS_G_M_V.L(prd,regg) lt 0)
    = -CONS_G_M_V.L(prd,regg) ;

* EQUATION 3.7
EQGFCF_D.SCALE(prd,regg)$(GFCF_D_V.L(prd,regg) gt 0)
    = GFCF_D_V.L(prd,regg) ;
GFCF_D_V.SCALE(prd,regg)$(GFCF_D_V.L(prd,regg) gt 0)
    = GFCF_D_V.L(prd,regg) ;

EQGFCF_D.SCALE(prd,regg)$(GFCF_D_V.L(prd,regg) lt 0)
    = -GFCF_D_V.L(prd,regg) ;
GFCF_D_V.SCALE(prd,regg)$(GFCF_D_V.L(prd,regg) lt 0)
    = -GFCF_D_V.L(prd,regg) ;

* EQUATION 3.8
EQGFCF_M.SCALE(prd,regg)$(GFCF_M_V.L(prd,regg) gt 0)
    = GFCF_M_V.L(prd,regg) ;
GFCF_M_V.SCALE(prd,regg)$(GFCF_M_V.L(prd,regg) gt 0)
    = GFCF_M_V.L(prd,regg) ;

EQGFCF_M.SCALE(prd,regg)$(GFCF_M_V.L(prd,regg) lt 0)
    = -GFCF_M_V.L(prd,regg) ;
GFCF_M_V.SCALE(prd,regg)$(GFCF_M_V.L(prd,regg) lt 0)
    = -GFCF_M_V.L(prd,regg) ;

* EQUATION 3.9
EQSV.SCALE(reg,prd,regg)$(SV_V.L(reg,prd,regg) gt 0)
    = SV_V.L(reg,prd,regg) ;
SV_V.SCALE(reg,prd,regg)$(SV_V.L(reg,prd,regg) gt 0)
    = SV_V.L(reg,prd,regg) ;

EQSV.SCALE(reg,prd,regg)$(SV_V.L(reg,prd,regg) lt 0)
    = -SV_V.L(reg,prd,regg) ;
SV_V.SCALE(reg,prd,regg)$(SV_V.L(reg,prd,regg) lt 0)
    = -SV_V.L(reg,prd,regg) ;

* EQUATION 3.10
EQIMP_T.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) gt 0)
    = IMPORT_T_V.L(prd,regg) ;
IMPORT_T_V.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) gt 0)
    = IMPORT_T_V.L(prd,regg) ;

EQIMP_T.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) lt 0)
    = -IMPORT_T_V.L(prd,regg) ;
IMPORT_T_V.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) lt 0)
    = -IMPORT_T_V.L(prd,regg) ;

* EQUATION 3.11
EQIMP_MOD.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) gt 0)
    = IMPORT_MOD_V.L(prd,regg) ;
IMPORT_MOD_V.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) gt 0)
    = IMPORT_MOD_V.L(prd,regg) ;

EQIMP_MOD.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) lt 0)
    = -IMPORT_MOD_V.L(prd,regg) ;
IMPORT_MOD_V.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) lt 0)
    = -IMPORT_MOD_V.L(prd,regg) ;

* EQUATION 3.12
EQIMP_ROW.SCALE(prd,regg)$(IMPORT_ROW_V.L(prd,regg) gt 0)
    = IMPORT_ROW_V.L(prd,regg) ;
IMPORT_ROW_V.SCALE(prd,regg)$(IMPORT_ROW_V.L(prd,regg) gt 0)
    = IMPORT_ROW_V.L(prd,regg) ;

EQIMP_ROW.SCALE(prd,regg)$(IMPORT_ROW_V.L(prd,regg) lt 0)
    = -IMPORT_ROW_V.L(prd,regg) ;
IMPORT_ROW_V.SCALE(prd,regg)$(IMPORT_ROW_V.L(prd,regg) lt 0)
    = -IMPORT_ROW_V.L(prd,regg) ;

* EQUATION 3.13
EQTRADE.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) gt 0)
    = TRADE_V.L(reg,prd,regg) ;
TRADE_V.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) gt 0)
    = TRADE_V.L(reg,prd,regg) ;

EQTRADE.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) lt 0)
    = -TRADE_V.L(reg,prd,regg) ;
TRADE_V.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) lt 0)
    = -TRADE_V.L(reg,prd,regg) ;

* EQUATION 3.14
EQEXP.SCALE(reg,prd)$(EXPORT_ROW_V.L(reg,prd) gt 0)
    = EXPORT_ROW_V.L(reg,prd) ;
EXPORT_ROW_V.SCALE(reg,prd)$(EXPORT_ROW_V.L(reg,prd) gt 0)
    = EXPORT_ROW_V.L(reg,prd) ;

EQEXP.SCALE(reg,prd)$(EXPORT_ROW_V.L(reg,prd) lt 0)
    = -EXPORT_ROW_V.L(reg,prd) ;
EXPORT_ROW_V.SCALE(reg,prd)$(EXPORT_ROW_V.L(reg,prd) lt 0)
    = -EXPORT_ROW_V.L(reg,prd) ;

* EXOGENOUS VARIBLES
SV_ROW_V.SCALE(prd,regg)$(SV_ROW_V.L(prd,regg) gt 0)
    = SV_ROW_V.L(prd,regg) ;
SV_ROW_V.SCALE(prd,regg)$(SV_ROW_V.L(prd,regg) lt 0)
    = -SV_ROW_V.L(prd,regg) ;

* EQUATION 3.15
EQPIMP_T.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) gt 0)
    = IMPORT_T_V.L(prd,regg) ;

EQPIMP_T.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) lt 0)
    = -IMPORT_T_V.L(prd,regg) ;

* EQUATION 3.16
EQPIMP_MOD.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) gt 0)
    = IMPORT_MOD_V.L(prd,regg) ;

EQPIMP_MOD.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) lt 0)
    = -IMPORT_MOD_V.L(prd,regg) ;

$label end_bounds_and_scales

* ======================== Phase 7: Declare sub-models  ========================
$if not '%phase%' == 'submodel_declaration' $goto submodel_declaration

* Include trade equations that will enter IO product technology model
Model trade_IO_product_technology
/
EQINTU_D
EQINTU_M
EQIMP_T
EQIMP_MOD
EQTRADE
/
;

* Include trade equations that will enter IO product technology model
Model trade_IO_industry_technology
/
EQINTU_D
EQINTU_M
EQIMP_T
EQIMP_MOD
EQTRADE
/
;

* Include trade equations that will enter CGE model
Model trade_CGE_MCP
/
EQINTU_D.INTER_USE_D_V
EQINTU_M.INTER_USE_M_V
EQCONS_H_D.CONS_H_D_V
EQCONS_H_M.CONS_H_M_V
EQCONS_G_D.CONS_G_D_V
EQCONS_G_M.CONS_G_M_V
EQGFCF_D.GFCF_D_V
EQGFCF_M.GFCF_M_V
EQSV.SV_V
EQIMP_T.IMPORT_T_V
EQIMP_MOD.IMPORT_MOD_V
EQIMP_ROW.IMPORT_ROW_V
EQTRADE.TRADE_V
EQEXP.EXPORT_ROW_V
EQPIMP_T.PIMP_T_V
EQPIMP_MOD.PIMP_MOD_V
/;

$label submodel_declaration
