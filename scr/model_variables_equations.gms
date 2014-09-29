* File:   scr/model_variables_equations.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 9 June 2014 (simple CGE formulation)

* gams-master-file: main.gms

$ontext startdoc
This `.gms` file is one of the `.gms` files part of the `main.gms` file and includes the equations and model formulation. Please start from `main.gms`.

This `.gms` file consists of the following parts:

1. *Declaration of variables*

    Output by activity and product are here the variables which can be adjusted in the model. The variable `Cshock` is defined later in the `%simulation%` gms file.

2. *Declaration of equations*

    One of the equations is an artificial objective function. This is because GAMS only understands a model run with an objective function. If you would like to run it without one, you can use such an artificial objective function which is basically put to any value such as 1.

3. *Definition of equations*

4. *Definition of levels and lower and upper bounds and fixed variables*

    Upper and lower bounds can be adjusted when needed.

5. *Declaration of equations in the model*

    This states which equations are included in which model. The models are based on either product technology or activity technology. The `main.gms` file includes the option to choose one of the two types of technologies.

$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ========================== Declaration of variables ==========================

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

    VA_V(regg,ind)                  use of aggregated production factors
    KL_V(reg,kl,regg,ind)           use of specific production factors

    FINAL_USE_T_V(prd,regg,fd)      final use on aggregated product level
    FINAL_USE_D_V(prd,regg,fd)      final use of domestically produced products
    FINAL_USE_M_V(prd,regg,fd)      final use of aggregated imported products
    FINAL_USE_V(reg,prd,regg,fd)    final use on the most detailed level

    IMPORT_V(prd,regg)              total use of aggregated imported products
    TRADE_V(reg,prd,regg)           bi-lateral trade flows

    FACREV_V(reg,kl)                revenue from factors of production
    TSPREV_V(reg,tsp)               revenue from net tax on products
    NTPREV_V(reg,ntp)               revenue from net tax on production

    INC_V(regg,fd)                  gross income of final consumers
    CBUD_V(regg,fd)                 budget available for final use

    PY_V(regg,ind)                  industry output price
    P_V(reg,prd)                    basic product price
    PKL_V(reg,kl)                   production factor price
    PVA_V(regg,ind)                 aggregate production factors price
    PIU_V(prd,regg,ind)             aggregate product price for intermediate use
    PFU_V(prd,regg,fd)              aggregate product price for final use
    PIMP_V(prd,regg)                aggregate imported product price
    SCLFD_V(regg,fd)                scale parameter for final users
    PAASCHE_V(regg,fd)              Paasche price index for final users
    LASPEYRES_V(regg,fd)            Laspeyres price index for final users
;

*Positive variables
*;

