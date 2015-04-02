* File:   scr/simulation/add_hh_types.gms
* Author: Trond Husby
* Date:   20.03.2015

$ontext startdoc
This simulation checks whether adding household types to labour supply and labour demand is easily implemented

1. List of sets that need to be changed
-va
-kl

2. List of equations that need to be changed
-EQKL
-EQPY
-EQPKL
-EQPVA

3. List of variables that need to be changed
-KL
-PKL

4. List of parameter that need to be changed
-KLS
-new elasticity for different education types
-alpha (share parameter)

The script consists of the following parts:

$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ======== Declaration and definition of simulation specific parameters ========

* Calibration of production function
Parameters
    fprod_pr(va,regg,ind)
    WZ_share(reg,va)
    VALUE_ADDED_pr(reg,va,regg,ind)
    VALUE_ADDED_DISTR_pr(reg,va,regg,fd) 
    alpha_pr(reg,va,regg,ind) project specific share parameter
    KLS_pr(reg,va)
    fac_distr_h_pr(reg,va,regg)
    fac_distr_g_pr(reg,va,regg)
    fac_distr_gfcf_pr(reg,va,regg)
    test(reg,va) ;

$offorder
* Factor productivity
fprod_pr(klpr,regg,ind)$(ord(klpr) = 1)  = sum(kl$(ord(kl) = 2), fprod(kl,regg,ind) ) ;
fprod_pr(klpr,regg,ind)$(ord(klpr) > 1)  = sum(kl$(ord(kl) = 1), fprod(kl,regg,ind) ) ;

* Distribution share
WZ_share(reg,klpr) = sum(ind, LZ_share(reg,ind,klpr)) / sum(ind, 1) ;
WZ_share(reg,klpr) = WZ_share(reg,klpr) / sum(klprr, WZ_share(reg,klprr)) ;

* Value added

    VALUE_ADDED_pr(reg,klpr,regg,ind)$(ord(klpr) = 1)  = sum(kl$(ord(kl) = 2), VALUE_ADDED(reg,kl,regg,ind)) ;
    VALUE_ADDED_pr(reg,klpr,regg,ind)$(ord(klpr) > 1)= sum(kl$(ord(kl) = 1), VALUE_ADDED(reg,kl,regg,ind))*WZ_share(reg,klpr) ;


    VALUE_ADDED_DISTR_pr(reg,klpr,regg,fd)$(ord(klpr) = 1) = sum(kl$(ord(kl) = 2), VALUE_ADDED_DISTR(reg,kl,regg,fd)) ;
    VALUE_ADDED_DISTR_pr(reg,klpr,regg,fd)$(ord(klpr) > 1) = sum(kl$(ord(kl) = 1), VALUE_ADDED_DISTR(reg,kl,regg,fd))* WZ_share(reg,klpr);


* Share of factor income, households
    fac_distr_h_pr(reg,klpr,regg)$(ord(klpr) = 1) = sum(kl$(ord(kl) = 2), fac_distr_h(reg,kl,regg)) ;
    fac_distr_h_pr(reg,klpr,regg)$(ord(klpr) > 1) = sum(kl$(ord(kl) = 1), fac_distr_h(reg,kl,regg)) ;

* Share of factor income, gov
fac_distr_g_pr(reg,klpr,regg)$(ord(klpr) = 1) = sum(kl$(ord(kl) = 2), fac_distr_g(reg,kl,regg)) ;
    fac_distr_g_pr(reg,klpr,regg)$(ord(klpr) > 1)= sum(kl$(ord(kl) = 1), fac_distr_g(reg,kl,regg)) ;

* Share of factor income, investor 
fac_distr_gfcf_pr(reg,klpr,regg)$(ord(klpr) = 1) = sum(kl$(ord(kl) = 2), fac_distr_gfcf(reg,kl,regg)) ;
    fac_distr_gfcf_pr(reg,klpr,regg)$(ord(klpr) > 1) = sum(kl$(ord(kl) = 1), fac_distr_gfcf(reg,kl,regg)) ;
$onorder

* Supply of factors of production
KLS_pr(reg,klpr)
    = sum((regg,ind),VALUE_ADDED_pr(reg,klpr,regg,ind) ) ;

* Share parameter
        alpha_pr(reg,klpr,regg,ind)$VALUE_ADDED_pr(reg,klpr,regg,ind)
    = VALUE_ADDED_pr(reg,klpr,regg,ind) /
    sum((reggg,klprr), VALUE_ADDED_pr(reggg,klprr,regg,ind) ) ;


Display LZ_share, WZ_share, KL, KLPR, value_added, VALUE_ADDED_pr, KLS_pr, alpha, alpha_pr, fac_distr_h, fac_distr_h_pr, fac_distr_g, fac_distr_g_pr, fac_distr_gfcf, fac_distr_gfcf_pr  ;

$exit


Equations
EQKL_pr(reg,va,regg,ind)
EQFACREV_pr(reg,va)
EQGRINC_H_pr(regg)
EQINC_G_pr(regg)
EQINC_I_pr(regg)

