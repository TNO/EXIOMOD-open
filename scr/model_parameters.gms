
* ========================= Declaration of parameters ==========================

Parameters
         Y(reg,ind)                  output vector by activity
         X(reg,prd)                  output vector by product
         coprodA(reg,prd,regg,ind)   co-production coefficients with mix per industry - corresponds to product technology assumption
         coprodB(reg,prd,regg,ind)   co-production coefficients with mix per product  - corresponds to industry technology assumption
         a(reg,prd,regg,ind)         technical input coefficients
         v(reg,va,ind)               value added coefficients
;


* ========================== Definition of parameters ==========================

Y(reg,ind)       = sum((regg,prd), SUP_model(regg,prd,reg,ind) ) ;

X(reg,prd)       = sum((regg,ind), SUP_model(reg,prd,regg,ind) ) ;

Display
Y
X
;

coprodA(reg,prd,regg,ind)$Y(regg,ind)
                 = SUP_model(reg,prd,regg,ind) / Y(regg,ind) ;

coprodB(reg,prd,regg,ind)$X(reg,prd)
                 = SUP_model(reg,prd,regg,ind) / X(reg,prd) ;

a(reg,prd,regg,ind)$Y(regg,ind)
                 = INTER_USE_model(reg,prd,regg,ind) / Y(regg,ind) ;

v(reg,va,ind)$Y(reg,ind)
                 = VALUE_ADDED_model(reg,va,ind) / Y(reg,ind) ;

Display
coprodA
coprodB
a
v
;
