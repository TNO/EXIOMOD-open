
* File:   project_COMPLEX\02_project_model_setup\scr\sub_simulation_ETS_price.gms
* Author: Hettie Boonman
* Date:   22 March 2016


* ========Declaration and definition of simulation specific parameters==========

Alias
(year, yearr)
;


* ============Define simulation specific variables/ equations===================

Variables
    CO2_NC_V(regg,ind)             CO2 emissions by each industry in Mt
                                   # includes both combustion and non-
                                   # combustion activity)
    CO2_C_V(prd,regg,ind)          CO2 emissions by each industry in Mt
                                   # includes both combustion and non-
                                   # combustion activity)
    CO2_C_FD_V(prd,regg)           CO2 emissions by each industry in Mt
                                   # includes both combustion and non-
                                   # combustion activity)
    CO2REV_V(regg)                 Revenue from carbon tax


* extra variable(s) for the price of CO2
    CO2S_V(regg)                   This is an exogenous variable: CO2 carbon
                                   # budget
    PCO2_V(regg)                   Price for CO2

;


Equations
    EQCO2_NC(regg,ind)             Demand of CO2 emissions (non-combustion)
    EQCO2_C(prd,regg,ind)          Demand of CO2 emissions (combustion)
    EQCO2_C_FD(prd,regg)           Demand of CO2 emissions FD (combustion)
    EQCO2REV(regg)                 Revenue from tax on water withdrawal
    EQGRINC_G_CO2(regg)            Gross income of government including potential
                                   # carbon tax
    EQGRINC_H_CO2(regg)            Gross income of households including potential
                                   # carbon tax
    EQPY_CO2                       Price for output including carbon tax
    EQENER_CO2(ener,regg,ind)      Demand for energy types
    EQPnENER_CO2(regg,ind)         balance between price per energy type and
                                   # aggregate energy price
    EQCONS_H_T_CO2(prd,regg)       demand of households for products on aggregated
                                   # product level
    EQCONS_G_T_CO2(prd,regg)       demand of government for products on aggregated
                                   # product level
    EQSCLFD_H_CO2(regg)            budget constraint of households
    EQSCLFD_G_CO2(regg)            budget constraint of government


* Extra equation for the price of CO2
    EQPCO2(regg)                   Balance on CO2 market
;

Parameters
    ener_factor(regg,ind)
;

ener_factor(regg,ind) = 1 ;

$ontext
* EQUATION 1.10: Gross income of households from factors of production. Gross
* income is composed of shares of factor revenues attributable to households
* in each region (regg).
EQGRINC_H_CO2(regg)..
    GRINC_H_V(regg)
    =E=
    sum(reg, CAPREV_V(reg) * k_distr_h(reg,regg) ) +
    sum(reg, LABREV_V(reg) * l_distr_h(reg,regg) ) + CO2REV_V(regg) ;
$offtext

* EQUATION 2.5a: CO2 emissions emitted by industries. The demand function follows
* Leontief form, where the relation between CO2 emissions and output of the
* industry (regg,ind) in volume is defined by a constant.
EQCO2_C(ener_CO2,regg,ind)$(Emissions_c_model(ener_CO2,regg,ind,"CO2_c","kg CO2-eq") )..
    CO2_C_V(ener_CO2,regg,ind)
    =E=
    ENER_V(ener_CO2,regg,ind) * coef_emis_c(ener_CO2,regg,ind,'CO2_c')
    /1000000 ;

* EQUATION 2.5a: CO2 emissions emitted by industries. The demand function follows
* Leontief form, where the relation between CO2 emissions and output of the
* industry (regg,ind) in volume is defined by a constant.
EQCO2_C_FD(ener_CO2,regg)$
    (Emissions_c_model(ener_CO2,regg,"FCH","CO2_c","kg CO2-eq")
     + Emissions_c_model(ener_CO2,regg,"FCG","CO2_c","kg CO2-eq") )..
    CO2_C_FD_V(ener_CO2,regg)
    =E=
    ( CONS_H_T_V(ener_CO2,regg) * coef_emis_c(ener_CO2,regg,'FCH','CO2_c')
    + CONS_G_T_V(ener_CO2,regg) * coef_emis_c(ener_CO2,regg,'FCG','CO2_c') )
    /1000000 ;