* Exogenous variables
Variables
    KLS_V(reg,kl)                   supply of production factors
    INCTRANSFER_V(reg,fd,regg,fdd)  income transfers
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
    EQINTU_D(prd,regg,ind)      demand for domestically produced intermediate
                                # inputs
    EQINTU_M(prd,regg,ind)      demand for aggregated imported intermediate
                                # inputs
    EQINTU(reg,prd,regg,ind)    demand for intermediate inputs on the most
                                # detailed level

    EQVA(regg,ind)              demand for aggregated production factors
    EQKL(reg,kl,regg,ind)       demand for specific production factors

    EQFU_T(prd,regg,fd)         demand for final use of products on aggregated
                                # product level
    EQFU_D(prd,regg,fd)         demand for final use of domesrically produced
                                # products
    EQFU_M(prd,regg,fd)         demand for final use of aggregated imported
                                # products
    EQFU(reg,prd,regg,fd)       demand for final use of products on the most
                                # detailed level

    EQIMP(prd,regg)             total demand for aggregared imported products
    EQTRADE(reg,prd,regg)       demand for bi-lateral trade transactions

    EQFACREV(reg,kl)            revenue from factors of production
    EQTSPREV(reg,tsp)           revenue from net tax on products
    EQNTPREV(reg,ntp)           revenue from net tax on production

    EQINC(regg,fd)              gross income of final consumers
    EQCBUD(regg,fd)             budget available for final use

    EQPY(regg,ind)              zero-profit condition (including possible
                                # margins)
    EQP(reg,prd)                balance between product price and industry price
    EQPKL(reg,kl)               balance on production factors market
    EQPVA(regg,ind)             balance between specific production factors
                                # price and aggregate production factors price
    EQPIU(prd,regg,ind)         balance between specific product price and
                                # aggregate product price for intermediate use
    EQPFU(prd,regg,fd)          balance between specific product price and
                                # aggregate product price for final use
    EQPIMP(prd,regg)            balance between specific imported product price
                                # and aggregated imported product price
    EQSCLFD(regg,fd)            budget constraint of final users
    EQPAASCHE(regg,fd)          Paasche price index for final users
    EQLASPEYRES(regg,fd)        Laspeyres price index for final users

    EQOBJ                       artificial objective function
;


* ========================== Definition of equations ===========================

* ## Beginning Input-output block ##

* EQUATION 1: Product market balance: product output is equal to total uses,
* including intermediate use, final use and, in case of an open economy, export.
* Product market balance is expressed in volume. Product market balance should
* hold for each product (prd) produced in each region.
EQBAL(reg,prd)..
    sum((regg,fd), FINAL_USE_V(reg,prd,regg,fd) ) +
    sum((regg,ind), INTER_USE_V(reg,prd,regg,ind) )
    =E=
    X_V(reg,prd) ;

* EQUATION 2A: Output level of products: given total amount of output per
* activity, output per product (reg,prd) is derived based on fixed output shares
* of each industry (regg,ind). EQUATION 2A corresponds to product technology
* assumption in input-output analysis, EQUATION 2B corresponds to industry
* technology assumption in input-output analysis. EQUATION 2A is only suitable
* for input-output analysis where number of product (prd) is equal to number
* number of industries (ind). EQUATION 2A cannot be used in MCP setup.
EQX(reg,prd)..
    X_V(reg,prd)
    =E=
    sum((regg,ind), coprodA(reg,prd,regg,ind) * Y_V(regg,ind) ) ;

* EQUATION 2B: Output level of activities: given total amount of output per
* product, required output per activity (regg,ind) is derived based on fixed
* sales structure on each product market (reg,prd). EQUATION 2A corresponds to
* product technology assumption in input-output analysis, EQUATION 2B
* corresponds to industry technology assumption in input-output analysis.
* EQUATION 2B is suitable for input-output and CGE analysis.
EQY(regg,ind)..
    Y_V(regg,ind)
    =E=
    sum((reg,prd), coprodB(reg,prd,regg,ind) * X_V(reg,prd) ) ;

* EQUATION 3: Demand for intermediate inputs on aggregated product level. The
* demand function follows Leontief form, where the relation between intermediate
* inputs of aggregated product (prd) and output of the industry (regg,ind) in
* volume is kept constant.
EQINTU_T(prd,regg,ind)..
    INTER_USE_T_V(prd,regg,ind)
    =E=
    ioc(prd,regg,ind) * Y_V(regg,ind) ;

* EQUATION 4: Demand for domestically produced intermediate inputs. The demand
* function follows CES form, where demand of each industry (regg,ind) for each
* domestically produced product (prd) depends linearly on the demand of the same
* industry for the corresponding aggregated product and with certain elasticity
* on relative prices of domestically produced product and aggregated imported
* product
EQINTU_D(prd,regg,ind)..
    INTER_USE_D_V(prd,regg,ind)
    =E=
    INTER_USE_T_V(prd,regg,ind) * phi_dom(prd,regg,ind) *
    ( P_V(regg,prd) /
    ( PIU_V(prd,regg,ind) * ( 1 + tc_ind(prd,regg,ind) ) ) )**
    ( -elasIU_DM(prd,regg,ind) ) ;

* EQUAION 5: Demand for aggregated imported intermediate inputs. The demand
* function follows CES form, where demand of each industry (regg,ind) for each
* aggregated imported product (prd) depends linearly on the demand of the same
* industry for the corresponding aggregated product and with certain elasticity
* on relative prices of aggregated imported product and domestically produced
* product
EQINTU_M(prd,regg,ind)..
    INTER_USE_M_V(prd,regg,ind)
    =E=
    INTER_USE_T_V(prd,regg,ind) * phi_imp(prd,regg,ind) *
    ( PIMP_V(prd,regg) /
    ( PIU_V(prd,regg,ind) * ( 1 + tc_ind(prd,regg,ind) ) ) )**
    ( -elasIU_DM(prd,regg,ind) ) ;

* EQUATION 6: Demand for intermediate inputs on the most detailed level. In case
* the region of demand (regg) is the same as region of product (reg), the
* demand function is equal to demand for domestically produced product. In case
* the regions of demand and production differ, the demand function depends on
* the demand for aggregated imported product and share of import from region
* regg in the aggregated import.
EQINTU(reg,prd,regg,ind)..
    INTER_USE_V(reg,prd,regg,ind)
    =E=
    ( INTER_USE_D_V(prd,regg,ind) )$sameas(reg,regg) +
    ( TRADE_V(reg,prd,regg) * INTER_USE_M_V(prd,regg,ind) /
    IMPORT_V(prd,regg) )$(not sameas(reg,regg)) ;

* ## End Input-output block ##



* ## Beginning Factor demand block ##

* EQUATION 7: Demand for aggregated production factors. The demand function
* follows Leontief form, where the relation between aggregated value added and
* output of the industry (regg,ind) in volume is kept constant.
EQVA(regg,ind)..
    VA_V(regg,ind)
    =E=
    aVA(regg,ind) * Y_V(regg,ind) ;

* EQUAION 8: Demand for specific production factors. The demand function follows
* CES form, where demand of each industry (regg,ind) for each factor of
* production (reg,kl) depends linearly on the demand of the same industry for
* aggregated production factors and with certain elasticity on relative prices
* of specific factors of production.
EQKL(reg,kl,regg,ind)$VALUE_ADDED_model(reg,kl,regg,ind)..
    KL_V(reg,kl,regg,ind)
    =E=
    VA_V(regg,ind) * alpha(reg,kl,regg,ind) *
    ( PKL_V(reg,kl) / PVA_V(regg,ind) )**( -elasKL(regg,ind) ) ;


* EQUATION 8 COBB-DOUGLAS: Demand for specific production factors in explicit
* Cobb-Douglas form.
*EQKL(reg,kl,regg,ind)$VALUE_ADDED_model(reg,kl,regg,ind)..
*    KL_V(reg,kl,regg,ind)
*    =E=
*    facC(reg,kl,regg,ind) / prod((reggg,kll)$facC(reggg,kll,regg,ind),
*    facC(reggg,kll,regg,ind)**facC(reggg,kll,regg,ind) ) *
*    ( 1 / PKL_V(reg,kl) ) * VA_V(regg,ind) / facA(regg,ind) *
*    prod((reggg,kll), PKL_V(reggg,kll)**facC(reggg,kll,regg,ind) ) ;

* EQUATION 8 CONSTANT ELASTICITY OF SUBSTITUTION: Demand for specific production
* factors in explicit CES form.
*EQKL(reg,kl,regg,ind)$VALUE_ADDED_model(reg,kl,regg,ind)..
*    KL_V(reg,kl,regg,ind)
*    =E=
*    VA_V(regg,ind) *
*    ( gammaCES(reg,kl,regg,ind) / PKL_V(reg,kl) )**elasKL(regg,ind) *
*    PVA_V(regg,ind)**elasKL(regg,ind) *
*    aCES(regg,ind)**( elasKL(regg,ind) - 1 ) ;

* ## End Factor demand block ##



* ## Beginning Final demand for products block ##

* EQUATION 9: Final demand for aggregated products. The demand function follows
* CES form, where demand by each final user (regg,fd) for each aggregated
* product (prd) depends with certain elasticity on relative prices of different
* aggregated products. The final demand function is derived from utility
* optimization, but there is no market for utility and corresponding price
* doesn't exist, contrary to CES demand functions derived from optimization of
* a production function. Scaling parameter (SCLDF_V) is introduced in order to
* ensure budget constraint (see EQUATION 27).
EQFU_T(prd,regg,fd)..
    FINAL_USE_T_V(prd,regg,fd)
    =E=
    SCLFD_V(regg,fd) * theta(prd,regg,fd) *
    ( PFU_V(prd,regg,fd) * ( 1 + tc_fd(prd,regg,fd) ) )**( -elasFU(regg,fd) ) ;

* EQUATION 10: Final demand for domestically produced products. The demand
* function follows CES form, where demand by each final user (regg,fd) for each
* domestically produced product (prd) depends linearly on the demand by the same
* final user for the corresponding aggregated product and with certain
* elasticity on relative prices of domestically produced products and aggregated
* imported product.
EQFU_D(prd,regg,fd)..
    FINAL_USE_D_V(prd,regg,fd)
    =E=
    FINAL_USE_T_V(prd,regg,fd) * theta_dom(prd,regg,fd) *
    ( P_V(regg,prd) /
    ( PFU_V(prd,regg,fd) * ( 1 + tc_fd(prd,regg,fd) ) ) )**
    ( -elasFU_DM(prd,regg,fd) ) ;

* EQUATION 11: Final demand for aggregated imported products. The demand
* function follows CES form, where demand by each final user (regg,fd) for each
* aggregated imported product (prd) depends linearly on the demand by the same
* final user for the corresponding aggregated product and with certain
* elasticity on relative prices of aggregated imported product and domestically
* produced products.
EQFU_M(prd,regg,fd)..
    FINAL_USE_M_V(prd,regg,fd)
    =E=
    FINAL_USE_T_V(prd,regg,fd) * theta_imp(prd,regg,fd) *
    ( PIMP_V(prd,regg) /
    ( PFU_V(prd,regg,fd) * ( 1 + tc_fd(prd,regg,fd) ) ) )
    **( -elasFU_DM(prd,regg,fd) ) ;

* EQUATION 12: Final demand for products on the most detailed level. In case
* the region of demand (regg) is the same as region of product (reg), the
* demand function is equal to demand for domestically produced product. In case
* the regions of demand and production differ, the demand function depends on
* the demand for aggregated imported product and share of import from region
* regg in the aggregated import.
EQFU(reg,prd,regg,fd)..
    FINAL_USE_V(reg,prd,regg,fd)
    =E=
    ( FINAL_USE_D_V(prd,regg,fd) )$sameas(reg,regg) +
    ( TRADE_V(reg,prd,regg) * FINAL_USE_M_V(prd,regg,fd) /
    IMPORT_V(prd,regg) )$(not sameas(reg,regg)) ;

* ## End Final demand for products block ##



* ## Beginning Inter-regional trade block ##

* EQUATION 13: Total demand for aggregate imported products. The demand for each
* aggregated imported product (prd) in each region (regg) is a sum of the
* corresponding demand of industries and final consumers in this region.
EQIMP(prd,regg)..
    IMPORT_V(prd,regg)
    =E=
    sum(ind, INTER_USE_M_V(prd,regg,ind) ) +
    sum(fd, FINAL_USE_M_V(prd,regg,fd) ) ;

* EQUATION 14: Demand for bi-lateral trade transactions. The demand function
* follows CES form, where demand from importing each region (regg) for each
* product type (prd) produced in each exporting region (reg) depends linearly
* on the total demand for aggregated imported product in the same importing
* region and with certain elasticity on relative prices of the same product
* types produced by different exporting regions.
EQTRADE(reg,prd,regg)..
    TRADE_V(reg,prd,regg)
    =E=
    IMPORT_V(prd,regg) * gamma(reg,prd,regg) *
    ( P_V(reg,prd) / PIMP_V(prd,regg) )**( -elasIMP(prd,regg) ) ;

* ## End Inter-regional trade block ##



* ## Beginning Factor and tax revenue block ##

* EQUATION 15: Revenue from factors of production. The revenue of each specific
* factor (reg,kl) is a sum of revenues earned by the corresponding factor in
* each industry (ind) in each region (regg).
EQFACREV(reg,kl)..
    FACREV_V(reg,kl)
    =E=
    sum((regg,ind), KL_V(reg,kl,regg,ind) * PKL_V(reg,kl) ) ;

* EQUATION 16: Revenue from net taxes on products. The revenue from each
* specific tax type (tsp) is a sum of revenues earned from sales of products
* to industries (reg,ind) for intermediate use and to final consumers (reg,fd)
* for final use. Net tax revenues ends up in the consumption region (reg)
EQTSPREV(reg,tsp)..
    TSPREV_V(reg,tsp)
    =E=
    sum((prd,ind), sum(regg, INTER_USE_V(regg,prd,reg,ind) * P_V(regg,prd) ) *
    tc_ind(prd,reg,ind) ) +
    sum((prd,fd), sum(regg, FINAL_USE_V(regg,prd,reg,fd) * P_V(regg,prd) ) *
    tc_fd(prd,reg,fd) ) ;

* EQUATION 17: Revenue from net taxes on production. The revenue from each
* specific tax type (reg,ntp) is a sum of revenue earned from production
* activities of each industry (ind) in each region (regg).

EQNTPREV(reg,ntp)..
    NTPREV_V(reg,ntp)
    =E=
    sum((regg,ind), Y_V(regg,ind) * PY_V(regg,ind) *
    txd_ind(reg,ntp,regg,ind) ) ;

* ## End Factor and tax revenue block ##



* ## Beginning Final consumers budgets block ##

* EQUATION 18: Gross income of final consumers. Gross income is composed of
* shares of factor and tax revenues attributable to each final user (regg,fd),
* and well as income transfers from other final users. At the moment income
* transfers is one of the exogenous variables of the model, therefore it is
* multiplied by a price index in order to preserve model homogeneity in prices
* of degree zero.
EQINC(regg,fd)..
    INC_V(regg,fd)
    =E=
    sum((reg,kl), FACREV_V(reg,kl) * fac_distr(reg,kl,regg,fd) ) +
    sum((reg,tsp), TSPREV_V(reg,tsp) * tsp_distr(reg,tsp,regg,fd) ) +
    sum((reg,ntp), NTPREV_V(reg,ntp) * ntp_distr(reg,ntp,regg,fd) ) +
    sum((reg,fdd), INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg,fdd) ) ;

