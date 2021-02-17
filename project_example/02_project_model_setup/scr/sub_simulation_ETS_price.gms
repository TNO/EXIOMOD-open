
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
    coef_emis_c_sim(reg,*)
    coef_emis_nc_sim(reg,ind)
    CO2(reg,ind,year);
;

$libinclude xlimport CO2   CO2.xlsx    sheet1!a1:k462

Display CO2;

* Initiate carbon tax rate
tax_CO2_shock(regg,ind,year)=0 ;
tax_CO2(regg,ind)=0 ;


coef_emis_c_sim(reg,ind)  = coef_emis_c_year('%scenario%',reg,ind,"CO2_c",'2007') ;
coef_emis_c_sim(reg,fd)  = coef_emis_c_year('%scenario%',reg,fd,"CO2_c",'2007') ;
coef_emis_nc_sim(reg,ind) = coef_emis_c_year('%scenario%',reg,ind,"CO2_nc",'2007');

* ============Define simulation specific variables/ equations===================

Variables
    CO2_V(regg,ind)                CO2 emissions by each industry in Mt
                                   # includes both combustion and non-
                                   # combustion activity)
    TOTCO2_V(regg)                 Total CO2 emissions for all industries and
                                   # households. Includes both combustion and
                                   # non-combustion activity
    CO2REV_V(regg)                 Revenue from carbon tax
;


Equations
    EQCO2(regg,ind)                Demand from withdrawal of water by industries
    EQTOTCO2(regg)                 Demand from withdrawal of water by industries
    EQCO2REV(regg)                 Revenue from tax on water withdrawal
    EQnENER_CO2(regg,ind)          Energy nest within the capital-energy nest
    EQGRINC_G_CO2(regg)            Gross income of government including potential
                                   # carbon tax
    EQPY_CO2                       Price for output including carbon tax
;


* EQUATION 1.11: Gross income of government. Gross income is composed of
* shares of factor revenues attributable to government in each region (regg),
* tax revenues from production, international trade and from sale of products
* (domestically and exported). Tax revenues from household income are not
* included.
* This equation holds for 05_module_demand_CES.gms and
* 05_module_demand_LES-CEShh.gms.
EQGRINC_G_CO2(regg)..
    GRINC_G_V(regg)
    =E=
    sum(reg, CAPREV_V(reg) * k_distr_g(reg,regg) ) +
    sum(reg, LABREV_V(reg) * l_distr_g(reg,regg) ) +
    TSPREV_V(regg) + NTPREV_V(regg) + INMREV_V(regg) + TSEREV_V(regg) + CO2REV_V(regg) ;

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
    ( CO2_V(regg,ind) * tax_CO2(regg,ind) ) ;

* EQUATION 2.5: Demand for aggregated energy nest. The demand function follows
* CES form, where demand for aggregated energy of each industry (regg,ind)
* depends linearly on the demand of the same industry for aggregated KL-E nest
* and with certain elasticity on relative prices of energy, capital and labour.
* This equation holds for 06_module_production_KL-E
EQnENER_CO2(regg,ind)..
    nENER_V(regg,ind)
    =E=
    nKLE_V(regg,ind) * aE(regg,ind) *
    ( PnENER_V(regg,ind) * (1 + tax_CO2(regg,ind)) / PnKLE_V(regg,ind) )**( -elasKLE(regg,ind) ) ;


* EQUATION 2.5a: CO2 emissions emitted by industries. The demand function follows
* Leontief form, where the relation between CO2 emissions and output of the
* industry (regg,ind) in volume is defined by a constant.
*EQCO2(regg,ind)..
*    CO2_V(regg,ind)
*    =E=
*    coef_emis_c(regg,ind,"CO2_c") * sum(energy, INTER_USE_T_V(energy,regg,ind) )
*    + coef_emis_nc(regg,ind,"CO2_nc") * Y_V(regg,ind) ;

* EQUATION 2.5a: CO2 emissions emitted by industries. The demand function follows
* Leontief form, where the relation between CO2 emissions and output of the
* industry (regg,ind) in volume is defined by a constant.
EQCO2(regg,ind)..
    CO2_V(regg,ind)
    =E=
    ( coef_emis_c_sim(regg,ind) * sum(energy, INTER_USE_T_V(energy,regg,ind) )
    + coef_emis_nc_sim(regg,ind) * Y_V(regg,ind) )
    /1000 ;

* EQUATION 2.5b: CO2 emissions emitted by industries and households. The demand
* function follows Leontief form, where the relation between CO2 emissions and
* output of the industry(regg,ind) and household (regg,fd) in volume is defined
* by a constant. Sum over all industries and final demand.
EQTOTCO2(regg)..
    TOTCO2_V(regg)
    =E=
