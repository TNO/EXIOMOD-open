
* ======== Declaration and definition of simulation specific parameters ========

Sets
         reg_sim(reg)                list of regions used in loop of simulation setup
         prd_sim(prd)                list of products used in loop of simulation setup
;


Parameters
         v(reg,va,ind)               value added coefficients
;

v(reg,va,ind)$Y(reg,ind)
                 = VALUE_ADDED_model(reg,va,ind) / Y(reg,ind) ;

Display
v
;

* ================ Declaration of simulation specific variables ================

Positive variables
         OUTPUTmult_intrareg(reg,prd)            intra-regional output multiplier
         OUTPUTmult_interreg(reg,prd)            inter-regional output multiplier
         OUTPUTmult_global(reg,prd)              global output multiplier

         VALUEADDEDmult_global(reg,prd)          global value-added multiplier
         VALUEADDEDmultT1_global(reg,prd)        global value-added multiplier of Type I
;

* ============================== Simulation setup ==============================

reg_sim(reg) = yes ;
prd_sim(prd) = yes ;

* start loop over regions and products
loop((reg_sim,prd_sim),

Cshock.FX(reg,prd,regg,fd)              = 0 ;
Cshock.FX(reg_sim,prd_sim,reg_sim,"FC") = 1 ;

Display
Cshock.L
;

* =============================== Solve statement ==============================

Solve %io_type% using lp maximizing obj ;

* ========================= Post-processing of results =========================

OUTPUTmult_intrareg.L(reg_sim,prd_sim)
                 = sum(ind, Y_V.L(reg_sim,ind) - Y(reg_sim,ind) ) ;
OUTPUTmult_interreg.L(reg_sim,prd_sim)
                 = sum((reg,ind)$(not sameas(reg_sim,reg)), Y_V.L(reg,ind) - Y(reg,ind) ) ;
OUTPUTmult_global.L(reg_sim,prd_sim)
                 = sum((reg,ind), Y_V.L(reg,ind) - Y(reg,ind) ) ;

VALUEADDEDmult_global.L(reg_sim,prd_sim)
                 = sum((va,reg,ind), Y_V.L(reg,ind) * v(reg,va,ind) - VALUE_ADDED_model(reg,va,ind) ) ;
VALUEADDEDmultT1_global.L(reg_sim,prd_sim)
                 = VALUEADDEDmult_global.L(reg_sim,prd_sim) / sum((va,regg,ind), v(reg_sim,va,ind) * coprodB(reg_sim,prd_sim,regg,ind) ) ;

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

$LIBInclude xldump       OUTPUTmult_intrareg.L   results/multipliers.xls output_intraregional!a1
$LIBInclude xldump       OUTPUTmult_interreg.L   results/multipliers.xls output_interregional!a1
$LIBInclude xldump       VALUEADDEDmult_global.L results/multipliers.xls valueadded!a1
$LIBInclude xldump       VALUEADDEDmultT1_global.L       results/multipliers.xls valueadded_typeI!a1
