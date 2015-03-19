* File:   library/scr/model_variables_equations.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 19 February 2015 (simple CGE formulation)

* gams-master-file: main.gms

$ontext startdoc
This `.gms` file is one of the `.gms` files part of the `main.gms` file and includes the equations and model formulation. Please start from `main.gms`.

This `.gms` file consists of the following parts:

1. Declaration of variables

2. Declaration of equations

3. Definition of equations

4. Definition of levels and lower and upper bounds and fixed variables

5. Setting of scale variables

6. Declaration of the model

$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ========================== 1. Declaration of variables ==========================

$ontext
Output by activity and product are here the variables which can be adjusted in the model. The variable `Cshock` is defined later in the `%simulation%` gms file.
$offtext

* Endogenous variables
Variables
    Y_V(regg,ind)                   output vector on industry level
    X_V(reg,prd)                    output vector on product level

    INTER_USE_T_V(prd,regg,ind)     use of intermediate inputs on aggregated
                                    # product level
    INTER_USE_D_V(prd,regg,ind)     use of domestically produced intermediate
                                    # inputs
    INTER_USE_M_V(prd,regg,ind)     use of aggregated imported intermediate
                                    # inputs
    INTER_USE_V(reg,prd,regg,ind)   use of intermediate inputs on the most
                                    # detailed level
    INTER_USE_ROW_V(row,prd,regg,ind)   intermediate use of products imported
                                    # from the rest of the world regions

    VA_V(regg,ind)                  use of aggregated production factors
    KL_V(reg,kl,regg,ind)           use of specific production factors

    CONS_H_T_V(prd,regg)            household consumption on aggregated product
                                    # level
    CONS_H_D_V(prd,regg)            household consumption of domestically
                                    # produced products
    CONS_H_M_V(prd,regg)            household consumption of aggregated products
                                    # imported from modeled regions
    CONS_H_V(reg,prd,regg)          household consumption of products on the
                                    # most detailed level
    CONS_H_ROW_V(row,prd,regg)      household consumption of products imported
                                    # from the rest of the world regions

    CONS_G_T_V(prd,regg)            government consumption on aggregated product
                                    # level
    CONS_G_D_V(prd,regg)            government consumption of domestically
                                    # produced products
    CONS_G_M_V(prd,regg)            government consumption of aggregated
                                    # product imported from modeled regions
    CONS_G_V(reg,prd,regg)          government consumption of products on the
                                    # most detailed level
    CONS_G_ROW_V(row,prd,regg)      government consumption of products imported
                                    # from the rest of the world regions

    GFCF_T_V(prd,regg)              gross fixed capital formation on aggregated
                                    # product level
    GFCF_D_V(prd,regg)              gross fixed capital formation of
                                    # domestically produced products
    GFCF_M_V(prd,regg)              gross fixed capital formation of aggregated
                                    # product imported from modeled regions
    GFCF_V(reg,prd,regg)            gross fixed capital formation of products on
                                    # the most detailed level
    GFCF_ROW_V(row,prd,regg)        gross fixed capital formation of products
                                    # imported from the rest of the world
                                    # regions

    SV_V(reg,prd,regg)              stock changes of products on the most
                                    # detailed level

    IMPORT_V(prd,regg)              total use of aggregated imported products
    TRADE_V(reg,prd,regg)           bi-lateral trade flows
    EXPORT_V(reg,prd,row)           export to the rest of the world regions

    FACREV_V(reg,kl)                revenue from factors of production
    TSPREV_V(reg)                   revenue from net tax on products
    NTPREV_V(reg)                   revenue from net tax on production
    TIMREV_V(reg)                   revenue from tax on export and international
                                    # margins

    INC_H_V(regg)                   gross income of households
    INC_G_V(regg)                   gross income of government
    INC_I_V(regg)                   gross income of investment agent
    CBUD_H_V(regg)                  budget available for household consumption
    CBUD_G_V(regg)                  budget available for government consumption
    CBUD_I_V(regg)                  budget available for gross fixed capital
                                    # formation

    PY_V(regg,ind)                  industry output price
    P_V(reg,prd)                    basic product price
    PKL_V(reg,kl)                   production factor price
    PVA_V(regg,ind)                 aggregate production factors price
    PIU_V(prd,regg,ind)             aggregate product price for intermediate use
    PC_H_V(prd,regg)                aggregate product price for household
                                    # consumption
    PC_G_V(prd,regg)                aggregate product price for government
                                    # consumption
    PC_I_V(prd,regg)                aggregate product price for gross fixed
                                    # capital formation
    PIMP_V(prd,regg)                aggregate imported product price
    SCLFD_H_V(regg)                 scale parameter for household consumption
    SCLFD_G_V(regg)                 scale parameter for government consumption
    SCLFD_I_V(regg)                 scale parameter for gross fixed capital
                                    # formation
    PROW_V(row)                     price of imports from the rest of the world
                                    # (similar to exchange rate)
    PAASCHE_V(regg)                 Paasche price index for household
                                    # consumption
    LASPEYRES_V(regg)               Laspeyres price index for household
                                    # consumption
;

*Positive variables
*;

* Exogenous variables
Variables
    KLS_V(reg,kl)                   supply of production factors
    SV_ROW_V(row,prd,regg)          stock changes of rest of the world products
    INCTRANSFER_V(reg,fd,regg,fdd)  income transfers
    TRANSFERS_ROW_V(reg,fd,row)     income trasnfers from rest of the world
                                    # regions
;

* Artificial objective
Variables
    OBJ                             artificial objective value

;

* ========================== 2. Declaration of equations ==========================