* EQUATION 19: Budget available for final use. Budget is composed of gross
* income of the corresponding final user (regg,fd) less income transfers to
* other final users. At the moment income transfers is one of the exogenous
* variables of the model, therefore it is multiplied by a price index in order
* to preserve model homogeneity in prices of degree zero.
EQCBUD(regg,fd)..
    CBUD_V(regg,fd)
    =E=
    INC_V(regg,fd) -
    sum((reg,fdd), INCTRANSFER_V(regg,fd,reg,fdd) * LASPEYRES_V(regg,fd) ) ;

* ## End Final consumers budgets block ##



* ## Beginning Price block ##

* EQUATION 20: Zero-profit condition. Industry output price for each industry
* (ind) in each region (regg) is defined in such a way that revenues earned from
* product sales less possible production net taxes are equal to the cost of
* intermediate inputs and factors of production, including possible product and
* factor taxes, plus, if modeled, excessive profit margins. Output price for one
* industry in one country is chosen as a numéraire (exogenous variable), so in
* order to keep the system square, the equation is not defined for this specific
* industry in this specific region.
EQPY(regg,ind)$((not sameas(regg,'US')) or (not sameas(ind,'A1')))..
    Y_V(regg,ind) * PY_V(regg,ind) *
    ( 1 - sum((reg,ntp), txd_ind(reg,ntp,regg,ind) ) )
    =E=
    sum((reg,prd), INTER_USE_V(reg,prd,regg,ind) * P_V(reg,prd) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((reg,kl), KL_V(reg,kl,regg,ind) * PKL_V(reg,kl) ) ;

* EQUATION 21: Balance between product price and industry price. Price of each
* product (prd) in each region of production (reg) is defined as a weighted
* average of industry prices, where weights are defined as output of the product
* by the corresponding industry . Price equation are only relevant for CGE
* model, and since only EQUATION 2B is suitable for CGE model, the co-production
* coefficients of EQUATION 2B are used.
EQP(reg,prd)..
    P_V(reg,prd) * X_V(reg,prd)
    =E=
    sum((regg,ind), PY_V(regg,ind) *
    ( coprodB(reg,prd,regg,ind) * X_V(reg,prd) ) ) ;

* EQUATION 22: Balance on production factors market. Price of each production
* factor (reg,kl) is defined in such a way that total demand for the
* corresponding production factor is equal to the supply of the factor less,
* if modeled, unemployment. Supply of production factors is one of the
* exogenous variables of the model.
EQPKL(reg,kl)..
    KLS_V(reg,kl)
    =E=
    sum((regg,ind), KL_V(reg,kl,regg,ind) ) ;

* EQUATION 23: Balance between specific production factors price and aggregate
* production factors price. The aggregate price is different in each industry
* (ind) in each region (regg) and is a weighted average of the price of specific
* production factors, where weights are defined as demand by the industry for
* corresponding production factors.
EQPVA(regg,ind)..
    PVA_V(regg,ind) * VA_V(regg,ind)
    =E=
    sum((reg,kl), PKL_V(reg,kl) * KL_V(reg,kl,regg,ind)) ;

* EQUATION 23 COBB-DOUGLAS: Price of aggregate production factors defines in
* explicit Cobb-Douglas form, can be only used in combination with EQUATION 8
* COBB DOUGLAS.
*EQPVA(regg,ind)..
*    PVA_V(regg,ind)
*    =E=
*    sum((reg,kl), facC(reg,kl,regg,ind) *
*    PKL_V(reg,kl)**( 1 - elasKL(regg,ind) ) )**
*    ( 1 / ( 1 - elasKL(regg,ind) ) ) ;

* EQUATION 23 CONSTANT ELASTICITY OF SUBSTITUTION: Price of aggregate
* production factors defines in explicit CES form, can be only used in
* combination with EQUATION 8 CONSTANT ELASTICITY OF SUBSTITUTION.
*EQPVA(regg,ind)..
*    PVA_V(regg,ind)
*    =E=
*    1 / aCES(regg,ind) *
*    sum((reg,kl)$gammaCES(reg,kl,regg,ind),
*    gammaCES(reg,kl,regg,ind)**elasKL(regg,ind) *
*    PKL_V(reg,kl)**( 1 - elasKL(regg,ind) ) )**
*    ( 1 / ( 1 - elasKL(regg,ind) ) ) ;

* EQUATION 24: Balance between specific product price and aggregate product
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

* EQUATION 25: Balance between specific product price and aggregate product
* price for final use. The aggregate price is different for each aggregated
* product (prd) demanded by each final user (regg,fd) and is a weighted average
* of the price of domestically produced product and the aggregate import price,
* where weights are defined as corresponding demands for final use.
EQPFU(prd,regg,fd)..
    PFU_V(prd,regg,fd) * FINAL_USE_T_V(prd,regg,fd)
    =E=
    P_V(regg,prd) * FINAL_USE_D_V(prd,regg,fd) +
    PIMP_V(prd,regg) * FINAL_USE_M_V(prd,regg,fd) ;

* EQUATION 26: Balance between specific imported product price and aggregated
* imported product price. The aggregate price is different for each product
* (prd) in each importing region (regg) and is a weighed average of specific
* product prices of exporting regions, where weights are defined as bi-lateral
* trade flows between the importing regions and the corresponding exporting
* regions.
EQPIMP(prd,regg)..
    PIMP_V(prd,regg) * IMPORT_V(prd,regg)
    =E=
    sum(reg, P_V(reg,prd) * TRADE_V(reg,prd,regg) ) ;

* EQUATION 27: Budget constraint of final users. The equation ensures that the
* total budget available for final use is spent on purchase of products. The
* equation defines scaling parameter of final users, see also explanation for
* EQUATION 9.
EQSCLFD(regg,fd)..
    CBUD_V(regg,fd)
    =E=
    sum((reg,prd), P_V(reg,prd) * ( 1 + tc_fd(prd,regg,fd) ) *
    FINAL_USE_V(reg,prd,regg,fd) ) ;

* EQUATION 28: Paasche price index for final users. The price index is
* calculated separately for each type of final user (regg,fd).
EQPAASCHE(regg,fd)..
    PAASCHE_V(regg,fd)
    =E=
    sum((reg,prd), P_V(reg,prd) * ( 1 + tc_fd(prd,regg,fd) ) *
    FINAL_USE_V(reg,prd,regg,fd) ) /
    sum((reg,prd), 1 * ( 1 + tc_fd(prd,regg,fd) ) *
    FINAL_USE_V(reg,prd,regg,fd) ) ;

* EQUATION 29: Laspeyres price index for final users. The price index is
* calculated separately for each type of final user (regg,fd).
EQLASPEYRES(regg,fd)..
    LASPEYRES_V(regg,fd)
    =E=
    sum((reg,prd), P_V(reg,prd) * ( 1 + tc_fd(prd,regg,fd) ) *
    FINAL_USE_bp_model(reg,prd,regg,fd) ) /
    sum((reg,prd), 1 * ( 1 + tc_fd(prd,regg,fd) ) *
    FINAL_USE_bp_model(reg,prd,regg,fd) ) ;

* ## End Price block ##



* EQUATION 30: Artificial objective function: only relevant for users of
* conopt solver in combination with NLP type of mathematical problem.
EQOBJ..
    OBJ
    =E=
    1 ;


* ======== Define levels and lower and upper bounds and fixed variables ========

* Endogenous variables
Y_V.L(regg,ind) = Y(regg,ind) ;
X_V.L(reg,prd)  = X(reg,prd) ;
Y_V.FX(regg,ind)$(Y(regg,ind) eq 0) = 0 ;
X_V.FX(reg,prd)$(X(reg,prd) eq 0)   = 0 ;

INTER_USE_T_V.L(prd,regg,ind)   = IU_PRD(prd,regg,ind) ;
INTER_USE_D_V.L(prd,regg,ind)   = IU_DOM(prd,regg,ind) ;
INTER_USE_M_V.L(prd,regg,ind)   = IU_IMP(prd,regg,ind) ;
INTER_USE_V.L(reg,prd,regg,ind) = INTER_USE_bp_model(reg,prd,regg,ind) ;
INTER_USE_T_V.FX(prd,regg,ind)$(IU_PRD(prd,regg,ind) eq 0)                   = 0 ;
INTER_USE_D_V.FX(prd,regg,ind)$(IU_DOM(prd,regg,ind) eq 0)                   = 0 ;
INTER_USE_M_V.FX(prd,regg,ind)$(IU_IMP(prd,regg,ind) eq 0)                   = 0 ;
INTER_USE_V.FX(reg,prd,regg,ind)$(INTER_USE_bp_model(reg,prd,regg,ind) eq 0) = 0 ;

VA_V.L(regg,ind)        = sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) ) ;
KL_V.L(reg,kl,regg,ind) = VALUE_ADDED_model(reg,kl,regg,ind) ;
VA_V.FX(regg,ind)$(sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) ) eq 0) = 0 ;
KL_V.FX(reg,kl,regg,ind)$(VALUE_ADDED_model(reg,kl,regg,ind) eq 0 )         = 0 ;

