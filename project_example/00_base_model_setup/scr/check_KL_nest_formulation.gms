* File:   %project%/00_base_model_setup/scr/check_KL_nest_formulation.gms
* Author: Jelmer Ypma
* Date:   17 October 2014

* gams-master-file: run_EXIOMOD.gms

$ontext startdoc
This simulation scripts checks whether the 'flexible' specification of a CES
function, which is used in the EXIOMOD_base_model codes is indeed correct and
produces result identical to explicit Cobb-Douglas and CES specifications. The
check is performed on only one specific nest of the model, namely capital-labour
block of the production function.

Both checks are only relevant if the initial level of productivity of all
factors (fprod) is set to 1.

Check on Cobb-Douglas specification is only relevant when the value of elasKL is
calibrated close to 1, e.g. 0.999 or 1.001.

The script consists of the following parts:

 * Declaration and definition of parameters required for explicit specification
   of Cobb-Douglas and CES functions.
 * Declaration and definition of new equations with explicit specification of
   Cobb-Douglas and CES functions.
 * Definition of new models, where some of the standard equations are replaced
   with the new ones.
 * Setup of the experiment and simulation of the three model specifications.
 * Reporting of the results.
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ======== Declaration and definition of simulation specific parameters ========

* Calibration of production function
Parameters
    facC(reg,va,regg,ind)       Cobb-Douglas share coefficients for factors
                                # of production (relation in value)
    facA(regg,ind)              Cobb-Douglas scale parameter for factors of
                                # production

    gammaCES(reg,va,regg,ind)   CES share coefficients for factors of production
                                # (relation in value)
    aCES(regg,ind)              CES slace parameter for factos of production
;


* Cobb-Douglas share coefficients for factors of production within the
* aggregated nest
facC(reg,kl,regg,ind)$VALUE_ADDED(reg,kl,regg,ind)
    = VALUE_ADDED(reg,kl,regg,ind) /
    sum((reggg,kll), VALUE_ADDED(reggg,kll,regg,ind) ) ;

* Cobb-Douglas scale parameter for the nest of aggregated factors of production
facA(regg,ind)$sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) )
    = sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) /
    prod((reg,kl), VALUE_ADDED(reg,kl,regg,ind)**facC(reg,kl,regg,ind) ) ;

Display
facC
facA
;

* CES share parameters
gammaCES(reg,kl,regg,ind)$VALUE_ADDED(reg,kl,regg,ind)
    = VALUE_ADDED(reg,kl,regg,ind)**( 1 / elasKL(regg,ind) ) /
    sum((reggg,kll),
    VALUE_ADDED(reggg,kll,regg,ind)**( 1 / elasKL(regg,ind) ) ) ;

* CES scale parameters
aCES(regg,ind)$sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) )
    = sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) ) /
    sum((reg,kl), gammaCES(reg,kl,regg,ind) *
    VALUE_ADDED(reg,kl,regg,ind)**
    ( ( elasKL(regg,ind) - 1 ) / elasKL(regg,ind) ))**
    ( elasKL(regg,ind) / ( elasKL(regg,ind) - 1 ) ) ;

Display
gammaCES
aCES
;

* ====== Declaration of parameters for saving result for post-processing =======

Parameters
    KL_V_ORIG(reg,va,regg,ind)          model solution for KL with flexible CES
                                        # formulation
    KL_V_COBBDOUGLAS(reg,va,regg,ind)   model solution for KL with explicit
                                        # Cobb-Douglas formulation
    KL_V_CES(reg,va,regg,ind)           model solution for KL with explicit CES
                                        # formulation
;

* = Declaration and definition of simulation specific variables and/or equations

Equations
    EQKL_COBBDOUGLAS(reg,va,regg,ind)   demand for specific production factors
                                        # with Cobb-Douglas specification
    EQKL_CES(reg,va,regg,ind)           demand for specific production factors
                                        # with CES specification
    EQPnKL_CES(regg,ind)                balance between specific production
                                        # factors price and aggregate production
                                        # factors price with CES specification
;

* EQUAION 2.2 COBB-DOUGLAS: Demand for specific production factors in explicit
* Cobb-Douglas form.
EQKL_COBBDOUGLAS(reg,kl,regg,ind)$VALUE_ADDED(reg,kl,regg,ind)..
    KL_V(reg,kl,regg,ind)
    =E=
    facC(reg,kl,regg,ind) / prod((reggg,kll)$facC(reggg,kll,regg,ind),
    facC(reggg,kll,regg,ind)**facC(reggg,kll,regg,ind) ) *
    ( 1 / PKL_V(reg,kl) ) * nKL_V(regg,ind) / facA(regg,ind) *
    prod((reggg,kll), PKL_V(reggg,kll)**facC(reggg,kll,regg,ind) ) ;

