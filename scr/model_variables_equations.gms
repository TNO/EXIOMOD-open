* File:   scr/model_variables_equations.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 9 June 2014 (simple CGE formulation)

* gams-master-file: main.gms

$ontext startdoc
This `.gms` file is one of the `.gms` files part of the `main.gms` file and includes the equations and model formulation. Please start from `main.gms`.

This `.gms` file consists of the following parts:

1. *Declaration of variables*

    Output by activity and product are here the variables which can be adjusted in the model. The variable `Cshock` is defined later in the `%simulation%` gms file.

2. *Declaration of equations*

    One of the equations is an artificial objective function. This is because GAMS only understands a model run with an objective function. If you would like to run it without one, you can use such an artificial objective function which is basically put to any value such as 1.

3. *Definition of equations*

4. *Definition of levels and lower and upper bounds and fixed variables*

    Upper and lower bounds can be adjusted when needed.

5. *Declaration of equations in the model*

    This states which equations are included in which model. The models are based on either product technology or activity technology. The `main.gms` file includes the option to choose one of the two types of technologies.

$offtext

* ========================== Declaration of variables ==========================

* Endogenous variables
Variables
        Y_V(reg,ind)                    output vector industries
        X_V(reg,prd)                    output vector products

        INTER_USE_V(reg,prd,regg,ind)   use of intermediate inputs
        KL_V(reg,kl,regg,ind)           use of production factors

        FINAL_USE_V(reg,prd,regg,fd)    final use
        CBUD_V(reg,fd)                  budget available for final use
        INC_V(reg,fd)                   gross income (after recieving all revenues and transfers, but before paying transfers)

        FACREV_V(reg,kl)                factors of production revenue
        TSPREV_V(reg,tsp)               net tax on products revenue
        NTPREV_V(reg,ntp)               net tax on production revenue

        P_V(reg,prd)                    vector of basic product prices
        PY_V(reg,ind)                   vector on total industry output prices
        PKL_V(reg,kl)                   vector of factor prices

        PFD_V(reg,fd)                   final use price index
;

*Positive variables
*Y_V
*X_V
*INTER_USE_V
*KL_V
*CBUD_V
*INC_V
*P_V
*PY_V
*PKL_V
*PFD_V
;

* Exogenous variables
Variables
*        coprodA_V(reg,prd,regg,ind)     co-production coefficients with mix per industry
        coprodB_V(reg,prd,regg,ind)     co-production coefficients with mix per product
        a_V(reg,prd,regg,ind)           technical input coefficients for intermediate inputs
        aVA_V(regg,ind)                 technical input coefficients for factors of production
        facC_V(reg,kl,regg,ind)         Cobb-Douglas share coefficients for factors of production
        facA_V(regg,ind)                Cobb-Douglas scale parameter for factor of production

        fdL_V(reg,prd,regg,fd)          leontief coefficients for final demand

        tsp_ind_V(reg,prd,regg,ind)     tax and subsidies on products rates for industries
        tsp_fd_V(reg,prd,regg,fd)       tax and subsidies on products rates for final demand
        ntp_ind_V(reg,ntp,regg,ind)     net taxes on production rates

        fac_distr_V(reg,kl,regg,fd)     distribution shares of factor income to budgets of final demand
        tsp_distr_V(reg,tsp,regg,fd)    distribution shares of taxes and subsidies on products income to budgets of final demand
        ntp_distr_V(reg,ntp,regg,fd)    distribution shares of taxes and subsidies on production income to budgets of final demand

        KLS_V(reg,kl)                   supply of production factors
        INCTRANSFER_V(regg,fdd,reg,fd)  income transfers
;

* Artificial objective
* See explanation on artificial objective function above.
Variables
        obj            artificial objective value

;


* ========================== Declaration of equations ==========================

Equations
        EQBAL(reg,prd)              product market balance
        EQINTU(reg,prd,regg,ind)    demand for intermediate inputs
*        EQX(reg,prd)                output level of products with mix per industry
        EQY(reg,ind)                output level of activities with mix per product

        EQKL(reg,kl,regg,ind)       demand for production factors

        EQFU(reg,prd,regg,fd)       demand for final use of products

        EQCBUD(reg,fd)              budget available for final use
        EQINC(reg,fd)               gross income

        EQFACREV(reg,kl)            factors of production revenue
        EQTSPREV(reg,tsp)           net tax on products revenue
        EQNTPREV(reg,ntp)           net tax on production revenue

        EQP(reg,prd)                balance between price per product and price per activity
        EQPFD(reg,fd)               price index for final use

        EQPKL(reg,kl)               production factors market balance
        EQPY(reg,ind)               revenues equals costs (including possible excessive profit)

        EQOBJ                       artificial objective function
;


* ========================== Definition of equations ===========================

* ## Input-output block ##

* Product market balance: product output is equal to total uses, including
* intermediate use, final use and, in case of an open economy, export. Product
* market balance is expressed in volume.
EQBAL(reg,prd)..
        sum((regg,fd), FINAL_USE_V(reg,prd,regg,fd)) +
        sum((regg,ind), INTER_USE_V(reg,prd,regg,ind) )
        =E=
        X_V(reg,prd) ;