EQPY_pr(regg,ind)
EQPKL_pr(reg,va)    
EQPVA_pr(regg,ind)
;

Variables
KL_V_pr(reg,va,regg,ind)
FACREV_V_pr(reg,va)
PKL_V_pr(reg,va)
KLS_V_pr(reg,va)
;

* ============= Define new variables/equations ============================

* EQUATION 2.2:
EQKL_pr(reg,klpr,regg,ind)$VALUE_ADDED_pr(reg,klpr,regg,ind)..
    KL_V_pr(reg,klpr,regg,ind)
    =E=
    ( VA_V(regg,ind) / fprod_pr(klpr,regg,ind) ) * alpha_pr(reg,klpr,regg,ind) *
    ( PKL_V_pr(reg,klpr) /
    ( fprod_pr(klpr,regg,ind) * PVA_V(regg,ind) ) )**( -elasKL(regg,ind) ) ;

* EQUATION 8.1:
EQFACREV_pr(reg,klpr)..
    FACREV_V_pr(reg,klpr)
    =E=
    sum((regg,ind), KL_V_pr(reg,klpr,regg,ind) * PKL_V_pr(reg,klpr) ) ;

* EQUATION 9.1:
EQGRINC_H_pr(regg)..
    GRINC_H_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_h_pr(reg,klpr,regg) ) ;

$ontext
EQINC_H_pr(regg)..
    INC_H_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_h_pr(reg,klpr,regg) ) +
    sum(fd$fd_assign(fd,'Households'),
    sum((reg,fdd), INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) +
    sum(row, TRANSFERS_ROW_V(regg,fd,row) * PROW_V(row) ) ) ;
$offtext


* EQUATION 9.2:
EQINC_G_pr(regg)..
    INC_G_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_g_pr(reg,klpr,regg) ) +
    TSPREV_V(regg) + NTPREV_V(regg) + TIMREV_V(regg) +
    ty(regg) * GRINC_H_V(regg) +
    sum(fd$fd_assign(fd,'Government'),
    sum(fdd$( not fd_assign(fdd,'Households') ),
    INCTRANSFER_V(regg,fdd,regg,fd) * LASPEYRES_V(regg) ) ) +
    sum(fd$fd_assign(fd,'Government'), sum((reg,fdd)$( not sameas(reg,regg) ),
    INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) ) +
    sum(fd$fd_assign(fd,'Government'), TRANSFERS_ROW_V(regg,fd) * PROW_V ) ;

$ontext
EQINC_G_pr(regg)..
    INC_G_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_g_pr(reg,klpr,regg) ) +
    TSPREV_V(regg) + NTPREV_V(regg) + TIMREV_V(regg) +
    sum(fd$fd_assign(fd,'Government'),
    sum((reg,fdd), INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) +
    sum(row, TRANSFERS_ROW_V(regg,fd,row) * PROW_V(row) ) ) ;
$offtext

* EQUATION 9.3:
EQINC_I_pr(regg)..
    INC_I_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_gfcf_pr(reg,klpr,regg) ) +
    mps(regg) * ( GRINC_H_V(regg) * ( 1 - ty(regg) ) ) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum(fdd$( not fd_assign(fdd,'Households') ),
    INCTRANSFER_V(regg,fdd,regg,fd) * LASPEYRES_V(regg) ) ) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum((reg,fdd)$( not sameas(reg,regg) ),
    INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) ) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    TRANSFERS_ROW_V(regg,fd) * PROW_V ) ;

$ontext
EQINC_I_pr(regg)..
    INC_I_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_gfcf_pr(reg,klpr,regg) ) +
    sum(fd$fd_assign(fd,'GrossFixCapForm'),
    sum((reg,fdd), INCTRANSFER_V(reg,fdd,regg,fd) * LASPEYRES_V(reg) ) +
    sum(row, TRANSFERS_ROW_V(regg,fd,row) * PROW_V(row) ) ) ;
$offtext

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

* EQUATION 10.4:
EQPVA_pr(regg,ind)..
    PVA_V(regg,ind) * VA_V(regg,ind)
    =E=
    sum((reg,klpr), PKL_V_pr(reg,klpr) * KL_V_pr(reg,klpr,regg,ind)) ;

* ======== Define levels and lower and upper bounds and fixed variables ========

KL_V_pr.L(reg,klpr,regg,ind) = VALUE_ADDED_pr(reg,klpr,regg,ind) ;
KL_V_pr.FX(reg,klpr,regg,ind)$(KL_V_pr.L(reg,klpr,regg,ind) = 0 ) = 0 ;

FACREV_V_pr.L(reg,klpr) = sum((regg,fd), VALUE_ADDED_DISTR_pr(reg,klpr,regg,fd) ) ;
FACREV_V_pr.FX(reg,klpr)$(FACREV_V_pr.L(reg,klpr) = 0) = 0 ;

