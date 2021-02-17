* File:   EXIOMOD_base_model/scr/08_module_prices.gms
* Author: Trond Husby
* Organization: TNO, Netherlands 
* Date:   22 April 2015
* Adjusted: 17 Februari 2021 by Hettie Boonman

* gams-master-file: phase.gms

********************************************************************************
* THIS MODEL IS A CUSTOM-LICENSE MODEL.
* EXIOMOD 2.0 shall not be used for commercial purposes until an exploitation
* aggreement is signed, subject to similar conditions as for the underlying
* database (EXIOBASE). EXIOBASE limitations are based on open source license
* agreements to be found here:
* http://exiobase.eu/index.php/terms-of-use

* For information on a license, please contact: hettie.boonman@tno.nl
********************************************************************************

$ontext startdoc
This is a module describing prices side equations of the base CGE model. The
code includes all the required elements (calibration, equations definition,
model statement) for the prices side. The following elements of the model are
described within the prices module:

- Zero profit condition for the producers: revenue equals expenses.
- Balance between price per product and price per activity.
- Balance on the market of factors of production: supply equals demand.
- Balance between market prices of traded products and factors of production and
  the prices for aggregated nests on different levels of production, demand and
  trade functions.
- Balance of payments with the rest of the world region.
- Definition of price indexes and GDP deflator, which is used as numéraire.

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
    KS(reg)                     supply of capital (volume)
    LS(reg)                     supply of labour (volume)
    GDP(regg)                   gross domestic product (value)
;

$label end_parameters_declaration

* ====================== Phase 3: Definition of parameters =====================
$if not '%phase%' == 'parameters_calibration' $goto end_parameters_calibration

* Supply in volume of the production factor capital in each region (reg), the
* corresponding basic price in the base year is equal to 1, market price can be
* different from 1 in case of non-zero taxes on factors of production.
KS(reg)
    = sum((k,regg,ind),VALUE_ADDED(reg,k,regg,ind) ) ;

* Supply in volume of the production factor labour in each region (reg), the
* corresponding basic price in the base year is equal to 1, market price can be
* different from 1 in case of non-zero taxes on factors of production.
LS(reg)
    = sum((l,regg,ind),VALUE_ADDED(reg,l,regg,ind) ) ;

Display
KS
LS
;

* Gross domestic product in each region (regg). GDP calculated as difference
* between total output and intermediate inputs (including international margins
* and taxes on exports paid in relation with intermediate inputs) plus taxes on
* products paid by final consumers and taxes paid on exports.
GDP(regg)
    = sum(ind, Y(regg,ind) ) -
    ( sum((prd,ind), INTER_USE_T(prd,regg,ind) ) +
    sum((reg,inm,ind), VALUE_ADDED(reg,inm,regg,ind) ) +
    sum((reg,tse,ind), VALUE_ADDED(reg,tse,regg,ind) ) )
    +
    sum((prd,fd), FINAL_USE_dt(prd,regg,fd) )
    +
    ( sum((tse,reg,ind), VALUE_ADDED(regg,tse,reg,ind) ) +
    sum((tse,reg,fd), TIM_FINAL_USE(regg,tse,reg,fd) ) +
    sum(tse, TIM_EXPORT_ROW(regg,tse) ) ) ;

Display
GDP
;

$label end_parameters_calibration

* =============== Phase 4: Declaration of variables and equations ==============
$if not '%phase%' == 'variables_equations_declaration' $goto end_variables_equations_declaration

* ========================== Declaration of variables ==========================

* Endogenous variables
Variables
    PY_V(regg,ind)                  industry output price
    P_V(reg,prd)                    basic product price
    PK_V(reg)                       capital price
    PL_V(reg)                       labour price

    PIU_V(prd,regg,ind)             aggregate product price for intermediate use
    PC_H_V(prd,regg)                aggregate product price for household
                                    # consumption
    PC_G_V(prd,regg)                aggregate product price for government
                                    # consumption
    PC_I_V(prd,regg)                aggregate product price for gross fixed
                                    # capital formation
    PROW_V                          price of imports from the rest of the world
                                    # region (similar to exchange rate)
    PAASCHE_V(regg)                 Paasche price index for household
                                    # consumption
    LASPEYRES_V(regg)               Laspeyres price index for household
                                    # consumption
    GDPCUR_V(regg)                  GDP in current prices (value)
    GDPCONST_V(regg)                GDP in constant prices (volume)
    GDPDEF_V                        GDP deflator used as numéraire
