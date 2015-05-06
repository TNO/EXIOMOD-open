* File:   library/scr/08_module_prices.gms
* Author: Trond Husby
* Date:   22 April 2015
* Adjusted: 6 May 2015

* gams-master-file: phase.gms

$ontext startdoc
Documentation is missing
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ==================== Phase 1: Additional sets and subsets ====================
$if not '%phase%' == 'additional_sets' $goto end_additional_sets

$label end_additional_sets

* ===================== Phase 2: Declaration of parameters =====================
$if not '%phase%' == 'parameters_declaration' $goto end_parameters_declaration

$label end_parameters_declaration

* ====================== Phase 3: Definition of parameters =====================
$if not '%phase%' == 'parameters_calibration' $goto end_parameters_calibration

$label end_parameters_calibration

* =============== Phase 4: Declaration of variables and equations ==============
$if not '%phase%' == 'variables_equations_declaration' $goto end_variables_equations_declaration

* ========================== Declaration of variables ==========================

* Endogenous variables
Variables
    PY_V(regg,ind)                  industry output price
    P_V(reg,prd)                    basic product price
    PKL_V(reg,va)                   production factor price
    PVA_V(regg,ind)                 aggregate production factors price
    PIU_V(prd,regg,ind)             aggregate product price for intermediate use
    PC_H_V(prd,regg)                aggregate product price for household
                                    # consumption
    PC_G_V(prd,regg)                aggregate product price for government
                                    # consumption
    PC_I_V(prd,regg)                aggregate product price for gross fixed
                                    # capital formation
    PIMP_T_V(prd,regg)              aggregate total imported product price
    PIMP_MOD_V(prd,regg)            aggregate imported product price for the
                                    # aggregate imported from modeled regions
    PROW_V                          price of imports from the rest of the world
                                    # region (similar to exchange rate)
    PAASCHE_V(regg)                 Paasche price index for household
                                    # consumption
    LASPEYRES_V(regg)               Laspeyres price index for household
                                    # consumption
    GDPDEF_V                        GDP deflator used as numéraire
;

* Artificial objective
Variables
    OBJ                             artificial objective value
;

* ========================== Declaration of equations ==========================

