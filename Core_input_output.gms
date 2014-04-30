
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

         row(uel)        list of rest of the world regions
/
$include sets/restoftheworld.txt
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
         (uel,uel2,uel3,uel4,uel5,uel6)
         (reg,regg,reggg)
         (prd,prdd,prddd)
         (ind,indd,inddd)
;


* ========================= Declaration of parameters ==========================

Parameters
         SUP_data(uel,uel2,uel3,uel4,uel5,uel6,*)      raw supply data
         USE_data(uel,uel2,uel3,uel4,uel5,uel6,*)      raw use data

         Y(reg,ind)                  output vector by activity
         X(reg,prd)                  output vector by product
         coprodA(reg,prd,regg,ind)   coproduction coefficients with mix per industry - corresponds to product technology assumption
         coprodB(reg,prd,regg,ind)   coproduction coefficients with mix per product  - correcponds to industry technology assumption
         a(reg,prd,regg,ind)         technical input coefficients
         alpha(reg,va,ind)           value added coefficients
         C(reg,prd,regg,fd)          final demand vector

         Cshock(reg,prd,regg,fd)     final demand shock
;


* ============================ Read in external data ===========================

$LIBInclude      xlimport        SUP_data        data/SUTdata_long_format.xlsx   Supply!a1..g65
$LIBInclude      xlimport        USE_data        data/SUTdata_long_format.xlsx   Use!a1..g170


* ========================== Definition of parameters ==========================

Y(reg,ind)       = sum((regg,prd), SUP_data("2007","MEUR",regg,prd,reg,ind,"Value")) ;
X(reg,prd)       = sum((regg,ind), SUP_data("2007","MEUR",reg,prd,regg,ind,"Value")) ;

Display Y,X ;

coprodA(reg,prd,regg,ind)$Y(regg,ind)
                 = SUP_data("2007","MEUR",reg,prd,regg,ind,"Value") / Y(regg,ind) ;
coprodB(reg,prd,regg,ind)$X(reg,prd)
                 = SUP_data("2007","MEUR",reg,prd,regg,ind,"Value") / X(reg,prd) ;

Display coprodA, coprodB ;

a(reg,prd,regg,ind)$Y(regg,ind)
                 = USE_data("2007","MEUR",reg,prd,regg,ind,"Value") / Y(regg,ind) ;

alpha(reg,va,ind)$Y(reg,ind)
                 = USE_data("2007","MEUR","N/A",va,reg,ind,"Value") / Y(reg,ind) ;

Display a, alpha ;

C(reg,prd,regg,fd)
                 = USE_data("2007","MEUR",reg,prd,regg,fd,"Value") ;

Display C ;



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


* Simulation setup


         Cshock(fd,prd)         final demand shock


Solve suts_test using lp maximizing obj ;

Parameters
         deltaY(j)       change in activity output
         deltaX(i)       change in product output
;

deltaY(j) = V_Y.L(j) - Y(j) ;
deltaX(i) = V_X.L(i) - X(i) ;


Display deltaY, deltaX ;
