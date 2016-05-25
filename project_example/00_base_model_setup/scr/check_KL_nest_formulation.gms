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
factors (prodK and prodL) is set to 1.

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
    facCK(reg,regg,ind)         Cobb-Douglas share coefficients for capital
                                # (relation in value)
    facCL(reg,regg,ind)         Cobb-Douglas share coefficients for labour
                                # (relation in value)
    facA(regg,ind)              Cobb-Douglas scale parameter for factors of
                                # production

    gammaCESK(reg,regg,ind)     CES share coefficients for capital (relation in
                                # value)
    gammaCESL(reg,regg,ind)     CES share coefficients for labour (relation in
                                # in value)
    aCES(regg,ind)              CES scale parameter for factors of production
;


* Cobb-Douglas share coefficients for factors of production within the
* aggregated nest
facCK(reg,regg,ind)$sum(k, VALUE_ADDED(reg,k,regg,ind) )
    = sum(k, VALUE_ADDED(reg,k,regg,ind) ) /
    sum((reggg,va)$(k(va) or l(va)), VALUE_ADDED(reggg,va,regg,ind) ) ;

facCL(reg,regg,ind)$sum(l, VALUE_ADDED(reg,l,regg,ind) )
    = sum(l, VALUE_ADDED(reg,l,regg,ind) ) /
    sum((reggg,va)$(k(va) or l(va)), VALUE_ADDED(reggg,va,regg,ind) ) ;


* Cobb-Douglas scale parameter for the nest of aggregated factors of production
facA(regg,ind)$sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) )
    = sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) ) /
    ( prod((reg,k), VALUE_ADDED(reg,k,regg,ind)**facCK(reg,regg,ind) ) *
    prod((reg,l), VALUE_ADDED(reg,l,regg,ind)**facCL(reg,regg,ind) ) ) ;

Display
facCK
facCL
facA
;

* CES share parameters
gammaCESK(reg,regg,ind)$sum(k, VALUE_ADDED(reg,k,regg,ind) )
    = sum(k, VALUE_ADDED(reg,k,regg,ind) )**( 1 / elasKL(regg,ind) ) /
    sum((reggg,va)$(k(va) or l(va)),
    VALUE_ADDED(reggg,va,regg,ind)**( 1 / elasKL(regg,ind) ) ) ;

gammaCESL(reg,regg,ind)$sum(l, VALUE_ADDED(reg,l,regg,ind) )
    = sum(l, VALUE_ADDED(reg,l,regg,ind) )**( 1 / elasKL(regg,ind) ) /
    sum((reggg,va)$(k(va) or l(va)),
    VALUE_ADDED(reggg,va,regg,ind)**( 1 / elasKL(regg,ind) ) ) ;

* CES scale parameters
aCES(regg,ind)$sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) )
    = sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) ) /
    ( sum((reg,k), gammaCESK(reg,regg,ind) * VALUE_ADDED(reg,k,regg,ind)**
    ( ( elasKL(regg,ind) - 1 ) / elasKL(regg,ind) ) ) +
    sum((reg,l), gammaCESL(reg,regg,ind) * VALUE_ADDED(reg,l,regg,ind)**
    ( ( elasKL(regg,ind) - 1 ) / elasKL(regg,ind) ) ) )**
    ( elasKL(regg,ind) / ( elasKL(regg,ind) - 1 ) ) ;

Display
gammaCESK
gammaCESL
aCES
;

* ====== Declaration of parameters for saving result for post-processing =======

Parameters
    K_V_ORIG(reg,regg,ind)          model solution for K with flexible CES
                                    # formulation
    L_V_ORIG(reg,regg,ind)          model solution for L with flexible CES
                                    # formulation
    K_V_COBBDOUGLAS(reg,regg,ind)   model solution for K with explicit
                                    # Cobb-Douglas formulation
    L_V_COBBDOUGLAS(reg,regg,ind)   model solution for L with explicit
                                    # Cobb-Douglas formulation
    K_V_CES(reg,regg,ind)           model solution for K with explicit CES
                                    # formulation
    L_V_CES(reg,regg,ind)           model solution for L with explicit CES
                                    # formulation
;

* = Declaration and definition of simulation specific variables and/or equations