PKL_V_pr.L(reg,klpr)       = 1 ;
PKL_V_pr.FX(reg,klpr)$(KLS_pr(reg,klpr) = 0)       = 0 ;

* Exogenous variables are fixed to their calibrated value.
KLS_V_pr.FX(reg,klpr)                   = KLS_pr(reg,klpr) ;

* ============= Scale and define levels of new variables/equations =============

* EQUAION 2.2:
EQKL_pr.SCALE(reg,klpr,regg,ind)$(KL_V_pr.L(reg,klpr,regg,ind) gt 0)
    = KL_V_pr.L(reg,klpr,regg,ind) ;

EQKL_pr.SCALE(reg,klpr,regg,ind)$(KL_V_pr.L(reg,klpr,regg,ind) lt 0)
    = -KL_V_pr.L(reg,klpr,regg,ind) ;

* EQUATION 8.1:
EQFACREV_pr.SCALE(reg,klpr)$(FACREV_V_pr.L(reg,klpr) gt 0)
    = FACREV_V_pr.L(reg,klpr) ;

EQFACREV_pr.SCALE(reg,klpr)$(FACREV_V_pr.L(reg,klpr) lt 0)
    = -FACREV_V_pr.L(reg,klpr) ;

* EQUATION 9.1:
EQGRINC_H_pr.SCALE(regg)$(INC_H_V.L(regg) gt 0)
    = INC_H_V.L(regg) ;

EQGRINC_H_pr.SCALE(regg)$(INC_H_V.L(regg) lt 0)
    = -INC_H_V.L(regg) ;

* EQUATION 9.2:
EQINC_G_pr.SCALE(regg)$(INC_G_V.L(regg) gt 0)
    = INC_G_V.L(regg) ;

EQINC_G_pr.SCALE(regg)$(INC_G_V.L(regg) lt 0)
    = -INC_G_V.L(regg) ;

* EQUATION 9.3:
EQINC_I_pr.SCALE(regg)$(INC_I_V.L(regg) gt 0)
    = INC_I_V.L(regg) ;

EQINC_I_pr.SCALE(regg)$(INC_I_V.L(regg) lt 0)
    = -INC_I_V.L(regg) ;

* EQUATION 10.1:
EQPY_pr.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;

EQPY_pr.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;

* EQUATION 10.3:
EQPKL_pr.SCALE(reg,klpr)$(KLS_V_pr.L(reg,klpr) gt 0)
    = KLS_V_pr.L(reg,klpr) ;

EQPKL_pr.SCALE(reg,klpr)$(KLS_V_pr.L(reg,klpr) lt 0)
    = -KLS_V_pr.L(reg,klpr) ;

* EQUATION 10.4
EQPVA_pr.SCALE(reg,ind)$(VA_V.L(reg,ind) gt 0)
    = VA_V.L(reg,ind) ;

EQPVA_pr.SCALE(reg,ind)$(VA_V.L(reg,ind) lt 0)
    = -VA_V.L(reg,ind) ;



* ================= Define models with new variables/equations =================

* Define model with new household types

Model CGE_MCP_hh_types
/
CGE_MCP
-EQKL
-EQFACREV
-EQGRINC_H
-EQINC_G
-EQINC_I
-EQPY
-EQPKL
-EQPVA

EQKL_pr.KL_V_pr
EQFACREV_pr.FACREV_V_pr
EQGRINC_H_pr.GRINC_H_V
EQINC_G_pr.INC_G_V
EQINC_I_pr.INC_I_V
EQPY_pr.PY_V
EQPKL_pr.PKL_V_pr
EQPVA_pr.PVA_V

/      
;

* ============================== Simulation setup ==============================

* Set value for experiment.
*KLS_V.FX('EU27','COE')  = 1.1 * KLS('EU27','COE') ;
*KLS_V.FX('EU','CLS')                 = 1.1 * KLS('EU','CLS')                      ;

* Define options.
*Option iterlim   = 20000000 ;
Option iterlim   = 0 ;
Option decimals  = 7 ;
CGE_MCP.scaleopt = 1 ;
CGE_MCP_hh_types.scaleopt = 1 ;

* =============================== Solve statement ==============================

* Solve original model.
*Solve CGE_MCP using MCP ;
*KL_V_ORIG(reg,kl,regg,ind) = KL_V.L(reg,kl,regg,ind) ;

* Solve multiple household specification.
Solve CGE_MCP_hh_types using MCP ;
*KL_V_COBBDOUGLAS(reg,kl,regg,ind) = KL_V.L(reg,kl,regg,ind) ;


* ========================= Post-processing of results =========================

* Show differences between KL_V variables.
*$setlocal display_tolerance 0.0001
*$batinclude library/includes/compare_data comparison_COBBDOUGLAS KL_V_ORIG KL_V_COBBDOUGLAS reg,kl,regg,ind %display_tolerance%
*$batinclude library/includes/compare_data comparison_CES         KL_V_ORIG KL_V_CES         reg,kl,regg,ind %display_tolerance%
