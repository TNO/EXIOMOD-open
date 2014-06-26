* File:   scr/model_parameters.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 25 June 2014

* gams-master-file: load_database.gms

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

* ========================== Declaration of subsets ============================
Sets
        ntp(va)   net taxes on production categories    /"NTP"/
        kl(va)    capital and labour categories         /"COE","OPS"/
        lab(va)   labour categories                     /"COE"/
        cap(va)   capital categories                    /"OPS"/
;

* ========================= Declaration of parameters ==========================

Parameters
        Y(reg,ind)                  output vector by activity
        X(reg,prd)                  output vector by product
        LS(reg)                     labour supply
        KS(reg)                     capital supply
*        coprodA(reg,prd,regg,ind)   co-production coefficients with mix per industry - corresponds to product technology assumption
        coprodB(reg,prd,regg,ind)   co-production coefficients with mix per product  - corresponds to industry technology assumption (relationin volume)
        a(reg,prd,regg,ind)         technical input coefficients (relation in volume)
        tsp_ind(reg,prd,regg,ind)   tax and subsidies on products rates for industries (relation in value)
        tpr(reg,ntp,regg,ind)       net taxes on production rates (relation in value)
        facL(reg,kl,regg,ind)       leotief coefficients for factors of production input (relation in volume)
        uip_ind(reg,ind,row,uip)    use of imported products coefficients for industries (relation in value)
        tsp_disrt(reg,tsp,regg,fd)  distribution shares of taxes and subsidies on products income to budgets of final demand (shares)
        fdL(reg,prd,regg,fd)        leontief coefficients for final demand (relation in volume)
        tsp_fd(reg,prd,regg,fd)     tax and subsidies on products rates for final demand (relation in value)
;


* ========================== Definition of parameters ==========================

Y(reg,ind)      = sum((regg,prd), SUP_model(regg,prd,reg,ind) ) ;

X(reg,prd)      = sum((regg,ind), SUP_model(reg,prd,regg,ind) ) ;

LS(reg)         = sum((lab,regg,ind),VALUE_ADDED_model(reg,lab,regg,ind) ) ;

KS(reg)         = sum((cap,regg,ind),VALUE_ADDED_model(reg,cap,regg,ind) ) ;

Display
Y
X
LS
KS
;

*coprodA(reg,prd,regg,ind)$Y(regg,ind)
*                 = SUP_model(reg,prd,regg,ind) / Y(regg,ind) ;

coprodB(reg,prd,regg,ind)$SUP_model(reg,prd,regg,ind)
                = SUP_model(reg,prd,regg,ind) / X(reg,prd) ;

a(reg,prd,regg,ind)$INTER_USE_bp_model(reg,prd,regg,ind)
                = INTER_USE_bp_model(reg,prd,regg,ind) / Y(regg,ind) ;

tsp_ind(reg,prd,regg,ind)$INTER_USE_ts_model(reg,prd,regg,ind)
                = INTER_USE_ts_model(reg,prd,regg,ind) /
                  INTER_USE_bp_model(reg,prd,regg,ind) ;

tpr(reg,ntp,regg,ind)$VALUE_ADDED_model(reg,ntp,regg,ind)
                = VALUE_ADDED_model(reg,ntp,regg,ind) / Y(regg,ind) ;

facL(reg,kl,regg,ind)$VALUE_ADDED_model(reg,kl,regg,ind)
                = VALUE_ADDED_model(reg,kl,regg,ind) / Y(regg,ind) ;

uip_ind(reg,ind,row,uip)$IMPORT_USE_IND_model(reg,ind,row,uip)
                = IMPORT_USE_IND_model(reg,ind,row,uip) / Y(reg,ind) ;

tsp_disrt(reg,tsp,regg,fd)$TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd)
                = TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd) /
                  sum((reggg,fdd), TAX_SUB_PRD_DISTR_model(reg,tsp,reggg,fdd) ) ;

fdL(reg,prd,regg,fd)$FINAL_USE_bp_model(reg,prd,regg,fd)
                = FINAL_USE_bp_model(reg,prd,regg,fd) /
                  sum((reggg,prdd), FINAL_USE_bp_model(reggg,prdd,regg,fd) ) ;

tsp_fd(reg,prd,regg,fd)$FINAL_USE_ts_model(reg,prd,regg,fd)
                = FINAL_USE_ts_model(reg,prd,regg,fd) /
                  FINAL_USE_bp_model(reg,prd,regg,fd) ;


Display
*coprodA
coprodB
a
tsp_ind
tpr
facL
uip_ind
tsp_disrt
fdL
tsp_fd
;