Equations
    EQBAL(reg,prd)              product market balance
    EQX(reg,prd)                supply of products with mix per industry
    EQY(regg,ind)               supply of activities with mix per product

    EQINTU_T(prd,regg,ind)      demand for intermediate inputs on aggregated
                                # product level
    EQINTU_D(prd,regg,ind)      demand for domestically produced intermediate
                                # inputs
    EQINTU_M(prd,regg,ind)      demand for aggregated imported intermediate
                                # inputs
    EQINTU(reg,prd,regg,ind)    demand for intermediate inputs on the most
                                # detailed level
    EQINTU_ROW(row,prd,regg,ind)    demand for intermediate use of products
                                # imported from the rest of the world regions

    EQVA(regg,ind)              demand for aggregated production factors
    EQKL(reg,kl,regg,ind)       demand for specific production factors

    EQCONS_H_T(prd,regg)        demand of households for products on aggregated
                                # product level
    EQCONS_H_D(prd,regg)        demand of households for domesrically produced
                                # products
    EQCONS_H_M(prd,regg)        demand of households for aggregated products
                                # imported from modeled regions
    EQCONS_H(reg,prd,regg)      demand of households for products on the most
                                # detailed level
    EQCONS_H_ROW(row,prd,regg)  expenditures of households on products
                                # imported from the rest of the world regions

    EQCONS_G_T(prd,regg)        demand of government for products on aggregated
                                # product level
    EQCONS_G_D(prd,regg)        demand of government for domesrically produced
                                # products
    EQCONS_G_M(prd,regg)        demand of government for aggregated products
                                # imported from modeled regions
    EQCONS_G(reg,prd,regg)      demand of government for products on the most
                                # detailed level
    EQCONS_G_ROW(row,prd,regg)  expenditures of government on products
                                # imported from the rest of the world regions

    EQGFCF_T(prd,regg)          demand of investment agent for products on
                                # aggregated product level
    EQGFCF_D(prd,regg)          demand of investment agent for domesrically
                                # produced products
    EQGFCF_M(prd,regg)          demand of investment agent for aggregated
                                # products imported from modeled regions
    EQGFCF(reg,prd,regg)        demand of investment agent for products on the
                                # most detailed level
    EQGFCF_ROW(row,prd,regg)    expenditures of investment agent on products
                                # imported from the rest of the world regions

    EQSV(reg,prd,regg)          demand for stock changes of products on the
                                # most detailed level

    EQIMP(prd,regg)             total demand for aggregared imported products
    EQTRADE(reg,prd,regg)       demand for bi-lateral trade transactions
    EQEXP(reg,prd,row)          export supply to the rest of the world regions

    EQFACREV(reg,kl)            revenue from factors of production
    EQTSPREV(reg)               revenue from net tax on products
    EQNTPREV(reg)               revenue from net tax on production
    EQTIMREV(reg)               revenue from tax on export and international
                                # margins

    EQINC_H(regg)               gross income of households
    EQINC_G(regg)               gross income of government
    EQINC_I(regg)               gross income of investment agent
    EQCBUD_H(regg)              budget available for household consumption
    EQCBUD_G(regg)              budget available for government consumption
    EQCBUD_I(regg)              budget available for gross fixed capital
                                # formation

    EQPY(regg,ind)              zero-profit condition (including possible
                                # margins)
    EQP(reg,prd)                balance between product price and industry price
    EQPKL(reg,kl)               balance on production factors market
    EQPVA(regg,ind)             balance between specific production factors
                                # price and aggregate production factors price
    EQPIU(prd,regg,ind)         balance between specific product price and
                                # aggregate product price for intermediate use
    EQPC_H(prd,regg)            balance between specific product price and
                                # aggregate product price for household
                                # consumption
    EQPC_G(prd,regg)            balance between specific product price and
                                # aggregate product price for government
                                # consumption
    EQPC_I(prd,regg)            balance between specific product price and
                                # aggregate product price for gross fixed
                                # capital formation
    EQPIMP(prd,regg)            balance between specific imported product price
                                # and aggregated imported product price
    EQSCLFD_H(regg)             budget constraint of households
    EQSCLFD_G(regg)             budget constraint of government
    EQSCLFD_I(regg)             budget constraint of investment agent
    EQPROW(row)                 balance of payments
    EQPAASCHE(regg)             Paasche price index for household consumption
    EQLASPEYRES(regg)           Laspeyres price index for household consumption

    EQOBJ                       artificial objective function
;


* ========================== 3. Definition of equations ===========================

* ## Beginning Block 1: Input-output ##

* EQUATION 1.1: Product market balance: product output is equal to total uses,
* including intermediate use, household consumption, government consumption,
* gross fixed capital formation, stock changes and, in case of an open economy,
* export. Product market balance is expressed in volume. Product market balance
* should hold for each product (prd) produced in each region (reg).
EQBAL(reg,prd)..
    sum((regg,ind), INTER_USE_V(reg,prd,regg,ind) ) +
    sum((regg), CONS_H_V(reg,prd,regg) ) +
    sum((regg), CONS_G_V(reg,prd,regg) ) +
    sum((regg), GFCF_V(reg,prd,regg) ) +
    sum((regg), SV_V(reg,prd,regg) ) +
    sum(row, EXPORT_V(reg,prd,row) )
    =E=
    X_V(reg,prd) ;

* EQUATION 1.2A: Output level of products: given total amount of output per
* activity, output per product (reg,prd) is derived based on fixed output shares
* of each industry (regg,ind). EQUATION 1.2A corresponds to product technology
* assumption in input-output analysis, EQUATION 1.2B corresponds to industry
* technology assumption in input-output analysis. EQUATION 1.2A is only suitable
* for input-output analysis where number of products (prd) is equal to number
* of industries (ind). EQUATION 1.2A cannot be used in MCP setup.
EQX(reg,prd)..
    X_V(reg,prd)
    =E=
    sum((regg,ind), coprodA(reg,prd,regg,ind) * Y_V(regg,ind) ) ;

* EQUATION 1.2B: Output level of activities: given total amount of output per
* product, required output per activity (regg,ind) is derived based on fixed
* sales structure on each product market (reg,prd). EQUATION 1.2A corresponds to
* product technology assumption in input-output analysis, EQUATION 1.2B
* corresponds to industry technology assumption in input-output analysis.
* EQUATION 1.2B is suitable for input-output and CGE analysis.
EQY(regg,ind)..
    Y_V(regg,ind)
    =E=
    sum((reg,prd), coprodB(reg,prd,regg,ind) * X_V(reg,prd) ) ;

* EQUATION 1.3: Demand for intermediate inputs on aggregated product level. The
* demand function follows Leontief form, where the relation between intermediate
* inputs of aggregated product (prd) and output of the industry (regg,ind) in
* volume is kept constant.
EQINTU_T(prd,regg,ind)..
    INTER_USE_T_V(prd,regg,ind)
    =E=
    ioc(prd,regg,ind) * Y_V(regg,ind) ;

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
    ( PIMP_V(prd,regg) /
    ( PIU_V(prd,regg,ind) * ( 1 + tc_ind(prd,regg,ind) ) ) )**
    ( -elasIU_DM(prd,regg,ind) ) ;

* EQUATION 1.6: Demand for intermediate inputs on the most detailed product
* level. In case the region of demand (regg) is the same as region of product
* (reg), the demand function is equal to demand for domestically produced
* product. In case the regions of demand and production differ, the demand
* function depends on the demand for aggregated imported product and share of
* import from region regg in the aggregated import.
EQINTU(reg,prd,regg,ind)$( sameas(reg,regg) or TRADE(reg,prd,regg) )..
    INTER_USE_V(reg,prd,regg,ind)
    =E=
    ( INTER_USE_D_V(prd,regg,ind) )$sameas(reg,regg) +
    ( TRADE_V(reg,prd,regg) * INTER_USE_M_V(prd,regg,ind) /
    IMPORT_V(prd,regg) )$(not sameas(reg,regg)) ;

* EQAUTION 1.7: Demand for intermediate use of product imported from the rest of
* the world regions. The demand function follows Leontief form, where use of
* each product type (prd) imported from each rest of the world region (row) by
* each industry (ind,regg) is proportional to the volume of output of this
* industry.
EQINTU_ROW(row,prd,regg,ind)..
    INTER_USE_ROW_V(row,prd,regg,ind)
    =E=
    phi_row(row,prd,regg,ind) * Y_V(regg,ind) ;

* ## End Block 1: Input-output ##



* ## Beginning Block 2: Factor demand ##

* EQUATION 2.1: Demand for aggregated production factors. The demand function
* follows Leontief form, where the relation between aggregated value added and
* output of the industry (regg,ind) in volume is kept constant.
EQVA(regg,ind)..
    VA_V(regg,ind)
    =E=
    aVA(regg,ind) * Y_V(regg,ind) ;

* EQUAION 2.2: Demand for specific production factors. The demand function
* follows CES form, where demand of each industry (regg,ind) for each factor of
* production (reg,kl) depends linearly on the demand of the same industry for
* aggregated production factors and with certain elasticity on relative prices
* of specific factors of production.
EQKL(reg,kl,regg,ind)$VALUE_ADDED(reg,kl,regg,ind)..
    KL_V(reg,kl,regg,ind)
    =E=
    ( VA_V(regg,ind) / tfp(regg,ind) ) * alpha(reg,kl,regg,ind) *
    ( PKL_V(reg,kl) /
    ( tfp(regg,ind) * PVA_V(regg,ind) ) )**( -elasKL(regg,ind) ) ;

* ## End Block 2: Factor demand ##



* ## Beginning Block 3: Household demand for products ##

* EQUATION 3.1: Household demand for aggregated products. The demand function
* follows CES form, where demand by households in each region (regg) for each
* aggregated product (prd) depends with certain elasticity on relative prices
* of different aggregated products. The final demand function is derived from
* utility optimization, but there is no market for utility and corresponding
* price doesn't exist, contrary to CES demand functions derived from
* optimization of a production function. Scaling parameter (SCLDF_H_V) is
* introduced in order to ensure budget constraint (see EQUATION 10.10).
EQCONS_H_T(prd,regg)..
    CONS_H_T_V(prd,regg)
    =E=
    SCLFD_H_V(regg) * theta_h(prd,regg) *
    ( PC_H_V(prd,regg) * ( 1 + tc_h(prd,regg) ) )**( -elasFU_H(regg) ) ;

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
    ( PIMP_V(prd,regg) /
    ( PC_H_V(prd,regg) * ( 1 + tc_h(prd,regg) ) ) )
    **( -elasFU_DM(prd,regg) ) ;

* EQUATION 3.4: Household demand for products on the most detailed level. In
* case the region of demand (regg) is the same as region of product (reg), the
* demand function is equal to demand for domestically produced product. In case
* the regions of demand and production differ, the demand function depends on
* the demand for aggregated imported product and share of import from region
* regg in the aggregated import.
EQCONS_H(reg,prd,regg)$( sameas(reg,regg) or TRADE(reg,prd,regg) )..
    CONS_H_V(reg,prd,regg)
    =E=
    ( CONS_H_D_V(prd,regg) )$sameas(reg,regg) +
    ( TRADE_V(reg,prd,regg) * CONS_H_M_V(prd,regg) /
    IMPORT_V(prd,regg) )$(not sameas(reg,regg)) ;

* EQUATOION 3.5: Expenditures of households on products imported from the rest
* of the world regions. The expenditures on each type of product (prd) imported
* from each rest of the world region (row) are modelled as a share of
* consumption budget of households in each region (regg).
EQCONS_H_ROW(row,prd,regg)..
    CONS_H_ROW_V(row,prd,regg) * PROW_V(row)
    =E=
    theta_h_row(row,prd,regg) * CBUD_H_V(regg) ;

* ## End Block 3: Household demand for products ##



* ## Beginning Block 4: Government demand for products ##

* EQUATION 4.1: Government demand for aggregated products. The demand function
* follows CES form, where demand by government in each region (regg) for each
* aggregated product (prd) depends with certain elasticity on relative prices
* of different aggregated products. Scaling parameter (SCLDF_G_V) is
* introduced in order to ensure budget constraint (see EQUATION 10.11).
EQCONS_G_T(prd,regg)..
    CONS_G_T_V(prd,regg)
    =E=
    SCLFD_G_V(regg) * theta_g(prd,regg) *
    ( PC_G_V(prd,regg) * ( 1 + tc_g(prd,regg) ) )**( -elasFU_G(regg) ) ;

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
    ( PIMP_V(prd,regg) /
    ( PC_G_V(prd,regg) * ( 1 + tc_g(prd,regg) ) ) )
    **( -elasFU_DM(prd,regg) ) ;

* EQUATION 4.4: Government demand for products on the most detailed level. In
* case the region of demand (regg) is the same as region of product (reg), the
* demand function is equal to demand for domestically produced product. In case
* the regions of demand and production differ, the demand function depends on
* the demand for aggregated imported product and share of import from region
* regg in the aggregated import.
EQCONS_G(reg,prd,regg)$( sameas(reg,regg) or TRADE(reg,prd,regg) )..
    CONS_G_V(reg,prd,regg)
    =E=
    ( CONS_G_D_V(prd,regg) )$sameas(reg,regg) +
    ( TRADE_V(reg,prd,regg) * CONS_G_M_V(prd,regg) /
    IMPORT_V(prd,regg) )$(not sameas(reg,regg)) ;

* EQUATOION 4.5: Expenditures of government on products imported from the rest
* of the world regions. The expenditures on each type of product (prd) imported
* from each rest of the world region (row) are modelled as a share of
* consumption budget of government in each region (regg).
EQCONS_G_ROW(row,prd,regg)..
    CONS_G_ROW_V(row,prd,regg) * PROW_V(row)
    =E=
    theta_g_row(row,prd,regg) * CBUD_G_V(regg) ;

* ## End Block 4: Government demand for products ##



* ## Beginning Block 5: Investment agent demand for products ##

* EQUATION 5.1: Investment agent demand for aggregated products. The demand
* function follows CES form, where demand by investment agent in each region
* (regg) for each aggregated product (prd) depends with certain elasticity on
* relative prices of different aggregated products. Scaling parameter
* (SCLDF_I_V) is introduced in order to ensure budget constraint (see EQUATION
* 10.12).
EQGFCF_T(prd,regg)..
    GFCF_T_V(prd,regg)
    =E=
    SCLFD_I_V(regg) * theta_gfcf(prd,regg) *
    ( PC_I_V(prd,regg) * ( 1 + tc_gfcf(prd,regg) ) )**( -elasFU_I(regg) ) ;

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
    ( PIMP_V(prd,regg) /
    ( PC_I_V(prd,regg) * ( 1 + tc_gfcf(prd,regg) ) ) )
    **( -elasFU_DM(prd,regg) ) ;

* EQUATION 5.4: Investment agent demand for products on the most detailed level.
* In case the region of demand (regg) is the same as region of product (reg),
* the demand function is equal to demand for domestically produced product. In
* case the regions of demand and production differ, the demand function depends
* on the demand for aggregated imported product and share of import from region
* regg in the aggregated import.
EQGFCF(reg,prd,regg)$( sameas(reg,regg) or TRADE(reg,prd,regg) )..
    GFCF_V(reg,prd,regg)
    =E=
    ( GFCF_D_V(prd,regg) )$sameas(reg,regg) +
    ( TRADE_V(reg,prd,regg) * GFCF_M_V(prd,regg) /
    IMPORT_V(prd,regg) )$(not sameas(reg,regg)) ;

* EQUATOION 5.5: Expenditures of investment agent on products imported from the
* rest of the world regions. The expenditures on each type of product (prd)
* imported from each rest of the world region (row) are modelled as a share of
* consumption budget of investment agent in each region (regg).
EQGFCF_ROW(row,prd,regg)..
    GFCF_ROW_V(row,prd,regg) * PROW_V(row)
    =E=
    theta_gfcf_row(row,prd,regg) * CBUD_I_V(regg) ;

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

* EQUATION 7.1: Total demand for aggregate products imported from modeled
* regions. The demand for each aggregated imported product (prd) in each region
* (regg) is a sum of the corresponding demand of industries, household,
* government and investment agent in this region.
EQIMP(prd,regg)..
    IMPORT_V(prd,regg)
    =E=
    sum(ind, INTER_USE_M_V(prd,regg,ind) ) +
    CONS_H_M_V(prd,regg) + CONS_G_M_V(prd,regg) + GFCF_M_V(prd,regg) ;

* EQUATION 7.2: Demand for bi-lateral trade transactions. The demand function
* follows CES form, where demand from importing each region (regg) for each
* product type (prd) produced in each exporting region (reg) depends linearly
* on the total demand for aggregated imported product in the same importing
* region and with certain elasticity on relative prices of the same product
* types produced by different exporting regions.
EQTRADE(reg,prd,regg)..
    TRADE_V(reg,prd,regg)
    =E=
    IMPORT_V(prd,regg) * gamma(reg,prd,regg) *
    ( P_V(reg,prd) / PIMP_V(prd,regg) )**
    ( -elasIMP(prd,regg) ) ;

* EQUATION 7.3: Export supply to the rest of the world regions. Export of each
* product (prd) produced in each region (reg) supplied to each rest of the world
* regions (row) is a share of the corresponding product output. It is assumed
* that the rest of the world regions are buying all th export supplied
* to them.
EQEXP(reg,prd,row)..
    EXPORT_V(reg,prd,row)
    =E=
    gammaE(reg,prd,row) * X_V(reg,prd) ;

* ## End Block 7: Inter-regional trade ##



* ## Beginning Block 8: Factor and tax revenue ##

* EQUATION 8.1: Revenue from factors of production. The revenue of each specific
* factor (reg,kl) is a sum of revenues earned by the corresponding factor in
* each industry (ind) in each region (regg).
EQFACREV(reg,kl)..
    FACREV_V(reg,kl)
    =E=
    sum((regg,ind), KL_V(reg,kl,regg,ind) * PKL_V(reg,kl) ) ;

* EQUATION 8.2: Revenue from net taxes on products. The revenue in each region
* (reg) is a sum of revenues earned from sales of products to industries (ind)
* for intermediate use, households, government, investment agent in the same
* region.
EQTSPREV(reg)..
    TSPREV_V(reg)
    =E=
    sum((regg,prd,ind), INTER_USE_V(regg,prd,reg,ind) * P_V(regg,prd) *
    tc_ind(prd,reg,ind) ) +
    sum((row,prd,ind), INTER_USE_ROW_V(row,prd,reg,ind) * PROW_V(row) *
    tc_ind(prd,reg,ind) ) +
    sum((regg,prd), CONS_H_V(regg,prd,reg) * P_V(regg,prd) *
    tc_h(prd,reg) ) +
    sum((row,prd), CONS_H_ROW_V(row,prd,reg) * PROW_V(row) *
    tc_h(prd,reg) ) +
    sum((regg,prd), CONS_G_V(regg,prd,reg) * P_V(regg,prd) *
    tc_g(prd,reg) ) +
    sum((row,prd), CONS_G_ROW_V(row,prd,reg) * PROW_V(row) *
    tc_g(prd,reg) ) +
    sum((regg,prd), GFCF_V(regg,prd,reg) * P_V(regg,prd) *
    tc_gfcf(prd,reg) ) +
    sum((row,prd), GFCF_ROW_V(row,prd,reg) * PROW_V(row) *
    tc_gfcf(prd,reg) ) +
    sum((regg,prd), SV_V(regg,prd,reg) * P_V(regg,prd) *
    tc_sv(prd,reg) ) +
    sum((row,prd), SV_ROW_V(row,prd,reg) * PROW_V(row) *
    tc_sv(prd,reg) ) ;

* EQUATION 8.3: Revenue from net taxes on production. The revenue in each region
* (reg) is a sum of revenues earned from production activities of each industry
* (ind,regg).
EQNTPREV(reg)..
    NTPREV_V(reg)
    =E=
    sum((regg,ind), Y_V(regg,ind) * PY_V(regg,ind) *
    txd_ind(reg,regg,ind) ) ;

* EQUATION 8.4: Revenue from tax on export and international margins. The
* revenue in each region (reg) is a sum of revenues earned from production
* activities of each industry (ind,regg) and from final consumers in each
* modeled region (reg) and rest of the world region (row). The revenues from
* final consumers and rest of the world are not explicitly modeled and taken
* as exogenous values from the calibration year.
EQTIMREV(reg)..
    TIMREV_V(reg)
    =E=
    sum((regg,ind), Y_V(regg,ind) * PY_V(regg,ind) *
    txd_tim(reg,regg,ind) ) +
    sum((tim,regg,fd), TAX_FINAL_USE(reg,tim,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum((tim,row), TAX_EXPORT(reg,tim,row) * PROW_V(row) ) ;

* ## End Block 8: Factor and tax revenue ##



* ## Beginning Block 9: Final consumers budgets ##

* EQUATION 9.1: Gross income of households. Gross income is composed of
* shares of factor revenues attributable to households in each region (regg),
* and well as income transfers from other final users. At the moment income
* transfers is one of the exogenous variables of the model, therefore it is
* multiplied by a price index in order to preserve model homogeneity in prices
* of degree zero.
EQINC_H(regg)..
    INC_H_V(regg)
    =E=
    sum((reg,kl), FACREV_V(reg,kl) * fac_distr_h(reg,kl,regg) ) +
    sum(fd$fd_assign(fd,'Households'),
    sum((reg,fdd), INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) +
    sum(row, TRANSFERS_ROW_V(regg,fd,row) * PROW_V(row) ) ) ;

* EQUATION 9.2: Gross income of government. Gross income is composed of
* shares of factor revenues attributable to government in each region (regg),
* tax revenues, as well as income transfers from other final users. At the
* moment income transfers is one of the exogenous variables of the model,
* therefore it is  multiplied by a price index in order to preserve model
* homogeneity in prices of degree zero.
EQINC_G(regg)..
    INC_G_V(regg)
    =E=
    sum((reg,kl), FACREV_V(reg,kl) * fac_distr_g(reg,kl,regg) ) +
    TSPREV_V(regg) + NTPREV_V(regg) + TIMREV_V(regg) +
    sum(fd$fd_assign(fd,'Government'),
    sum((reg,fdd), INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) +
    sum(row, TRANSFERS_ROW_V(regg,fd,row) * PROW_V(row) ) ) ;

* EQUATION 9.3: Gross income of investment agent. Gross income is composed of
* shares of factor revenues attributable to investment agent in each region
* (regg), and well as income transfers from other final users. At the moment
* income transfers is one of the exogenous variables of the model, therefore it
* is multiplied by a price index in order to preserve model homogeneity in
* prices of degree zero.
EQINC_I(regg)..
    INC_I_V(regg)
    =E=
    sum((reg,kl), FACREV_V(reg,kl) * fac_distr_gfcf(reg,kl,regg) ) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum((reg,fdd), INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) +
    sum(row, TRANSFERS_ROW_V(regg,fd,row) * PROW_V(row) ) ) ;

* EQUATION 9.4: Budget available for household consumption. Budget is composed
* of gross income of households in each region (regg) less income transfers to
* other final users and less international margin paid by household. At the
* moment income transfers is one of the exogenous variables of the model,
* therefore it is multiplied by a price index in order to preserve model
* homogeneity in prices of degree zero.
EQCBUD_H(regg)..
    CBUD_H_V(regg)
    =E=
    INC_H_V(regg) -
    sum(fd$fd_assign(fd,'Households'),
    sum((reg,fdd), INCTRANSFER_V(regg,fd,reg,fdd) * LASPEYRES_V(regg) ) +
    sum((reg,tim), TAX_FINAL_USE(reg,tim,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum((row,tim), TAX_FINAL_USE_ROW(row,tim,regg,fd) *
    PROW_V(row) ) ) ;

* EQUATION 9.5: Budget available for government consumption. Budget is composed
* of gross income of government in each region (regg) less income transfers to
* other final users and less international margin paid by government. At the
* moment income transfers is one of the exogenous variables of the model,
* therefore it is multiplied by a price index in order to preserve model
* homogeneity in prices of degree zero.
EQCBUD_G(regg)..
    CBUD_G_V(regg)
    =E=
    INC_G_V(regg) -
    sum(fd$fd_assign(fd,'Government'),
    sum((reg,fdd), INCTRANSFER_V(regg,fd,reg,fdd) * LASPEYRES_V(regg) ) +
    sum((reg,tim), TAX_FINAL_USE(reg,tim,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum((row,tim), TAX_FINAL_USE_ROW(row,tim,regg,fd) *
    PROW_V(row) ) ) ;

* EQUATION 9.6: Budget available for gross fixed capital formation. Budget is
* composed of gross income of investment agent in each region (regg) less
* expenditures on stock changes, less income transfers to other final users and
* less international margin by on gross fixed capital formation and on stock
* change. At the moment income transfers is one of the exogenous variables of
* the model, therefore it is multiplied by a price index in order to preserve
* model homogeneity in prices of degree zero.
EQCBUD_I(regg)..
    CBUD_I_V(regg)
    =E=
    INC_I_V(regg) -
    sum((reg,prd), SV_V(reg,prd,regg) * P_V(reg,prd) *
    ( 1 + tc_sv(prd,regg) ) ) -
    sum((row,prd), SV_ROW_V(row,prd,regg) * PROW_V(row) *
    ( 1 + tc_sv(prd,regg) ) ) -
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum((reg,fdd)$( not fd_assign(fdd,'StockChange') ),
    INCTRANSFER_V(regg,fd,reg,fdd) * LASPEYRES_V(regg) ) +
    sum((reg,tim), TAX_FINAL_USE(reg,tim,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum((row,tim), TAX_FINAL_USE_ROW(row,tim,regg,fd) *
    PROW_V(row) ) ) -
    sum(fd$fd_assign(fd,'StockChange'),
    sum((reg,tim), TAX_FINAL_USE(reg,tim,regg,fd) *
    LASPEYRES_V(regg) ) +
    sum((row,tim), TAX_FINAL_USE_ROW(row,tim,regg,fd) *
    PROW_V(row) ) ) ;

* ## End Block 9: Final consumers budgets ##



* ## Beginning Block 10: Prices and budget constraints ##

* EQUATION 10.1: Zero-profit condition. Industry output price for each industry
* (ind) in each region (regg) is defined in such a way that revenues earned from
* product sales less possible production net taxes are equal to the cost of
* intermediate inputs and factors of production, including possible product and
* factor taxes, plus, if modeled, excessive profit margins. Output price for one
* industry in one country is chosen as a numéraire (exogenous variable), so in
* order to keep the system square, the equation is not defined for this specific
* industry in this specific region.
EQPY(regg,ind)$((not sameas(regg,'WEU')) or (not sameas(ind,'i020')))..
    Y_V(regg,ind) * PY_V(regg,ind) *
    ( 1 - sum(reg, txd_ind(reg,regg,ind) ) -
    sum(reg, txd_tim(reg,regg,ind) ) )
    =E=
    sum((reg,prd), INTER_USE_V(reg,prd,regg,ind) * P_V(reg,prd) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((row,prd), INTER_USE_ROW_V(row,prd,regg,ind) * PROW_V(row) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((reg,kl), KL_V(reg,kl,regg,ind) * PKL_V(reg,kl) ) +
    sum((row,tim), TAX_INTER_USE_ROW(row,tim,regg,ind) * PROW_V(row) ) ;

* EQUATION 10.2: Balance between product price and industry price. Price of each
* product (prd) in each region of production (reg) is defined as a weighted
* average of industry prices, where weights are defined as output of the product
* by the corresponding industry . Price equation are only relevant for CGE
* model, and since only EQUATION 1.2B is suitable for CGE model, the
* co-production coefficients of EQUATION 1.2B are used.
EQP(reg,prd)..
    P_V(reg,prd) * X_V(reg,prd)
    =E=
    sum((regg,ind), PY_V(regg,ind) *
    ( coprodB(reg,prd,regg,ind) * X_V(reg,prd) ) ) ;

* EQUATION 10.3: Balance on production factors market. Price of each production
* factor (reg,kl) is defined in such a way that total demand for the
* corresponding production factor is equal to the supply of the factor less,
* if modeled, unemployment. Supply of production factors is one of the
* exogenous variables of the model.
EQPKL(reg,kl)..
    KLS_V(reg,kl)
    =E=
    sum((regg,ind), KL_V(reg,kl,regg,ind) ) ;

* EQUATION 10.4: Balance between specific production factors price and aggregate
* production factors price. The aggregate price is different in each industry
* (ind) in each region (regg) and is a weighted average of the price of specific
* production factors, where weights are defined as demand by the industry for
* corresponding production factors.
EQPVA(regg,ind)..
    PVA_V(regg,ind) * VA_V(regg,ind)
    =E=
    sum((reg,kl), PKL_V(reg,kl) * KL_V(reg,kl,regg,ind)) ;

* EQUATION 10.5: Balance between specific product price and aggregate product
* price for intermediate use. The aggregate price is different for each
* aggregated product (prd) in each industry (ind) in each region (regg) and is
* a weighted average of the price of domestically produced product and the
* aggregate import price, where weights are defined as corresponding demands for
* intermediate use.
EQPIU(prd,regg,ind)..
    PIU_V(prd,regg,ind) * INTER_USE_T_V(prd,regg,ind)
    =E=
    P_V(regg,prd) * INTER_USE_D_V(prd,regg,ind) +
    PIMP_V(prd,regg) * INTER_USE_M_V(prd,regg,ind) ;

* EQUATION 10.6: Balance between specific product price and aggregate product
* price for household consumption. The aggregate price is different for each
* aggregated product (prd) demanded by households in each region (regg) and is a
* weighted average of the price of domestically produced product and the
* aggregate import price, where weights are defined as corresponding household
* demands.
EQPC_H(prd,regg)..
    PC_H_V(prd,regg) * CONS_H_T_V(prd,regg)
    =E=
    P_V(regg,prd) * CONS_H_D_V(prd,regg) +
    PIMP_V(prd,regg) * CONS_H_M_V(prd,regg) ;

* EQUATION 10.7: Balance between specific product price and aggregate product
* price for government consumption. The aggregate price is different for each
* aggregated product (prd) demanded by government in each region (regg) and is a
* weighted average of the price of domestically produced product and the
* aggregate import price, where weights are defined as corresponding government
* demands.
EQPC_G(prd,regg)..
    PC_G_V(prd,regg) * CONS_G_T_V(prd,regg)
    =E=
    P_V(regg,prd) * CONS_G_D_V(prd,regg) +
    PIMP_V(prd,regg) * CONS_G_M_V(prd,regg) ;

* EQUATION 10.8: Balance between specific product price and aggregate product
* price for gross fixed capital formation. The aggregate price is different for
* each aggregated product (prd) demanded by investment agent in each region
* (regg) and is a weighted average of the price of domestically produced product
* and the aggregate import price, where weights are defined as corresponding
* gross fixed capital formation demands.
EQPC_I(prd,regg)..
    PC_I_V(prd,regg) * GFCF_T_V(prd,regg)
    =E=
    P_V(regg,prd) * GFCF_D_V(prd,regg) +
    PIMP_V(prd,regg) * GFCF_M_V(prd,regg) ;

* EQUATION 10.9: Balance between specific imported product price and aggregated
* imported product price. The aggregate price is different for each product
* (prd) in each importing region (regg) and is a weighed average of specific
* product prices of exporting regions, where weights are defined as bi-lateral
* trade flows between the importing regions and the corresponding exporting
* regions.
EQPIMP(prd,regg)..
    PIMP_V(prd,regg) * IMPORT_V(prd,regg)
    =E=
    sum(reg, TRADE_V(reg,prd,regg) * P_V(reg,prd) ) ;

* EQUATION 10.10: Budget constraint of households. The equation ensures that the
* total budget available for household consumption is spent on purchase of
* products. The equation defines scaling parameter of households, see also
* explanation for EQUATION 3.1.
EQSCLFD_H(regg)..
    CBUD_H_V(regg)
    =E=
    sum((reg,prd), CONS_H_V(reg,prd,regg) * P_V(reg,prd) *
    ( 1 + tc_h(prd,regg) ) ) +
    sum((row,prd), CONS_H_ROW_V(row,prd,regg) * PROW_V(row) *
    ( 1 + tc_h(prd,regg) ) ) ;

* EQUATION 10.11: Budget constraint of government. The equation ensures that the
* total budget available for government consumption is spent on purchase of
* products. The equation defines scaling parameter of government.
EQSCLFD_G(regg)..
    CBUD_G_V(regg)
    =E=
    sum((reg,prd), CONS_G_V(reg,prd,regg) * P_V(reg,prd) *
    ( 1 + tc_g(prd,regg) ) ) +
    sum((row,prd), CONS_G_ROW_V(row,prd,regg) * PROW_V(row) *
    ( 1 + tc_g(prd,regg) ) ) ;

* EQUATION 10.12: Budget constraint of investment agent. The equation ensures
* that the total budget available for gross fixed capital formation is spent on
* purchase of products. The equation defines scaling parameter of investment
* agent.
EQSCLFD_I(regg)..
    CBUD_I_V(regg)
    =E=
    sum((reg,prd), GFCF_V(reg,prd,regg) * P_V(reg,prd) *
    ( 1 + tc_gfcf(prd,regg) ) ) +
    sum((row,prd), GFCF_ROW_V(row,prd,regg) * PROW_V(row) *
    ( 1 + tc_gfcf(prd,regg) ) ) ;

* EQUATION 10.13: Balance of payments. Expenditures of each rest of the world
* region (row) on exports and income transfers are equal to the region's
* receipts from its imports. The balance is regulated by the price that
* intermediate and final users are paying for the products imported from the
* corresponding rest of the world region.
EQPROW(row)..
    sum((reg,prd), EXPORT_V(reg,prd,row) * P_V(reg,prd) ) +
    sum((reg,tim), TAX_EXPORT(reg,tim,row) ) * PROW_V(row)
    =E=
    sum((prd,regg,ind), INTER_USE_ROW_V(row,prd,regg,ind) ) * PROW_V(row) +
    sum((prd,regg), CONS_H_ROW_V(row,prd,regg) ) * PROW_V(row) +
    sum((prd,regg), CONS_G_ROW_V(row,prd,regg) ) * PROW_V(row) +
    sum((prd,regg), GFCF_ROW_V(row,prd,regg) ) * PROW_V(row) +
    sum((prd,regg), SV_ROW_V(row,prd,regg) ) * PROW_V(row) +
    sum((tim,regg,ind), TAX_INTER_USE_ROW(row,tim,regg,ind) ) *
    PROW_V(row) +
    sum((tim,regg,fd), TAX_FINAL_USE_ROW(row,tim,regg,fd) ) *
    PROW_V(row) -
    sum((reg,fd), TRANSFERS_ROW_V(reg,fd,row) * PROW_V(row) ) ;

* EQUATION 10.14: Paasche price index for households. The price index is
* calculated separately for each region (regg).
EQPAASCHE(regg)..
    PAASCHE_V(regg)
    =E=
    sum((reg,prd), CONS_H_V(reg,prd,regg) * P_V(reg,prd) *
    ( 1 + tc_h(prd,regg) ) ) /
    sum((reg,prd), CONS_H_V(reg,prd,regg) * 1 *
    ( 1 + tc_h(prd,regg) ) ) ;

* EQUATION 10.15: Laspeyres price index for households. The price index is
* calculated separately for each region (regg).
EQLASPEYRES(regg)..
    LASPEYRES_V(regg)
    =E=
    sum((reg,prd), CONS_H(reg,prd,regg) * P_V(reg,prd) *
    ( 1 + tc_h(prd,regg) ) ) /
    sum((reg,prd), CONS_H(reg,prd,regg) * 1 *
    ( 1 + tc_h(prd,regg) ) ) ;

* ## End Price block ##



* EQUATION 34: Artificial objective function: only relevant for users of
* conopt solver in combination with NLP type of mathematical problem.
EQOBJ..
    OBJ
    =E=
    1 ;


* ======== 4. Define levels and lower and upper bounds and fixed variables ========

* Endogenous variables
* Variables in real terms: level is set to the calibrated value of the
* corresponding parameter. In the the calibrated value is equal to zero, the
* variable value is also fixed to zero. The equation setup will led to zero
* solution for this variable and fixing it at this point help the solver.
Y_V.L(regg,ind) = Y(regg,ind) ;
X_V.L(reg,prd)  = X(reg,prd) ;
Y_V.FX(regg,ind)$(Y(regg,ind) eq 0) = 0 ;
X_V.FX(reg,prd)$(X(reg,prd) eq 0)   = 0 ;

INTER_USE_T_V.L(prd,regg,ind)       = INTER_USE_T(prd,regg,ind) ;
INTER_USE_D_V.L(prd,regg,ind)       = INTER_USE_D(prd,regg,ind) ;
INTER_USE_M_V.L(prd,regg,ind)       = INTER_USE_M(prd,regg,ind) ;
INTER_USE_V.L(reg,prd,regg,ind)     = INTER_USE(reg,prd,regg,ind) ;
INTER_USE_ROW_V.L(row,prd,regg,ind) = INTER_USE_ROW(row,prd,regg,ind) ;
INTER_USE_T_V.FX(prd,regg,ind)$(INTER_USE_T(prd,regg,ind) eq 0)                   = 0 ;
INTER_USE_D_V.FX(prd,regg,ind)$(INTER_USE_D(prd,regg,ind) eq 0)                   = 0 ;
INTER_USE_M_V.FX(prd,regg,ind)$(INTER_USE_M(prd,regg,ind) eq 0)                   = 0 ;
INTER_USE_V.FX(reg,prd,regg,ind)$(INTER_USE(reg,prd,regg,ind) eq 0)               = 0 ;
INTER_USE_ROW_V.FX(row,prd,regg,ind)$(INTER_USE_ROW(row,prd,regg,ind) eq 0) = 0 ;

VA_V.L(regg,ind)        = sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) ;
KL_V.L(reg,kl,regg,ind) = VALUE_ADDED(reg,kl,regg,ind) ;
VA_V.FX(regg,ind)$(sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) eq 0) = 0 ;
KL_V.FX(reg,kl,regg,ind)$(VALUE_ADDED(reg,kl,regg,ind) eq 0 )         = 0 ;

CONS_H_T_V.L(prd,regg)       = CONS_H_T(prd,regg) ;
CONS_H_D_V.L(prd,regg)       = CONS_H_D(prd,regg) ;
CONS_H_M_V.L(prd,regg)       = CONS_H_M(prd,regg) ;
CONS_H_V.L(reg,prd,regg)     = CONS_H(reg,prd,regg) ;
CONS_H_ROW_V.L(row,prd,regg) = CONS_H_ROW(row,prd,regg) ;
CONS_H_T_V.FX(prd,regg)$(CONS_H_T(prd,regg) eq 0)             = 0 ;
CONS_H_D_V.FX(prd,regg)$(CONS_H_D(prd,regg) eq 0)             = 0 ;
CONS_H_M_V.FX(prd,regg)$(CONS_H_M(prd,regg) eq 0)             = 0 ;
CONS_H_V.FX(reg,prd,regg)$(CONS_H(reg,prd,regg) eq 0)         = 0 ;
CONS_H_ROW_V.FX(row,prd,regg)$(CONS_H_ROW(row,prd,regg) eq 0) = 0 ;

CONS_G_T_V.L(prd,regg)       = CONS_G_T(prd,regg) ;
CONS_G_D_V.L(prd,regg)       = CONS_G_D(prd,regg) ;
CONS_G_M_V.L(prd,regg)       = CONS_G_M(prd,regg) ;
CONS_G_V.L(reg,prd,regg)     = CONS_G(reg,prd,regg) ;
CONS_G_ROW_V.L(row,prd,regg) = CONS_G_ROW(row,prd,regg) ;
CONS_G_T_V.FX(prd,regg)$(CONS_G_T(prd,regg) eq 0)             = 0 ;
CONS_G_D_V.FX(prd,regg)$(CONS_G_D(prd,regg) eq 0)             = 0 ;
CONS_G_M_V.FX(prd,regg)$(CONS_G_M(prd,regg) eq 0)             = 0 ;
CONS_G_V.FX(reg,prd,regg)$(CONS_G(reg,prd,regg) eq 0)         = 0 ;
CONS_G_ROW_V.FX(row,prd,regg)$(CONS_G_ROW(row,prd,regg) eq 0) = 0 ;

GFCF_T_V.L(prd,regg)       = GFCF_T(prd,regg) ;
GFCF_D_V.L(prd,regg)       = GFCF_D(prd,regg) ;
GFCF_M_V.L(prd,regg)       = GFCF_M(prd,regg) ;
GFCF_V.L(reg,prd,regg)     = GFCF(reg,prd,regg) ;
GFCF_ROW_V.L(row,prd,regg) = GFCF_ROW(row,prd,regg) ;
GFCF_T_V.FX(prd,regg)$(GFCF_T(prd,regg) eq 0)             = 0 ;
GFCF_D_V.FX(prd,regg)$(GFCF_D(prd,regg) eq 0)             = 0 ;
GFCF_M_V.FX(prd,regg)$(GFCF_M(prd,regg) eq 0)             = 0 ;
GFCF_V.FX(reg,prd,regg)$(GFCF(reg,prd,regg) eq 0)         = 0 ;
GFCF_ROW_V.FX(row,prd,regg)$(GFCF_ROW(row,prd,regg) eq 0) = 0 ;

SV_V.L(reg,prd,regg) = SV(reg,prd,regg) ;
SV_V.FX(reg,prd,regg)$(SV(reg,prd,regg) eq 0) = 0 ;

IMPORT_V.L(prd,regg)        = IMPORT(prd,regg) ;
TRADE_V.L(reg,prd,regg)     = TRADE(reg,prd,regg) ;
EXPORT_V.L(reg,prd,row)     = EXPORT(reg,prd,row) ;
IMPORT_V.FX(prd,regg)$(IMPORT(prd,regg) eq 0)             = 0 ;
TRADE_V.FX(reg,prd,regg)$(TRADE(reg,prd,regg) eq 0)       = 0 ;
EXPORT_V.FX(reg,prd,row)$(EXPORT(reg,prd,row) eq 0) = 0 ;

* Variables in monetary terms: level is set to the calibrated value of the
* corresponding parameter. In the the calibrated value is equal to zero, the
* variable value is also fixed to zero. The equation setup will led to zero
* solution for this variable and fixing it at this point help the solver.
FACREV_V.L(reg,kl) = sum((regg,fd), VALUE_ADDED_DISTR(reg,kl,regg,fd) ) ;
TSPREV_V.L(reg)    = sum((tsp,regg,fd), TAX_SUB_PRD_DISTR(reg,tsp,regg,fd) ) ;
NTPREV_V.L(reg)    = sum((ntp,regg,fd), VALUE_ADDED_DISTR(reg,ntp,regg,fd) ) ;
TIMREV_V.L(reg)    = sum((tim,regg,fd), VALUE_ADDED_DISTR(reg,tim,regg,fd) ) ;
FACREV_V.FX(reg,kl)$(sum((regg,fd), VALUE_ADDED_DISTR(reg,kl,regg,fd) ) eq 0)    = 0 ;
TSPREV_V.FX(reg)$(sum((tsp,regg,fd), TAX_SUB_PRD_DISTR(reg,tsp,regg,fd) )  eq 0) = 0 ;
NTPREV_V.FX(reg)$(sum((ntp,regg,fd), VALUE_ADDED_DISTR(reg,ntp,regg,fd) )  eq 0) = 0 ;
TIMREV_V.FX(reg)$(sum((tim,regg,fd), VALUE_ADDED_DISTR(reg,tim,regg,fd) )  eq 0) = 0 ;

INC_H_V.L(regg)  = INC_H(regg) ;
INC_G_V.L(regg)  = INC_G(regg) ;
INC_I_V.L(regg)  = INC_I(regg) ;
CBUD_H_V.L(regg) = CBUD_H(regg) ;
CBUD_G_V.L(regg) = CBUD_G(regg) ;
CBUD_I_V.L(regg) = CBUD_I(regg) ;
INC_H_V.FX(regg)$(INC_H(regg) eq 0)  = 0 ;
INC_G_V.FX(regg)$(INC_G(regg) eq 0)  = 0 ;
INC_I_V.FX(regg)$(INC_I(regg) eq 0)  = 0 ;
CBUD_H_V.L(regg)$(CBUD_H(regg) eq 0) = 0 ;
CBUD_G_V.L(regg)$(CBUD_G(regg) eq 0) = 0 ;
CBUD_I_V.L(regg)$(CBUD_I(regg) eq 0) = 0 ;

SCLFD_H_V.L(regg) = sum((reg,prd), CONS_H(reg,prd,regg) ) ;
SCLFD_G_V.L(regg) = sum((reg,prd), CONS_G(reg,prd,regg) ) ;
SCLFD_I_V.L(regg) = sum((reg,prd), GFCF(reg,prd,regg) ) ;
SCLFD_H_V.FX(regg)$(SCLFD_H_V.L(regg) eq 0) = 0 ;
SCLFD_G_V.FX(regg)$(SCLFD_G_V.L(regg) eq 0) = 0 ;
SCLFD_I_V.FX(regg)$(SCLFD_I_V.L(regg) eq 0) = 0 ;

* Price variables: level of basic prices is set to one, which also corresponds
* to the price level used in calibration. In the the real variable to which the
* price level is linked is fixed to zero, the price is fixed to one. For zero
* level variables any price level will be a solution and fixing it to one helps
* the solver. Additionally, price of the numéraire is fixed.
PY_V.L(regg,ind)      = 1 ;
P_V.L(reg,prd)        = 1 ;
PKL_V.L(reg,kl)       = 1 ;
PVA_V.L(regg,ind)     = 1 ;
PIU_V.L(prd,regg,ind) = 1 ;
PC_H_V.L(prd,regg)    = 1 ;
PC_G_V.L(prd,regg)    = 1 ;
PC_I_V.L(prd,regg)    = 1 ;
PIMP_V.L(prd,regg)    = 1 ;
PROW_V.L(row)         = 1 ;
PAASCHE_V.L(regg)     = 1 ;
LASPEYRES_V.L(regg)   = 1 ;
PY_V.FX('WEU','i020')                                                       = 1 ;
PY_V.FX(regg,ind)$(Y_V.L(regg,ind) eq 0)                                    = 1 ;
P_V.FX(reg,prd)$(X_V.L(reg,prd) eq 0)                                       = 1 ;
PKL_V.FX(reg,kl)$(KLS(reg,kl) eq 0)                                         = 1 ;
PVA_V.FX(regg,ind)$(VA_V.L(regg,ind) eq 0)                                  = 1 ;
PIU_V.FX(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) eq 0)                 = 1 ;
PC_H_V.FX(prd,regg)$(CONS_H_T_V.L(prd,regg) eq 0)                           = 1 ;
PC_G_V.FX(prd,regg)$(CONS_G_T_V.L(prd,regg) eq 0)                           = 1 ;
PC_I_V.FX(prd,regg)$(GFCF_T_V.L(prd,regg) eq 0)                             = 1 ;
PIMP_V.FX(prd,regg)$(IMPORT_V.L(prd,regg)eq 0)                              = 1 ;
PROW_V.FX(row)$( ( sum((prd,regg,ind), INTER_USE_ROW_V.L(row,prd,regg,ind) ) +
            sum((prd,regg), CONS_H_ROW_V.L(row,prd,regg) ) +
            sum((prd,regg), CONS_G_ROW_V.L(row,prd,regg) ) +
            sum((prd,regg), GFCF_ROW_V.L(row,prd,regg) ) +
            sum((prd,regg), SV_ROW(row,prd,regg) ) ) eq 0 )                 = 1 ;
PAASCHE_V.FX(regg)$(sum((reg,prd), CONS_H_V.L(reg,prd,regg) ) eq 0)         = 1 ;
LASPEYRES_V.FX(regg)$(sum((reg,prd), CONS_H_V.L(reg,prd,regg) ) eq 0)       = 1 ;


* Exogenous variables
* Exogenous variables are fixed to their calibrated value.
KLS_V.FX(reg,kl)                   = KLS(reg,kl) ;
SV_ROW_V.FX(row,prd,regg)          = SV_ROW(row,prd,regg) ;
INCTRANSFER_V.FX(reg,fd,regg,fdd)  = INCOME_DISTR(reg,fd,regg,fdd) ;
TRANSFERS_ROW_V.FX(reg,fd,row)     = TRANSFERS_ROW(reg,fd,row) ;

* ======================= 5. Scale variables and equations ========================

* Scaling of variables and equations is done in order to help the solver to
* find the solution quicker. The scaling should ensure that the partial
* derivative of each variable evaluated at their current level values is within
* the range between 0.1 and 100. The values of partial derivatives can be seen
* in the equation listing. In general, the rule is that the variable and the
* equation linked to this variables in MCP formulation should both be scaled by
* the initial level of the variable.

* EQUATION 1.1 and EQUATION 1.2A
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

* EQUATION 1.2B
EQY.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;
Y_V.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;

EQY.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;
Y_V.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;

* EQUATION 1.3
EQINTU_T.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) gt 0)
    = INTER_USE_T_V.L(prd,regg,ind) ;
INTER_USE_T_V.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) gt 0)
    = INTER_USE_T_V.L(prd,regg,ind) ;

EQINTU_T.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_T_V.L(prd,regg,ind) ;
INTER_USE_T_V.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_T_V.L(prd,regg,ind) ;

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

* EQUATION 1.6
EQINTU.SCALE(reg,prd,regg,ind)$(INTER_USE_V.L(reg,prd,regg,ind) gt 0)
    = INTER_USE_V.L(reg,prd,regg,ind) ;
INTER_USE_V.SCALE(reg,prd,regg,ind)$(INTER_USE_V.L(reg,prd,regg,ind) gt 0)
    = INTER_USE_V.L(reg,prd,regg,ind) ;

EQINTU.SCALE(reg,prd,regg,ind)$(INTER_USE_V.L(reg,prd,regg,ind) lt 0)
    = -INTER_USE_V.L(reg,prd,regg,ind) ;
INTER_USE_V.SCALE(reg,prd,regg,ind)$(INTER_USE_V.L(reg,prd,regg,ind) lt 0)
    = -INTER_USE_V.L(reg,prd,regg,ind) ;

* EQUATION 1.7
EQINTU_ROW.SCALE(row,prd,regg,ind)$(INTER_USE_ROW_V.L(row,prd,regg,ind) gt 0)
    = INTER_USE_ROW_V.L(row,prd,regg,ind) ;
INTER_USE_ROW_V.SCALE(row,prd,regg,ind)$(INTER_USE_ROW_V.L(row,prd,regg,ind) gt 0)
    = INTER_USE_ROW_V.L(row,prd,regg,ind) ;

EQINTU_ROW.SCALE(row,prd,regg,ind)$(INTER_USE_ROW_V.L(row,prd,regg,ind) lt 0)
    = -INTER_USE_ROW_V.L(row,prd,regg,ind) ;
INTER_USE_ROW_V.SCALE(row,prd,regg,ind)$(INTER_USE_ROW_V.L(row,prd,regg,ind) lt 0)
    = -INTER_USE_ROW_V.L(row,prd,regg,ind) ;

* EQUATION 2.1
EQVA.SCALE(regg,ind)$(VA_V.L(regg,ind) gt 0)
    = VA_V.L(regg,ind) ;
VA_V.SCALE(regg,ind)$(VA_V.L(regg,ind) gt 0)
    = VA_V.L(regg,ind) ;

EQVA.SCALE(regg,ind)$(VA_V.L(regg,ind) lt 0)
    = -VA_V.L(regg,ind) ;
VA_V.SCALE(regg,ind)$(VA_V.L(regg,ind) lt 0)
    = -VA_V.L(regg,ind) ;

* EQUAION 2.2
EQKL.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) gt 0)
    = KL_V.L(reg,kl,regg,ind) ;
