* File:   scr/model_parameters.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 9 June 2014 (simple CGE formulation)

* gams-master-file: main.gms

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
;

Alias
    (kl,kll)
;

* ========================= Declaration of parameters ==========================

Parameters
        Y(reg,ind)                  output vector by activity
        X(reg,prd)                  output vector by product
        KLS(reg,kl)                 supply of production factors
        INC(reg,fd)                 total income of final demand categories

*        coprodA(reg,prd,regg,ind)   co-production coefficients with mix per industry - corresponds to product technology assumption
        coprodB(reg,prd,regg,ind)   co-production coefficients with mix per product  - corresponds to industry technology assumption (relationin volume)
        a(reg,prd,regg,ind)         technical input coefficients for intermediate inputs (relation in volume)
        aVA(regg,ind)               technical input coefficients for factors of production (relation in volume)
        facC(reg,kl,regg,ind)       Cobb-Douglas share coefficients for factors of production (relation in value)
        facA(regg,ind)              Cobb-Douglas scale parameter for factor of production

        fdL(reg,prd,regg,fd)        leontief coefficients for final demand (relation in volume)

        tsp_ind(reg,prd,regg,ind)   tax and subsidies on products rates for industries (relation in value)
        tsp_fd(reg,prd,regg,fd)     tax and subsidies on products rates for final demand (relation in value)
        ntp_ind(reg,ntp,regg,ind)   net taxes on production rates (relation in value)

        fac_distr(reg,kl,regg,fd)   distribution shares of factor income to budgets of final demand (shares)
        tsp_distr(reg,tsp,regg,fd)  distribution shares of taxes and subsidies on products income to budgets of final demand (shares)
        ntp_distr(reg,ntp,regg,fd)  distribution shares of taxes and subsidies on production income to budgets of final demand (shares)
;


* ========================== Definition of parameters ==========================

*## Aggregates ##
Y(reg,ind)      = sum((regg,prd), SUP_model(regg,prd,reg,ind) ) ;

X(reg,prd)      = sum((regg,ind), SUP_model(reg,prd,regg,ind) ) ;

KLS(reg,kl)     = sum((regg,ind),VALUE_ADDED_model(reg,kl,regg,ind) ) ;

INC(reg,fd)     = sum((regg,prd), FINAL_USE_bp_model(regg,prd,reg,fd) ) +
                  sum((regg,prd), FINAL_USE_ts_model(regg,prd,reg,fd) ) +
                  sum((regg,fdd), INCOME_DISTR_model(reg,fd,regg,fdd) ) +
                  sum((row,uip), IMPORT_USE_FD_model(reg,fd,row,uip) ) ;

Display
Y
X
KLS
INC
;


*## Parameters of production function ##

* Leontief co-production coefficients according to product technology assumption
* (not used at the moment)
*coprodA(reg,prd,regg,ind)$Y(regg,ind)
*                 = SUP_model(reg,prd,regg,ind) / Y(regg,ind) ;

* Leontief co-production coefficients according to industry technology
* assumption
coprodB(reg,prd,regg,ind)$SUP_model(reg,prd,regg,ind)
                = SUP_model(reg,prd,regg,ind) / X(reg,prd) ;

* Leontief technical input coefficients for intermediate inputs
a(reg,prd,regg,ind)$INTER_USE_bp_model(reg,prd,regg,ind)
                = INTER_USE_bp_model(reg,prd,regg,ind) / Y(regg,ind) ;

* Leontief technical input coefficients for the nest of aggregated factors of
* production
aVA(regg,ind)$sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) )
                = sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) ) / Y(regg,ind) ;

* Cobb-Douglas share coefficients for factors of production within the
* aggregated nest
facC(reg,kl,regg,ind)$VALUE_ADDED_model(reg,kl,regg,ind)
                = VALUE_ADDED_model(reg,kl,regg,ind) /
                  sum((reggg,kll), VALUE_ADDED_model(reggg,kll,regg,ind) ) ;

* Cobb-Douglas scale parameter for the nest of aggregated factors of production
facA(regg,ind)$sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) )
                = sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) ) /
                  prod((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind)**facC(reg,kl,regg,ind) ) ;

Display
*coprodA
coprodB
a
aVA
facC
facA
;


*## Parameters of final demand function ##

* Leontief coefficients for final demand
fdL(reg,prd,regg,fd)$FINAL_USE_bp_model(reg,prd,regg,fd)
                = FINAL_USE_bp_model(reg,prd,regg,fd) /
                  sum((reggg,prdd), FINAL_USE_bp_model(reggg,prdd,regg,fd) ) ;

Display
fdL
;


*## Tax rates ##

* Net product tax (taxes less subsidies) rates on intermediate consumption
tsp_ind(reg,prd,regg,ind)$INTER_USE_ts_model(reg,prd,regg,ind)
                = INTER_USE_ts_model(reg,prd,regg,ind) /
                  INTER_USE_bp_model(reg,prd,regg,ind) ;

* Net product tax (taxes less subsidies) rates on final demand
tsp_fd(reg,prd,regg,fd)$FINAL_USE_ts_model(reg,prd,regg,fd)
                = FINAL_USE_ts_model(reg,prd,regg,fd) /
                  FINAL_USE_bp_model(reg,prd,regg,fd) ;

* Net production tax (taxes less subsidies) rates
ntp_ind(reg,ntp,regg,ind)$VALUE_ADDED_model(reg,ntp,regg,ind)
                = VALUE_ADDED_model(reg,ntp,regg,ind) / Y(regg,ind) ;

Display
tsp_ind
tsp_fd
ntp_ind
;


*## Distribution of value added and tax revenues to final consumers ##

* Distribution shares of factor revenues to budgets of final consumers
fac_distr(reg,kl,regg,fd)$VALUE_ADDED_DISTR_model(reg,kl,regg,fd)
                = VALUE_ADDED_DISTR_model(reg,kl,regg,fd) /
                  sum((reggg,fdd), VALUE_ADDED_DISTR_model(reg,kl,reggg,fdd) ) ;

* Distribution shares of net tax on products revenues to budgets of final
* consumers
tsp_distr(reg,tsp,regg,fd)$TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd)
                = TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd) /
                  sum((reggg,fdd), TAX_SUB_PRD_DISTR_model(reg,tsp,reggg,fdd) ) ;

* Distribution shares of net tax on production revenues to budgets of final
* consumers
ntp_distr(reg,ntp,regg,fd)$VALUE_ADDED_DISTR_model(reg,ntp,regg,fd)
                = VALUE_ADDED_DISTR_model(reg,ntp,regg,fd) /
                  sum((reggg,fdd), VALUE_ADDED_DISTR_model(reg,ntp,reggg,fdd) ) ;


Display
fac_distr
tsp_distr
ntp_distr
;
