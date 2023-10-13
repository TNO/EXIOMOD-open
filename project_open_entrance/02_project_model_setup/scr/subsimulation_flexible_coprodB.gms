* File:   Endogenous coprodB coefficients
* Author: Hettie Boonman
* Date:   08 December 2017
* Adjusted:

* gams-master-file: run_EXIOMOD.gms

$ontext startdoc

$offtext

* ==============================  Define parameters ============================


Sets
    ind_elec(ind)
/
iELCC     'Production of electricity by coal'
iELCG     'Production of electricity by gas'
iELCN     'Production of electricity by nuclear'
iELCH     'Production of electricity by hydro'
iELCW     'Production of electricity by wind'
iELCO     'Production of electricity by petroleum and other oil derivatives'
iELCB     'Production of electricity by biomass and waste'
iELCS     'Production of electricity by solar photovoltaic'
iELCE     'Production of electricity nec'
iELCT     'Production of electricity by Geothermal'
/
;

Alias (ind_elec, indd_elec)

Parameters
    coprodB_fixed(regg,ind)                 Coefficients for coprodB in 2011
    coprodB_sum_elec(regg)                  sum of electricity produced by electricity sectors
    nENER_factor(regg,ind)
    coprobB_fixed_sum(regg)                 Check if sum of electricity prodced by electricity sectors sums up to one
    util_elec(regg,ind)
    shares_util_elec(regg,ind)
    nENER_V_adjusted(regg,ind)
    nENER_addition(regg,ind)
    coprodB_not_ener(reg,prd,regg,ind)
;

* Sum of electricity product produced by electricity sector
coprodB_sum_elec(reg) =
    sum( (regg,ind_elec), coprodB(reg,'pELEC',regg,ind_elec) ) ;

* Share of electricity produced by electricity sectors. Sums up to one.
coprodB_fixed(regg,ind_elec)
    = sum(reg, coprodB(reg,'pELEC',regg,ind_elec) ) /
      coprodB_sum_elec(regg) ;

* Check if sum of coprodB_fixed sum up to one. All electricity sectors together
* produce 100% of electricity
coprobB_fixed_sum(regg)
    =sum(ind_elec, coprodB_fixed(regg,ind_elec) ) ;

* When nENER does not exist, but coprodB_fixed does exist, we need to include
* extra values in prodB_fixed
nENER_addition(regg,ind_elec)
    = coprodB_fixed(regg,ind_elec)$
        (not nENER_V.L(regg,ind_elec) and coprodB_fixed(regg,ind_elec))
     ;

* When nENER does not exist, but coprodB_fixed does exist, we need to include
* extra values in prodB_fixed
nENER_V_adjusted(regg,ind_elec)
    = nENER_V.L(regg,ind_elec)
        + nENER_addition(regg,ind_elec)
     ;

* Factor that rescales nENER_V in 2011, such that the shares are optimal for
* 2011.
* See notes for details on how I obtained this scaling factor.
nENER_factor(regg,ind_elec)$nENER_V_adjusted(regg,ind_elec)
    = ( 1 / nENER_V_adjusted(regg,ind_elec) )
      * log( coprodB_fixed(regg,ind_elec) / coprodB_fixed(regg,'iELCB') ) ;

* Create exponentional of utility function
util_elec(regg,ind_elec)$coprodB_fixed(regg,ind_elec)
    = system.exp( nENER_factor(regg,ind_elec) * nENER_V_adjusted(regg,ind_elec) )  ;


* Create shares based on utilities. These should be equal to coprodB_fixed.
shares_util_elec(regg,ind_elec)
    = util_elec(regg,ind_elec) /
        sum(indd_elec, util_elec(regg,indd_elec) ) ;

* Fix the following values in the coprodB table
coprodB_not_ener(reg,prd,regg,ind)
    = coprodB(reg,prd,regg,ind) ;

coprodB_not_ener(regg,'pELEC',regg,ind_elec)
    = 0 ;


Parameter
check(regg,ind)
;

