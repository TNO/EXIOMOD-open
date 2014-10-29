* File:   scr/simulation/multipliers.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014

$ontext startdoc
Documentation for this file is missing.
$offtext

* === Check whether model_type is defined. =====================================
* Add one of the two statements below to main.gms to define the model_type
*   $if not set model_type  $setglobal  model_type  'IO_product_technology'
*   $if not set model_type  $setglobal  model_type  'IO_industry_technology'

$if not set model_type $abort "global model_type not defined in project/scr/simulation/multipliers.gms on line %system.line%."

* ======== Declaration and definition of simulation specific parameters ========

Sets
    reg_sim(reg)                list of regions used in loop of simulation setup
    prd_sim(prd)                list of products used in loop of simulation setup
;


Parameters
    v(reg,va,regg,ind)          value added coefficients
;

v(reg,va,regg,ind)$Y(regg,ind)
    = VALUE_ADDED_model(reg,va,regg,ind) / Y(regg,ind) ;

Display
v
;

* ================ Declaration of simulation specific variables ================

Positive variables
    OUTPUTmult_intrareg(reg,prd)        intra-regional output multiplier
    OUTPUTmult_interreg(reg,prd)        inter-regional output multiplier
    OUTPUTmult_global(reg,prd)          global output multiplier

    VALUEADDEDmult_global(reg,prd)      global value-added multiplier
    VALUEADDEDmultT1_global(reg,prd)    global value-added multiplier of Type I
;

* ============================== Simulation setup ==============================

* Select regions and products for which the multipliers are calculated
reg_sim(reg) = yes ;
prd_sim(prd) = yes ;

* Fix other variables which enter IO model equations
P_V.FX(regg,prd)         = 1 ;
PIU_V.FX(prd,regg,ind)   = 1 ;
PIMP_V.FX(prd,regg)      = 1 ;
TRADE_V.FX(reg,prd,regg) = TRADE(reg,prd,regg) ;
IMPORT_V.FX(prd,regg)    = IMPORT(prd,regg) ;

* start loop over regions and products
loop((reg_sim,prd_sim),

FINAL_USE_V.FX(reg,prd,regg,fd)
    = FINAL_USE_bp_model(reg,prd,regg,fd) ;
FINAL_USE_V.FX(reg_sim,prd_sim,reg_sim,"FCH")
    = FINAL_USE_bp_model(reg_sim,prd_sim,reg_sim,"FCH") + 1 ;

Display
FINAL_USE_V.L
;

* =============================== Solve statement ==============================

Solve %model_type% using nlp maximizing obj ;

* ========================= Post-processing of results =========================

OUTPUTmult_intrareg.L(reg_sim,prd_sim)
    = sum(ind, Y_V.L(reg_sim,ind) - Y(reg_sim,ind) ) ;
OUTPUTmult_interreg.L(reg_sim,prd_sim)
    = sum((regg,ind)$(not sameas(reg_sim,regg)),
    Y_V.L(regg,ind) - Y(regg,ind) ) ;
OUTPUTmult_global.L(reg_sim,prd_sim)
    = sum((regg,ind), Y_V.L(regg,ind) - Y(regg,ind) ) ;

VALUEADDEDmult_global.L(reg_sim,prd_sim)
    = sum((reg,va,regg,ind), Y_V.L(regg,ind) * v(reg,va,regg,ind) -
    VALUE_ADDED_model(reg,va,regg,ind) ) ;
VALUEADDEDmultT1_global.L(reg_sim,prd_sim)
    = VALUEADDEDmult_global.L(reg_sim,prd_sim) /
    sum((va,regg,ind), v(reg_sim,va,regg,ind) *
    coprodB(reg_sim,prd_sim,regg,ind) ) ;

Display
OUTPUTmult_intrareg.L
OUTPUTmult_interreg.L
OUTPUTmult_global.L

VALUEADDEDmult_global.L
VALUEADDEDmultT1_global.L
;

* end loop over regions and products
) ;

* =========================== Write results to Excel ===========================
execute 'mkdir results'

$LIBInclude xldump       OUTPUTmult_intrareg.L   results/multipliers.xls output_intraregional!a1
$LIBInclude xldump       OUTPUTmult_interreg.L   results/multipliers.xls output_interregional!a1
$LIBInclude xldump       VALUEADDEDmult_global.L results/multipliers.xls valueadded!a1
$LIBInclude xldump       VALUEADDEDmultT1_global.L       results/multipliers.xls valueadded_typeI!a1
