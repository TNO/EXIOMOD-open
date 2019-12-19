* File:   project_polfree/simulation/multipliers.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014

$ontext startdoc
This file specifies the simulation setup for calculating multipliers based
on previous simulation results.

A set `multiplier_type` with different types of multipliers, on output and
value added, is defined as

Element in the set         | Explanation
-------------------------- | -------------------------------------
output_intrareg            | Intra-regional output multipliers
output_interreg            | Inter-regional output multipliers
output_global              | Global output multipliers
value_added_global         | Global value added multipliers
value_added_global_type1   | Global value added multipliers Type I
RMC_global                 | Global raw material consumption multipliers
biomass_global             | Global material use of biomass multipliers
wood_global                | Global material use of wood multipliers
metal_global               | Global material use of metal multipliers
minerals_global            | Global material use of minerals multipliers
fuels_global               | Global material use of fuels multipliers

The multipliers that are calculated are stored in
`multipliers(reg,prd,multiplier_type)`.

In the simulation setup section, the country/countries, and product(s) for which
to calculate the multipliers can be defined as shown in the examples in the
comments. If a multiplier can not be calculated, because the solver runs into an
error, then the resulting multiplier will have the value NA.

In the final section, the multipliers are used to calculate consumption based
indicators.
$offtext

* === Check whether model_type is defined. =====================================
* Add one of the two statements below to main.gms to define the model_type
*   $if not set model_type  $setglobal  model_type  'IO_product_technology'
*   $if not set model_type  $setglobal  model_type  'IO_industry_technology'

*$if not set model_type $abort "global model_type not defined in project/scr/simulation/multipliers.gms on line %system.line%."
option decimals=3 ;

* =================================== Sets =====================================

Set
    reg_sim(reg)                list of regions used in loop of simulation setup
    prd_sim(prd)                list of products used in loop of simulation setup
    t_sim(year)                 list of years used in loop of simulation setup

    multiplier_type             Type of the multipliers to be calculated
/
    output_intrareg             'Intra-regional output multipliers'
    output_interreg             'Inter-regional output multipliers'
    output_global               'Global output multipliers'
*    value_added_global          'Global value added multipliers'
*    value_added_global_type1    'Global value added multipliers Type I'
    RMC_global                  'Global material use multipliers'
    biomass_global              'Global material use of biomass multipliers'
    wood_global                 'Global material use of wood multipliers'
    metal_global                'Global material use of metal multipliers'
    minerals_global             'Global material use of minerals multipliers'
    fuels_global                'Global material use of fuels multipliers'
    water_global
    WCG_agri
    WCB_agri
    WCB_manu
    WCB_elec
    WCB_dom
    WWB_manu
    WWB_elec
    WWB_dom
    'Arable land'
    'Used forest land and wood fuel'
    land_global



    CO2_c
    CO2_nc
    CH4_c
    CH4_nc
    N2O_c
    N2O_nc
    SOX_c
    SOX_nc
    NOX_c
    NOX_nc

/
;


* Change the set of countries and products that we want to calculate multipliers
* for. We can specify to calculate the multipliers for all regions by putting all
* elements in the reg_sim set equal to yes.
* Example to calculate for all regions:  reg_sim(reg) = yes
* Example to calculate for one country:  reg_sim("NL") = yes
* Example to calculate for all products: prd_sim(prd) = yes
* Example to calculate for one product:  prd_sim("t4") = yes
t_sim("2011") = yes ;
*t_sim("2012") = yes ;
t_sim("2025") = yes ;
t_sim("2030") = yes ;
*t_sim("2050") = yes ;
*reg_sim("NLD") = yes ;
reg_sim(reg) =yes;
prd_sim(prd) = yes ;


* ======== Declaration and definition of simulation specific parameters ========
Parameters
    multipliers(reg,prd,multiplier_type)
                                # all multipliers in one parameter
    multipliers_disaggregate_c(reg,prd,regg,ind)
    multipliers_disaggregate_nc(reg,prd,regg,ind)