Equations
    EQPY(regg,ind)              zero-profit condition (including possible
                                # margins)
    EQP(reg,prd)                balance between product price and industry price
    EQPKL(reg,va)               balance on production factors market
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
    EQPIMP_T(prd,regg)          balance between specific imported product price
                                # from the rest of the world and modeled regions
                                # and total aggregated imported product price
    EQPIMP_MOD(prd,regg)        balance between specific imported product price
                                # from modeled regions and corresponding
                                # aggregated imported product price
    EQPROW                      balance of payments with the rest of the world
                                # region
    EQPAASCHE(regg)             Paasche price index for household consumption
    EQLASPEYRES(regg)           Laspeyres price index for household consumption
    EQGDPDEF                    GDP deflator used as numéraire
    EQOBJ                       artificial objective function
;

$label end_variables_equations_declaration

* ====================== Phase 5: Definition of equations ======================
$if not '%phase%' == 'equations_definition' $goto end_equations_definition

* EQUATION 4.1: Zero-profit condition. Industry output price for each industry
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
    sum(prd, INTER_USE_T_V(prd,regg,ind) * PIU_V(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((reg,kl), KL_V(reg,kl,regg,ind) * PKL_V(reg,kl) ) +
    sum(tim, TAX_INTER_USE_ROW(tim,regg,ind) * PROW_V ) ;

* EQUATION 4.2: Balance between product price and industry price. Price of each
* product (prd) in each region of production (reg) is defined as a weighted
* average of industry prices, where weights are defined as output of the product
* by the corresponding industry. Price equation are only relevant for CGE
* model, and since only EQUATION 2.2B is suitable for CGE model, the
* co-production coefficients of EQUATION 2.2B are used.
EQP(reg,prd)..
    P_V(reg,prd) * X_V(reg,prd)
    =E=
    sum((regg,ind), PY_V(regg,ind) *
    ( coprodB(reg,prd,regg,ind) * X_V(reg,prd) ) ) ;

* EQUATION 4.3: Balance on production factors market. Price of each production
* factor (reg,kl) is defined in such a way that total demand for the
* corresponding production factor is equal to the supply of the factor less,
* if modeled, unemployment or non-utilized capacity. Supply of production
* factors is one of the exogenous variables of the model.
EQPKL(reg,kl)..
    KLS_V(reg,kl)
    =E=
    sum((regg,ind), KL_V(reg,kl,regg,ind) ) ;

* EQUATION 4.4: Balance between specific production factors price and aggregate
* production factors price. The aggregate price is different in each industry
* (ind) in each region (regg) and is a weighted average of the price of specific
* production factors, where weights are defined as demand by the industry for
* corresponding production factors.
EQPVA(regg,ind)..
    PVA_V(regg,ind) * VA_V(regg,ind)
    =E=
    sum((reg,kl), PKL_V(reg,kl) * KL_V(reg,kl,regg,ind)) ;

* EQUATION 4.5: Balance between specific product price and aggregate product
* price for intermediate use. The aggregate price is different for each
* aggregated product (prd) in each industry (ind) in each region (regg) and is
* a weighted average of the price of domestically produced product and the
* aggregated import price, where weights are defined as corresponding demands
* for intermediate use.
EQPIU(prd,regg,ind)..
    PIU_V(prd,regg,ind) * INTER_USE_T_V(prd,regg,ind)
    =E=
    P_V(regg,prd) * INTER_USE_D_V(prd,regg,ind) +
    PIMP_T_V(prd,regg) * INTER_USE_M_V(prd,regg,ind) ;

* EQUATION 4.6: Balance between specific product price and aggregate product
* price for household consumption. The aggregate price is different for each
* aggregated product (prd) demanded by households in each region (regg) and is a
* weighted average of the price of domestically produced product and the
* aggregated import price, where weights are defined as corresponding household
* demands.
EQPC_H(prd,regg)..
    PC_H_V(prd,regg) * CONS_H_T_V(prd,regg)
    =E=
    P_V(regg,prd) * CONS_H_D_V(prd,regg) +
    PIMP_T_V(prd,regg) * CONS_H_M_V(prd,regg) ;

* EQUATION 4.7: Balance between specific product price and aggregate product
* price for government consumption. The aggregate price is different for each
* aggregated product (prd) demanded by government in each region (regg) and is a
* weighted average of the price of domestically produced product and the
* aggregated import price, where weights are defined as corresponding government
* demands.
EQPC_G(prd,regg)..
    PC_G_V(prd,regg) * CONS_G_T_V(prd,regg)
    =E=
    P_V(regg,prd) * CONS_G_D_V(prd,regg) +
    PIMP_T_V(prd,regg) * CONS_G_M_V(prd,regg) ;

* EQUATION 4.8: Balance between specific product price and aggregate product
* price for gross fixed capital formation. The aggregate price is different for
* each aggregated product (prd) demanded by investment agent in each region
* (regg) and is a weighted average of the price of domestically produced product
* and the aggregated import price, where weights are defined as corresponding
* gross fixed capital formation demands.
EQPC_I(prd,regg)..
    PC_I_V(prd,regg) * GFCF_T_V(prd,regg)
    =E=
    P_V(regg,prd) * GFCF_D_V(prd,regg) +
    PIMP_T_V(prd,regg) * GFCF_M_V(prd,regg) ;

* EQUATION 4.9: Balance between total aggregated imported price and the price
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

* EQUATION 4.10: Balance between specific imported product price and aggregated
* imported product price. The aggregate price is different for each product
* (prd) in each importing region (regg) and is a weighed average of specific
* product prices of exporting regions, where weights are defined as bi-lateral
* trade flows between the importing regions and the corresponding exporting
* region.
EQPIMP_MOD(prd,regg)..
    PIMP_MOD_V(prd,regg) * IMPORT_MOD_V(prd,regg)
    =E=
    sum(reg, TRADE_V(reg,prd,regg) * P_V(reg,prd) ) ;

* EQUATION 4.11: Balance of payments. Expenditures of the rest of the world
* region on exports and income transfers are equal to the region's receipts from
* its imports. The balance is regulated by the price that intermediate and final
* users are paying for the products imported from the rest of the world region.
EQPROW..
    sum((reg,prd), EXPORT_ROW_V(reg,prd) * P_V(reg,prd) ) +
    sum((reg,tim), TAX_EXPORT_ROW(reg,tim) ) * PROW_V
    =E=
    sum((prd,regg), IMPORT_ROW_V(prd,regg) * PROW_V ) +
    sum((prd,regg), SV_ROW_V(prd,regg) ) * PROW_V +
    sum((tim,regg,ind), TAX_INTER_USE_ROW(tim,regg,ind) ) * PROW_V +
    sum((tim,regg,fd), TAX_FINAL_USE_ROW(tim,regg,fd) ) * PROW_V -
    sum((reg,fd), TRANSFERS_ROW_V(reg,fd) * PROW_V ) ;

* EQUATION 4.12: Paasche price index for households. The price index is
* calculated separately for each region (regg).
EQPAASCHE(regg)..
    PAASCHE_V(regg)
    =E=
    sum(prd, CONS_H_T_V(prd,regg) * PC_H_V(prd,regg) *
    ( 1 + tc_h(prd,regg) ) ) /
    sum(prd, CONS_H_T_V(prd,regg) * 1 *
    ( 1 + tc_h_0(prd,regg) ) ) ;

* EQUATION 4.13: Laspeyres price index for households. The price index is
* calculated separately for each region (regg).
EQLASPEYRES(regg)..
    LASPEYRES_V(regg)
    =E=
    sum((reg,prd), CONS_H(reg,prd,regg) * P_V(reg,prd) *
    ( 1 + tc_h(prd,regg) ) ) /
    sum((reg,prd), CONS_H(reg,prd,regg) * 1 *
    ( 1 + tc_h_0(prd,regg) ) ) ;


* EQUATION 4.14: GDP deflator. The deflator is calculated as a single value for
* all modeled regions and is used as a numéraire in the model.
EQGDPDEF..
    GDPDEF_V
    =E=
    sum(regg, GDPCUR_V(regg) ) / sum(regg, GDPCONST_V(regg) ) ;


* EQUATION 4.15: Artificial objective function: only relevant for users of
* conopt solver in combination with NLP type of mathematical problem.
EQOBJ..
    OBJ
    =E=
    1 ;

$label end_equations_definition

* ===== Phase 6: Define levels, bounds and fixed variables, scale equations ====
$if not '%phase%' == 'bounds_and_scales' $goto end_bounds_and_scales

* ==================== Define level and bounds of variables ====================

* Price variables: level of basic prices is set to one, which also corresponds
* to the price level used in calibration. If the the real variable to which the
* price level is linked is fixed to zero, the price is fixed to one. For zero
* level variables any price level will be a solution and fixing it to one helps
* the solver. Additionally, price of the numéraire is fixed.
PY_V.L(regg,ind)       = 1 ;
P_V.L(reg,prd)         = 1 ;
PKL_V.L(reg,kl)        = 1 ;
PVA_V.L(regg,ind)      = 1 ;
PIU_V.L(prd,regg,ind)  = 1 ;
PC_H_V.L(prd,regg)     = 1 ;
PC_G_V.L(prd,regg)     = 1 ;
PC_I_V.L(prd,regg)     = 1 ;
PIMP_T_V.L(prd,regg)   = 1 ;
PIMP_MOD_V.L(prd,regg) = 1 ;
PROW_V.L               = 1 ;
PAASCHE_V.L(regg)      = 1 ;
LASPEYRES_V.L(regg)    = 1 ;
GDPDEF_V.L                                                    = 1 ;
PY_V.FX('WEU','i020')                                         = 1 ;
PY_V.FX(regg,ind)$(Y_V.L(regg,ind) eq 0)                      = 1 ;
P_V.FX(reg,prd)$(X_V.L(reg,prd) eq 0)                         = 1 ;
PKL_V.FX(reg,kl)$(KLS(reg,kl) eq 0)                           = 1 ;
PVA_V.FX(regg,ind)$(VA_V.L(regg,ind) eq 0)                    = 1 ;
PIU_V.FX(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) eq 0)   = 1 ;
PC_H_V.FX(prd,regg)$(CONS_H_T_V.L(prd,regg) eq 0)             = 1 ;
PC_G_V.FX(prd,regg)$(CONS_G_T_V.L(prd,regg) eq 0)             = 1 ;
PC_I_V.FX(prd,regg)$(GFCF_T_V.L(prd,regg) eq 0)               = 1 ;
PIMP_T_V.FX(prd,regg)$(IMPORT_T_V.L(prd,regg)eq 0)            = 1 ;
PIMP_MOD_V.FX(prd,regg)$(IMPORT_MOD_V.L(prd,regg)eq 0)        = 1 ;
PROW_V.FX$( ( sum((prd,regg), IMPORT_ROW(prd,regg) ) +
            sum((prd,regg), SV_ROW(prd,regg) ) ) eq 0 )       = 1 ;
PAASCHE_V.FX(regg)$(sum(prd, CONS_H_T_V.L(prd,regg) ) eq 0)   = 1 ;
LASPEYRES_V.FX(regg)$(sum(prd, CONS_H_T_V.L(prd,regg) ) eq 0) = 1 ;

* ======================= Scale variables and equations ========================

* Scaling of variables and equations is done in order to help the solver to
* find the solution quicker. The scaling should ensure that the partial
* derivative of each variable evaluated at their current level values is within
* the range between 0.1 and 100. The values of partial derivatives can be seen
* in the equation listing. In general, the rule is that the variable and the
* equation linked to this variables in MCP formulation should both be scaled by
* the initial level of the variable.

* EQUATION 4.1
EQPY.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;

EQPY.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;

* EQUATION 4.2
EQP.SCALE(reg,prd)$(X_V.L(reg,prd) gt 0)
    = X_V.L(reg,prd) ;

EQP.SCALE(reg,prd)$(X_V.L(reg,prd) lt 0)
    = -X_V.L(reg,prd)  ;

* EQUATION 4.3
EQPKL.SCALE(reg,kl)$(KLS_V.L(reg,kl) gt 0)
    = KLS_V.L(reg,kl) ;

EQPKL.SCALE(reg,kl)$(KLS_V.L(reg,kl) lt 0)
    = -KLS_V.L(reg,kl) ;

* EQUATION 4.4
EQPVA.SCALE(reg,ind)$(VA_V.L(reg,ind) gt 0)
    = VA_V.L(reg,ind) ;

EQPVA.SCALE(reg,ind)$(VA_V.L(reg,ind) lt 0)
    = -VA_V.L(reg,ind) ;

* EQUATION 4.5
EQPIU.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) gt 0)
    = INTER_USE_T_V.L(prd,regg,ind) ;