FINAL_USE_T_V.L(prd,regg,fd)   = FU_PRD(prd,regg,fd) ;
FINAL_USE_D_V.L(prd,regg,fd)   = FU_DOM(prd,regg,fd) ;
FINAL_USE_M_V.L(prd,regg,fd)   = FU_IMP(prd,regg,fd) ;
FINAL_USE_V.L(reg,prd,regg,fd) = FINAL_USE_bp_model(reg,prd,regg,fd) ;
FINAL_USE_T_V.FX(prd,regg,fd)$(FU_PRD(prd,regg,fd) eq 0)                   = 0 ;
FINAL_USE_D_V.FX(prd,regg,fd)$(FU_DOM(prd,regg,fd) eq 0)                   = 0 ;
FINAL_USE_M_V.FX(prd,regg,fd)$(FU_IMP(prd,regg,fd) eq 0)                   = 0 ;
FINAL_USE_V.FX(reg,prd,regg,fd)$(FINAL_USE_bp_model(reg,prd,regg,fd) eq 0) = 0 ;

IMPORT_V.L(prd,regg)    = IMPORT(prd,regg) ;
TRADE_V.L(reg,prd,regg) = TRADE(reg,prd,regg) ;
IMPORT_V.FX(prd,regg)$(IMPORT(prd,regg) eq 0)       = 0 ;
TRADE_V.FX(reg,prd,regg)$(TRADE(reg,prd,regg) eq 0) = 0 ;