*    v(reg,va,regg,ind)          value added coefficients
    d(reg,ind,deu)              domestic extraction use coefficients
    e(reg,*,emis)               emissions coefficients
    w(reg,*,water)              water coefficients
    lnd(reg,*,res)               land coefficients

    P(regg,prd)                 product price
    PIU(prd,regg,ind)           price of intermediate use
    PIMP_T(prd,regg)            price of aggregate imports
    PIMP_MOD(prd,regg)          price of imports from modeled regions

    Materials_model_no_unit(regg,ind,deu)
    Emissions_model_no_unit(regg,*,emis)
    Water_model_no_unit(regg,*,water)
    Land_model_no_unit(regg,ind,res)

* parameters by year
    multipliers_year(reg,prd,multiplier_type,year)
                                # all multipliers in one parameter by year
    Y_year(reg,ind,year)        output by year
    DEU_year(reg,ind,deu,year)  material use by year
    water_year(reg,ind,water,year)  material use by year
    land_year(reg,ind,res,year)  material use by year
    FINAL_USE_year(reg,prd,reg,year) final use by year

    NewY(reg,prd,regg,ind,multiplier_type,year)
;

* ======================== Use modeling results as input =======================

* Leontief co-production coefficients according to industry technology
* assumption.

* Start loop over years
Loop(t_sim$sum((regg,prd), P_time(regg,prd,t_sim) ),


* Variables in the model
Y(regg,ind)                 = Y_time(regg,ind,t_sim) ;
X(regg,prd)                 = X_time(regg,prd,t_sim) ;
CONS_H_D(prd,regg)          = CONS_H_D_time(prd,regg,t_sim)  ;
INTER_USE_T(prd,reg,ind)    = INTER_USE_T_time(prd,reg,ind,t_sim) ;
INTER_USE_D(prd,reg,ind)    = INTER_USE_D_time(prd,reg,ind,t_sim) ;
INTER_USE_M(prd,reg,ind)    = INTER_USE_M_time(prd,reg,ind,t_sim) ;
IMPORT_T(prd,regg)          = IMPORT_T_time(prd,regg,t_sim) ;
IMPORT_MOD(prd,regg)        = IMPORT_MOD_time(prd,regg,t_sim) ;
TRADE(reg,prd,regg)         = TRADE_time(reg,prd,regg,t_sim) ;
EXPORT_ROW(reg,prd)         = EXPORT_ROW_time(reg,prd,t_sim) ;

* Variables that will be fixed in the model
P(regg,prd)                 = P_time(regg,prd,t_sim)          ;
PIU(prd,regg,ind)           = PIU_time(prd,regg,ind,t_sim)    ;
PIMP_T(prd,regg)            = PIMP_T_time(prd,regg,t_sim)     ;
PIMP_MOD(prd,regg)          = PIMP_MOD_time(prd,regg,t_sim)   ;
CONS_G_D(prd,regg)          = CONS_G_D_time(prd,regg,t_sim)   ;
GFCF_D(prd,regg)            = GFCF_D_time(prd,regg,t_sim)     ;
SV(reg,prd,regg)            = SV_time(reg,prd,regg,t_sim)     ;
EXPORT_ROW(reg,prd)         = EXPORT_ROW_time(reg,prd,t_sim)  ;
CONS_H_M(prd,regg)          = CONS_H_M_time(prd,regg,t_sim)   ;
CONS_G_M(prd,regg)          = CONS_G_M_time(prd,regg,t_sim)   ;
GFCF_M(prd,regg)            = GFCF_M_time(prd,regg,t_sim)     ;


* Exogenous parameters
*coprodB(reg,prd,regg,ind)   = coprodB_time(reg,prd,regg,ind,t_sim) ;
*ioc(prd,regg,ind)           = ioc_%scenario%(prd,regg,ind,t_sim) ;
* Recalibrate input output coefficients in case there was a different nest
* used for the production inputs.
*ioc(prd,regg,ind)           = 0 ;
*ioc(prd,regg,ind)$Y(regg,ind)
*        = INTER_USE_T(prd,regg,ind) / Y(regg,ind) ;

* Exegenous ioc
ioc(prd,reg,ind) = 0 ;
ioc(prd,reg,ind) = ioc_loop(prd,reg,ind,t_sim) ;

* Exogenous coprodB.
*coprodB(reg,prd,regg,ind) =0;
*coprodB(reg,prd,regg,ind)  = coprodB_loop(reg,prd,regg,ind,t_sim) ;

* Physical extensions
Materials_model_no_unit(regg,ind,deu)
        = coef_deu(regg,ind,deu) * Y(regg,ind)  ;

Land_model_no_unit(regg,ind,res)
        = coef_land(regg,ind,res) * Y(regg,ind)  ;

Water_model_no_unit(regg,ind,water)
        = coef_water(regg,ind,water) * Y(regg,ind)  ;

Water_model_no_unit(regg,"FCH",water)
        = coef_water(regg,"FCH",water) * sum(prd, CONS_H_T(prd,regg) ) ;

Emissions_model_no_unit(regg,ind,emis)
    = EMIS_time(regg,ind,emis,t_sim) ;

Emissions_model_no_unit(regg,"FCH",emis)
    = EMIS_time(regg,"FCH",emis,t_sim) ;

Emissions_model_no_unit(regg,"FCG",emis)
    = EMIS_time(regg,"FCG",emis,t_sim) ;

$ontext
Emissions_model_no_unit(regg,ind,emis_c)
    = coef_emis_c_year(regg,ind,emis_c,t_sim) * sum(ener_CO2, INTER_USE_T(ener_CO2,regg,ind) ) ;

Emissions_model_no_unit(regg,"FCH",emis_c)
    = coef_emis_c_year(regg,"FCH",emis_c,t_sim) * sum(ener_CO2, CONS_H_T(ener_CO2,regg) ) ;

Emissions_model_no_unit(regg,"FCG",emis_c)
    = coef_emis_c_year(regg,"FCG",emis_c,t_sim) * sum(ener_CO2, CONS_G_T(ener_CO2,regg) ) ;

Emissions_model_no_unit(regg,ind,emis_nc)
        = coef_emis_nc_year(regg,ind,emis_nc,t_sim) * Y(regg,ind)  ;
$offtext



Display Materials_model_no_unit, ioc, Emissions_model_no_unit;

* =========================== calibrate coefficients ===========================

*v(reg,va,regg,ind)$Y(regg,ind)
*    = VALUE_ADDED(reg,va,regg,ind) / Y(regg,ind) ;

d(regg,ind,deu)$Y(regg,ind)
    = Materials_model_no_unit(regg,ind,deu) / Y(regg,ind) ;

w(regg,ind,water)$Y(regg,ind)
    = Water_model_no_unit(regg,ind,water) / Y(regg,ind) ;

w(regg,"FCH",water)$sum(prd, CONS_H_T(prd,regg) )
    = Water_model_no_unit(regg,"FCH",water) / sum(prd, CONS_H_T(prd,regg) ) ;

lnd(regg,ind,res)$Y(regg,ind)
    = Land_model_no_unit(regg,ind,res) / Y(regg,ind) ;

e(regg,ind,emis_c)$Y(regg,ind)
    = Emissions_model_no_unit(regg,ind,emis_c)
         / sum(ener_CO2, INTER_USE_T(ener_CO2,regg,ind) ) ;

e(regg,"FCH",emis_c)$sum(ener_CO2, CONS_H_T(ener_CO2,regg) )
    = Emissions_model_no_unit(regg,"FCH",emis_c)
         / sum(ener_CO2, CONS_H_T(ener_CO2,regg) ) ;

e(regg,"FCG",emis_c)$sum(ener_CO2, CONS_G_T(ener_CO2,regg) )
    = Emissions_model_no_unit(regg,"FCG",emis_c)
         / sum(ener_CO2, CONS_G_T(ener_CO2,regg) ) ;

e(regg,ind,emis_nc)$Y(regg,ind)
    = Emissions_model_no_unit(regg,ind,emis_nc) / Y(regg,ind) ;





Display
*v
d
;

* ============================== Simulation setup ==============================
* Assign new initial levels
* This is needed when the simulation results have changed from the
* calibration year data.

* Initial levels of endogenous variables
Y_V.L(regg,ind)                 = Y(regg,ind) ;
X_V.L(regg,prd)                 = X(regg,prd) ;
CONS_H_D_V.L(prd,regg)          = CONS_H_D(prd,regg)  ;
INTER_USE_T_V.L(prd,reg,ind)    = INTER_USE_T(prd,reg,ind) ;
INTER_USE_D_V.L(prd,reg,ind)    = INTER_USE_D(prd,reg,ind) ;
INTER_USE_M_V.L(prd,reg,ind)    = INTER_USE_M(prd,reg,ind) ;
IMPORT_T_V.L(prd,regg)          = IMPORT_T(prd,regg) ;
IMPORT_MOD_V.L(prd,regg)        = IMPORT_MOD(prd,regg) ;
TRADE_V.L(reg,prd,regg)         = TRADE(reg,prd,regg) ;
EXPORT_ROW_V.L(reg,prd)         = EXPORT_ROW(reg,prd) ;

* Fix other variables which enter IO model equations
P_V.FX(regg,prd)                = P(regg,prd) ;
PIU_V.FX(prd,regg,ind)          = PIU(prd,regg,ind) ;
PIMP_T_V.FX(prd,regg)           = PIMP_T(prd,regg) ;
PIMP_MOD_V.FX(prd,regg)         = PIMP_MOD(prd,regg) ;
* In case you dont use simulation results as input, set all prices to one.
*P_V.FX(regg,prd)                = 1 ;
*PIU_V.FX(prd,regg,ind)          = 1 ;
*PIMP_T_V.FX(prd,regg)           = 1 ;
*PIMP_MOD_V.FX(prd,regg)         = 1 ;
CONS_G_D_V.FX(prd,regg)         = CONS_G_D(prd,regg) ;
GFCF_D_V.FX(prd,regg)           = GFCF_D(prd,regg) ;
SV_V.FX(reg,prd,regg)           = SV(reg,prd,regg) ;
EXPORT_ROW_V.FX(reg,prd)        = EXPORT_ROW(reg,prd) ;
CONS_H_M_V.FX(prd,regg)         = CONS_H_M(prd,regg) ;
CONS_G_M_V.FX(prd,regg)         = CONS_G_M(prd,regg) ;
GFCF_M_V.FX(prd,regg)           = GFCF_M(prd,regg) ;


Display
Y_V.L
X_V.L
CONS_H_D_V.L
INTER_USE_T_V.L
INTER_USE_D_V.L
INTER_USE_M_V.L
IMPORT_T_V.L
IMPORT_MOD_V.L
TRADE_V.L
EXPORT_ROW_V.L

* Fix other variables which enter IO model equations
P_V.L
PIU_V.L
PIMP_T_V.L
PIMP_MOD_V.L
* In case you dont use simulation results as input, set all prices to one.
*P_V.FX(regg,prd)                = 1 ;
*PIU_V.FX(prd,regg,ind)          = 1 ;
*PIMP_T_V.FX(prd,regg)           = 1 ;
*PIMP_MOD_V.FX(prd,regg)         = 1 ;
CONS_G_D_V.L
GFCF_D_V.L
SV_V.L
EXPORT_ROW_V.L
CONS_H_M_V.L
CONS_G_M_V.L
GFCF_M_V.L
;



* ============================== Start simulation ==============================

* start loop over regions and products, only for the combinations with non-zero
* output in the base year
* remove multipliers from previous year first

multipliers(reg,prd,multiplier_type) = 0 ;

loop((reg_sim,prd_sim)$X(reg_sim,prd_sim),

* Set all the final demand elements to the values from calibration (from data).
* This is needed, because one of the shocks may be non-zero from a previous step
* in the loop.
CONS_H_D_V.FX(prd,regg)
    = CONS_H_D(prd,regg) ;

* Add a shock of 1 for only one country-product combination for final household
* demand for domestic product (CONS_H_D_V).
CONS_H_D_V.FX(prd_sim,reg_sim)
    = CONS_H_D(prd_sim,reg_sim)
      + 1 ;

* The display statement below is only useful for debugging purposes when a small
* number of countries and products is used. Otherwise, since the display
* statement is inside the loop, it will return a lot of additional output.
*Display
*CONS_H_D_V.L
*;

* =============================== Solve statement ==============================
*Option iterlim = 0 ;
Solve IO_industry_technology using nlp maximizing obj ;

* ========================= Post-processing of results =========================

* Check whether the model solved without errors. If an error occurred
* (modelstat > 2) then we set the multipliers to NA, otherwise calculate the
* different types of multipliers.

* Display %model_type%.modelstat, %model_type%.solvestat ;

If(IO_industry_technology.modelstat > 2,
* Set all multipliers types to NA if an error occurred.
    multipliers(reg_sim,prd_sim,multiplier_type) = NA;

else

* Calculate output multipliers.
    multipliers(reg_sim,prd_sim,'output_intrareg')
        = sum(ind, Y_V.L(reg_sim,ind) - Y(reg_sim,ind) ) ;
    multipliers(reg_sim,prd_sim,'output_interreg')
        = sum((regg,ind)$(not sameas(reg_sim,regg)),
        Y_V.L(regg,ind) - Y(regg,ind) ) ;
    multipliers(reg_sim,prd_sim,'output_global')
        = sum((regg,ind), Y_V.L(regg,ind) - Y(regg,ind) ) ;
Display multipliers;

* Calculate value added multipliers.
*    multipliers(reg_sim,prd_sim,'value_added_global')
*        = sum((reg,va,regg,ind), Y_V.L(regg,ind) * v(reg,va,regg,ind) -
*        VALUE_ADDED(reg,va,regg,ind) ) ;
*    multipliers(reg_sim,prd_sim,'value_added_global_type1')
*        = multipliers(reg_sim,prd_sim,'value_added_global') / sum((va,regg,ind),
*        v(reg_sim,va,regg,ind) * coprodB(reg_sim,prd_sim,regg,ind) ) ;

* Calculate raw material consumption multipliers.
* Materials
    multipliers(reg_sim,prd_sim,'RMC_global')
        = sum((reg,ind), Y_V.L(reg,ind) * sum(deu,d(reg,ind,deu) ) -
        sum(deu,Materials_model_no_unit(reg,ind,deu)) ) ;
    multipliers(reg_sim,prd_sim,'biomass_global')
        = sum((reg,ind), Y_V.L(reg,ind) * d(reg,ind,"DEU_Biomassa") -
         Materials_model_no_unit(reg,ind,"DEU_Biomassa") ) ;
    multipliers(reg_sim,prd_sim,'wood_global')
        = sum((reg,ind), Y_V.L(reg,ind) * d(reg,ind,"DEU_Wood") -
        Materials_model_no_unit(reg,ind,"DEU_Wood") ) ;
    multipliers(reg_sim,prd_sim,'metal_global')
        = sum((reg,ind), Y_V.L(reg,ind) * d(reg,ind,"DEU_Metal ores") -
        Materials_model_no_unit(reg,ind,"DEU_Metal ores") ) ;
    multipliers(reg_sim,prd_sim,'minerals_global')
        = sum((reg,ind), Y_V.L(reg,ind) * d(reg,ind,"DEU_non-metalic minerals") -
        Materials_model_no_unit(reg,ind,"DEU_non-metalic minerals") ) ;
    multipliers(reg_sim,prd_sim,'fuels_global')
        = sum((reg,ind), Y_V.L(reg,ind) * d(reg,ind,"DEU_Fossil fuels") -
        Materials_model_no_unit(reg,ind,"DEU_Fossil fuels") ) ;

* Emissions
    multipliers(reg_sim,prd_sim,'CO2_nc')
        = sum((reg,ind), Y_V.L(reg,ind) * e(reg,ind,"CO2_nc") -
        Emissions_model_no_unit(reg,ind,"CO2_nc") ) ;
    multipliers(reg_sim,prd_sim,'CH4_nc')
        = sum((reg,ind), Y_V.L(reg,ind) * e(reg,ind,"CH4_nc") -
        Emissions_model_no_unit(reg,ind,"CH4_nc") ) ;
    multipliers(reg_sim,prd_sim,'N2O_nc')
        = sum((reg,ind), Y_V.L(reg,ind) * e(reg,ind,"N2O_nc") -
        Emissions_model_no_unit(reg,ind,"N2O_nc") ) ;
    multipliers(reg_sim,prd_sim,'SOX_nc')
        = sum((reg,ind), Y_V.L(reg,ind) * e(reg,ind,"SOX_nc") -
        Emissions_model_no_unit(reg,ind,"SOX_nc") ) ;
    multipliers(reg_sim,prd_sim,'NOX_nc')
        = sum((reg,ind), Y_V.L(reg,ind) * e(reg,ind,"NOX_nc") -
        Emissions_model_no_unit(reg,ind,"NOX_nc") ) ;

    multipliers(reg_sim,prd_sim,'CO2_c')
        = sum((reg,ind), sum(ener_CO2, INTER_USE_T_V.L(ener_CO2,reg,ind) ) * e(reg,ind,"CO2_c") -
        Emissions_model_no_unit(reg,ind,"CO2_c" ) ) ;
    multipliers(reg_sim,prd_sim,'CH4_c')
        = sum((reg,ind), sum(ener_CO2, INTER_USE_T_V.L(ener_CO2,reg,ind) ) * e(reg,ind,"CH4_c") -
        Emissions_model_no_unit(reg,ind,"CH4_c" ) ) ;
    multipliers(reg_sim,prd_sim,'N2O_c')
        = sum((reg,ind), sum(ener_CO2, INTER_USE_T_V.L(ener_CO2,reg,ind) ) * e(reg,ind,"N2O_c") -
        Emissions_model_no_unit(reg,ind,"N2O_c" ) ) ;
    multipliers(reg_sim,prd_sim,'SOX_c')
        = sum((reg,ind), sum(ener_CO2, INTER_USE_T_V.L(ener_CO2,reg,ind) ) * e(reg,ind,"SOX_c") -
        Emissions_model_no_unit(reg,ind,"SOX_c" ) ) ;
    multipliers(reg_sim,prd_sim,'NOX_c')
        = sum((reg,ind), sum(ener_CO2, INTER_USE_T_V.L(ener_CO2,reg,ind) ) * e(reg,ind,"NOX_c") -
        Emissions_model_no_unit(reg,ind,"NOX_c" ) ) ;


* Water
    multipliers(reg_sim,prd_sim,'water_global')
        = sum((reg,ind), Y_V.L(reg,ind) * sum(water,w(reg,ind,water) ) -
        sum(water,Water_model_no_unit(reg,ind,water)) ) ;

*    multipliers(reg_sim,prd_sim,water)
*        = sum((reg,ind), Y_V.L(reg,ind) * w(reg,ind,water) -
*         Water_model_no_unit(reg,ind,water) ) ;

* Land
    multipliers(reg_sim,prd_sim,'land_global')
        = sum((reg,ind), Y_V.L(reg,ind) * sum(res,lnd(reg,ind,res) ) -
        sum(res,Land_model_no_unit(reg,ind,res)) ) ;

*    multipliers(reg_sim,prd_sim,res)
*        = sum((reg,ind), Y_V.L(reg,ind) * l(reg,ind,res) -
*         Land_model_no_unit(reg,ind,res) ) ;

*Test disaggregate
    multipliers_disaggregate_nc(reg_sim,prd_sim,regg,ind)
        = Y_V.L(regg,ind) * e(regg,ind,"CO2_nc") -
        Emissions_model_no_unit(regg,ind,"CO2_nc")  ;

    multipliers_disaggregate_c(reg_sim,prd_sim,regg,ind)
        = sum(ener_CO2, INTER_USE_T_V.L(ener_CO2,regg,ind) ) * e(regg,ind,"CO2_c") -
        Emissions_model_no_unit(regg,ind,"CO2_c") ;


* Test why negatives in CO2_nc
    NewY(reg_sim,prd_sim,reg,ind,'CO2_nc',t_sim)
        = Y_V.L(reg,ind);

);

* The display statement below inside the loop is only useful for debugging
* when a small number of countries and products are used. Otherwise it
* results in a very large output file. Just displaying the results for
* future reference is better done outside the loop.
*Display
*multipliers
*;

* end loop over regions and products
) ;

* Save results after each year
multipliers_year(reg_sim,prd_sim,multiplier_type,t_sim) = multipliers(reg_sim,prd_sim,multiplier_type) ;
Y_year(regg,ind,t_sim) = Y(regg,ind) ;
DEU_year(regg,ind,deu,t_sim) = Materials_model_no_unit(regg,ind,deu) ;
water_year(regg,ind,water,t_sim) = Water_model_no_unit(regg,ind,water) ;
land_year(regg,ind,res,t_sim) = Land_model_no_unit(regg,ind,res) ;

* end loop over years
) ;