KL_V.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) gt 0)
    = KL_V.L(reg,kl,regg,ind) ;

EQKL.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) lt 0)
    = -KL_V.L(reg,kl,regg,ind) ;
KL_V.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) lt 0)
    = -KL_V.L(reg,kl,regg,ind) ;

* EQUATION 3.1
EQCONS_H_T.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) gt 0)
    = CONS_H_T_V.L(prd,regg) ;
CONS_H_T_V.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) gt 0)
    = CONS_H_T_V.L(prd,regg) ;

EQCONS_H_T.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) lt 0)
    = -CONS_H_T_V.L(prd,regg) ;
CONS_H_T_V.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) lt 0)
    = -CONS_H_T_V.L(prd,regg) ;

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

* EQUATION 3.4
EQCONS_H.SCALE(reg,prd,regg)$(CONS_H_V.L(reg,prd,regg) gt 0)
    = CONS_H_V.L(reg,prd,regg) ;
CONS_H_V.SCALE(reg,prd,regg)$(CONS_H_V.L(reg,prd,regg) gt 0)
    = CONS_H_V.L(reg,prd,regg) ;

EQCONS_H.SCALE(reg,prd,regg)$(CONS_H_V.L(reg,prd,regg) lt 0)
    = -CONS_H_V.L(reg,prd,regg) ;