* EQUATION 2.5b: CO2 emissions emitted by industries. The demand function follows
* Leontief form, where the relation between CO2 emissions and output of the
* industry (regg,ind) in volume is defined by a constant.
EQCO2_NC(regg,ind)$(Emissions_model(regg,ind,"CO2_nc","kg CO2-eq") )..
    CO2_NC_V(regg,ind)
    =E=
     coef_emis_nc(regg,ind,'CO2_nc') * Y_V(regg,ind)
    /1000000 ;


* EQUATION 1.8a: Revenue from carbon tax. The revenue in each region (regg) is a
* sum of revenues earned from production activities of each industry subject to
* carbon tax.
EQCO2REV(regg)..
    CO2REV_V(regg)
    =E=
    sum(ind, CO2_NC_V(regg,ind) * PCO2_V(regg) )
*;
    +
    sum((ener_CO2,ind), CO2_C_V(ener_CO2,regg,ind) * PCO2_V(regg) )
* TAKE THIS OUT WHEN NOT FD:
    + sum((ener_CO2), CO2_C_FD_V(ener_CO2,regg) * PCO2_V(regg) ) ;
;

* EQUATION 10.3a: Balance on the production factors market. Price of each
* production factor (reg,kl) is defined in such a way that total demand for the
* corresponding production factor is equal to supply of the factor less, if
* modeled unemployed. Supply of production factors is one of the exogenous
* variables in the model.
EQPCO2(regg)..
    CO2S_V(regg)
    =G=
    sum(ind,CO2_NC_V(regg,ind) )
*;
    +
    sum((prd,ind), CO2_C_V(prd,regg,ind) )
*TAKE THIS OUT WHEN NOT FD:
    + sum(prd, CO2_C_FD_V(prd,regg) ) ;
;

* ==============================================================================
* New equations

* EQUATION 2.7: Demand for types of energy. The demand function follows CES
* form, where demand of each industry (regg,ind) for each type of energy (ener)
* depends linearly on the demand of the same industry for aggregated energy nest
* and with certain elasticity on relative prices of energy types. The demand for
* energy types is also augmented with exogenous level of energy productivity.
EQENER_CO2(ener,regg,ind)..
    ENER_V(ener,regg,ind)
    =E=
    ener_factor(regg,ind) *
    ( nENER_V(regg,ind) / eprod(ener,regg,ind) ) * alphaE(ener,regg,ind) *
    ( PIU_V(ener,regg,ind) * ( 1 + tc_ind(ener,regg,ind) +
*    PCO2_V(regg) * CO2_C_V(ener,regg,ind) /
*    ( (1 + tc_ind_0(ener,regg,ind) ) * ENER_V(ener,regg,ind) )
    PCO2_V(regg) * coef_emis_c(ener,regg,ind,'CO2_c') /
    1000000
*    ( 1000000 * (1 + tc_ind_0(ener,regg,ind) ) )
    ) /
    ( eprod(ener,regg,ind) * PnENER_V(regg,ind) ) )**( -elasE(regg,ind) )
;