Display Y_year;


Parameter
        check(year)         check whether total production and consumption
                            # based output are the same
;

* Domestic final use
FINAL_USE_year(reg,prd,reg,t_sim)
                = CONS_H_D_time(prd,reg,t_sim)
                + CONS_G_D_time(prd,reg,t_sim)
                + GFCF_D_time(prd,reg,t_sim)
                + SV_time(reg,prd,reg,t_sim)
                + EXPORT_ROW_time(reg,prd,t_sim) ;

* Imported final use
FINAL_USE_year(reg,prd,regg,t_sim)$
        (not sameas(reg,regg) and
        TRADE_time(reg,prd,regg,t_sim) )
                = ( CONS_H_M_time(prd,regg,t_sim)
                    + CONS_G_M_time(prd,regg,t_sim)
                    + GFCF_M_time(prd,regg,t_sim) )
                * ( TRADE_time(reg,prd,regg,t_sim)
                    / sum(reggg,TRADE_time(reggg,prd,regg,t_sim) ) )
                + SV_time(reg,prd,regg,t_sim);


* Total Y should equal total of FD * multiplier. Check should therefore be zero.
check(t_sim)
        = sum((reg,prd,regg),
        multipliers(reg,prd,'output_global') * FINAL_USE_year(reg,prd,regg,t_sim) )
        - sum((reg,ind), Y(reg,ind) ) ;