CONS_H_V.SCALE(reg,prd,regg)$(CONS_H_V.L(reg,prd,regg) lt 0)
    = -CONS_H_V.L(reg,prd,regg) ;

* EQUATION 3.5
EQCONS_H_ROW.SCALE(row,prd,regg)$(CONS_H_ROW_V.L(row,prd,regg) gt 0)
    = CONS_H_ROW_V.L(row,prd,regg) ;
CONS_H_ROW_V.SCALE(row,prd,regg)$(CONS_H_ROW_V.L(row,prd,regg) gt 0)
    = CONS_H_ROW_V.L(row,prd,regg) ;

EQCONS_H_ROW.SCALE(row,prd,regg)$(CONS_H_ROW_V.L(row,prd,regg) lt 0)
    = -CONS_H_ROW_V.L(row,prd,regg) ;
CONS_H_ROW_V.SCALE(row,prd,regg)$(CONS_H_ROW_V.L(row,prd,regg) lt 0)
    = -CONS_H_ROW_V.L(row,prd,regg) ;

* EQUATION 4.1
EQCONS_G_T.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) gt 0)
    = CONS_G_T_V.L(prd,regg) ;
CONS_G_T_V.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) gt 0)
    = CONS_G_T_V.L(prd,regg) ;

EQCONS_G_T.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) lt 0)
    = -CONS_G_T_V.L(prd,regg) ;