;

* Exogenous variables
Variables
    KS_V(reg)                       supply of capital
    LS_V(reg)                       supply of labour
;

* ========================== Declaration of equations ==========================

Equations
    EQPY(regg,ind)              zero-profit condition (including possible
                                # margins)
    EQP(reg,prd)                balance between product price and industry price
    EQPK(reg)                   balance on capital market
    EQPL(reg)                   balance on labour market
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
    EQPROW                      balance of payments with the rest of the world
                                # region
    EQPAASCHE(regg)             Paasche price index for household consumption
    EQLASPEYRES(regg)           Laspeyres price index for household consumption
    EQGDPCUR(regg)              GDP in current prices (value)
    EQGDPCONST(regg)            GDP in constant prices (volume)
    EQGDPDEF                    GDP deflator used as numéraire
;

$label end_variables_equations_declaration

* ====================== Phase 5: Definition of equations ======================
$if not '%phase%' == 'equations_definition' $goto end_equations_definition

* EQUATION 4.1: Zero-profit condition. Industry output price for each industry
* (ind) in each region (regg) is defined in such a way that revenues earned from
* product sales less possible production net taxes are equal to the cost of
* intermediate inputs and factors of production, including possible product and
* factor taxes, plus, if modeled, excessive profit margins. In this type of CGE
* model the equation form a linear dependent system, therefore one of the
* equations is usually dropped, and on of the variables is declared as
* numéraire. We choose to drop one of the equations in this group. Due to
* programming convenience, the equation corresponding to the largest output
* value in the base year is dropped. GDP deflator is used as numéraire (see
* EQUATION 4.14).
EQPY(regg,ind)$( Y(regg,ind) ne smax((reggg,indd), Y(reggg,indd) ) and
    Y(regg,ind) )..
    Y_V(regg,ind) * PY_V(regg,ind) *
    ( 1 - sum(reg, txd_ind(reg,regg,ind) ) -
    sum(reg, txd_inm(reg,regg,ind) ) - sum(reg, txd_tse(reg,regg,ind) ) )
    =E=
    sum(prd, INTER_USE_T_V(prd,regg,ind) * PIU_V(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum(reg, K_V(reg,regg,ind) * PK_V(reg) ) +
    sum(reg, L_V(reg,regg,ind) * PL_V(reg) ) +
    sum(inm, TIM_INTER_USE_ROW(inm,regg,ind) * PROW_V ) +
    sum(tse, TIM_INTER_USE_ROW(tse,regg,ind) * PROW_V ) ;

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

* EQUATION 4.3: Balance on the capital market. Price of each production
* factor (reg) is defined in such a way that total demand for the
* corresponding production factor is equal to the supply of the factor less,
* if modeled, unemployment or non-utilized capacity. Supply of production
* factors is one of the exogenous variables of the model.
EQPK(reg)..
    KS_V(reg)
    =E=
    sum((regg,ind), K_V(reg,regg,ind) ) ;

* EQUATION 4.4: Balance on the labour market. Price of each production
* factor (reg) is defined in such a way that total demand for the
* corresponding production factor is equal to the supply of the factor less,
* if modeled, unemployment or non-utilized capacity. Supply of production
* factors is one of the exogenous variables of the model.
EQPL(reg)..
    LS_V(reg)
    =E=
    sum((regg,ind), L_V(reg,regg,ind) ) ;

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

* EQUATION 4.9: Balance of payments. Expenditures of the rest of the world
* region on exports and income transfers are equal to the region's receipts from
* its imports. The balance is regulated by the price that intermediate and final
* users are paying for the products imported from the rest of the world region.
EQPROW..
    sum((reg,prd), EXPORT_ROW_V(reg,prd) * P_V(reg,prd) ) +
    sum((reg,inm), TIM_EXPORT_ROW(reg,inm) ) * PROW_V +
    sum((reg,tse), TIM_EXPORT_ROW(reg,tse) ) * PROW_V
    =E=
    sum((prd,regg), IMPORT_ROW_V(prd,regg) * PROW_V ) +
    sum((prd,regg), SV_ROW_V(prd,regg) ) * PROW_V +
    sum((inm,regg,ind), TIM_INTER_USE_ROW(inm,regg,ind) ) * PROW_V +
    sum((tse,regg,ind), TIM_INTER_USE_ROW(tse,regg,ind) ) * PROW_V +
    sum((inm,regg,fd), TIM_FINAL_USE_ROW(inm,regg,fd) ) * PROW_V +
    sum((tse,regg,fd), TIM_FINAL_USE_ROW(tse,regg,fd) ) * PROW_V -
    sum((reg,fd), TRANSFERS_ROW_V(reg,fd) * PROW_V ) ;

* EQUATION 4.10: Paasche price index for households. The price index is
* calculated separately for each region (regg).
EQPAASCHE(regg)..
    PAASCHE_V(regg)
    =E=
    sum(prd, CONS_H_T_V(prd,regg) * PC_H_V(prd,regg) *
    ( 1 + tc_h(prd,regg) ) ) /
    sum(prd, CONS_H_T_V(prd,regg) * 1 *
    ( 1 + tc_h_0(prd,regg) ) ) ;

* EQUATION 4.11: Laspeyres price index for households. The price index is
* calculated separately for each region (regg).
EQLASPEYRES(regg)..
    LASPEYRES_V(regg)
    =E=
    sum((reg,prd), CONS_H(reg,prd,regg) * P_V(reg,prd) *
    ( 1 + tc_h(prd,regg) ) ) /
    sum((reg,prd), CONS_H(reg,prd,regg) * 1 *
    ( 1 + tc_h_0(prd,regg) ) ) ;

* EQUATION 4.12: Gross domestic product calculated in current prices. GDP is
* calculated separately for each modeled region (regg).
EQGDPCUR(regg)..
    GDPCUR_V(regg)
    =E=
    sum(ind, Y_V(regg,ind) * PY_V(regg,ind) ) -
    ( sum((prd,ind), INTER_USE_T_V(prd,regg,ind) * PIU_V(prd,regg,ind) ) +
    sum(ind, Y_V(regg,ind) * PY_V(regg,ind) * sum(reg, txd_inm(reg,regg,ind) ) +
    Y_V(regg,ind) * PY_V(regg,ind) * sum(reg, txd_tse(reg,regg,ind) ) ) )
    +
    sum(prd, CONS_H_T_V(prd,regg) * PC_H_V(prd,regg) * tc_h(prd,regg) ) +
    sum(prd, CONS_G_T_V(prd,regg) * PC_G_V(prd,regg) * tc_g(prd,regg) ) +
    sum(prd, GFCF_T_V(prd,regg) * PC_I_V(prd,regg) * tc_gfcf(prd,regg) ) +
    sum((reg,prd), SV_V(reg,prd,regg) * P_V(reg,prd) * tc_sv(prd,regg) ) +
    sum(prd, SV_ROW_V(prd,regg) * PROW_V * tc_sv(prd,regg) )
    +
    sum((reg,ind), Y_V(reg,ind) * PY_V(reg,ind) * txd_tse(regg,reg,ind) ) +
    sum((tse,reg,fd), TIM_FINAL_USE(regg,tse,reg,fd) * LASPEYRES_V(regg) ) +
    sum(tse, TIM_EXPORT_ROW(regg,tse) * PROW_V ) ;

* EQUATION 4.13: Gross domestic product calculated in constant prices of the
* base year. GDP is calculated separately for each modeled region (regg).
EQGDPCONST(regg)..
    GDPCONST_V(regg)
    =E=
    sum(ind, Y_V(regg,ind) ) -
    ( sum((prd,ind), INTER_USE_T_V(prd,regg,ind) ) +
    sum(ind, Y_V(regg,ind) * sum(reg, txd_inm(reg,regg,ind) ) +
    Y_V(regg,ind) * sum(reg, txd_tse(reg,regg,ind) ) ) )
    +
    sum(prd, CONS_H_T_V(prd,regg) * tc_h_0(prd,regg) ) +
    sum(prd, CONS_G_T_V(prd,regg) * tc_g_0(prd,regg) ) +
    sum(prd, GFCF_T_V(prd,regg) * tc_gfcf_0(prd,regg) ) +
    sum((reg,prd), SV_V(reg,prd,regg) * tc_sv_0(prd,regg) ) +
    sum(prd, SV_ROW_V(prd,regg) * tc_sv_0(prd,regg) )
    +
    sum((reg,ind), Y_V(reg,ind) * txd_tse(regg,reg,ind) ) +
    sum((tse,reg,fd), TIM_FINAL_USE(regg,tse,reg,fd) ) +
    sum(tse, TIM_EXPORT_ROW(regg,tse) ) ;


* EQUATION 4.14: GDP deflator. The deflator is calculated as a single value for
* all modeled regions and is used as a numéraire in the model.
EQGDPDEF..
    GDPDEF_V
    =E=
    sum(regg, GDPCUR_V(regg) ) / sum(regg, GDPCONST_V(regg) ) ;

$label end_equations_definition

* ===== Phase 6: Define levels, bounds and fixed variables, scale equations ====
$if not '%phase%' == 'bounds_and_scales' $goto end_bounds_and_scales

* ==================== Define level and bounds of variables ====================

* Endogenous variables
* Variables in real terms: level is set to the calibrated value of the
* corresponding parameter. If the the calibrated value is equal to zero, the
* variable value is also fixed to zero. The equation setup will lead to zero
* solution for this variable and fixing it at this point helps the solver.
GDPCUR_V.L(regg)   = GDP(regg) ;
GDPCONST_V.L(regg) = GDP(regg) ;
GDPCUR_V.FX(regg)$( GDP(regg) eq 0 )   = 0 ;
GDPCONST_V.FX(regg)$( GDP(regg) eq 0 ) = 0 ;

* Price variables: level of basic prices is set to one, which also corresponds
* to the price level used in calibration. If the the real variable to which the
* price level is linked is fixed to zero, the price is fixed to one. For zero
* level variables any price level will be a solution and fixing it to one helps
* the solver. Additionally, price of the numéraire is fixed.
PY_V.L(regg,ind)       = 1 ;
P_V.L(reg,prd)         = 1 ;
PK_V.L(reg)            = 1 ;
PL_V.L(reg)            = 1 ;
PIU_V.L(prd,regg,ind)  = 1 ;
PC_H_V.L(prd,regg)     = 1 ;
PC_G_V.L(prd,regg)     = 1 ;
PC_I_V.L(prd,regg)     = 1 ;
PROW_V.L               = 1 ;
PAASCHE_V.L(regg)      = 1 ;
LASPEYRES_V.L(regg)    = 1 ;
GDPDEF_V.FX                                                   = 1 ;
PY_V.FX(regg,ind)$(Y_V.L(regg,ind) eq 0)                      = 1 ;
P_V.FX(reg,prd)$(X_V.L(reg,prd) eq 0)                         = 1 ;
PK_V.FX(reg)$(KS(reg) eq 0)                                   = 1 ;
PL_V.FX(reg)$(LS(reg) eq 0)                                   = 1 ;
PIU_V.FX(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) eq 0)   = 1 ;
PC_H_V.FX(prd,regg)$(CONS_H_T_V.L(prd,regg) eq 0)             = 1 ;
PC_G_V.FX(prd,regg)$(CONS_G_T_V.L(prd,regg) eq 0)             = 1 ;
PC_I_V.FX(prd,regg)$(GFCF_T_V.L(prd,regg) eq 0)               = 1 ;
PROW_V.FX$( ( sum((prd,regg), IMPORT_ROW(prd,regg) ) +
            sum((prd,regg), SV_ROW(prd,regg) ) ) eq 0 )       = 1 ;
PAASCHE_V.FX(regg)$(sum(prd, CONS_H_T_V.L(prd,regg) ) eq 0)   = 1 ;
LASPEYRES_V.FX(regg)$(sum(prd, CONS_H_T_V.L(prd,regg) ) eq 0) = 1 ;

* Exogenous variables
* Exogenous variables are fixed to their calibrated value.
KS_V.FX(reg)                  = KS(reg) ;
LS_V.FX(reg)                  = LS(reg) ;

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
EQPK.SCALE(reg)$(KS_V.L(reg) gt 0)
    = KS_V.L(reg) ;

EQPK.SCALE(reg)$(KS_V.L(reg) lt 0)
    = -KS_V.L(reg) ;

* EQUATION 4.4
EQPL.SCALE(reg)$(LS_V.L(reg) gt 0)
    = LS_V.L(reg) ;

EQPL.SCALE(reg)$(LS_V.L(reg) lt 0)
    = -LS_V.L(reg) ;

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
EQPROW.SCALE$(sum((reg,prd), EXPORT_ROW_V.L(reg,prd) ) gt 0   )
    = sum((reg,prd), EXPORT_ROW_V.L(reg,prd) ) ;

EQPROW.SCALE$(sum((reg,prd), EXPORT_ROW_V.L(reg,prd) ) lt 0   )
    = -sum((reg,prd), EXPORT_ROW_V.L(reg,prd) ) ;

* EQUATION 4.10 - SCALING IS NOT REQUIRED

* EQUATION 4.11 - SCALING IS NOT REQUIRED

* EQUATION 4.12
EQGDPCUR.SCALE(regg)$(GDPCUR_V.L(regg) gt 0)
    = GDPCUR_V.L(regg) ;
GDPCUR_V.SCALE(regg)$(GDPCUR_V.L(regg) gt 0)
    = GDPCUR_V.L(regg) ;

EQGDPCUR.SCALE(regg)$(GDPCUR_V.L(regg) lt 0)
    = -GDPCUR_V.L(regg) ;
GDPCUR_V.SCALE(regg)$(GDPCUR_V.L(regg) lt 0)
    = -GDPCUR_V.L(regg) ;

* EQUATION 4.13
EQGDPCONST.SCALE(regg)$(GDPCONST_V.L(regg) gt 0)
    = GDPCONST_V.L(regg) ;
GDPCONST_V.SCALE(regg)$(GDPCONST_V.L(regg) gt 0)
    = GDPCONST_V.L(regg) ;

EQGDPCONST.SCALE(regg)$(GDPCONST_V.L(regg) lt 0)
    = -GDPCONST_V.L(regg) ;
GDPCONST_V.SCALE(regg)$(GDPCONST_V.L(regg) lt 0)
    = -GDPCONST_V.L(regg) ;

* EQUATION 4.14 - SCALING IS NOT REQUIRED

* EXOGENOUS VARIABLES
KS_V.SCALE(reg)$(KS_V.L(reg) gt 0)
    = KS_V.L(reg) ;
KS_V.SCALE(reg)$(KS_V.L(reg) lt 0)
    = -KS_V.L(reg) ;

* EXOGENOUS VARIABLES
LS_V.SCALE(reg)$(LS_V.L(reg) gt 0)
    = LS_V.L(reg) ;
LS_V.SCALE(reg)$(LS_V.L(reg) lt 0)
    = -LS_V.L(reg) ;

$label end_bounds_and_scales

* ======================== Phase 7: Declare sub-models  ========================
$if not '%phase%' == 'submodel_declaration' $goto submodel_declaration

* Include price equations that will enter CGE model
* Two of the equations (EQPY and EQGDPDEF) are not explicitly paired with any
* variables. This happens because GDPDEF has been chosen to be a numéraire and
* therefore is a fixed variable. EQGDPDEF has to be paired with PY_V
* corresponding to the dropped EQPY (see explanation for EQUATION 4.1 for more
* details). GAMS automatically pairs unmatched variables and equations.
Model price_CGE_MCP
/
EQPY
EQP.P_V
EQPK.PK_V
EQPL.PL_V
EQPIU.PIU_V
EQPC_H.PC_H_V
EQPC_G.PC_G_V
EQPC_I.PC_I_V
EQPROW.PROW_V
EQPAASCHE.PAASCHE_V
EQLASPEYRES.LASPEYRES_V
EQGDPCUR.GDPCUR_V
EQGDPCONST.GDPCONST_V
EQGDPDEF
/;

$label submodel_declaration