FACREV_V.L(reg,kl)  = sum((regg,fd), VALUE_ADDED_DISTR_model(reg,kl,regg,fd) ) ;
TSPREV_V.L(reg,tsp) = sum((regg,fd), TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd) ) ;
NTPREV_V.L(reg,ntp) = sum((regg,fd), VALUE_ADDED_DISTR_model(reg,ntp,regg,fd) ) ;
FACREV_V.FX(reg,kl)$(sum((regg,fd), VALUE_ADDED_DISTR_model(reg,kl,regg,fd) ) eq 0)    = 0 ;
TSPREV_V.FX(reg,tsp)$(sum((regg,fd), TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd) )  eq 0) = 0 ;
NTPREV_V.FX(reg,ntp)$(sum((regg,fd), VALUE_ADDED_DISTR_model(reg,ntp,regg,fd) )  eq 0) = 0 ;

INC_V.L(regg,fd)  = INC(regg,fd) ;
CBUD_V.L(regg,fd) = sum((reg,prd), FINAL_USE_bp_model(reg,prd,regg,fd) + FINAL_USE_ts_model(reg,prd,regg,fd) ) ;
INC_V.FX(regg,fd)$(INC(regg,fd) eq 0)                                                                               = 0 ;
CBUD_V.L(regg,fd)$(sum((reg,prd), FINAL_USE_bp_model(reg,prd,regg,fd) + FINAL_USE_ts_model(reg,prd,regg,fd) ) eq 0) = 0 ;

