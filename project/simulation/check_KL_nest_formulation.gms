
* File:   scr/simulation/check_KL_nest_specification.gms
* Author: Jelmer Ypma
* Date:   17 October 2014

$ontext startdoc
This simulation scripts checks whether the 'flexible' specification of a CES
function, which is used in library/scr/model_parameters.gms and
library/scr/model_variables_equations.gms is indeed correct and produces result
identical to explicit Cobb-Douglas and CES specifications. The check is
performed on only one specific nest of the model, namely capital-labour block
of the production function.

Check on Cobb-Douglas specification is only relevant when the value of elasKL is
calibrated close to 1, e.g. 0.99 or 1.01.

The script consists of the following parts:

 * Declaration and definition of parameters required for explicit specification
   of Cobb-Douglas and CES functions.
 * Declaration and definition of new equations with explicit specification of
   Cobb-Douglas and CES functions.
 * Definition of new models, where some of the standard equations are replaced
   with the new ones.
 * Setup of the experiment and simulation of the there model specifications.
 * Reporting of the results.
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ======== Declaration and definition of simulation specific parameters ========

* Calibration of production function
Parameters
    facC(reg,kl,regg,ind)       Cobb-Douglas share coefficients for factors
                                # of production (relation in value)
    facA(regg,ind)              Cobb-Douglas scale parameter for factors of
                                # production

    gammaCES(reg,kl,regg,ind)   CES share coefficients for factors of production
                                # (relation in value)
    aCES(regg,ind)              CES slace parameter for factos of production
;


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
facC
facA
;

* CES share parameters
gammaCES(reg,kl,regg,ind)
    = VALUE_ADDED_model(reg,kl,regg,ind)**( 1 / elasKL(regg,ind) ) /
    sum((reggg,kll),
    VALUE_ADDED_model(reggg,kll,regg,ind)**( 1 / elasKL(regg,ind) ) ) ;

* CES scale parameters
aCES(regg,ind)
    = sum((reg,kl), VALUE_ADDED_model(reg,kl,regg,ind) ) /
    sum((reg,kl), gammaCES(reg,kl,regg,ind) *
    VALUE_ADDED_model(reg,kl,regg,ind)**
    ( ( elasKL(regg,ind) - 1 ) / elasKL(regg,ind) ))**
    ( elasKL(regg,ind) / ( elasKL(regg,ind) - 1 ) );

Display
gammaCES,
aCES ;

* Parameters to save results.
Parameters
    KL_V_ORIG(reg,kl,regg,ind)
    KL_V_COBBDOUGLAS(reg,kl,regg,ind)
    KL_V_CES(reg,kl,regg,ind)
;


* = Declaration and definition of simulation specific variables and/or equations

Equations
    EQKL_COBBDOUGLAS(reg,kl,regg,ind)   demand for specific production factors
                                        # with Cobb-Douglas specification
    EQKL_CES(reg,kl,regg,ind)           demand for specific production factors
                                        # with CES specification
    EQPVA_CES(regg,ind)                 balance between specific production
                                        # factors price and aggregate production
                                        # factors price with CES specification
;

* EQUATION 9 COBB-DOUGLAS: Demand for specific production factors in explicit
* Cobb-Douglas form.
EQKL_COBBDOUGLAS(reg,kl,regg,ind)$VALUE_ADDED_model(reg,kl,regg,ind)..
    KL_V(reg,kl,regg,ind)
    =E=
    facC(reg,kl,regg,ind) / prod((reggg,kll)$facC(reggg,kll,regg,ind),
    facC(reggg,kll,regg,ind)**facC(reggg,kll,regg,ind) ) *
    ( 1 / PKL_V(reg,kl) ) * VA_V(regg,ind) / facA(regg,ind) *
    prod((reggg,kll), PKL_V(reggg,kll)**facC(reggg,kll,regg,ind) ) ;

* EQUATION 9 CONSTANT ELASTICITY OF SUBSTITUTION: Demand for specific production
* factors in explicit CES form.
EQKL_CES(reg,kl,regg,ind)$VALUE_ADDED_model(reg,kl,regg,ind)..
    KL_V(reg,kl,regg,ind)
    =E=
    VA_V(regg,ind) *
    ( gammaCES(reg,kl,regg,ind) / PKL_V(reg,kl) )**elasKL(regg,ind) *
    PVA_V(regg,ind)**elasKL(regg,ind) *
    aCES(regg,ind)**( elasKL(regg,ind) - 1 ) ;