* EQUATION 2.11: Balance between price per energy type and aggregate energy
* price. The aggregate price is different in each industry (ind) in each region
* (regg) and is a weighted average of the price per type of energy, where
* weights are defined as demand by the industry for the corresponding types of
* energy.
EQPnENER_CO2(regg,ind)..
    PnENER_V(regg,ind) * nENER_V(regg,ind)
    =E=
    sum(ener, PIU_V(ener,regg,ind) * ( 1 + tc_ind(ener,regg,ind) +
*    PCO2_V(regg) * CO2_C_V(ener,regg,ind) /
*    ( (1 + tc_ind_0(ener,regg,ind) ) * ENER_V(ener,regg,ind) )
    PCO2_V(regg) * coef_emis_c(ener,regg,ind,'CO2_c') /
    1000000
*    ( 1000000 * (1 + tc_ind_0(ener,regg,ind) ) )
    ) *
    ENER_V(ener,regg,ind) ) ;


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
EQPY_CO2(regg,ind)$( Y(regg,ind) ne smax((reggg,indd), Y(reggg,indd) ) and
    Y(regg,ind) )..
    Y_V(regg,ind) * PY_V(regg,ind) *
    ( 1 - sum(reg, txd_ind(reg,regg,ind) ) -
    sum(reg, txd_inm(reg,regg,ind) ) - sum(reg, txd_tse(reg,regg,ind) ) )
    =E=
    sum(prd, INTER_USE_T_V(prd,regg,ind) * PIU_V(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum(ener_CO2, CO2_C_V(ener_CO2,regg,ind) ) * PCO2_V(regg) +
    CO2_NC_V(regg,ind) * PCO2_V(regg) +
    sum(reg, K_V(reg,regg,ind) * PK_V(reg) ) +
    sum(reg, L_V(reg,regg,ind) * PL_V(reg) ) +
    sum(inm, TIM_INTER_USE_ROW(inm,regg,ind) * PROW_V ) +
    sum(tse, TIM_INTER_USE_ROW(tse,regg,ind) * PROW_V )
;
*    + NON_COMBUSTION EMISSIONS;

* EQUATION 1.11: Gross income of government. Gross income is composed of
* shares of factor revenues attributable to government in each region (regg),
* tax revenues from production, international trade and from sale of products
* (domestically and exported). Tax revenues from household income are not
* included.
EQGRINC_G_CO2(regg)..
    GRINC_G_V(regg)
    =E=
    sum(reg, CAPREV_V(reg) * k_distr_g(reg,regg) ) +
    sum(reg, LABREV_V(reg) * l_distr_g(reg,regg) ) +
    TSPREV_V(regg) + NTPREV_V(regg) + INMREV_V(regg) + TSEREV_V(regg) +
    CO2REV_V(regg) ;

* ==============================================================================
* Household equations

* EQUATION 1.1: Household demand for aggregated products. The demand function
* follows CES form, where demand by households in each region (regg) for each
* aggregated product (prd) depends, with certain elasticity, on relative prices
* of different aggregated products. The final demand function is derived from
* utility optimization, but there is no market for utility and corresponding
* price doesn't exist, contrary to CES demand functions derived from
* optimization of a production function. Scaling parameter (SCLDF_H_V) is
* introduced in order to ensure budget constraint (see EQUATION 1.16).
EQCONS_H_T_CO2(prd,regg)..
    CONS_H_T_V(prd,regg)
    =E=
    SCLFD_H_V(regg) * theta_h(prd,regg) *
     ( PC_H_V(prd,regg) * ( 1 + tc_h(prd,regg) +
    PCO2_V(regg) * coef_emis_c(prd,regg,'FCH','CO2_c') /
    1000000
    ) )**( -elasFU_H(regg) ) ;


* EQUATION 1.16: Budget constraint of households. The equation ensures that the
* total budget available for household consumption is spent on purchase of
* products. The equation defines scaling parameter of households, see also
* explanation for EQUATION 1.1.
EQSCLFD_H_CO2(regg)..
    CBUD_H_V(regg)
    =E=
    sum(prd, CONS_H_T_V(prd,regg) * PC_H_V(prd,regg) *
    ( 1 + tc_h(prd,regg) +
    PCO2_V(regg) * coef_emis_c(prd,regg,'FCH','CO2_c') /
    1000000
    ) ) ;

* EQUATION 1.2: Government demand for aggregated products. The demand function
* follows CES form, where demand by government in each region (regg) for each
* aggregated product (prd) depends, with certain elasticity, on relative prices
* of different aggregated products. Scaling parameter (SCLDF_G_V) is
* introduced in order to ensure budget constraint (see EQUATION 1.17).
EQCONS_G_T_CO2(prd,regg)..
    CONS_G_T_V(prd,regg)
    =E=
    SCLFD_G_V(regg) * theta_g(prd,regg) *
    ( PC_G_V(prd,regg) * ( 1 + tc_g(prd,regg) +
    PCO2_V(regg) * coef_emis_c(prd,regg,'FCG','CO2_c') /
    1000000
    ) )**( -elasFU_G(regg) ) ;


* EQUATION 1.17: Budget constraint of government. The equation ensures that the
* total budget available for government consumption is spent on purchase of
* products. The equation defines scaling parameter of government.
EQSCLFD_G_CO2(regg)..
    CBUD_G_V(regg)
    =E=
    sum(prd, CONS_G_T_V(prd,regg) * PC_G_V(prd,regg) *
    ( 1 + tc_g(prd,regg) +
    PCO2_V(regg) * coef_emis_c(prd,regg,'FCG','CO2_c') /
    1000000
    ) ) ;

* ============================== Initial levels ================================

CO2_NC_V.L(regg,ind)
    = (Emissions_model(regg,ind,"CO2_nc","kg CO2-eq") )
      /1000000 ;

CO2_C_V.L(ener_CO2,regg,ind)
    = Emissions_c_model(ener_CO2,regg,ind,"CO2_c","kg CO2-eq")
      /1000000 ;

CO2_C_FD_V.L(ener_CO2,regg)
    = ( Emissions_c_model(ener_CO2,regg,"FCH","CO2_c","kg CO2-eq")
      + Emissions_c_model(ener_CO2,regg,"FCG","CO2_c","kg CO2-eq") )
        /1000000 ;

PCO2_V.L(regg)          = 0 ;
CO2REV_V.L(regg)        =
                            sum(ind, CO2_NC_V.L(regg,ind) * PCO2_V.L(regg) )
*;
                            +
                            sum((ener_CO2,ind), CO2_C_V.L(ener_CO2,regg,ind)
                            * PCO2_V.L(regg) )
* TAKE THIS OUT WHEN NOT FD:
                            + sum((ener_CO2,ind), CO2_C_FD_V.L(ener_CO2,regg)
                            * PCO2_V.L(regg) )
;


* ============================== Fix values ====================================

CO2_C_V.FX(prd,regg,ind)$(CO2_C_V.L(prd,regg,ind) eq 0 )            = 0 ;
CO2_NC_V.FX(regg,ind)$(CO2_NC_V.L(regg,ind) eq 0 )                  = 0 ;
CO2_C_FD_V.FX(prd,regg)$(CO2_C_FD_V.L(prd,regg) eq 0 )              = 0 ;

CO2S_V.FX(regg)
    = sum(ind,
    (
        sum(ener_CO2, Emissions_c_model(ener_CO2,regg,ind,"CO2_c","kg CO2-eq") )
        + Emissions_model(regg,ind,"CO2_nc","kg CO2-eq")
    )
    ) /1000000
* TAKE THIS OUT WHEN NOT FD:
    + sum((ener_CO2,fd), Emissions_c_model(ener_CO2,regg,fd,"CO2_c","kg CO2-eq") )
     / 1000000 ;
;

* Still: we do not want negative prices
PCO2_V.LO(regg) = 0;

* ============================== Scaling =======================================

* Scaling
* EQUATION 2.5a:
EQCO2_C.SCALE(prd,regg,ind)$(CO2_C_V.L(prd,regg,ind) gt 0)
    = CO2_C_V.L(prd,regg,ind) ;
CO2_C_V.SCALE(prd,regg,ind)$(CO2_C_V.L(prd,regg,ind) gt 0)
    = CO2_C_V.L(prd,regg,ind) ;


EQCO2_C.SCALE(prd,regg,ind)$(CO2_C_V.L(prd,regg,ind) lt 0)
    = -CO2_C_V.L(prd,regg,ind) ;
CO2_C_V.SCALE(prd,regg,ind)$(CO2_C_V.L(prd,regg,ind) lt 0)
    = -CO2_C_V.L(prd,regg,ind) ;


* EQUATION 2.5b:
EQCO2_NC.SCALE(regg,ind)$(CO2_NC_V.L(regg,ind) gt 0)
    = CO2_NC_V.L(regg,ind) ;
CO2_NC_V.SCALE(regg,ind)$(CO2_NC_V.L(regg,ind) gt 0)
    = CO2_NC_V.L(regg,ind) ;


EQCO2_NC.SCALE(regg,ind)$(CO2_NC_V.L(regg,ind) lt 0)
    = -CO2_NC_V.L(regg,ind) ;
CO2_NC_V.SCALE(regg,ind)$(CO2_NC_V.L(regg,ind) lt 0)
    = -CO2_NC_V.L(regg,ind) ;

* EQUATION 2.5c:
EQCO2_C_FD.SCALE(prd,regg)$(CO2_C_FD_V.L(prd,regg) gt 0)
    = CO2_C_FD_V.L(prd,regg) ;
CO2_C_FD_V.SCALE(prd,regg)$(CO2_C_FD_V.L(prd,regg) gt 0)
    = CO2_C_FD_V.L(prd,regg) ;


EQCO2_C_FD.SCALE(prd,regg)$(CO2_C_FD_V.L(prd,regg) lt 0)
    = -CO2_C_FD_V.L(prd,regg) ;
CO2_C_FD_V.SCALE(prd,regg)$(CO2_C_FD_V.L(prd,regg) lt 0)
    = -CO2_C_FD_V.L(prd,regg) ;

* EQUATION 1.8:
EQCO2REV.SCALE(regg)$(CO2REV_V.L(regg) gt 0)
    = CO2REV_V.L(regg) ;
CO2REV_V.SCALE(regg)$(CO2REV_V.L(regg) gt 0)
    = CO2REV_V.L(regg) ;


EQCO2REV.SCALE(regg)$(CO2REV_V.L(regg) lt 0)
    = -CO2REV_V.L(regg) ;
CO2REV_V.SCALE(regg)$(CO2REV_V.L(regg) lt 0)
    = -CO2REV_V.L(regg) ;


* EQUATION 1.10
EQGRINC_H_CO2.SCALE(reg)$(GRINC_H_V.L(reg) gt 0)
    = GRINC_H_V.L(reg) ;


EQGRINC_H_CO2.SCALE(reg)$(GRINC_H_V.L(reg) lt 0)
    = -GRINC_H_V.L(reg) ;


* EQUATION 1.11
EQGRINC_G_CO2.SCALE(reg)$(GRINC_G_V.L(reg) gt 0)
    = GRINC_G_V.L(reg) ;


EQGRINC_G_CO2.SCALE(reg)$(GRINC_G_V.L(reg) lt 0)
    = -GRINC_G_V.L(reg) ;


* EQUATION 4.1
EQPY_CO2.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;


EQPY_CO2.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;


* EQUATION 2.7
EQENER_CO2.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) gt 0)
    = ENER_V.L(ener,regg,ind) ;

