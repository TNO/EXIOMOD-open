
Parameter concrd_prd_ind(prd,ind) ;

concrd_prd_ind("P1","A1") = 1 ;
concrd_prd_ind("P2","A2") = 1 ;
concrd_prd_ind("P3","A3") = 1 ;
concrd_prd_ind("P4","A4") = 1 ;

* ========================== Declaration of variables ==========================

* Endogenous variables
Variables
         Y_V(reg,ind)   output vector activities
         X_V(reg,prd)   output vector products
         coprod_V(reg,prd,regg,ind)     co-production coefficients
;

* Exogenous variables
Variables
         FINAL_USE_V(reg,prd,regg,fd)   final demand
         EXPORT_V(reg,prd,row,exp)      export
         a_V(reg,prd,regg,ind)          technical coefficients
         coprodA_V(reg,prd,regg,ind)    co-production coefficients with mix per industry
         coprodB_V(reg,prd,regg,ind)    co-production coefficients with mix per product
         I(reg,prd,regg,ind)            identity matrix

* ========================== Declaration of equations ==========================

Equations
         EQBAL(reg,prd)    product market balance
         EQYA(reg,ind)     output level of activities with mix per industry
         EQYB(reg,ind)     output level of activities with mix per product
         EQCOPRODA(reg,prd,regg,ind)   defines co-production coefficients with mix per industry
         EQCOPRODB(reg,prd,regg,ind)   defines co-production coefficients with mix per product
;


* ========================== Definition of equations ===========================

EQBAL(reg,prd)..       sum((regg,fd), FINAL_USE_V(reg,prd,regg,fd)) +
                       sum((row,exp), EXPORT_V(reg,prd,row,exp)) +
                       sum((regg,ind), a_v(reg,prd,regg,ind) * Y_V(regg,ind))
                       =E=
                       X_V(reg,prd) ;

*EQX(reg,prd)..         X_V(reg,prd)
*                       =E=
*                       sum((regg,ind), coprodA_V(reg,prd,regg,ind) * Y_V(regg,ind)) ;

EQYA(reg,ind)..        Y_V(reg,ind)
                       =E=
                       sum((regg,prd,indd)$concrd_prd_ind(prd,ind), coprod_V(reg,prd,regg,indd) * sum(prdd$concrd_prd_ind(prdd,indd),X_V(regg,prdd))) ;

EQYB(reg,ind)..        Y_V(reg,ind)
                       =E=
                       sum((regg,prd), coprod_V(regg,prd,reg,ind) * X_V(regg,prd)) ;

EQCOPRODA(reg,prd,regg,ind)..
                       sum((reggg,indd,prdd)$concrd_prd_ind(prdd,indd),coprod_V(reg,prd,reggg,indd) * coprodA_V(reggg,prdd,regg,ind) )
                       =E=
                       I(reg,prd,regg,ind) ;

EQCOPRODB(reg,prd,regg,ind)..
                       coprod_V(reg,prd,regg,ind)
                       =E=
                       coprodB_V(reg,prd,regg,ind) ;

* ======== Define levels and lower and upper bounds and fixed variables ========

* Endogenous variables
Y_V.L(reg,ind)     = Y(reg,ind) ;
X_V.L(reg,prd)     = X(reg,prd) ;

* Exogenous variables
FINAL_USE_V.FX(reg,prd,regg,fd)  = FINAL_USE_model(reg,prd,regg,fd) ;
EXPORT_V.FX(reg,prd,row,exp)     = EXPORT_model(reg,prd,row,exp)    ;
a_V.FX(reg,prd,regg,ind)         = a(reg,prd,regg,ind)              ;
coprodA_V.FX(reg,prd,regg,ind)   = coprodA(reg,prd,regg,ind)        ;
coprodB_V.FX(reg,prd,regg,ind)   = coprodB(reg,prd,regg,ind)        ;
I.FX(reg,prd,regg,ind)           = 0 ;
I.FX(reg,prd,reg,ind)$concrd_prd_ind(prd,ind) = 1 ;


* ========================== Declare model equations ===========================

Model product_technology
/
EQBAL.X_V
EQYA.Y_V
EQCOPRODA.coprod_V
/ ;

Model industry_technology
/
EQBAL.X_V
EQYB.Y_V
EQCOPRODB.coprod_V
/ ;