* Energy related industry emissions
      (sum((ind),
            coef_emis_c_sim(regg,ind) * sum(energy, INTER_USE_T_V(energy,regg,ind)) )
* Non energy related industry emissions
      + sum((ind),
            coef_emis_nc_sim(regg,ind) * Y_V(regg,ind) )
* Energy related final demand emissions
      + sum(fd,coef_emis_c_sim(regg,fd) * sum(energy, CONS_H_T_V(energy,regg)) ))
* Convert kt to Mt
      / 1000 ;


* EQUATION 1.8a: Revenue from carbon tax. The revenue in each region (regg) is a
* sum of revenues earned from production activities of each industry subject to
* carbon tax.
EQCO2REV(regg)..
    CO2REV_V(regg)
    =E=
    sum(ind, CO2_V(regg,ind) * tax_CO2(regg,ind) ) ;

* CHeck whether with model demand CES or with model production KL we can also
* immediately add some equations. STILL TO DO! This makes the model more flexible

* Initial levels
CO2_V.L(regg,ind) = (EMIS_model(regg,ind,"CO2_c") + EMIS_model(regg,ind,"CO2_nc") )/1000 ;
TOTCO2_V.L(regg) = sum(ind,(EMIS_model(regg,ind,"CO2_c") + EMIS_model(regg,ind,"CO2_nc") )/1000) ;
CO2REV_V.L(regg)  = 0 ;

*CO2_V.FX(regg,ind)=CO2(regg,ind,'2007');

CO2_V.FX(regg,ind)$(CO2_V.L(regg,ind) eq 0 ) = 0;
TOTCO2_V.FX(regg)$(TOTCO2_V.L(regg) eq 0 ) = 0;

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

* Scaling
* EQUATION 2.5b:
EQTOTCO2.SCALE(regg)$(TOTCO2_V.L(regg) gt 0)
    = TOTCO2_V.L(regg) ;
TOTCO2_V.SCALE(regg)$(TOTCO2_V.L(regg) gt 0)
    = TOTCO2_V.L(regg) ;


EQTOTCO2.SCALE(regg)$(TOTCO2_V.L(regg) lt 0)
    = -TOTCO2_V.L(regg) ;
TOTCO2_V.SCALE(regg)$(TOTCO2_V.L(regg) lt 0)
    = -TOTCO2_V.L(regg) ;


* EQUATION 2.5
EQnENER_CO2.SCALE(regg,ind)$(nENER_V.L(regg,ind) gt 0)
    = nENER_V.L(regg,ind) ;
nENER_V.SCALE(regg,ind)$(nENER_V.L(regg,ind) gt 0)
    = nENER_V.L(regg,ind) ;


EQnENER_CO2.SCALE(regg,ind)$(nENER_V.L(regg,ind) lt 0)
    = -nENER_V.L(regg,ind) ;
nENER_V.SCALE(regg,ind)$(nENER_V.L(regg,ind) lt 0)
    = -nENER_V.L(regg,ind) ;


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
EQGRINC_G_CO2.SCALE(reg)$(GRINC_G_V.L(reg) gt 0)
    = GRINC_G_V.L(reg) ;


EQGRINC_G_CO2.SCALE(reg)$(GRINC_G_V.L(reg) lt 0)
    = -GRINC_G_V.L(reg) ;


* EQUATION 4.1
EQPY_CO2.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;


EQPY_CO2.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;



* ============================== Define carbon tax =============================

* Implementation of carbon price in the world.
* We choose the carbon prices from World Energy Outlook.
* In 2007 was the carbon price on average 14.77 euro. The emissions given in
* 2007 are already an effect of a carbon price of 14.77. Thus, we set the
* 'extra' ETS price in 2007 to 0. However, the price was decreasing until 2016,
* implying a negative price in those years. We have to make sure that emissions
* are not increasing enormously, because the price for emissions are so cheap.

* Maybe it is an idea, when prices are negative, we set the price to zero?


* baseyear_sim is defined in simulation_framework_BL.gms
* Possible scenarios are 'CPS', 'NPS' and '250S'.
*tax_CO2_shock(reg,ind,year)  = (ETS_level('CPS',year,reg,ind)-ETS_level('CPS','2007',reg,ind))/1000 ;
*tax_CO2_shock(reg,ind,year)$(tax_CO2_shock(reg,ind,year)<0)  = 0  ;


tax_CO2_shock(reg,ind,year)=0.00;
tax_CO2_shock(reg,ind,'2007')=0;
* Recalculate first guess of revenue from carbon tax
CO2REV_V.L(regg) = sum(ind, CO2_V.L(regg,ind) * tax_CO2_shock(regg,ind,"%baseyear_sim%") ) ;


Display tax_CO2_shock ;
