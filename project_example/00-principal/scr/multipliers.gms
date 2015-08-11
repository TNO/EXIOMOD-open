* File:   00-principal/scr/multipliers.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014

$ontext startdoc
This file specifies the simulation setup to use when calculating multipliers.

A set `multiplier_type` with different types of multipliers, on output and
value added, is defined as

Element in the set         | Explanation
-------------------------- | -------------------------------------
output_intrareg            | Intra-regional output multipliers
output_interreg            | Inter-regional output multipliers
output_global              | Global output multipliers
value_added_global         | Global value added multipliers
value_added_global_type1   | Global value added multipliers Type I

The multipliers that are calculated are stored in
`multipliers(reg,prd,multiplier_type)`.

In the simulation setup section, the country/countries, and product(s) for which
to calculate the multipliers can be defined as shown in the examples in the
comments. If a multiplier can not be calculated, because the solver runs into an
error, then the resulting multiplier will have the value NA.

In the final section, the multipliers are saved to a file.
$offtext

* === Check whether model_type is defined. =====================================
* Add one of the two statements below to main.gms to define the model_type
*   $if not set model_type  $setglobal  model_type  'IO_product_technology'
*   $if not set model_type  $setglobal  model_type  'IO_industry_technology'

$if not set model_type $abort "global model_type not defined in %project%/00-principal/scr/multipliers.gms on line %system.line%."

* ======== Declaration and definition of simulation specific parameters ========

Sets
    reg_sim(reg)                list of regions used in loop of simulation setup
    prd_sim(prd)                list of products used in loop of simulation setup
;


Parameters
    v(reg,va,regg,ind)          value added coefficients
;

v(reg,va,regg,ind)$Y(regg,ind)
    = VALUE_ADDED(reg,va,regg,ind) / Y(regg,ind) ;

Display
v
;

* ================ Declaration of simulation specific parameters ===============

Sets
    multiplier_type  Type of the multipliers to be calculated
/
    output_intrareg             'Intra-regional output multipliers'
    output_interreg             'Inter-regional output multipliers'
    output_global               'Global output multipliers'
    value_added_global          'Global value added multipliers'
    value_added_global_type1    'Global value added multipliers Type I'
/
;

Parameters
    multipliers(reg,prd,multiplier_type)    all multipliers in one parameter
;

* ============================== Simulation setup ==============================

* Change the set of countries and products that we want to calculate multipliers
* for. We can specify to calculate the multipliers for all regions by putting all
* elements in the reg_sim set equal to yes.
* Example to calculate for all regions:  reg_sim(reg) = yes
* Example to calculate for one country:  reg_sim("NL") = yes
* Example to calculate for all products: prd_sim(prd) = yes
* Example to calculate for one product:  prd_sim("t4") = yes
reg_sim("WEU") = yes ;
prd_sim(prd) = yes ;

* Fix other variables which enter IO model equations
P_V.FX(regg,prd)             = 1 ;
PIU_V.FX(prd,regg,ind)       = 1 ;
PIMP_T_V.FX(prd,regg)        = 1 ;
PIMP_MOD_V.FX(prd,regg)      = 1 ;
CONS_G_D_V.FX(prd,regg)      = CONS_G_D(prd,regg) ;
GFCF_D_V.FX(prd,regg)        = GFCF_D(prd,regg) ;
SV_V.FX(reg,prd,regg)        = SV(reg,prd,regg) ;
EXPORT_ROW_V.FX(reg,prd)     = EXPORT_ROW(reg,prd) ;
CONS_H_M_V.FX(prd,regg)      = CONS_H_M(prd,regg) ;
CONS_G_M_V.FX(prd,regg)      = CONS_G_M(prd,regg) ;
GFCF_M_V.FX(prd,regg)        = GFCF_M(prd,regg) ;


* start loop over regions and products, only for the combinations with non-zero
* output in the base year
loop((reg_sim,prd_sim)$X(reg_sim,prd_sim),

* Set all the final demand elements to the values from calibration (from data).
* This is needed, because one of the shocks may be non-zero from a previous step
* in the loop.
CONS_H_D_V.FX(prd,regg)
    = CONS_H_D(prd,regg) ;

* Add a shock of 1 for only one country-product combination for final household
* demand for domestic product (CONS_H_D_V).
CONS_H_D_V.FX(prd_sim,reg_sim)
    = CONS_H_D(prd_sim,reg_sim) + 1 ;

* The display statement below is only useful for debugging purposes when a small
* number of countries and products is used. Otherwise, since the display
* statement is inside the loop, it will return a lot of additional output.
*Display
*FINAL_USE_V.L
*;

* =============================== Solve statement ==============================

Solve %model_type% using nlp maximizing obj ;

* ========================= Post-processing of results =========================

* Check whether the model solved without errors. If an error occurred
* (modelstat > 2) then we set the multipliers to NA, otherwise calculate the
* different types of multipliers.

* Display %model_type%.modelstat, %model_type%.solvestat ;

If(%model_type%.modelstat > 2,
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

* Calculate value added multipliers.
    multipliers(reg_sim,prd_sim,'value_added_global')
        = sum((reg,va,regg,ind), Y_V.L(regg,ind) * v(reg,va,regg,ind) -
        VALUE_ADDED(reg,va,regg,ind) ) ;
    multipliers(reg_sim,prd_sim,'value_added_global_type1')
        = multipliers(reg_sim,prd_sim,'value_added_global') / sum((va,regg,ind),
        v(reg_sim,va,regg,ind) * coprodB(reg_sim,prd_sim,regg,ind) ) ;
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

* =========================== Write results to Excel ===========================
execute 'mkdir %project%\results'

$LIBInclude xldump       multipliers            %project%/results/multipliers.xls multipliers!a1

Display
multipliers
;
