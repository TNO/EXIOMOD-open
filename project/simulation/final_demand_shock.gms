* File:   scr/simulation/final_demand_shock.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014

$ontext startdoc
Documentation for this file is missing.
$offtext

* === Check whether model_type is defined. =====================================
* Add one of the two statements below to main.gms to define the model_type
*   $if not set model_type  $setglobal  model_type  'IO_product_technology'
*   $if not set model_type  $setglobal  model_type  'IO_industry_technology'

$if not set model_type $abort "global model_type not defined in %project%/scr/simulation/final_demand_shock.gms on line %system.line%."

* ======== Declaration and definition of simulation specific parameters ========

* ================ Declaration of simulation specific variables ================

Positive variables
    deltaY(reg,ind)         change in activity output
    deltaX(reg,prd)         change in product output
;

* ============================== Simulation setup ==============================

Parameter
    Cshock_data(reg,prd,regg,fd,*)      raw shock data
;

$LIBInclude      xlimport        Cshock_data     %project%/simulation/final_demand_shock.xlsx   long!a1..e33

* Define new fixed value of final demand
FINAL_USE_V.FX(reg,prd,regg,fd)
    = FINAL_USE_bp_model(reg,prd,regg,fd) +
    Cshock_data(reg,prd,regg,fd,"Value") ;

Display
FINAL_USE_V.L
;

* Fix other variables which enter IO model equations
P_V.FX(regg,prd)             = 1 ;
PIU_V.FX(prd,regg,ind)       = 1 ;
PIMP_V.FX(prd,regg)          = 1 ;
TRADE_V.FX(reg,prd,regg)     = TRADE(reg,prd,regg) ;
IMPORT_V.FX(prd,regg)        = IMPORT(prd,regg) ;
EXPORT_V.FX(reg,prd,row,exp) = EXPORT_model(reg,prd,row,exp) ;

* =============================== Solve statement ==============================

Solve %model_type% using nlp maximizing obj ;

* ========================= Post-processing of results =========================

deltaY.L(reg,ind) = Y_V.L(reg,ind) - Y(reg,ind) ;
deltaX.L(reg,prd) = X_V.L(reg,prd) - X(reg,prd) ;

Display
deltaY.L
deltaX.L
;