CONS_G_T_V.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) lt 0)
    = -CONS_G_T_V.L(prd,regg) ;

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

* EQUATION 4.4
EQCONS_G.SCALE(reg,prd,regg)$(CONS_G_V.L(reg,prd,regg) gt 0)
    = CONS_G_V.L(reg,prd,regg) ;
CONS_G_V.SCALE(reg,prd,regg)$(CONS_G_V.L(reg,prd,regg) gt 0)
    = CONS_G_V.L(reg,prd,regg) ;

EQCONS_G.SCALE(reg,prd,regg)$(CONS_G_V.L(reg,prd,regg) lt 0)
    = -CONS_G_V.L(reg,prd,regg) ;
CONS_G_V.SCALE(reg,prd,regg)$(CONS_G_V.L(reg,prd,regg) lt 0)
    = -CONS_G_V.L(reg,prd,regg) ;

* EQUATION 4.5
EQCONS_G_ROW.SCALE(row,prd,regg)$(CONS_G_ROW_V.L(row,prd,regg) gt 0)
    = CONS_G_ROW_V.L(row,prd,regg) ;
CONS_G_ROW_V.SCALE(row,prd,regg)$(CONS_G_ROW_V.L(row,prd,regg) gt 0)
    = CONS_G_ROW_V.L(row,prd,regg) ;