* Demand for intermediate inputs: corresponds to the first order conditions of
* the selected production function.
EQINTU(reg,prd,regg,ind)..
        INTER_USE_V(reg,prd,regg,ind)
        =E=
        a_V(reg,prd,regg,ind) * Y_V(regg,ind) ;

*EQX(reg,prd)..
*        X_V(reg,prd)
*        =E=
*        sum((regg,ind), coprodA_V(reg,prd,regg,ind) * Y_V(regg,ind)) ;

* Output level of activities: given total amount of output per product required
* output per activity is derived based on fixed sales structure on each market.
EQY(reg,ind)..
        Y_V(reg,ind)
        =E=
        sum((regg,prd), coprodB_V(regg,prd,reg,ind) * X_V(regg,prd)) ;

* Demand for production factors: corresponds to the first order conditions of
* the selected production function.
EQKL(reg,kl,regg,ind)..
        KL_V(reg,kl,regg,ind)
        =E=
        facC_V(reg,kl,regg,ind) / prod((reggg,kll)$facC(reggg,kll,regg,ind),
        facC_V(reggg,kll,regg,ind)**facC_V(reggg,kll,regg,ind) ) *
        ( 1 / PKL_V(reg,kl) ) * aVA_V(regg,ind) * Y_V(regg,ind) / facA_V(regg,ind) *
        prod((reggg,kll), PKL_V(reggg,kll)**facC_V(reggg,kll,regg,ind) ) ;

* Demand for final use of products: corresponds to the first order conditions of
* the selected utility function.
EQFU(reg,prd,regg,fd)..
        FINAL_USE_V(reg,prd,regg,fd)
        =E=
        fdL_V(reg,prd,regg,fd) * CBUD_V(regg,fd) / PFD_V(regg,fd) ;

* Budget available for final use: gross income minus transfers to other
* institutional agents.
EQCBUD(reg,fd)..
        CBUD_V(reg,fd)
        =E=
        INC_V(reg,fd) - sum((regg,fdd), INCTRANSFER_V(reg,fd,regg,fdd) ) ;

* Gross income: composed of factor and tax revenues transfers to the agent, as
* well as income transfers from other institutional agents.
EQINC(reg,fd)..
        INC_V(reg,fd)
        =E=
        sum((regg,kl), FACREV_V(regg,kl) * fac_distr_V(regg,kl,reg,fd) ) +
        sum((regg,tsp), TSPREV_V(regg,tsp) * tsp_distr_V(regg,tsp,reg,fd) ) +
        sum((regg,ntp), NTPREV_V(regg,ntp) * ntp_distr_V(regg,ntp,reg,fd) ) +
        sum((regg,fdd), INCTRANSFER_V(regg,fdd,reg,fd)) ;

* Factors of production revenue: sum of revenue earned by each production
* factor.
EQFACREV(reg,kl)..
        FACREV_V(reg,kl)
        =E=
        sum((regg,ind), KL_V(reg,kl,regg,ind) * PKL_V(reg,kl) ) ;

* Net tax on products revenue: net tax revenue earned from sales of products.
EQTSPREV(reg,tsp)..
        TSPREV_V(reg,tsp)
        =E=
        sum((regg,prd,ind), INTER_USE_V(regg,prd,reg,ind) * P_V(regg,prd) *
        tsp_ind_V(regg,prd,reg,ind) ) +
        sum((regg,prd,fd), FINAL_USE_V(regg,prd,reg,fd) * P_V(regg,prd) *
        tsp_fd_V(regg,prd,reg,fd) ) ;

* Net tax on production revenue: net tax revenue earned from production
* activities.
EQNTPREV(reg,ntp)..
        NTPREV_V(reg,ntp)
        =E=
        sum((regg,ind), Y_V(regg,ind) * PY_V(regg,ind) *
        ntp_ind_V(reg,ntp,regg,ind) ) ;

* Balance between price per product and price per activity: price per product is
* equal to weighted average of prices per activity.
EQP(reg,prd)..
        P_V(reg,prd) * X_V(reg,prd)
        =E=
        sum((regg,ind), PY_V(regg,ind) * coprodB_V(reg,prd,regg,ind) *
        X_V(reg,prd) ) ;

* Price index for final use: weighted average of products' purchaser prices.
* At the moment the equation is not defined to the price choses as a numeraire.
EQPFD(reg,fd)$((not sameas(reg,'US')) or (not sameas(fd,'FU')))..
        PFD_V(reg,fd)
        =E=
        sum((regg,prd), P_V(regg,prd) * fdL_V(regg,prd,reg,fd) *
        ( 1 + tsp_fd_V(regg,prd,reg,fd) ) ) ;

* Production factors market balance: supply of each factor is equal to the
* demand on this factor plus, if modeled, unemployment.
EQPKL(reg,kl)..
        KLS_V(reg,kl)
        =E=
        sum((regg,ind), KL_V(reg,kl,regg,ind) ) ;

