
* File:   project_COMPLEX\02_project_model_setup\scr\sub_simulation_ETS_price.gms
* Author: Hettie Boonman
* Date:   22 March 2016


* ========Declaration and definition of simulation specific parameters==========

Alias
(year, yearr)
;

* Additional parameters
Parameters
    tax_CO2(regg,ind)                 Initial carbon tax rate in euro per kt
    tax_CO2_shock(regg,ind,year)      Additional carbon tax rate in euro per kt
;

* Initiate values

* Tax shocks
tax_CO2_shock(regg,ind,year)=0 ;
tax_CO2(regg,ind)=0 ;

* ============Define simulation specific variables/ equations===================

Variables
    CO2_V(regg,ind)                CO2 emissions by each industry in Mt
                                   # includes both combustion and non-
                                   # combustion activity)
    CO2REV_V(regg)                 Revenue from carbon tax


* extra variable(s) for the price of CO2
    CO2S_V(regg)                   This is an exogenous variable: CO2 carbon
                                   # budget
    PCO2_V(regg)                   Price for CO2
;


Equations
    EQCO2(regg,ind)                Demand from withdrawal of water by industries
    EQCO2REV(regg)                 Revenue from tax on water withdrawal
*    EQGRINC_G_CO2(regg)            Gross income of government including potential
*                                   # carbon tax
    EQGRINC_H_CO2(regg)            Gross income of households including potential
                                   # carbon tax
    EQPY_CO2                       Price for output including carbon tax


* Extra equation for the price of CO2
    EQPCO2(regg)                   Balance on CO2 market
;


* EQUATION 1.11: Gross income of government. Gross income is composed of
* shares of factor revenues attributable to government in each region (regg),
* tax revenues from production, international trade and from sale of products
* (domestically and exported). Tax revenues from household income are not
* included.
* This equation holds for 05_module_demand_CES.gms and
* 05_module_demand_LES-CEShh.gms.
*EQGRINC_G_CO2(regg)..
*    GRINC_G_V(regg)
*    =E=
*    sum(reg, CAPREV_V(reg) * k_distr_g(reg,regg) ) +
*    sum(reg, LABREV_V(reg) * l_distr_g(reg,regg) ) +
*    TSPREV_V(regg) + NTPREV_V(regg) + INMREV_V(regg) + TSEREV_V(regg)
*    + CO2REV_V(regg)
*;

* EQUATION 1.10: Gross income of households from factors of production. Gross
* income is composed of shares of factor revenues attributable to households
* in each region (regg).
EQGRINC_H_CO2(regg)..
    GRINC_H_V(regg)
    =E=
    sum(reg, CAPREV_V(reg) * k_distr_h(reg,regg) ) +
    sum(reg, LABREV_V(reg) * l_distr_h(reg,regg) ) + CO2REV_V(regg) ;


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
* This equation holds for 08_module_closure
EQPY_CO2(regg,ind)$( Y(regg,ind) ne smax((reggg,indd), Y(reggg,indd) ) and
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
    sum(tse, TIM_INTER_USE_ROW(tse,regg,ind) * PROW_V ) +
    ( CO2_V(regg,ind) * PCO2_V(regg) ) ;


* EQUATION 2.5a: CO2 emissions emitted by industries. The demand function follows
* Leontief form, where the relation between CO2 emissions and output of the
* industry (regg,ind) in volume is defined by a constant.
EQCO2(regg,ind)$(EMIS_model(regg,ind,'CO2_nc') or EMIS_model(regg,ind,'CO2_c') )..
    CO2_V(regg,ind)
    =E=
    ( coef_emis_c(regg,ind,'CO2_c') * sum(energy, INTER_USE_T_V(energy,regg,ind) )
    + coef_emis_nc(regg,ind,'CO2_nc') * Y_V(regg,ind) )
    /1000 ;


* EQUATION 1.8a: Revenue from carbon tax. The revenue in each region (regg) is a
* sum of revenues earned from production activities of each industry subject to
* carbon tax.
EQCO2REV(regg)..
    CO2REV_V(regg)
    =E=
    sum(ind, CO2_V(regg,ind) * PCO2_V(regg) ) ;


* EQUATION 10.3a: Balance on the production factors market. Price of each
* production factor (reg,kl) is defined in such a way that total demand for the
* corresponding production factor is equal to supply of the factor less, if
* modeled unemployed. Supply of production factors is one of the exogenous
* variables in the model.
EQPCO2(regg)..
    CO2S_V(regg)
    =G=
    sum(ind,CO2_V(regg,ind) ) ;


* Initial levels
*CO2_V.L(regg,ind)
*         = ( coef_emis_c(regg,ind,'CO2_c') * sum(energy, INTER_USE_T_V.L(energy,regg,ind) )
*         + coef_emis_nc(regg,ind,'CO2_nc') * Y_V.L(regg,ind) )
*         / 1000  ;
CO2_V.L(regg,ind)
    = (EMIS_model(regg,ind,"CO2_c") + EMIS_model(regg,ind,"CO2_nc") )
      /1000 ;
*TOTCO2_V.L(regg) = sum(ind,(EMIS_model(regg,ind,"CO2_c") + EMIS_model(regg,ind,"CO2_nc") )/1000) ;
PCO2_V.L(regg)          = 0 ;
CO2REV_V.L(regg)        = sum(ind, CO2_V.L(regg,ind) * PCO2_V.L(regg) ) ;



* Fix values

CO2_V.FX(regg,ind)$(CO2_V.L(regg,ind) eq 0 ) = 0;
*CO2S_V.FX(regg)
*         = sum(ind,
*         ( coef_emis_c(regg,ind,'CO2_c') * sum(energy, INTER_USE_T_V.L(energy,regg,ind) )
*         + coef_emis_nc(regg,ind,'CO2_nc') * Y_V.L(regg,ind) )
*         / 1000 );
CO2S_V.FX(regg)
    = sum(ind,
      (EMIS_model(regg,ind,"CO2_c") + EMIS_model(regg,ind,"CO2_nc") )
      /1000 ) ;


PCO2_V.LO(regg) = 0;


* Scaling
* EQUATION 2.5a:
EQCO2.SCALE(regg,ind)$(CO2_V.L(regg,ind) gt 0)
    = CO2_V.L(regg,ind) ;
CO2_V.SCALE(regg,ind)$(CO2_V.L(regg,ind) gt 0)
    = CO2_V.L(regg,ind) ;


EQCO2.SCALE(regg,ind)$(CO2_V.L(regg,ind) lt 0)
    = -CO2_V.L(regg,ind) ;
CO2_V.SCALE(regg,ind)$(CO2_V.L(regg,ind) lt 0)
    = -CO2_V.L(regg,ind) ;


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


* EQUATION 4.1
EQPY_CO2.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;


EQPY_CO2.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;


* EQUATION 10.3a:
EQPCO2.SCALE(reg)$(CO2S_V.L(reg) gt 0)
    = CO2S_V.L(reg) ;
CO2S_V.SCALE(reg)$(CO2S_V.L(reg) gt 0)
    = CO2S_V.L(reg) ;


EQPCO2.SCALE(reg)$(CO2S_V.L(reg) lt 0)
    = -CO2S_V.L(reg) ;
CO2S_V.SCALE(reg)$(CO2S_V.L(reg) lt 0)
    = -CO2S_V.L(reg) ;


* ================= Define models with new variables/equations =================