check(regg,ind_elec)
    = shares_util_elec(regg,ind_elec) - coprodB_fixed(regg,ind_elec) ;
check(regg,ind_elec)$(check(regg,ind_elec) lt 0.00000001) = 0;


Display
    coprodB_sum_elec
    coprodB_fixed
    coprobB_fixed_sum
    nENER_V.L
    nENER_V_adjusted
    nENER_factor
    util_elec
    shares_util_elec
    check
    nENER_addition
;




* ============Define simulation specific variables/ equations===================

Variables
    ELEC_UTIL_V(regg,ind)                Utility from electricity technology
    ELEC_SHARE_V(regg,ind)               Share parameter
    nENER_ADJ_V(regg,ind)                Adjusted variable for nENER
    COPRODB_V(reg,prd,regg,ind)          Adjusted coprodB parameter

;


Equations
    EQELEC_UTIL(regg,ind)                Utility from electricity technology
    EQELEC_SHARE(regg,ind)               Share parameter
    EQnENER_ADJ(regg,ind)                Adjusted variable for nENER
    EQCOPRODB(reg,prd,regg,ind)
    EQY_COPRODB(regg,ind)

;

* EQUATION 1: Adjusted nENER_V variable. There should be a value for nENER_V_ADJ
* where there is not value in nENER_V and there is a value in coprodB_fixed.
EQnENER_ADJ(regg,ind_elec)..
    nENER_ADJ_V(regg,ind_elec)
    =E=
*    nENER_V(regg,ind_elec)
    nKLE_V(regg,ind_elec) * aE(regg,ind_elec) *
    ( PnENER_V(regg,ind_elec) / PnKLE_V(regg,ind_elec) )**( -elasKLE(regg,ind_elec) )
    + nENER_addition(regg,ind_elec)
;

*EQUATION 2: Calculate utility obtained from electricity using nENER_ADJ_V and
* a scalar.
EQELEC_UTIL(regg,ind_elec)..
    ELEC_UTIL_V(regg,ind_elec)$coprodB_fixed(regg,ind_elec)
    =E=
    system.exp( nENER_factor(regg,ind_elec)
        * nENER_ADJ_V(regg,ind_elec) )
;

* Equation 3: Calculate share per electricity industry that produces electricity
EQELEC_SHARE(regg,ind_elec)..
    ELEC_SHARE_V(regg,ind_elec)
    =E=
    ELEC_UTIL_V(regg,ind_elec)
        / sum(indd_elec, ELEC_UTIL_V(regg,indd_elec) )
;

* Equation 4: produce coprodB when
EQCOPRODB(reg,'pELEC',regg,ind_elec)..
    COPRODB_V(regg,'pELEC',regg,ind_elec)
    =E=
    ELEC_SHARE_V(regg,ind_elec) * coprodB_sum_elec(regg)
;

* EQUATION 2.2B: Output level of activities: given total amount of output per
* product, required output per activity (regg,ind) is derived based on fixed
* sales structure on each product market (reg,prd). EQUATION 2.2A corresponds to
* product technology assumption in input-output analysis, EQUATION 2.2B
* corresponds to industry technology assumption in input-output analysis.
* EQUATION 2.2B is suitable for input-output and CGE analysis.
EQY_COPRODB(regg,ind)..
    Y_V(regg,ind)
    =E=
    sum((reg,prd), COPRODB_V(reg,prd,regg,ind) * X_V(reg,prd) ) ;


* =============================== Set parameters ===============================


ELEC_UTIL_V.L(regg,ind_elec)               = util_elec(regg,ind_elec) ;
ELEC_SHARE_V.L(regg,ind_elec)              = shares_util_elec(regg,ind_elec) ;
nENER_ADJ_V.L(regg,ind_elec)               = nENER_V_adjusted(regg,ind_elec) ;
COPRODB_V.L(reg,prd,regg,ind)              = coprodB(reg,prd,regg,ind) ;