EQPIU.SCALE(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) lt 0)
    = -INTER_USE_T_V.L(prd,regg,ind) ;

* EQUATION 4.6
EQPC_H.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) gt 0)
    = CONS_H_T_V.L(prd,regg) ;

EQPC_H.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) lt 0)
    = -CONS_H_T_V.L(prd,regg) ;

* EQUATION 4.7
EQPC_G.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) gt 0)
    = CONS_G_T_V.L(prd,regg) ;

EQPC_G.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) lt 0)
    = -CONS_G_T_V.L(prd,regg) ;

* EQUATION 4.8
EQPC_I.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) gt 0)
    = GFCF_T_V.L(prd,regg) ;

EQPC_I.SCALE(prd,regg)$(GFCF_T_V.L(prd,regg) lt 0)
    = -GFCF_T_V.L(prd,regg) ;

* EQUATION 4.9
EQPIMP_T.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) gt 0)
    = IMPORT_T_V.L(prd,regg) ;

EQPIMP_T.SCALE(prd,regg)$(IMPORT_T_V.L(prd,regg) lt 0)
    = -IMPORT_T_V.L(prd,regg) ;

* EQUATION 4.10
EQPIMP_MOD.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) gt 0)
    = IMPORT_MOD_V.L(prd,regg) ;

EQPIMP_MOD.SCALE(prd,regg)$(IMPORT_MOD_V.L(prd,regg) lt 0)
    = -IMPORT_MOD_V.L(prd,regg) ;

* EQUATION 4.11
EQPROW.SCALE$(sum((reg,prd), EXPORT_ROW_V.L(reg,prd) ) gt 0   )
    = sum((reg,prd), EXPORT_ROW_V.L(reg,prd) ) ;

EQPROW.SCALE$(sum((reg,prd), EXPORT_ROW_V.L(reg,prd) ) lt 0   )
    = -sum((reg,prd), EXPORT_ROW_V.L(reg,prd) ) ;

* EQUATION 4.12 - SCALING IS NOT REQUIRED

* EQUATION 4.13 - SCALING IS NOT REQUIRED

* EQUATION 4.14 - SCALING IS NOT REQUIRED

$label end_bounds_and_scales