PY_V.L(regg,ind)       = 1 ;
P_V.L(reg,prd)         = 1 ;
PKL_V.L(reg,kl)        = 1 ;
PVA_V.L(regg,ind)      = 1 ;
PIU_V.L(prd,regg,ind)  = 1 ;
PFU_V.L(prd,regg,fd)   = 1 ;
PIMP_V.L(prd,regg)     = 1 ;
SCLFD_V.L(regg,fd)     = sum((reg,prd), FINAL_USE_bp_model(reg,prd,regg,fd) ) ;
PAASCHE_V.L(regg,fd)   = 1 ;
LASPEYRES_V.L(regg,fd) = 1 ;
PY_V.FX('US','A1')                                                             = 1 ;
PY_V.FX(regg,ind)$(Y_V.L(regg,ind) eq 0)                                       = 1 ;
P_V.FX(reg,prd)$(X_V.L(reg,prd) eq 0)                                          = 1 ;
PKL_V.FX(reg,kl)$(KLS(reg,kl) eq 0)                                            = 1 ;
PVA_V.FX(regg,ind)$(VA_V.L(regg,ind) eq 0)                                     = 1 ;
PIU_V.FX(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) eq 0)                    = 1 ;
PFU_V.FX(prd,regg,fd)$(FINAL_USE_T_V.L(prd,regg,fd) eq 0)                      = 1 ;
PIMP_V.FX(prd,regg)$(IMPORT_V.L(prd,regg)eq 0)                                 = 1 ;
SCLFD_V.FX(regg,fd)$(SCLFD_V.L(regg,fd) eq 0)                                  = 0 ;
PAASCHE_V.FX(regg,fd)$(sum((reg,prd), FINAL_USE_V.L(reg,prd,regg,fd) ) eq 0)   = 1 ;
LASPEYRES_V.FX(regg,fd)$(sum((reg,prd), FINAL_USE_V.L(reg,prd,regg,fd) ) eq 0) = 1 ;


* Exogenous variables
KLS_V.FX(reg,kl)                  = KLS(reg,kl) ;
INCTRANSFER_V.FX(reg,fd,regg,fdd) = INCOME_DISTR_model(reg,fd,regg,fdd) ;

* ======================= Scale variables and equations ========================

* EQUATION 1 and EQUATION 2A
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

* EQUATION 2B
EQY.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;
Y_V.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;

EQY.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;
Y_V.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;

* EQUATION 3
EQINTU_T.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) gt 0)
    = INTER_USE_T_V.L(prd,regg,ind) ;
INTER_USE_T_V.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) gt 0)
    = INTER_USE_T_V.L(prd,regg,ind) ;

EQINTU_T.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_T_V.L(prd,regg,ind) ;
INTER_USE_T_V.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_T_V.L(prd,regg,ind) ;

* EQUATION 4
EQINTU_D.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) gt 0)
    = INTER_USE_D_V.L(prd,regg,ind) ;
INTER_USE_D_V.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) gt 0)
    = INTER_USE_D_V.L(prd,regg,ind) ;

EQINTU_D.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_D_V.L(prd,regg,ind) ;
INTER_USE_D_V.SCALE(prd,regg,ind)$(INTER_USE_D_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_D_V.L(prd,regg,ind) ;

* EQUATION 5
EQINTU_M.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) gt 0)
    = INTER_USE_M_V.L(prd,regg,ind) ;
INTER_USE_M_V.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) gt 0)
    = INTER_USE_M_V.L(prd,regg,ind) ;

EQINTU_M.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_M_V.L(prd,regg,ind) ;
INTER_USE_M_V.SCALE(prd,regg,ind)$(INTER_USE_M_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_M_V.L(prd,regg,ind) ;

* EQUATION 6
EQINTU.SCALE(reg,prd,regg,ind)$(INTER_USE_V.L(reg,prd,regg,ind) gt 0)
    = INTER_USE_V.L(reg,prd,regg,ind) ;
INTER_USE_V.SCALE(reg,prd,regg,ind)$(INTER_USE_V.L(reg,prd,regg,ind) gt 0)
    = INTER_USE_V.L(reg,prd,regg,ind) ;

EQINTU.SCALE(reg,prd,regg,ind)$(INTER_USE_V.L(reg,prd,regg,ind) lt 0)
    = -INTER_USE_V.L(reg,prd,regg,ind) ;
INTER_USE_V.SCALE(reg,prd,regg,ind)$(INTER_USE_V.L(reg,prd,regg,ind) lt 0)
    = -INTER_USE_V.L(reg,prd,regg,ind) ;

* EQUATION 7
EQVA.SCALE(regg,ind)$(VA_V.L(regg,ind) gt 0)
    = VA_V.L(regg,ind) ;
VA_V.SCALE(regg,ind)$(VA_V.L(regg,ind) gt 0)
    = VA_V.L(regg,ind) ;

EQVA.SCALE(regg,ind)$(VA_V.L(regg,ind) lt 0)
    = -VA_V.L(regg,ind) ;
VA_V.SCALE(regg,ind)$(VA_V.L(regg,ind) lt 0)
    = -VA_V.L(regg,ind) ;

* EQUAION 8
EQKL.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) gt 0)
    = KL_V.L(reg,kl,regg,ind) ;
KL_V.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) gt 0)
    = KL_V.L(reg,kl,regg,ind) ;

EQKL.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) lt 0)
    = -KL_V.L(reg,kl,regg,ind) ;
KL_V.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) lt 0)
    = -KL_V.L(reg,kl,regg,ind) ;

* EQUATION 9
EQFU_T.SCALE(prd,regg,fd)$(FINAL_USE_T_V.L(prd,regg,fd) gt 0)
    = FINAL_USE_T_V.L(prd,regg,fd) ;
