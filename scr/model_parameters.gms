* File:   scr/model_parameters.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014

$ontext startdoc
This GAMS file defines the parameters that are used in the model. Please start from `main.gms`.

Parameters are fixed and are declared (in a first block) and defined (in the second block) in this file. The following parameters are defined:

Variable                    | Explanation     
--------------------------- |:----------------
`Y(reg,ind)`                | This is the output vector by activity. It is defined from the supply table in model format, by summing `SUP_model(regg,prd,reg,ind)` over `regg` and `prd`.
`X(reg,ind)`                | This is the output vector by product. It is defined from the supply table in model format, by summing `SUP_model(reg,prd,regg,ind)` over `regg` and `ind`.
`coprodA(reg,prd,regg,ind)` | These are the co-production coefficients with mix per industry. Using these coefficients in the analysis corresponds to the product technology assumption. The coefficients are defined as `SUP_model(reg,prd,regg,ind) / Y(regg,ind)`. if `Y(regg,ind)` is nonzero.
`coprodA(reg,prd,regg,ind)` | These are the co-production coefficients with mix per product. Using these coefficients in the analysis corresponds to the industry technology assumption. The coefficients are defined as `SUP_model(reg,prd,regg,ind) / X(reg,prd)`. if `X(reg,prd)` is nonzero.
`a(reg,prd,regg,ind)`       | These are the technical input coefficients. They are defined as `INTER_USE_model(reg,prd,regg,ind) / Y(regg,ind)`.

No changes should be made in this file, as the parameters declared here are all defined using their standard definitions.
$offtext

* ========================= Declaration of parameters ==========================

Parameters
         Y(reg,ind)                  output vector by activity
         X(reg,prd)                  output vector by product
         coprodA(reg,prd,regg,ind)   co-production coefficients with mix per industry - corresponds to product technology assumption
         coprodB(reg,prd,regg,ind)   co-production coefficients with mix per product  - corresponds to industry technology assumption
         a(reg,prd,regg,ind)         technical input coefficients
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

Display
coprodA
coprodB
a
;