* EQUATION 26 CONSTANT ELASTICITY OF SUBSTITUTION: Price of aggregate
* production factors defines in explicit CES form, can be only used in
* combination with EQUATION 9 CONSTANT ELASTICITY OF SUBSTITUTION.
EQPVA_CES(regg,ind)..
    PVA_V(regg,ind)
    =E=
    1 / aCES(regg,ind) *
    sum((reg,kl)$gammaCES(reg,kl,regg,ind),
    gammaCES(reg,kl,regg,ind)**elasKL(regg,ind) *
    PKL_V(reg,kl)**( 1 - elasKL(regg,ind) ) )**
    ( 1 / ( 1 - elasKL(regg,ind) ) ) ;


* ============= Scale and define levels of new variables/equations =============

* EQUATION 9 COBB-DOUGLAS
EQKL_COBBDOUGLAS.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) gt 0)
    = KL_V.L(reg,kl,regg,ind) ;

EQKL_COBBDOUGLAS.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) lt 0)
    = -KL_V.L(reg,kl,regg,ind) ;

* EQUAION 9 CONSTANT ELASTICITY OF SUBSTITUTION
EQKL_CES.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) gt 0)
    = KL_V.L(reg,kl,regg,ind) ;

EQKL_CES.SCALE(reg,kl,regg,ind)$(KL_V.L(reg,kl,regg,ind) lt 0)
    = -KL_V.L(reg,kl,regg,ind) ;

* EQUATION 26CONSTANT ELASTICITY OF SUBSTITUTION
EQPVA_CES.SCALE(reg,ind)$(VA_V.L(reg,ind) gt 0)
    = VA_V.L(reg,ind) ;

EQPVA_CES.SCALE(reg,ind)$(VA_V.L(reg,ind) lt 0)
    = -VA_V.L(reg,ind) ;


* ================= Define models with new variables/equations =================

* Define Cobb-Douglas specification.
Model CGE_MCP_COBBDOUGLAS
/
EQBAL.X_V
EQY.Y_V
EQINTU_T.INTER_USE_T_V
EQINTU_D.INTER_USE_D_V
EQINTU_M.INTER_USE_M_V
EQINTU.INTER_USE_V
EQINTU_ROW.INTER_USE_ROW_V
EQVA.VA_V
EQKL_COBBDOUGLAS.KL_V
EQFU_T.FINAL_USE_T_V
EQFU_D.FINAL_USE_D_V
EQFU_M.FINAL_USE_M_V
EQFU.FINAL_USE_V
EQFU_ROW.FINAL_USE_ROW_V
EQIMP.IMPORT_V
EQTRADE.TRADE_V
EQEXP.EXPORT_V
EQFACREV.FACREV_V
EQTSPREV.TSPREV_V
EQNTPREV.NTPREV_V
EQINC.INC_V
EQCBUD.CBUD_V
EQPY.PY_V
EQP.P_V
EQPKL.PKL_V
EQPVA.PVA_V
EQPIU.PIU_V
EQPFU.PFU_V
EQPIMP.PIMP_V
EQSCLFD.SCLFD_V
EQPROW.PROW_V
EQPAASCHE.PAASCHE_V
EQLASPEYRES.LASPEYRES_V
/
;

* Define CES specification.
Model CGE_MCP_CES
/
EQBAL.X_V
EQY.Y_V
EQINTU_T.INTER_USE_T_V
EQINTU_D.INTER_USE_D_V
EQINTU_M.INTER_USE_M_V
EQINTU.INTER_USE_V
EQINTU_ROW.INTER_USE_ROW_V
EQVA.VA_V
EQKL_CES.KL_V
EQFU_T.FINAL_USE_T_V
EQFU_D.FINAL_USE_D_V
EQFU_M.FINAL_USE_M_V
EQFU.FINAL_USE_V
EQFU_ROW.FINAL_USE_ROW_V
EQIMP.IMPORT_V
EQTRADE.TRADE_V
EQEXP.EXPORT_V
EQFACREV.FACREV_V
EQTSPREV.TSPREV_V
EQNTPREV.NTPREV_V
EQINC.INC_V
EQCBUD.CBUD_V
EQPY.PY_V
EQP.P_V
EQPKL.PKL_V
EQPVA_CES.PVA_V
EQPIU.PIU_V
EQPFU.PFU_V
EQPIMP.PIMP_V
EQSCLFD.SCLFD_V
EQPROW.PROW_V
EQPAASCHE.PAASCHE_V
EQLASPEYRES.LASPEYRES_V
/
;


* ============================== Simulation setup ==============================

* Set value for experiment.
KLS_V.FX('EU27','COE')  = 1.1 * KLS('EU27','COE') ;

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
$batinclude library/includes/compare_data comparison_COBBDOUGLAS KL_V_ORIG KL_V_COBBDOUGLAS reg,kl,regg,ind %display_tolerance%
$batinclude library/includes/compare_data comparison_CES         KL_V_ORIG KL_V_CES         reg,kl,regg,ind %display_tolerance%