FINAL_USE_T_V.SCALE(prd,regg,fd)$(FINAL_USE_T_V.L(prd,regg,fd) gt 0)
    = FINAL_USE_T_V.L(prd,regg,fd) ;

EQFU_T.SCALE(prd,regg,fd)$(FINAL_USE_T_V.L(prd,regg,fd) lt 0)
    = -FINAL_USE_T_V.L(prd,regg,fd) ;
FINAL_USE_T_V.SCALE(prd,regg,fd)$(FINAL_USE_T_V.L(prd,regg,fd) lt 0)
    = -FINAL_USE_T_V.L(prd,regg,fd) ;

* EQUATION 10
EQFU_D.SCALE(prd,regg,fd)$(FINAL_USE_D_V.L(prd,regg,fd) gt 0)
    = FINAL_USE_D_V.L(prd,regg,fd) ;
FINAL_USE_D_V.SCALE(prd,regg,fd)$(FINAL_USE_D_V.L(prd,regg,fd) gt 0)
    = FINAL_USE_D_V.L(prd,regg,fd) ;

EQFU_D.SCALE(prd,regg,fd)$(FINAL_USE_D_V.L(prd,regg,fd) lt 0)
    = -FINAL_USE_D_V.L(prd,regg,fd) ;
FINAL_USE_D_V.SCALE(prd,regg,fd)$(FINAL_USE_D_V.L(prd,regg,fd) lt 0)
    = -FINAL_USE_D_V.L(prd,regg,fd) ;

* EQUATION 11
EQFU_M.SCALE(prd,regg,fd)$(FINAL_USE_M_V.L(prd,regg,fd) gt 0)
    = FINAL_USE_M_V.L(prd,regg,fd) ;
FINAL_USE_M_V.SCALE(prd,regg,fd)$(FINAL_USE_M_V.L(prd,regg,fd) gt 0)
    = FINAL_USE_M_V.L(prd,regg,fd) ;

EQFU_M.SCALE(prd,regg,fd)$(FINAL_USE_M_V.L(prd,regg,fd) lt 0)
    = -FINAL_USE_M_V.L(prd,regg,fd) ;
FINAL_USE_M_V.SCALE(prd,regg,fd)$(FINAL_USE_M_V.L(prd,regg,fd) lt 0)
    = -FINAL_USE_M_V.L(prd,regg,fd) ;

* EQUATION 12
EQFU.SCALE(reg,prd,regg,fd)$(FINAL_USE_V.L(reg,prd,regg,fd) gt 0)
    = FINAL_USE_V.L(reg,prd,regg,fd) ;
FINAL_USE_V.SCALE(reg,prd,regg,fd)$(FINAL_USE_V.L(reg,prd,regg,fd) gt 0)
    = FINAL_USE_V.L(reg,prd,regg,fd) ;

EQFU.SCALE(reg,prd,regg,fd)$(FINAL_USE_V.L(reg,prd,regg,fd) lt 0)
    = -FINAL_USE_V.L(reg,prd,regg,fd) ;
FINAL_USE_V.SCALE(reg,prd,regg,fd)$(FINAL_USE_V.L(reg,prd,regg,fd) lt 0)
    = -FINAL_USE_V.L(reg,prd,regg,fd) ;

* EQUATION 13
EQIMP.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) gt 0)
    = IMPORT_V.L(prd,regg) ;
IMPORT_V.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) gt 0)
    = IMPORT_V.L(prd,regg) ;

EQIMP.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) lt 0)
    = -IMPORT_V.L(prd,regg) ;
IMPORT_V.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) lt 0)
    = -IMPORT_V.L(prd,regg) ;

* EQUATION 14
EQTRADE.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) gt 0)
    = TRADE_V.L(reg,prd,regg) ;
TRADE_V.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) gt 0)
    = TRADE_V.L(reg,prd,regg) ;

EQTRADE.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) lt 0)
    = -TRADE_V.L(reg,prd,regg) ;
TRADE_V.SCALE(reg,prd,regg)$(TRADE_V.L(reg,prd,regg) lt 0)
    = -TRADE_V.L(reg,prd,regg) ;

* EQUATION 15
EQFACREV.SCALE(reg,kl)$(FACREV_V.L(reg,kl) gt 0)
    = FACREV_V.L(reg,kl) ;
FACREV_V.SCALE(reg,kl)$(FACREV_V.L(reg,kl) gt 0)
    = FACREV_V.L(reg,kl) ;

EQFACREV.SCALE(reg,kl)$(FACREV_V.L(reg,kl) lt 0)
    = -FACREV_V.L(reg,kl) ;
FACREV_V.SCALE(reg,kl)$(FACREV_V.L(reg,kl) lt 0)
    = -FACREV_V.L(reg,kl) ;

* EQUATION 16
EQTSPREV.SCALE(reg,tsp)$(TSPREV_V.L(reg,tsp) gt 0)
    = TSPREV_V.L(reg,tsp) ;
TSPREV_V.SCALE(reg,tsp)$(TSPREV_V.L(reg,tsp) gt 0)
    = TSPREV_V.L(reg,tsp) ;

EQTSPREV.SCALE(reg,tsp)$(TSPREV_V.L(reg,tsp) lt 0)
    = -TSPREV_V.L(reg,tsp) ;
TSPREV_V.SCALE(reg,tsp)$(TSPREV_V.L(reg,tsp) lt 0)
    = -TSPREV_V.L(reg,tsp) ;

* EQUATION 17
EQNTPREV.SCALE(reg,ntp)$(NTPREV_V.L(reg,ntp) gt 0)
    = NTPREV_V.L(reg,ntp) ;
NTPREV_V.SCALE(reg,ntp)$(NTPREV_V.L(reg,ntp) gt 0)
    = NTPREV_V.L(reg,ntp) ;

EQNTPREV.SCALE(reg,ntp)$(NTPREV_V.L(reg,ntp) lt 0)
    = -NTPREV_V.L(reg,ntp) ;
NTPREV_V.SCALE(reg,ntp)$(NTPREV_V.L(reg,ntp) lt 0)
    = -NTPREV_V.L(reg,ntp) ;