ELEC_UTIL_V.FX(regg,ind)$(not util_elec(regg,ind))               = 0 ;
ELEC_SHARE_V.FX(regg,ind)$(not shares_util_elec(regg,ind) )      = 0 ;
nENER_ADJ_V.FX(regg,ind)$(not nENER_V_adjusted(regg,ind) )       = 0 ;
COPRODB_V.FX(reg,prd,regg,ind)$( not coprodB(reg,prd,regg,ind) ) = 0 ;
COPRODB_V.FX(reg,prd,regg,ind)$coprodB_not_ener(reg,prd,regg,ind) = coprodB_not_ener(reg,prd,regg,ind) ;


* =============================== Scaling ======================================

* EQUATION 1:
EQELEC_UTIL.SCALE(regg,ind)$(ELEC_UTIL_V.L(regg,ind) gt 0)
    = ELEC_UTIL_V.L(regg,ind) ;
ELEC_UTIL_V.SCALE(regg,ind)$(ELEC_UTIL_V.L(regg,ind) gt 0)
    = ELEC_UTIL_V.L(regg,ind) ;

EQELEC_UTIL.SCALE(regg,ind)$(ELEC_UTIL_V.L(regg,ind) lt 0)
    = -ELEC_UTIL_V.L(regg,ind) ;
ELEC_UTIL_V.SCALE(regg,ind)$(ELEC_UTIL_V.L(regg,ind) lt 0)
    = -ELEC_UTIL_V.L(regg,ind) ;


* EQUATION 2:
EQELEC_SHARE.SCALE(regg,ind)$(ELEC_SHARE_V.L(regg,ind) gt 0)
    = ELEC_SHARE_V.L(regg,ind) ;
ELEC_SHARE_V.SCALE(regg,ind)$(ELEC_SHARE_V.L(regg,ind) gt 0)
    = ELEC_SHARE_V.L(regg,ind) ;

EQELEC_SHARE.SCALE(regg,ind)$(ELEC_SHARE_V.L(regg,ind) lt 0)
    = -ELEC_SHARE_V.L(regg,ind) ;
ELEC_SHARE_V.SCALE(regg,ind)$(ELEC_SHARE_V.L(regg,ind) lt 0)
    = -ELEC_SHARE_V.L(regg,ind) ;


* EQUATION 3:
EQnENER_ADJ.SCALE(regg,ind)$(nENER_ADJ_V.L(regg,ind) gt 0)
    = nENER_ADJ_V.L(regg,ind) ;
nENER_ADJ_V.SCALE(regg,ind)$(nENER_ADJ_V.L(regg,ind) gt 0)
    = nENER_ADJ_V.L(regg,ind) ;

EQnENER_ADJ.SCALE(regg,ind)$(nENER_ADJ_V.L(regg,ind) lt 0)
    = -nENER_ADJ_V.L(regg,ind) ;
nENER_ADJ_V.SCALE(regg,ind)$(nENER_ADJ_V.L(regg,ind) lt 0)
    = -nENER_ADJ_V.L(regg,ind) ;


* EQUATION 4:
EQCOPRODB.SCALE(reg,prd,regg,ind)$(COPRODB_V.L(reg,prd,regg,ind) gt 0)
    = COPRODB_V.L(reg,prd,regg,ind) ;
COPRODB_V.SCALE(reg,prd,regg,ind)$(COPRODB_V.L(reg,prd,regg,ind) gt 0)
    = COPRODB_V.L(reg,prd,regg,ind) ;

EQCOPRODB.SCALE(reg,prd,regg,ind)$(COPRODB_V.L(reg,prd,regg,ind) lt 0)
    = -COPRODB_V.L(reg,prd,regg,ind) ;
COPRODB_V.SCALE(reg,prd,regg,ind)$(COPRODB_V.L(reg,prd,regg,ind) lt 0)
    = -COPRODB_V.L(reg,prd,regg,ind) ;


* Equation 2.2.b
EQY_COPRODB.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;


EQY_COPRODB.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;




* ================= Define models with new variables/equations =================






