
* ======== Declaration and definition of simulation specific parameters ========

* ================ Declaration of simulation specific variables ================

Positive variables
         deltaY(reg,ind)       change in activity output
         deltaX(reg,prd)       change in product output
;

* ============================== Simulation setup ==============================

Parameter
         Cshock_data(reg,prd,regg,fd,*) raw shock data
;

$LIBInclude      xlimport        Cshock_data     simulation/shock.xlsx   long!a1..e33

FINAL_USE_V.FX(reg,prd,regg,fd)   = FINAL_USE_model(reg,prd,regg,fd) +
                                    Cshock_data(reg,prd,regg,fd,"Value") ;

Display
FINAL_USE_V.L
;

* =============================== Solve statement ==============================

Solve %io_type% using nlp maximizing obj ;

* ========================= Post-processing of results =========================

deltaY.L(reg,ind) = Y_V.L(reg,ind) - Y(reg,ind) ;
deltaX.L(reg,prd) = X_V.L(reg,prd) - X(reg,prd) ;

Display
deltaY.L
deltaX.L
;
