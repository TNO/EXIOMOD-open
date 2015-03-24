* File:   scr/simulation/add_hh_types.gms
* Author: Trond Husby
* Date:   20.03.2015

$ontext startdoc
This simulation checks whether adding household types to labour supply and labour demand is easily implemented

List of sets that need to be changed
-va
-kl

List of parameter that need to be changed
-KLS
-new elasticity for different education types
-alpha (share parameter)

List of variables that need to be changed
-KL
-PKL

List of equations that need to be changed
-EQKL
-EQPY
-EQPKL
-EQPVA

The script consists of the following parts:

$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ======== Declaration and definition of simulation specific parameters ========

* Calibration of production function
Parameters
    VALUE_ADDED_pr(reg,klpr,regg,ind) 
    alpha_pr(reg,klpr,regg,ind) project specific share parameter
    KLS_pr(reg,klpr)
    fac_distr_h_pr(reg,klpr,regg)
    fac_distr_g_pr(reg,klpr,regg)
    fac_distr_gfcf_pr(reg,klpr,regg)
    test(reg,klpr) ;

* Value added
    VALUE_ADDED_pr(reg,klpr,regg,ind)  = sum(kl$(ord(kl) = 1), VALUE_ADDED(reg,kl,regg,ind)) ;

    VALUE_ADDED_pr(reg,klpr,regg,ind)$LZ_share(reg,ind,klpr) = sum(kl$(ord(kl) = 2), VALUE_ADDED(reg,kl,regg,ind))*LZ_share(reg,ind,klpr) ;

*households

    fac_distr_h_pr(reg,klpr,regg) = sum(kl$(ord(kl) = 1), fac_distr_h(reg,kl,regg)) ;
    fac_distr_h_pr(reg,klpr,regg)$(sum(ind, LZ_share(reg,ind,klpr))) = sum(kl$(ord(kl) = 2), fac_distr_h(reg,kl,regg))* sum(ind, LZ_share(reg,ind,klpr))/sum(ind,1) ;

* gov
fac_distr_g_pr(reg,klpr,regg) = sum(kl$(ord(kl) = 1), fac_distr_g(reg,kl,regg)) ;
    fac_distr_g_pr(reg,klpr,regg)$(sum(ind, LZ_share(reg,ind,klpr))) = sum(kl$(ord(kl) = 2), fac_distr_g(reg,kl,regg))* sum(ind, LZ_share(reg,ind,klpr))/sum(ind,1) ;

* investor (?)
fac_distr_gfcf_pr(reg,klpr,regg) = sum(kl$(ord(kl) = 1), fac_distr_gfcf(reg,kl,regg)) ;
    fac_distr_gfcf_pr(reg,klpr,regg)$(sum(ind, LZ_share(reg,ind,klpr))) = sum(kl$(ord(kl) = 2), fac_distr_gfcf(reg,kl,regg))* sum(ind, LZ_share(reg,ind,klpr))/sum(ind,1) ;

* Supply
KLS_pr(reg,klpr)
    = sum((regg,ind),VALUE_ADDED(reg,klpr,regg,ind) ) ;

* Share parameter
    
    alpha_pr(reg,klpr,regg,ind)$VALUE_ADDED_pr(reg,klpr,regg,ind)
    = VALUE_ADDED_pr(reg,klpr,regg,ind) /
    sum((reggg,klprr), VALUE_ADDED_pr(reggg,klprr,regg,ind) ) ;


Display VALUE_ADDED_pr, KLS_pr, alpha, alpha_pr, fac_distr_h, fac_distr_h_pr, fac_distr_g, fac_distr_g_pr, fac_distr_gfcf, fac_distr_gfcf_pr ;


Equations
EQKL_pr(reg,klpr,regg,ind)
EQPY_pr(regg,ind)
EQPKL_pr(reg,klpr)    
EQPVA_pr(regg,ind)

EQFACREV_pr(reg,kl)
EQINC_H_pr(regg)
EQINC_G_pr(regg)
EQINC_I_pr(regg)
EQPY_pr(regg,ind)

;

Variables
KL_V_pr(reg,klpr,regg,ind)
FACREV_V_pr(reg,klpr)
PKL_V(reg,kl)

KLS_V_pr(reg,klpr)
;

    
* EQUAION 2.2:
EQKL_pr(reg,klpr,regg,ind)$VALUE_ADDED_pr(reg,klpr,regg,ind)..
    KL_V_pr(reg,klpr,regg,ind)
    =E=
    VA_V_pr(regg,ind) * alpha_pr(reg,klpr,regg,ind) *
    ( PKL_V_pr(reg,klpr) / PVA_V(regg,ind) )**( -elasKL(regg,ind) ) ;

* EQUATION 8.1:
EQFACREV_pr(reg,klpr)..
    FACREV_V_pr(reg,klpr)
    =E=
    sum((regg,ind), KL_V_pr(reg,klpr,regg,ind) * PKL_V_pr(reg,klpr) ) ;

* EQUATION 9.1:
EQINC_H_pr(regg)..
    INC_H_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_h_pr(reg,klpr,regg) ) +
    sum(fd$fd_assign(fd,'Households'),
    sum((reg,fdd), INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) +
    sum(row, TRANSFERS_ROW_V(regg,fd,row) * PROW_V(row) ) ) ;

* EQUATION 9.2:
EQINC_G(regg)..
    INC_G_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_g_pr(reg,klpr,regg) ) +
    TSPREV_V(regg) + NTPREV_V(regg) + TIMREV_V(regg) +
    sum(fd$fd_assign(fd,'Government'),
    sum((reg,fdd), INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) +
    sum(row, TRANSFERS_ROW_V(regg,fd,row) * PROW_V(row) ) ) ;

* EQUATION 9.3:
EQINC_I_pr(regg)..
    INC_I_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_gfcf_pr(reg,klpr,regg) ) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum((reg,fdd), INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) +
    sum(row, TRANSFERS_ROW_V(regg,fd,row) * PROW_V(row) ) ) ;

* EQUATION 10.1:
EQPY_pr(regg,ind)$((not sameas(regg,'WEU')) or (not sameas(ind,'i020')))..
    Y_V(regg,ind) * PY_V(regg,ind) *
    ( 1 - sum(reg, txd_ind(reg,regg,ind) ) -
    sum(reg, txd_tim(reg,regg,ind) ) )
    =E=
    sum((reg,prd), INTER_USE_V(reg,prd,regg,ind) * P_V(reg,prd) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((row,prd), INTER_USE_ROW_V(row,prd,regg,ind) * PROW_V(row) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((reg,klpr), KL_V_pr(reg,klpr,regg,ind) * PKL_V_pr(reg,klpr) ) +
    sum((row,tim), TAX_INTER_USE_ROW(row,tim,regg,ind) * PROW_V(row) ) ;

* EQUATION 10.3:
EQPKL_pr(reg,klpr)..
    KLS_V_pr(reg,klpr)
    =E=
    sum((regg,ind), KL_V_pr(reg,klpr,regg,ind) ) ;


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
-EQPVA
EQKL_CES.KL_V
EQPVA_CES.PVA_V
/
;


* ============================== Simulation setup ==============================

* Set value for experiment.
*KLS_V.FX('EU27','COE')  = 1.1 * KLS('EU27','COE') ;
KLS_V.FX('EU','CLS')                 = 1.1 * KLS('EU','CLS')                      ;

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
