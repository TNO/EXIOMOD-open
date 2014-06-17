
* ========================== Declaration of variables ==========================

* Endogenous variables
Positive variables
         Y_V(reg,ind)   output vector activities
         X_V(reg,prd)   output vector products
;

* Exogenous variables
Variables
         FINAL_USE_V(reg,prd,regg,fd)   final demand
         EXPORT_V(reg,prd,row,exp)      export
         a_V(reg,prd,regg,ind)          technical coefficients
         coprodA_V(reg,prd,regg,ind)    co-production coefficients with mix per industry
         coprodB_V(reg,prd,regg,ind)    co-production coefficients with mix per product
;

* Artificial objective
Variables
         obj            artificial objective value
;


* ========================== Declaration of equations ==========================

Equations
         EQBAL(reg,prd)    product market balance
         EQX(reg,prd)      output level of products
         EQY(reg,ind)      output level of activities
         EQOBJ             artificial objective function
;


* ========================== Definition of equations ===========================

EQBAL(reg,prd)..       sum((regg,fd), FINAL_USE_V(reg,prd,regg,fd)) +
                       sum((row,exp), EXPORT_V(reg,prd,row,exp)) +
                       sum((regg,ind), a_V(reg,prd,regg,ind) * Y_V(regg,ind))
                       =E=
                       X_V(reg,prd) ;

EQX(reg,prd)..         X_V(reg,prd)
                       =E=
                       sum((regg,ind), coprodA_V(reg,prd,regg,ind) * Y_V(regg,ind)) ;

EQY(reg,ind)..         Y_V(reg,ind)
                       =E=
                       sum((regg,prd), coprodB_V(regg,prd,reg,ind) * X_V(regg,prd)) ;

EQOBJ..                obj
                       =E=
                       1 ;


* ======== Define levels and lower and upper bounds and fixed variables ========

* Endogenous variables
Y_V.L(reg,ind)     = Y(reg,ind) ;
Y_V.UP(reg,ind)    = 100 * Y(reg,ind) ;

X_V.L(reg,prd)     = X(reg,prd) ;
X_V.UP(reg,prd)    = 100 * X(reg,prd) ;

* Exogenous variables
FINAL_USE_V.FX(reg,prd,regg,fd)  = FINAL_USE_model(reg,prd,regg,fd) ;
EXPORT_V.FX(reg,prd,row,exp)     = EXPORT_model(reg,prd,row,exp)    ;
a_V.FX(reg,prd,regg,ind)         = a(reg,prd,regg,ind)              ;
coprodA_V.FX(reg,prd,regg,ind)   = coprodA(reg,prd,regg,ind)        ;
coprodB_V.FX(reg,prd,regg,ind)   = coprodB(reg,prd,regg,ind)        ;


* ========================== Declare model equations ===========================

Model product_technology
/
EQBAL
EQX
EQOBJ
/ ;

Model industry_technology
/
EQBAL
EQY
EQOBJ
/ ;