* EQUATION 18
EQINC.SCALE(reg,fd)$(INC_V.L(reg,fd) gt 0)
    = INC_V.L(reg,fd) ;
INC_V.SCALE(reg,fd)$(INC_V.L(reg,fd) gt 0)
    = INC_V.L(reg,fd) ;

EQINC.SCALE(reg,fd)$(INC_V.L(reg,fd) lt 0)
    = -INC_V.L(reg,fd) ;
INC_V.SCALE(reg,fd)$(INC_V.L(reg,fd) lt 0)
    = -INC_V.L(reg,fd) ;

* EQUATION 19
EQCBUD.SCALE(reg,fd)$(CBUD_V.L(reg,fd) gt 0)
    = CBUD_V.L(reg,fd) ;
CBUD_V.SCALE(reg,fd)$(CBUD_V.L(reg,fd) gt 0)
    = CBUD_V.L(reg,fd) ;

EQCBUD.SCALE(reg,fd)$(CBUD_V.L(reg,fd) lt 0)
    = -CBUD_V.L(reg,fd) ;
CBUD_V.SCALE(reg,fd)$(CBUD_V.L(reg,fd) lt 0)
    = -CBUD_V.L(reg,fd) ;

* EQUATION 20
EQPY.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;

EQPY.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;

*EQUATION 21
EQP.SCALE(reg,prd)$(X_V.L(reg,prd) gt 0)
    = X_V.L(reg,prd) ;

EQP.SCALE(reg,prd)$(X_V.L(reg,prd) lt 0)
    = -X_V.L(reg,prd)  ;

* EQUATION 22
EQPKL.SCALE(reg,kl)$(KLS_V.L(reg,kl) gt 0)
    = KLS_V.L(reg,kl) ;

EQPKL.SCALE(reg,kl)$(KLS_V.L(reg,kl) lt 0)
    = -KLS_V.L(reg,kl) ;

* EQUATION 23
EQPVA.SCALE(reg,ind)$(VA_V.L(reg,ind) gt 0)
    = VA_V.L(reg,ind) ;

EQPVA.SCALE(reg,ind)$(VA_V.L(reg,ind) lt 0)
    = -VA_V.L(reg,ind) ;

* EQUATION 24
EQPIU.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) gt 0)
    = INTER_USE_T_V.L(prd,regg,ind) ;

EQPIU.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_T_V.L(prd,regg,ind) ;

* EQUATION 25
EQPFU.SCALE(prd,regg,fd)$(FINAL_USE_T_V.L(prd,regg,fd) gt 0)
    = FINAL_USE_T_V.L(prd,regg,fd) ;

EQPFU.SCALE(prd,regg,fd)$(FINAL_USE_T_V.L(prd,regg,fd) lt 0)
    = -FINAL_USE_T_V.L(prd,regg,fd) ;

* EQUATION 26
EQPIMP.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) gt 0)
    = IMPORT_V.L(prd,regg) ;

EQPIMP.SCALE(prd,regg)$(IMPORT_V.L(prd,regg) lt 0)
    = -IMPORT_V.L(prd,regg) ;

* EQUATION 27
EQSCLFD.SCALE(reg,fd)$(SCLFD_V.L(reg,fd) gt 0)
    = SCLFD_V.L(reg,fd) ;
SCLFD_V.SCALE(reg,fd)$(SCLFD_V.L(reg,fd) gt 0)
    = SCLFD_V.L(reg,fd) ;

EQSCLFD.SCALE(reg,fd)$(SCLFD_V.L(reg,fd) lt 0)
    = -SCLFD_V.L(reg,fd) ;
SCLFD_V.SCALE(reg,fd)$(SCLFD_V.L(reg,fd) lt 0)
    = -SCLFD_V.L(reg,fd) ;

* EQUATION 28 - SCALING IS NOT REQUIRED

* EQUATION 29 - SCALING IS NOT REQUIRED

* EQUATION 30 - SCALING IS NOT REQUIRED

* EXOGENOUS VARIBLES
KLS_V.SCALE(reg,kl)$(KLS_V.L(reg,kl) gt 0)
    = KLS_V.L(reg,kl) ;
KLS_V.SCALE(reg,kl)$(KLS_V.L(reg,kl) lt 0)
    = -KLS_V.L(reg,kl) ;

INCTRANSFER_V.SCALE(reg,fd,regg,fdd)$(INCTRANSFER_V.L(reg,fd,regg,fdd) gt 0)
    = INCTRANSFER_V.L(reg,fd,regg,fdd) ;
INCTRANSFER_V.SCALE(reg,fd,regg,fdd)$(INCTRANSFER_V.L(reg,fd,regg,fdd) lt 0)
    = -INCTRANSFER_V.L(reg,fd,regg,fdd) ;

* ========================== Declare model equations ===========================

Model IO_product_technology
/
EQBAL
EQX
EQINTU_T
EQINTU_D
EQINTU_M
EQINTU
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
EQVA
EQKL
EQFU_T
EQFU_D
EQFU_M
EQFU
EQIMP
EQTRADE
EQFACREV
EQTSPREV
EQNTPREV
EQINC
EQCBUD
EQPY
EQP
EQPKL
EQPVA
EQPIU
EQPFU
EQPIMP
EQSCLFD
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
EQVA.VA_V
EQKL.KL_V
EQFU_T.FINAL_USE_T_V
EQFU_D.FINAL_USE_D_V
EQFU_M.FINAL_USE_M_V
EQFU.FINAL_USE_V
EQIMP.IMPORT_V
EQTRADE.TRADE_V
EQFACREV.FACREV_V
EQTSPREV.TSPREV_V
EQNTPREV.NTPREV_V
EQINC.INC_V
EQCBUD.CBUD_V
EQPY.PY_V
EQP.P_V
EQPKL.PKL_V
EQPVA.PVA_V
EQPIU.PIU_V
EQPFU.PFU_V
EQPIMP.PIMP_V
EQSCLFD.SCLFD_V
EQPAASCHE.PAASCHE_V
EQLASPEYRES.LASPEYRES_V
/
;
