
* ============================== Simulation setup ==============================

Parameter
         Cshock_data(reg,prd,regg,fd,*) raw shock data
;

$LIBInclude      xlimport        Cshock_data     simulation/shock.xlsx   long!a1..e33

Cshock.FX(reg,prd,regg,fd)              = Cshock_data(reg,prd,regg,fd,"Value") ;

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

Parameters
         deltaY(reg,ind)       change in activity output
         deltaX(reg,prd)       change in product output
;

deltaY(reg,ind) = Y_V.L(reg,ind) - Y(reg,ind) ;
deltaX(reg,prd) = X_V.L(reg,prd) - X(reg,prd) ;

Display
deltaY
deltaX
;