Display check ;
Display FINAL_USE_year;

check(t_sim)=0;
check(t_sim)
        = sum((reg,prd,regg),
        multipliers(reg,prd,'CO2_nc') * FINAL_USE_year(reg,prd,regg,t_sim) )
        - sum((reg,ind), Emissions_model_no_unit(reg,ind,"CO2_nc") ) ;
Display check ;

check(t_sim)=0;
check(t_sim)
        = sum((reg,prd,regg),
        multipliers(reg,prd,'CO2_c') * FINAL_USE_year(reg,prd,regg,t_sim) )
        - sum((reg,ind), Emissions_model_no_unit(reg,ind,"CO2_c") ) ;
Display check ;

* ============================ Calculate footprints ============================

Parameter
    Y_cons(reg,prd,year)            Consumption based output
    RMC_cons(reg,prd,*,year)        Consumption based total material use
    water_cons(reg,prd,*,year)      Consumption based total water use
    land_cons(reg,prd,*,year)       Consumption based total land use
    EMIS_cons(reg,prd,*,year)
;

Y_cons(reg_sim,prd_sim,t_sim)
        = sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'output_global',t_sim) ) ;

RMC_cons(reg_sim,prd_sim,"total",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'RMC_global',t_sim) ) ;

RMC_cons(reg_sim,prd_sim,"DEU_Biomassa",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'biomass_global',t_sim) ) ;

