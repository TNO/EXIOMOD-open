
* ============================== Simulation setup ==============================

reg_sim(reg) = yes ;
prd_sim(prd) = yes ;

loop((reg_sim,prd_sim),

Cshock.FX(reg,prd,regg,fd)              = 0 ;
Cshock.FX(reg_sim,prd_sim,reg_sim,"FC") = 1 ;

Display
Cshock.L
;


* =============================== Solve statement ==============================

$if %io_type% == "product_technology"    $goto product_technology
$if %io_type% == "industry_technology"   $goto industry_technology

$label product_technology
Solve product_technology using lp maximizing obj ;
$goto post_processing

$label industry_technology
Solve industry_technology using lp maximizing obj ;
$goto post_processing

$label post_processing
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

) ;