Equations
    EQK_COBBDOUGLAS(reg,regg,ind)   demand for production factor capital with
                                    # Cobb-Douglas specification
    EQL_COBBDOUGLAS(reg,regg,ind)   demand for production factor labour with
                                    # Cobb-Douglas specification
    EQK_CES(reg,regg,ind)           demand for production factor capital with
                                    # CES specification
    EQL_CES(reg,regg,ind)           demand for production factor labour with
                                    # CES specification
    EQPnKL_CES(regg,ind)            balance between specific production
                                    # factors price and aggregate production
                                    # factors price with CES specification
;

* EQUAION 2.5a COBB-DOUGLAS: Demand for production factor capital in explicit
* Cobb-Douglas form.
EQK_COBBDOUGLAS(reg,regg,ind)$sum(k, VALUE_ADDED(reg,k,regg,ind) )..
    K_V(reg,regg,ind)
    =E=
    facCK(reg,regg,ind) / ( prod(reggg$facCK(reggg,regg,ind),
    facCK(reggg,regg,ind)**facCK(reggg,regg,ind) ) *
    prod(reggg$facCL(reggg,regg,ind),
    facCL(reggg,regg,ind)**facCL(reggg,regg,ind) ) ) *
    ( 1 / PK_V(reg) ) * nKL_V(regg,ind) / facA(regg,ind) *
    ( prod(reggg, PK_V(reggg)**facCK(reggg,regg,ind) ) *
    prod(reggg, PL_V(reggg)**facCL(reggg,regg,ind) ) ) ;

* EQUAION 2.5b COBB-DOUGLAS: Demand for production factor labour in explicit
* Cobb-Douglas form.
EQL_COBBDOUGLAS(reg,regg,ind)$sum(l, VALUE_ADDED(reg,l,regg,ind) )..
    L_V(reg,regg,ind)
    =E=
    facCL(reg,regg,ind) / ( prod(reggg$facCK(reggg,regg,ind),
    facCK(reggg,regg,ind)**facCK(reggg,regg,ind) ) *
    prod(reggg$facCL(reggg,regg,ind),
    facCL(reggg,regg,ind)**facCL(reggg,regg,ind) ) ) *
    ( 1 / PL_V(reg) ) * nKL_V(regg,ind) / facA(regg,ind) *
    ( prod(reggg, PK_V(reggg)**facCK(reggg,regg,ind) ) *
    prod(reggg, PL_V(reggg)**facCL(reggg,regg,ind) ) ) ;

* EQUAION 2.5a CONSTANT ELASTICITY OF SUBSTITUTION: Demand for production factor
* capital in explicit CES form.
EQK_CES(reg,regg,ind)$sum(k, VALUE_ADDED(reg,k,regg,ind) )..
    K_V(reg,regg,ind)
    =E=
    nKL_V(regg,ind) *
    ( gammaCESK(reg,regg,ind) / PK_V(reg) )**elasKL(regg,ind) *
    PnKL_V(regg,ind)**elasKL(regg,ind) *
    aCES(regg,ind)**( elasKL(regg,ind) - 1 ) ;

* EQUAION 2.5b CONSTANT ELASTICITY OF SUBSTITUTION: Demand for production factor
* labour in explicit CES form.
EQL_CES(reg,regg,ind)$sum(l, VALUE_ADDED(reg,l,regg,ind) )..
    L_V(reg,regg,ind)
    =E=
    nKL_V(regg,ind) *
    ( gammaCESL(reg,regg,ind) / PL_V(reg) )**elasKL(regg,ind) *
    PnKL_V(regg,ind)**elasKL(regg,ind) *
    aCES(regg,ind)**( elasKL(regg,ind) - 1 ) ;

* EQUATION 2.6 CONSTANT ELASTICITY OF SUBSTITUTION: Price of aggregate
* production factors defines in explicit CES form, can be only used in
* combination with EQUATION 9 CONSTANT ELASTICITY OF SUBSTITUTION.
EQPnKL_CES(regg,ind)$sum((reg,va)$(k(va) or l(va)), VALUE_ADDED(reg,va,regg,ind) )..
    PnKL_V(regg,ind)
    =E=
    1 / aCES(regg,ind) *
    ( sum(reg$gammaCESK(reg,regg,ind),
    gammaCESK(reg,regg,ind)**elasKL(regg,ind) *
    PK_V(reg)**( 1 - elasKL(regg,ind) ) ) + sum(reg$gammaCESL(reg,regg,ind),
    gammaCESL(reg,regg,ind)**elasKL(regg,ind) *
    PL_V(reg)**( 1 - elasKL(regg,ind) ) ) )**( 1 / ( 1 - elasKL(regg,ind) ) ) ;