EQENER_CO2.SCALE(ener,regg,ind)$(ENER_V.L(ener,regg,ind) lt 0)
    = -ENER_V.L(ener,regg,ind) ;


* EQUATION 2.11
EQPnENER_CO2.SCALE(reg,ind)$(nENER_V.L(reg,ind) gt 0)
    = nENER_V.L(reg,ind) ;

EQPnENER_CO2.SCALE(reg,ind)$(nENER_V.L(reg,ind) lt 0)
    = -nENER_V.L(reg,ind) ;


* EQUATION 10.3a:
EQPCO2.SCALE(reg)$(CO2S_V.L(reg) gt 0)
    = CO2S_V.L(reg) ;
CO2S_V.SCALE(reg)$(CO2S_V.L(reg) gt 0)
    = CO2S_V.L(reg) ;


EQPCO2.SCALE(reg)$(CO2S_V.L(reg) lt 0)
    = -CO2S_V.L(reg) ;
CO2S_V.SCALE(reg)$(CO2S_V.L(reg) lt 0)
    = -CO2S_V.L(reg) ;


* EQUATION 1.16
EQSCLFD_H_CO2.SCALE(regg)$(SCLFD_H_V.L(regg) gt 0)
    = SCLFD_H_V.L(regg) ;

EQSCLFD_H_CO2.SCALE(regg)$(SCLFD_H_V.L(regg) lt 0)
    = -SCLFD_H_V.L(regg) ;


* EQUATION 1.17
EQSCLFD_G_CO2.SCALE(regg)$(SCLFD_G_V.L(regg) gt 0)
    = SCLFD_G_V.L(regg) ;

EQSCLFD_G_CO2.SCALE(regg)$(SCLFD_G_V.L(regg) lt 0)
    = -SCLFD_G_V.L(regg) ;


* EQUATION 1.1
EQCONS_H_T_CO2.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) gt 0)
    = CONS_H_T_V.L(prd,regg) ;

EQCONS_H_T_CO2.SCALE(prd,regg)$(CONS_H_T_V.L(prd,regg) lt 0)
    = -CONS_H_T_V.L(prd,regg) ;


* EQUATION 1.2
EQCONS_G_T_CO2.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) gt 0)
    = CONS_G_T_V.L(prd,regg) ;

EQCONS_G_T_CO2.SCALE(prd,regg)$(CONS_G_T_V.L(prd,regg) lt 0)
    = -CONS_G_T_V.L(prd,regg) ;



* ================= Define models with new variables/equations =================



