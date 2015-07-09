
* File:     project_ENVLinkages\00-principal\scr\run_simulation_InternalWS_step2.gms
* Author:   Tatyana Bulavskaya
* Date:     7 July 2015

* gams-master-file: main.gms

$oneolcom
$eolcom #

* ======== Declaration and definition of simulation specific parameters ========

Sets
    year  /2007*2025/

    prd_elec(prd)                       sub-set of electricity products
/
p030
/

    ind_elec(ind)                       sub-set of electricity producing
                                        # industries
/
i030
i032
i034
i035
i036
/


;

Parameter
    elec_mix(regg,ind,year)             electricity mix
    elec_shift(regg,year)               shift of electicity from fossil to
                                        # renewable
;

elec_mix(regg,ind_elec,year) =
    sum(prd_elec, coprodB(regg,prd_elec,regg,ind_elec) ) ;

elec_shift("EU",year) = elec_mix("EU","i030",year) -
    elec_mix("EU","i030",year) * 0.9**( ord(year) - 1 ) ;

* share of fossil goes down every year
elec_mix(regg,"i030",year) = elec_mix(regg,"i030",year) - elec_shift(regg,year) ;
* share of wind and solar goes up every year
elec_mix(regg,"i035",year) = elec_mix(regg,"i035",year) + elec_shift(regg,year) ;

Display
elec_shift
elec_mix
;

* ====== Declaration of parameters for saving result for post-processing =======

Parameters
    Y_change(regg,ind,year)             change in industry output due to shock
    X_change(reg,prd,year)              change in product output due to shock
    Yreg_change(regg,year)              change in country output due to shock
    CBUD_H_check(regg,year)             check that budget constraint holds
    CBUD_G_check(regg,year)             check that budget constraint holds
    CBUD_I_check(regg,year)             check that budget constraint holds
    numer_check(regg,ind,year)          check that the numeraire equation holds

    check_neg_Y(reg,ind,year)           check for any negatives due to shock
    check_neg_X(reg,prd,year)           check for any negatives due to shock
    check_neg_CBUD_H(reg,year)          check for any negatives due to shock
    check_neg_CBUD_G(reg,year)          check for any negatives due to shock
    check_neg_CBUD_I(reg,year)          check for any negatives due to shock
;

$include    %project%\00-principal\scr\save_simulation_results_declaration_parameters.gms

* ================= Define models with new variables/equations =================

Model CGE_step2_ioeffect
/
EQBAL.X_V
EQY.Y_V
EQINTU_T.INTER_USE_T_V
EQVA.VA_V
EQKL.KL_V
EQINTU_D.INTER_USE_D_V
EQINTU_M.INTER_USE_M_V
EQIMP_T.IMPORT_T_V
EQIMP_MOD.IMPORT_MOD_V
EQTRADE.TRADE_V
/
;

CONS_H_D_V.FX(prd,reg)  = CONS_H_D_V.L(prd,reg) ;
CONS_G_D_V.FX(prd,reg)  = CONS_G_D_V.L(prd,reg) ;
GFCF_D_V.FX(prd,reg)    = GFCF_D_V.L(prd,reg) ;
CONS_H_M_V.FX(prd,regg) = CONS_H_M_V.L(prd,regg) ;
CONS_G_M_V.FX(prd,regg) = CONS_G_M_V.L(prd,regg) ;
GFCF_M_V.FX(prd,regg)   = GFCF_M_V.L(prd,regg) ;

SV_V.FX(reg,prd,regg)       = SV_V.L(reg,prd,regg) ;
EXPORT_ROW_V.FX(reg,prd)    = EXPORT_ROW_V.L(reg,prd) ;

PKL_V.FX(reg,kl)        = PKL_V.L(reg,kl) ;
PVA_V.FX(regg,ind)      = PVA_V.L(regg,ind) ;
P_V.FX(regg,prd)        = P_V.L(regg,prd) ;
PIU_V.FX(prd,regg,ind)  = PIU_V.L(prd,regg,ind) ;
PIMP_T_V.FX(prd,regg)   = PIMP_T_V.L(prd,regg) ;
PIMP_MOD_V.FX(prd,regg) = PIMP_MOD_V.L(prd,regg) ;

* ============================== Simulation setup ==============================

* start loop over years
*loop(year$( ord(year) eq 1),
loop(year,

coprodB(regg,prd_elec,regg,ind_elec) = elec_mix(regg,ind_elec,year) ;

* =============================== Solve statement ==============================
Option iterlim = 10000 ;
Option reslim  = 10000 ;
Option decimals = 8 ;
Option nlp = conopt3 ;
CGE_step2_ioeffect.scaleopt = 1 ;
Solve CGE_step2_ioeffect using MCP ;

$include %project%\00-principal\scr\save_simulation_results.gms

* end loop over years
) ;

* ========================= Post-processing of results =========================

Y_change(regg,ind,year)$Y(regg,ind)
    = Y_%scenario%(regg,ind,year) / Y(regg,ind) ;
X_change(reg,prd,year)$X(reg,prd)
    = X_%scenario%(reg,prd,year) / X(reg,prd) ;

Yreg_change(regg,year)$
    sum(ind, Y_%scenario%(regg,ind,year) )
         = sum(ind, Y_%scenario%(regg,ind,year) ) - sum(ind, Y(regg,ind) ) ;

Display
Y_change
X_change
;

Display
Yreg_change
;

CBUD_H_check(regg,year)$
    CBUD_H_%scenario%(regg,year)
         = ( sum(prd, CONS_H_T_%scenario%(prd,regg,year) * PC_H_%scenario%(prd,regg,year) *
         ( 1 + tc_h_%scenario%(prd,regg,year) ) ) ) / CBUD_H_%scenario%(regg,year) ;

CBUD_G_check(regg,year)$
    CBUD_G_%scenario%(regg,year)
         = ( sum(prd, CONS_G_T_%scenario%(prd,regg,year) * PC_G_%scenario%(prd,regg,year) *
         ( 1 + tc_g(prd,regg) ) ) ) / CBUD_G_%scenario%(regg,year) ;

CBUD_I_check(regg,year)$
    CBUD_I_%scenario%(regg,year)
         = ( sum(prd, GFCF_T_%scenario%(prd,regg,year) * PC_I_%scenario%(prd,regg,year) *
         ( 1 + tc_gfcf(prd,regg) ) ) ) / CBUD_I_%scenario%(regg,year) ;

Display
CBUD_H_check
CBUD_G_check
CBUD_I_check
;

Execute_Unload 'results_step2_ioeffect'