RMC_cons(reg_sim,prd_sim,"DEU_Wood",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'wood_global',t_sim) ) ;

RMC_cons(reg_sim,prd_sim,"DEU_Metal ores",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'metal_global',t_sim) ) ;

RMC_cons(reg_sim,prd_sim,"DEU_non-metalic minerals",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'minerals_global',t_sim) ) ;

RMC_cons(reg_sim,prd_sim,"DEU_Fossil fuels",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'fuels_global',t_sim) ) ;

EMIS_cons(reg_sim,prd_sim,"CO2_c",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'CO2_c',t_sim) ) ;
EMIS_cons(reg_sim,prd_sim,"CH4_c",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'CH4_c',t_sim) ) ;
EMIS_cons(reg_sim,prd_sim,"N2O_c",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'N2O_c',t_sim) ) ;
EMIS_cons(reg_sim,prd_sim,"SOX_c",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'SOX_c',t_sim) ) ;
EMIS_cons(reg_sim,prd_sim,"NOX_c",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'NOX_c',t_sim) ) ;
EMIS_cons(reg_sim,prd_sim,"CO2_nc",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'CO2_nc',t_sim) ) ;
EMIS_cons(reg_sim,prd_sim,"CH4_nc",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'CH4_nc',t_sim) ) ;
EMIS_cons(reg_sim,prd_sim,"N2O_nc",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'N2O_nc',t_sim) ) ;
EMIS_cons(reg_sim,prd_sim,"SOX_nc",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'SOX_nc',t_sim) ) ;
EMIS_cons(reg_sim,prd_sim,"NOX_nc",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'NOX_nc',t_sim) ) ;