* EQUAION 2.2 CONSTANT ELASTICITY OF SUBSTITUTION: Demand for specific
* production factors in explicit CES form.
EQKL_CES(reg,kl,regg,ind)$VALUE_ADDED(reg,kl,regg,ind)..
    KL_V(reg,kl,regg,ind)
    =E=
    nKL_V(regg,ind) *
    ( gammaCES(reg,kl,regg,ind) / PKL_V(reg,kl) )**elasKL(regg,ind) *
    PnKL_V(regg,ind)**elasKL(regg,ind) *
    aCES(regg,ind)**( elasKL(regg,ind) - 1 ) ;

* EQUATION 10.4 CONSTANT ELASTICITY OF SUBSTITUTION: Price of aggregate
* production factors defines in explicit CES form, can be only used in
* combination with EQUATION 9 CONSTANT ELASTICITY OF SUBSTITUTION.
EQPnKL_CES(regg,ind)$sum((reg,kl), VALUE_ADDED(reg,kl,regg,ind) )..
    PnKL_V(regg,ind)
    =E=
    1 / aCES(regg,ind) *
    sum((reg,kl)$gammaCES(reg,kl,regg,ind),
    gammaCES(reg,kl,regg,ind)**elasKL(regg,ind) *
    PKL_V(reg,kl)**( 1 - elasKL(regg,ind) ) )**
    ( 1 / ( 1 - elasKL(regg,ind) ) ) ;

* ====== Define levels and lower and upper bounds and fixed new variables ======


* ======================= Scale new variables/equations ========================

* EQUAION 2.2 COBB-DOUGLAS
EQKL_COBBDOUGLAS.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) gt 0)
    = KL_V.L(reg,kl,regg,ind) ;

EQKL_COBBDOUGLAS.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) lt 0)
    = -KL_V.L(reg,kl,regg,ind) ;

* EQUAION 2.2 CONSTANT ELASTICITY OF SUBSTITUTION
EQKL_CES.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) gt 0)
    = KL_V.L(reg,kl,regg,ind) ;

EQKL_CES.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) lt 0)
    = -KL_V.L(reg,kl,regg,ind) ;

* EQUATION 10.4 CONSTANT ELASTICITY OF SUBSTITUTION
EQPnKL_CES.SCALE(reg,ind)$(nKL_V.L(reg,ind) gt 0)
    = nKL_V.L(reg,ind) ;

EQPnKL_CES.SCALE(reg,ind)$(nKL_V.L(reg,ind) lt 0)
    = -nKL_V.L(reg,ind) ;


* ================= Define models with new variables/equations =================

* Define Cobb-Douglas specification.
Model CGE_MCP_COBBDOUGLAS
/
CGE_MCP
-EQKL
EQKL_COBBDOUGLAS.KL_V
/
;

* Define CES specification.
Model CGE_MCP_CES
/
CGE_MCP
-EQKL
-EQPnKL
EQKL_CES.KL_V
EQPnKL_CES.PnKL_V
/
;


* ============================== Simulation setup ==============================

* Set value for experiment.
KLS_V.FX('WEU','COE')                 = 1.1 * KLS('WEU','COE') ;

* Define options.
Option iterlim   = 20000000 ;
Option decimals  = 7 ;
CGE_MCP.scaleopt = 1 ;
CGE_MCP_COBBDOUGLAS.scaleopt = 1 ;
CGE_MCP_CES.scaleopt = 1 ;


* =============================== Solve statement ==============================

* Solve original model.
Solve CGE_MCP using MCP ;
KL_V_ORIG(reg,kl,regg,ind) = KL_V.L(reg,kl,regg,ind) ;

* Solve Cobb-Douglas specification.
Solve CGE_MCP_COBBDOUGLAS using MCP ;
KL_V_COBBDOUGLAS(reg,kl,regg,ind) = KL_V.L(reg,kl,regg,ind) ;

* Solve CES specification.
Solve CGE_MCP_CES using MCP ;
KL_V_CES(reg,kl,regg,ind) = KL_V.L(reg,kl,regg,ind) ;


* ========================= Post-processing of results =========================

* Show differences between KL_V variables.
$setlocal display_tolerance 0.0001
$batinclude EXIOMOD_base_model/includes/compare_data comparison_COBBDOUGLAS KL_V_ORIG KL_V_COBBDOUGLAS reg,va,regg,ind %display_tolerance%
$batinclude EXIOMOD_base_model/includes/compare_data comparison_CES         KL_V_ORIG KL_V_CES         reg,va,regg,ind %display_tolerance%