EQCONS_G_ROW.SCALE(row,prd,regg)$(CONS_G_ROW_V.L(row,prd,regg) lt 0)
    = -CONS_G_ROW_V.L(row,prd,regg) ;
CONS_G_ROW_V.SCALE(row,prd,regg)$(CONS_G_ROW_V.L(row,prd,regg) lt 0)
    = -CONS_G_ROW_V.L(row,prd,regg) ;

* EQUATION 5.1
EQGFCF_T.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) gt 0)
    = GFCF_T_V.L(prd,regg) ;
GFCF_T_V.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) gt 0)
    = GFCF_T_V.L(prd,regg) ;

EQGFCF_T.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) lt 0)
    = -GFCF_T_V.L(prd,regg) ;
GFCF_T_V.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) lt 0)
    = -GFCF_T_V.L(prd,regg) ;

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

* EQUATION 5.4
EQGFCF.SCALE(reg,prd,regg)$(GFCF_V.L(reg,prd,regg) gt 0)
    = GFCF_V.L(reg,prd,regg) ;
GFCF_V.SCALE(reg,prd,regg)$(GFCF_V.L(reg,prd,regg) gt 0)
    = GFCF_V.L(reg,prd,regg) ;

EQGFCF.SCALE(reg,prd,regg)$(GFCF_V.L(reg,prd,regg) lt 0)
    = -GFCF_V.L(reg,prd,regg) ;
