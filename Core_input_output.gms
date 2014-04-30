
*======================== Declaration of sets and alias ========================

Sets
         uel             unique element list
/
$include sets/uel.txt
/

         reg(uel)        list of regions
/
$include sets/regions.txt
/

         prd(uel)        list of products
/
$include sets/products.txt
/

         ind(uel)        list of industries
/
$include sets/industries.txt
/

         fd(uel)         list of final demand categories
/
$include sets/finaldemand.txt
/

         va(uel)         list of value added categories
/
$include sets/valueadded.txt
/

         exp(uel)        list of export categories
/
$include sets/export.txt
/

         year(uel)       list of time periods
/
$include sets/years.txt
/

         cur(uel)        list of currencies
/
$include sets/currencies.txt
/

         uim(uel)        use of imported products category
/
$include sets/useofimportedproducts.txt
/
;

Alias
         (reg,regg,reggg)
         (prd,prdd,prddd)
         (ind,indd,inddd)
;


Table
         SUP(*,*) example supply table
         j1      j2
i1      130       0
i2       20     200
;

Table
         USE(*,*) example use table
         j1      j2      fd
i1        0      80      50
i2       60      30     130
va       90      90
;

Parameters
         Y(j)        output vector by activity
         X(i)        output vector by product
         coprod1(i,j) coproduction coefficients with mix per industry - corresponds to product technology assumption
         coprod2(i,j) coproduction coefficients with mix per product  - correcponds to industry technology assumption
         a(i,j)      input coefficients
         alpha(j)    value added coefficients
         C(i)        final demand vector
         Cshock(i)   final demand shock
;

Y(j)             = sum(i, SUP(i,j) ) ;
X(i)             = sum(j, SUP(i,j) ) ;

coprod1(i,j)     = SUP(i,j) / Y(j) ;
coprod2(i,j)     = SUP(i,j) / X(i) ;
a(i,j)           = USE(i,j) / Y(j) ;
alpha(j)         = USE("va",j) / Y(j) ;
C(i)             = USE(i,"fd") ;
Cshock(i)        = 1 ;

Variables
         V_Y(j)      output vector activities after shock
         V_X(i)      output vector products after shock
         obj         aftificial objective value
;

Equations
         EQBAL(i)    product market balance
         EQX(i)      output level products
         EQY(j)      output level activities
         EQOBJ       aftificial objective function
;

EQBAL(i)..       C(i) + Cshock(i) + sum(j, a(i,j) * V_Y(j) ) =e= V_X(i) ;
EQX(i)..         V_X(i) =e= sum(j, coprod1(i,j) * V_Y(j) ) ;
EQY(j)..         V_Y(j) =e= sum(i, coprod2(i,j) * V_X(i) ) ;
EQOBJ..          obj =e= 1 ;

V_Y.L(j)  = Y(j) ;
V_Y.LO(j) = 0 ;
V_Y.UP(j) = 100 * Y(j) ;

V_X.L(i)  = X(i) ;
V_X.LO(i) = 0 ;
V_X.UP(i) = 100 * X(i) ;

Model suts_test
/
EQBAL
*EQX
EQY
EQOBJ
/ ;

Solve suts_test using lp maximizing obj ;

Parameters
         deltaY(j)       change in activity output
         deltaX(i)       change in product output
;

deltaY(j) = V_Y.L(j) - Y(j) ;
deltaX(i) = V_X.L(i) - X(i) ;


Display deltaY, deltaX ;