* water footprint
water_cons(reg_sim,prd_sim,"water_global",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'water_global',t_sim) ) ;

land_cons(reg_sim,prd_sim,"land_global",t_sim)
        =   sum(reg,
            FINAL_USE_year(reg,prd_sim,reg_sim,t_sim)
            * multipliers_year(reg,prd_sim,'land_global',t_sim) ) ;


Display multipliers, multipliers_disaggregate_nc, multipliers_disaggregate_c, Y_cons;


* =========================== Write results to Excel ===========================
*execute 'mkdir results'

*$LIBInclude xldump       multipliers_year       results/multipliers.xls multipliers!a1

Display
multipliers
multipliers_year
;
$ontext
$libinclude xldump Y_year           %project%\03_simulation_results\output\output_%scenario%.xlsx    Yprod_year!
$libinclude xldump DEU_year         %project%\03_simulation_results\output\output_%scenario%.xlsx    DEU_year!
$libinclude xldump FINAL_USE_year   %project%\03_simulation_results\output\output_%scenario%.xlsx    FD_year!
$libinclude xldump multipliers_year %project%\03_simulation_results\output\output_%scenario%.xlsx    multipliers_year!
$libinclude xldump Y_cons           %project%\03_simulation_results\output\output_%scenario%.xlsx    Ycons_year!
$libinclude xldump RMC_cons         %project%\03_simulation_results\output\output_%scenario%.xlsx    RMCcons_year!
$libinclude xldump EMIS_cons        %project%\03_simulation_results\output\output_%scenario%.xlsx    EMIScons_year!
$libinclude xldump water_cons       %project%\03_simulation_results\output\output_%scenario%.xlsx    water_cons_year!
$libinclude xldump land_cons        %project%\03_simulation_results\output\output_%scenario%.xlsx    land_cons_year!
$libinclude xldump water_year       %project%\03_simulation_results\output\output_%scenario%.xlsx    water_year!
$libinclude xldump land_year        %project%\03_simulation_results\output\output_%scenario%.xlsx    land_year!
$offtext