GFCF_V.SCALE(reg,prd,regg)$(GFCF_V.L(reg,prd,regg) lt 0)
    = -GFCF_V.L(reg,prd,regg) ;

* EQUATION 5.5
EQGFCF_ROW.SCALE(row,prd,regg)$(GFCF_ROW_V.L(row,prd,regg) gt 0)
    = GFCF_ROW_V.L(row,prd,regg) ;
GFCF_ROW_V.SCALE(row,prd,regg)$(GFCF_ROW_V.L(row,prd,regg) gt 0)
    = GFCF_ROW_V.L(row,prd,regg) ;

EQGFCF_ROW.SCALE(row,prd,regg)$(GFCF_ROW_V.L(row,prd,regg) lt 0)
    = -GFCF_ROW_V.L(row,prd,regg) ;
GFCF_ROW_V.SCALE(row,prd,regg)$(GFCF_ROW_V.L(row,prd,regg) lt 0)
    = -GFCF_ROW_V.L(row,prd,regg) ;

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
EQIMP.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) gt 0)
    = IMPORT_V.L(prd,regg) ;
IMPORT_V.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) gt 0)
    = IMPORT_V.L(prd,regg) ;

EQIMP.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) lt 0)
    = -IMPORT_V.L(prd,regg) ;
IMPORT_V.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) lt 0)
    = -IMPORT_V.L(prd,regg) ;

* EQUATION 7.2
EQTRADE.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) gt 0)
    = TRADE_V.L(reg,prd,regg) ;
TRADE_V.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) gt 0)
    = TRADE_V.L(reg,prd,regg) ;

EQTRADE.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) lt 0)
    = -TRADE_V.L(reg,prd,regg) ;
TRADE_V.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) lt 0)
    = -TRADE_V.L(reg,prd,regg) ;

* EQUATION 7.3
EQEXP.SCALE(reg,prd,row)$(EXPORT_V.L(reg,prd,row) gt 0)
    = EXPORT_V.L(reg,prd,row) ;
EXPORT_V.SCALE(reg,prd,row)$(EXPORT_V.L(reg,prd,row) gt 0)
    = EXPORT_V.L(reg,prd,row) ;

EQEXP.SCALE(reg,prd,row)$(EXPORT_V.L(reg,prd,row) lt 0)
    = -EXPORT_V.L(reg,prd,row) ;
EXPORT_V.SCALE(reg,prd,row)$(EXPORT_V.L(reg,prd,row) lt 0)
    = -EXPORT_V.L(reg,prd,row) ;

* EQUATION 8.1
EQFACREV.SCALE(reg,kl)$(FACREV_V.L(reg,kl) gt 0)
    = FACREV_V.L(reg,kl) ;
FACREV_V.SCALE(reg,kl)$(FACREV_V.L(reg,kl) gt 0)
    = FACREV_V.L(reg,kl) ;

EQFACREV.SCALE(reg,kl)$(FACREV_V.L(reg,kl) lt 0)
    = -FACREV_V.L(reg,kl) ;
FACREV_V.SCALE(reg,kl)$(FACREV_V.L(reg,kl) lt 0)
    = -FACREV_V.L(reg,kl) ;

* EQUATION 8.2
EQTSPREV.SCALE(reg)$(TSPREV_V.L(reg) gt 0)
    = TSPREV_V.L(reg) ;
TSPREV_V.SCALE(reg)$(TSPREV_V.L(reg) gt 0)
    = TSPREV_V.L(reg) ;

EQTSPREV.SCALE(reg)$(TSPREV_V.L(reg) lt 0)
    = -TSPREV_V.L(reg) ;
TSPREV_V.SCALE(reg)$(TSPREV_V.L(reg) lt 0)
    = -TSPREV_V.L(reg) ;

* EQUATION 8.3
EQNTPREV.SCALE(reg)$(NTPREV_V.L(reg) gt 0)
    = NTPREV_V.L(reg) ;
NTPREV_V.SCALE(reg)$(NTPREV_V.L(reg) gt 0)
    = NTPREV_V.L(reg) ;

EQNTPREV.SCALE(reg)$(NTPREV_V.L(reg) lt 0)
    = -NTPREV_V.L(reg) ;
NTPREV_V.SCALE(reg)$(NTPREV_V.L(reg) lt 0)
    = -NTPREV_V.L(reg) ;

* EQUATION 8.4
EQTIMREV.SCALE(reg)$(TIMREV_V.L(reg) gt 0)
    = TIMREV_V.L(reg) ;
TIMREV_V.SCALE(reg)$(TIMREV_V.L(reg) gt 0)
    = TIMREV_V.L(reg) ;

EQTIMREV.SCALE(reg)$(TIMREV_V.L(reg) lt 0)
    = -TIMREV_V.L(reg) ;
TIMREV_V.SCALE(reg)$(TIMREV_V.L(reg) lt 0)
    = -TIMREV_V.L(reg) ;

* EQUATION 9.1
EQINC_H.SCALE(reg)$(INC_H_V.L(reg) gt 0)
    = INC_H_V.L(reg) ;
INC_H_V.SCALE(reg)$(INC_H_V.L(reg) gt 0)
    = INC_H_V.L(reg) ;

EQINC_H.SCALE(reg)$(INC_H_V.L(reg) lt 0)
    = -INC_H_V.L(reg) ;
INC_H_V.SCALE(reg)$(INC_H_V.L(reg) lt 0)
    = -INC_H_V.L(reg) ;

* EQUATION 9.2
EQINC_G.SCALE(reg)$(INC_G_V.L(reg) gt 0)
    = INC_G_V.L(reg) ;
INC_G_V.SCALE(reg)$(INC_G_V.L(reg) gt 0)
    = INC_G_V.L(reg) ;

EQINC_G.SCALE(reg)$(INC_G_V.L(reg) lt 0)
    = -INC_G_V.L(reg) ;
INC_G_V.SCALE(reg)$(INC_G_V.L(reg) lt 0)
    = -INC_G_V.L(reg) ;

* EQUATION 9.3
EQINC_I.SCALE(reg)$(INC_I_V.L(reg) gt 0)
    = INC_I_V.L(reg) ;
INC_I_V.SCALE(reg)$(INC_I_V.L(reg) gt 0)
    = INC_I_V.L(reg) ;

EQINC_I.SCALE(reg)$(INC_I_V.L(reg) lt 0)
    = -INC_I_V.L(reg) ;
INC_I_V.SCALE(reg)$(INC_I_V.L(reg) lt 0)
    = -INC_I_V.L(reg) ;

* EQUATION 9.4
EQCBUD_H.SCALE(reg)$(CBUD_H_V.L(reg) gt 0)
    = CBUD_H_V.L(reg) ;
CBUD_H_V.SCALE(reg)$(CBUD_H_V.L(reg) gt 0)
    = CBUD_H_V.L(reg) ;

EQCBUD_H.SCALE(reg)$(CBUD_H_V.L(reg) lt 0)
    = -CBUD_H_V.L(reg) ;
CBUD_H_V.SCALE(reg)$(CBUD_H_V.L(reg) lt 0)
    = -CBUD_H_V.L(reg) ;

* EQUATION 9.5
EQCBUD_G.SCALE(reg)$(CBUD_G_V.L(reg) gt 0)
    = CBUD_G_V.L(reg) ;
CBUD_G_V.SCALE(reg)$(CBUD_G_V.L(reg) gt 0)
    = CBUD_G_V.L(reg) ;

EQCBUD_G.SCALE(reg)$(CBUD_G_V.L(reg) lt 0)
    = -CBUD_G_V.L(reg) ;
CBUD_G_V.SCALE(reg)$(CBUD_G_V.L(reg) lt 0)
    = -CBUD_G_V.L(reg) ;

* EQUATION 9.6
EQCBUD_I.SCALE(reg)$(CBUD_I_V.L(reg) gt 0)
    = CBUD_I_V.L(reg) ;
CBUD_I_V.SCALE(reg)$(CBUD_I_V.L(reg) gt 0)
    = CBUD_I_V.L(reg) ;