* Revenues equals costs: revenues earned from product sales equal to cost of
* intermediate products, factors of production, all associated taxes and, if
* modeled, excessive profit margins.
EQPY(reg,ind)..
        Y_V(reg,ind) * PY_V(reg,ind) *
        ( 1 - sum((regg,ntp), ntp_ind_V(regg,ntp,reg,ind) ) )
        =E=
        sum((regg,prd), INTER_USE_V(regg,prd,reg,ind) * P_V(regg,prd) *
        ( 1 + tsp_ind_V(regg,prd,reg,ind) ) ) +
        sum((regg,kl), KL_V(regg,kl,reg,ind) * PKL_V(regg,kl) ) ;

* Artificial objective function: only relevant for users of conopt solver.
EQOBJ.. obj
        =E=
        1 ;


* ======== Define levels and lower and upper bounds and fixed variables ========

* Endogenous variables
Y_V.L(reg,ind)     = Y(reg,ind) ;
X_V.L(reg,prd)     = X(reg,prd) ;

INTER_USE_V.L(reg,prd,regg,ind)    = INTER_USE_bp_model(reg,prd,regg,ind) ;
KL_V.L(reg,kl,regg,ind) = VALUE_ADDED_model(reg,kl,regg,ind) ;

FINAL_USE_V.L(reg,prd,regg,fd) = FINAL_USE_bp_model(reg,prd,regg,fd) ;
CBUD_V.L(reg,fd) = sum((regg,prd), FINAL_USE_bp_model(regg,prd,reg,fd) + FINAL_USE_ts_model(regg,prd,reg,fd) ) ;
INC_V.L(reg,fd) = INC(reg,fd) ;

FACREV_V.L(reg,kl) = sum((regg,fd), VALUE_ADDED_DISTR_model(reg,kl,regg,fd) ) ; ;
TSPREV_V.L(reg,tsp) = sum((regg,fd), TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd) ) ;
NTPREV_V.L(reg,ntp) = sum((regg,fd), VALUE_ADDED_DISTR_model(reg,ntp,regg,fd) ) ;

P_V.L(reg,prd) = 1 ;
PY_V.L(reg,ind) = 1 ;
PKL_V.L(reg,kl) = 1 ;

PFD_V.L(reg,fd) = sum((regg,prd), fdL(regg,prd,reg,fd) * ( 1 + tsp_fd(regg,prd,reg,fd) ) ) ; ;

* One endogenous variable is chosen to be a numeraire
PFD_V.FX('US','FU') = 1 ;


* Exogenous variables
*coprodA_V.FX(reg,prd,regg,ind)   = coprodA(reg,prd,regg,ind)        ;
coprodB_V.FX(reg,prd,regg,ind)   = coprodB(reg,prd,regg,ind)        ;
a_V.FX(reg,prd,regg,ind)         = a(reg,prd,regg,ind)              ;
aVA_V.FX(regg,ind)               = aVA(regg,ind)                    ;
facC_V.FX(reg,kl,regg,ind)       = facC(reg,kl,regg,ind)            ;
facA_V.FX(regg,ind)              = facA(regg,ind)                   ;

fdL_V.FX(reg,prd,regg,fd)        = fdL(reg,prd,regg,fd)             ;

tsp_ind_V.FX(reg,prd,regg,ind)   = tsp_ind(reg,prd,regg,ind)        ;
tsp_fd_V.FX(reg,prd,regg,fd)     = tsp_fd(reg,prd,regg,fd)          ;
ntp_ind_V.FX(reg,ntp,regg,ind)   = ntp_ind(reg,ntp,regg,ind)        ;

fac_distr_V.FX(reg,kl,regg,fd)   = fac_distr(reg,kl,regg,fd)        ;
tsp_distr_V.FX(reg,tsp,regg,fd)  = tsp_distr(reg,tsp,regg,fd)       ;
ntp_distr_V.FX(reg,ntp,regg,fd)  = ntp_distr(reg,ntp,regg,fd)       ;

KLS_V.FX(reg,kl)                 = KLS(reg,kl)                      ;
INCTRANSFER_V.FX(reg,fd,regg,fdd) = INCOME_DISTR_model(reg,fd,regg,fdd) ;


* ========================== Declare model equations ===========================

Model IO_product_technology
/
EQBAL
EQINTU
EQX
EQOBJ
/
;

Model IO_industry_technology
/
EQBAL
EQINTU
EQY
EQOBJ
/
;

Model CGE_TRICK
/
EQBAL
EQINTU
EQY
EQKL
EQFU
EQCBUD
EQINC
EQFACREV
EQTSPREV
EQNTPREV
EQP
EQPFD
EQPKL
EQPY
EQOBJ
/
;

Model CGE_MCP
/
EQBAL.X_V
EQINTU.INTER_USE_V
EQY.Y_V
EQKL.KL_V
EQFU.FINAL_USE_V
EQCBUD.CBUD_V
EQINC.INC_V
EQFACREV.FACREV_V
EQTSPREV.TSPREV_V
EQNTPREV.NTPREV_V
EQP.P_V
EQPFD.PFD_V
EQPKL.PKL_V
EQPY.PY_V
/
;