* ====== Define levels and lower and upper bounds and fixed new variables ======


* ======================= Scale new variables/equations ========================

* EQUAION 2.5a COBB-DOUGLAS
EQK_COBBDOUGLAS.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) gt 0)
    = K_V.L(reg,regg,ind) ;

EQK_COBBDOUGLAS.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) lt 0)
    = -K_V.L(reg,regg,ind) ;

* EQUAION 2.5b COBB-DOUGLAS
EQL_COBBDOUGLAS.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) gt 0)
    = L_V.L(reg,regg,ind) ;

EQL_COBBDOUGLAS.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) lt 0)
    = -L_V.L(reg,regg,ind) ;

* EQUAION 2.5a CONSTANT ELASTICITY OF SUBSTITUTION
EQK_CES.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) gt 0)
    = K_V.L(reg,regg,ind) ;

EQK_CES.SCALE(reg,regg,ind)$(K_V.L(reg,regg,ind) lt 0)
    = -K_V.L(reg,regg,ind) ;

* EQUAION 2.5b CONSTANT ELASTICITY OF SUBSTITUTION
EQL_CES.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) gt 0)
    = L_V.L(reg,regg,ind) ;

EQL_CES.SCALE(reg,regg,ind)$(L_V.L(reg,regg,ind) lt 0)
    = -L_V.L(reg,regg,ind) ;

* EQUATION 2.6 CONSTANT ELASTICITY OF SUBSTITUTION
EQPnKL_CES.SCALE(reg,ind)$(nKL_V.L(reg,ind) gt 0)
    = nKL_V.L(reg,ind) ;

EQPnKL_CES.SCALE(reg,ind)$(nKL_V.L(reg,ind) lt 0)
    = -nKL_V.L(reg,ind) ;


* ================= Define models with new variables/equations =================

* Define Cobb-Douglas specification.
Model CGE_MCP_COBBDOUGLAS
/
CGE_MCP
-EQK
-EQL
EQK_COBBDOUGLAS.K_V
EQL_COBBDOUGLAS.L_V
/
;

* Define CES specification.
Model CGE_MCP_CES
/
CGE_MCP
-EQK
-EQL
-EQPnKL
EQK_CES.K_V
EQL_CES.L_V
EQPnKL_CES.PnKL_V
/
;


* ============================== Simulation setup ==============================

* Set value for experiment.
LS_V.FX('WEU')                 = 1.1 * LS('WEU') ;

* Define options.
*Option iterlim   = 0 ;
Option iterlim   = 20000000 ;
Option decimals  = 7 ;
CGE_MCP.scaleopt = 1 ;
CGE_MCP_COBBDOUGLAS.scaleopt = 1 ;
CGE_MCP_CES.scaleopt = 1 ;


* =============================== Solve statement ==============================

* Solve original model.
Solve CGE_MCP using MCP ;
K_V_ORIG(reg,regg,ind) = K_V.L(reg,regg,ind) ;
L_V_ORIG(reg,regg,ind) = L_V.L(reg,regg,ind) ;

* Solve Cobb-Douglas specification.
Solve CGE_MCP_COBBDOUGLAS using MCP ;
K_V_COBBDOUGLAS(reg,regg,ind) = K_V.L(reg,regg,ind) ;
L_V_COBBDOUGLAS(reg,regg,ind) = L_V.L(reg,regg,ind) ;

* Solve CES specification.
Solve CGE_MCP_CES using MCP ;
K_V_CES(reg,regg,ind) = K_V.L(reg,regg,ind) ;
L_V_CES(reg,regg,ind) = L_V.L(reg,regg,ind) ;


* ========================= Post-processing of results =========================

* Show differences between KL_V variables.
$setlocal display_tolerance 0.0001
$batinclude EXIOMOD_base_model/includes/compare_data comparison_COBBDOUGLAS K_V_ORIG K_V_COBBDOUGLAS reg,regg,ind %display_tolerance%
$batinclude EXIOMOD_base_model/includes/compare_data comparison_COBBDOUGLAS L_V_ORIG L_V_COBBDOUGLAS reg,regg,ind %display_tolerance%
$batinclude EXIOMOD_base_model/includes/compare_data comparison_CES         K_V_ORIG K_V_CES         reg,regg,ind %display_tolerance%
$batinclude EXIOMOD_base_model/includes/compare_data comparison_CES         L_V_ORIG L_V_CES         reg,regg,ind %display_tolerance%