EQCBUD_I.SCALE(reg)$(CBUD_I_V.L(reg) lt 0)
    = -CBUD_I_V.L(reg) ;
CBUD_I_V.SCALE(reg)$(CBUD_I_V.L(reg) lt 0)
    = -CBUD_I_V.L(reg) ;

* EQUATION 10.1
EQPY.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;

EQPY.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;

*EQUATION 10.2
EQP.SCALE(reg,prd)$(X_V.L(reg,prd) gt 0)
    = X_V.L(reg,prd) ;

EQP.SCALE(reg,prd)$(X_V.L(reg,prd) lt 0)
    = -X_V.L(reg,prd)  ;

* EQUATION 10.3
EQPKL.SCALE(reg,kl)$(KLS_V.L(reg,kl) gt 0)
    = KLS_V.L(reg,kl) ;

EQPKL.SCALE(reg,kl)$(KLS_V.L(reg,kl) lt 0)
    = -KLS_V.L(reg,kl) ;

* EQUATION 10.4
EQPVA.SCALE(reg,ind)$(VA_V.L(reg,ind) gt 0)
    = VA_V.L(reg,ind) ;

EQPVA.SCALE(reg,ind)$(VA_V.L(reg,ind) lt 0)
    = -VA_V.L(reg,ind) ;

* EQUATION 10.5
EQPIU.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) gt 0)
    = INTER_USE_T_V.L(prd,regg,ind) ;

EQPIU.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_T_V.L(prd,regg,ind) ;

* EQUATION 10.6
EQPC_H.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) gt 0)
    = CONS_H_T_V.L(prd,regg) ;

EQPC_H.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) lt 0)
    = -CONS_H_T_V.L(prd,regg) ;

* EQUATION 10.7
EQPC_G.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) gt 0)
    = CONS_G_T_V.L(prd,regg) ;

EQPC_G.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) lt 0)
    = -CONS_G_T_V.L(prd,regg) ;

* EQUATION 10.8
EQPC_I.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) gt 0)
    = GFCF_T_V.L(prd,regg) ;

EQPC_I.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) lt 0)
    = -GFCF_T_V.L(prd,regg) ;

* EQUATION 10.9
EQPIMP.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) gt 0)
    = IMPORT_V.L(prd,regg) ;

EQPIMP.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) lt 0)
    = -IMPORT_V.L(prd,regg) ;

* EQUATION 10.10
EQSCLFD_H.SCALE(regg)$(SCLFD_H_V.L(regg) gt 0)
    = SCLFD_H_V.L(regg) ;
SCLFD_H_V.SCALE(regg)$(SCLFD_H_V.L(regg) gt 0)
    = SCLFD_H_V.L(regg) ;

EQSCLFD_H.SCALE(regg)$(SCLFD_H_V.L(regg) lt 0)
    = -SCLFD_H_V.L(regg) ;
SCLFD_H_V.SCALE(regg)$(SCLFD_H_V.L(regg) lt 0)
    = -SCLFD_H_V.L(regg) ;

* EQUATION 10.11
EQSCLFD_G.SCALE(regg)$(SCLFD_G_V.L(regg) gt 0)
    = SCLFD_G_V.L(regg) ;
SCLFD_G_V.SCALE(regg)$(SCLFD_G_V.L(regg) gt 0)
    = SCLFD_G_V.L(regg) ;

EQSCLFD_G.SCALE(regg)$(SCLFD_G_V.L(regg) lt 0)
    = -SCLFD_G_V.L(regg) ;
SCLFD_G_V.SCALE(regg)$(SCLFD_G_V.L(regg) lt 0)
    = -SCLFD_G_V.L(regg) ;

* EQUATION 10.12
EQSCLFD_I.SCALE(regg)$(SCLFD_I_V.L(regg) gt 0)
    = SCLFD_I_V.L(regg) ;
SCLFD_I_V.SCALE(regg)$(SCLFD_I_V.L(regg) gt 0)
    = SCLFD_I_V.L(regg) ;

EQSCLFD_I.SCALE(regg)$(SCLFD_I_V.L(regg) lt 0)
    = -SCLFD_I_V.L(regg) ;
SCLFD_I_V.SCALE(regg)$(SCLFD_I_V.L(regg) lt 0)
    = -SCLFD_I_V.L(regg) ;

* EQUATION 10.13
EQPROW.SCALE(row)$(sum((reg,prd), EXPORT_V.L(reg,prd,row) ) gt 0   )
    = sum((reg,prd), EXPORT_V.L(reg,prd,row) ) ;

EQPROW.SCALE(row)$(sum((reg,prd), EXPORT_V.L(reg,prd,row) ) lt 0   )
    = -sum((reg,prd), EXPORT_V.L(reg,prd,row) ) ;

* EQUATION 10.14 - SCALING IS NOT REQUIRED

* EQUATION 10.15 - SCALING IS NOT REQUIRED

* EXOGENOUS VARIBLES
KLS_V.SCALE(reg,kl)$(KLS_V.L(reg,kl) gt 0)
    = KLS_V.L(reg,kl) ;
KLS_V.SCALE(reg,kl)$(KLS_V.L(reg,kl) lt 0)
    = -KLS_V.L(reg,kl) ;

SV_ROW_V.SCALE(row,prd,regg)$(SV_ROW_V.L(row,prd,regg) gt 0)
    = SV_ROW_V.L(row,prd,regg) ;
SV_ROW_V.SCALE(row,prd,regg)$(SV_ROW_V.L(row,prd,regg) lt 0)
    = -SV_ROW_V.L(row,prd,regg) ;

INCTRANSFER_V.SCALE(reg,fd,regg,fdd)$(INCTRANSFER_V.L(reg,fd,regg,fdd) gt 0)
    = INCTRANSFER_V.L(reg,fd,regg,fdd) ;
INCTRANSFER_V.SCALE(reg,fd,regg,fdd)$(INCTRANSFER_V.L(reg,fd,regg,fdd) lt 0)
    = -INCTRANSFER_V.L(reg,fd,regg,fdd) ;

TRANSFERS_ROW_V.SCALE(reg,fd,row)$(TRANSFERS_ROW_V.L(reg,fd,row) gt 0)
    = TRANSFERS_ROW_V.L(reg,fd,row) ;
TRANSFERS_ROW_V.SCALE(reg,fd,row)$(TRANSFERS_ROW_V.L(reg,fd,row) lt 0)
    = -TRANSFERS_ROW_V.L(reg,fd,row) ;


* ========================== 6. Declare model equations ===========================
$ontext
This states which equations are included in which model. The models are based on either product technology or activity technology. The `main.gms` file includes the option to choose one of the two types of technologies.
$offtext


Model IO_product_technology
/
EQBAL
EQX
EQINTU_T
EQINTU_D
EQINTU_M
EQINTU
EQINTU_ROW
EQOBJ
/
;

Model IO_industry_technology
/
EQBAL
EQY
EQINTU_T
EQINTU_D
EQINTU_M
EQINTU
EQINTU_ROW
EQOBJ
/
;

Model CGE_TRICK
/
EQBAL
EQY
EQINTU_T
EQINTU_D
EQINTU_M
EQINTU
EQINTU_ROW
EQVA
EQKL
EQCONS_H_T
EQCONS_H_D
EQCONS_H_M
EQCONS_H
EQCONS_H_ROW
EQCONS_G_T
EQCONS_G_D
EQCONS_G_M
EQCONS_G
EQCONS_G_ROW
EQGFCF_T
EQGFCF_D
EQGFCF_M
EQGFCF
EQGFCF_ROW
EQSV
EQIMP
EQTRADE
EQEXP
EQFACREV
EQTSPREV
EQNTPREV
EQTIMREV
EQINC_H
EQINC_G
EQINC_I
EQCBUD_H
EQCBUD_G
EQCBUD_I
EQPY
EQP
EQPKL
EQPVA
EQPIU
EQPC_H
EQPC_G
EQPC_I
EQPIMP
EQSCLFD_H
EQSCLFD_G
EQSCLFD_I
EQPROW
EQPAASCHE
EQLASPEYRES
EQOBJ
/
;

Model CGE_MCP
/
EQBAL.X_V
EQY.Y_V
EQINTU_T.INTER_USE_T_V
EQINTU_D.INTER_USE_D_V
EQINTU_M.INTER_USE_M_V
EQINTU.INTER_USE_V
EQINTU_ROW.INTER_USE_ROW_V
EQVA.VA_V
EQKL.KL_V
EQCONS_H_T.CONS_H_T_V
EQCONS_H_D.CONS_H_D_V
EQCONS_H_M.CONS_H_M_V
EQCONS_H.CONS_H_V
EQCONS_H_ROW.CONS_H_ROW_V
EQCONS_G_T.CONS_G_T_V
EQCONS_G_D.CONS_G_D_V
EQCONS_G_M.CONS_G_M_V
EQCONS_G.CONS_G_V
EQCONS_G_ROW.CONS_G_ROW_V
EQGFCF_T.GFCF_T_V
EQGFCF_D.GFCF_D_V
EQGFCF_M.GFCF_M_V
EQGFCF.GFCF_V
EQGFCF_ROW.GFCF_ROW_V
EQSV.SV_V
EQIMP.IMPORT_V
EQTRADE.TRADE_V
EQEXP.EXPORT_V
EQFACREV.FACREV_V
EQTSPREV.TSPREV_V
EQNTPREV.NTPREV_V
EQTIMREV.TIMREV_V
EQINC_H.INC_H_V
EQINC_G.INC_G_V
EQINC_I.INC_I_V
EQCBUD_H.CBUD_H_V
EQCBUD_G.CBUD_G_V
EQCBUD_I.CBUD_I_V
EQPY.PY_V
EQP.P_V
EQPKL.PKL_V
EQPVA.PVA_V
EQPIU.PIU_V
EQPC_H.PC_H_V
EQPC_G.PC_G_V
EQPC_I.PC_I_V
EQPIMP.PIMP_V
EQSCLFD_H.SCLFD_H_V
EQSCLFD_G.SCLFD_G_V
EQSCLFD_I.SCLFD_I_V
EQPROW.PROW_V
EQPAASCHE.PAASCHE_V
EQLASPEYRES.LASPEYRES_V
/
;
