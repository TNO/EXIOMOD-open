* File:   %project%/00_base_model_setup/scr/add_labour_types.gms
* Author: Trond Husby
* Date:   20.03.2015

* gams-master-file: run_EXIOMOD.gms

$ontext startdoc
This simulation tests how one can split labour supply into different skill
groups. Data for wage-share of different skill groups are read in
user-data.gms


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
* Firslty deactive old symbol for end of line comment
* See more: http://support.gams.com/doku.php?id=gams:error_286
$offeolcom
$eolcom #

* ======== Declaration and definition of simulation specific parameters ========

* Calibration of production function
Parameters
    fprod_pr(klpr,regg,ind)     parameter on productivity on individual factors
                                # in the nest of aggregated factors of
                                # production

    wz_share(reg,klpr)          wages share of different skill levels
    VALUE_ADDED_pr(reg,klpr,regg,ind) value added in model aggregation
    VALUE_ADDED_DISTR_pr(reg,klpr,regg,fd) value added in model aggregation
    alphaKL_pr(reg,klpr,regg,ind) relative share parameter for factors of
                                # production within the aggregated nest
                                # (relation in volume)

    KLS_pr(reg,klpr)            supply of production factors (volume)
    fac_distr_h_pr(reg,klpr,regg) distribution shares of factor income to
                                # household budget (shares in value)
    fac_distr_g_pr(reg,klpr,regg) distribution shares of factor income to
                                # government budget (shares in value)
    fac_distr_gfcf_pr(reg,klpr,regg) distribution shares of factor income to
                                # gross fixed capital formation budget (shares
                                # in value)
;

$offorder
fprod_pr(klpr,regg,ind)$(ord(klpr) = 1)
    = sum(kl$(ord(kl) = 2),fprod(kl,regg,ind) ) ;
fprod_pr(klpr,regg,ind)$(ord(klpr) > 1)
    = sum(kl$(ord(kl) = 1),fprod(kl,regg,ind) ) ;

wz_share(reg,klpr) = sum(ind, lz_share(reg,ind,klpr)) / sum(ind, 1) ;
wz_share(reg,klpr) = wz_share(reg,klpr) / sum(klprr, wz_share(reg,klprr)) ;

VALUE_ADDED_pr(reg,klpr,regg,ind)$(ord(klpr) = 1)
    = sum(kl$(ord(kl) = 2), VALUE_ADDED(reg,kl,regg,ind)) ;
VALUE_ADDED_pr(reg,klpr,regg,ind)$(ord(klpr) > 1)
    = sum(kl$(ord(kl) = 1), VALUE_ADDED(reg,kl,regg,ind))*WZ_share(reg,klpr) ;

VALUE_ADDED_DISTR_pr(reg,klpr,regg,fd)$(ord(klpr) = 1)
    = sum(kl$(ord(kl) = 2), VALUE_ADDED_DISTR(reg,kl,regg,fd)) ;
VALUE_ADDED_DISTR_pr(reg,klpr,regg,fd)$(ord(klpr) > 1)
    = sum(kl$(ord(kl) = 1), VALUE_ADDED_DISTR(reg,kl,regg,fd))
    * WZ_share(reg,klpr);


fac_distr_h_pr(reg,klpr,regg)$(ord(klpr) = 1)
    = sum(kl$(ord(kl) = 2), fac_distr_h(reg,kl,regg)) ;
fac_distr_h_pr(reg,klpr,regg)$(ord(klpr) > 1)
    = sum(kl$(ord(kl) = 1), fac_distr_h(reg,kl,regg)) ;

fac_distr_g_pr(reg,klpr,regg)$(ord(klpr) = 1)
    = sum(kl$(ord(kl) = 2), fac_distr_g(reg,kl,regg)) ;
fac_distr_g_pr(reg,klpr,regg)$(ord(klpr) > 1)
    = sum(kl$(ord(kl) = 1), fac_distr_g(reg,kl,regg)) ;

fac_distr_gfcf_pr(reg,klpr,regg)$(ord(klpr) = 1)
    = sum(kl$(ord(kl) = 2), fac_distr_gfcf(reg,kl,regg)) ;
fac_distr_gfcf_pr(reg,klpr,regg)$(ord(klpr) > 1)
    = sum(kl$(ord(kl) = 1), fac_distr_gfcf(reg,kl,regg)) ;
$onorder

KLS_pr(reg,klpr)
    = sum((regg,ind),VALUE_ADDED_pr(reg,klpr,regg,ind) ) ;

alphaKL_pr(reg,klpr,regg,ind)$VALUE_ADDED_pr(reg,klpr,regg,ind)
    = VALUE_ADDED_pr(reg,klpr,regg,ind) /
    sum((reggg,klprr), VALUE_ADDED_pr(reggg,klprr,regg,ind) ) ;

Display
lz_share
wz_share
KL
KLPR
value_added
VALUE_ADDED_pr
KLS_pr
alphaKL
alphaKL_pr
fac_distr_h
fac_distr_h_pr
fac_distr_g
fac_distr_g_pr
fac_distr_gfcf
fac_distr_gfcf_pr
;

Equations
    EQKL_pr(reg,klpr,regg,ind)  demand for specific production factors
    EQFACREV_pr(reg,klpr)       revenue from factors of production
    EQGRINC_H_pr(regg)          gross income of households
    EQGRINC_G_pr(regg)          gross income of government
    EQGRINC_I_pr(regg)          gross income of investment agent

    EQPY_pr(regg,ind)           zero-profit condition (including possible
                                # margins)
    EQPKL_pr(reg,klpr)          balance on production factors market
    EQPnKL_pr(regg,ind)         balance between specific production factors
                                # price and aggregate production factors price
;

Variables
    KL_V_pr(reg,klpr,regg,ind)  use of specific production factors
    FACREV_V_pr(reg,klpr)       revenue from factors of production
    PKL_V_pr(reg,klpr)          production factor price
    KLS_V_pr(reg,klpr)          supply of production factors
;

* ============= Define new variables/equations ============================

* EQUATION 2.5:
EQKL_pr(reg,klpr,regg,ind)$VALUE_ADDED_pr(reg,klpr,regg,ind)..
    KL_V_pr(reg,klpr,regg,ind)
    =E=
    ( nKL_V(regg,ind) / fprod_pr(klpr,regg,ind) ) *
    alphaKL_pr(reg,klpr,regg,ind) *
    ( PKL_V_pr(reg,klpr) /
    ( fprod_pr(klpr,regg,ind) * PnKL_V(regg,ind) ) )**( -elasKL(regg,ind) ) ;

* EQUATION 1.4:
EQFACREV_pr(reg,klpr)..
    FACREV_V_pr(reg,klpr)
    =E=
    sum((regg,ind), KL_V_pr(reg,klpr,regg,ind) * PKL_V_pr(reg,klpr) ) ;

* EQUATION 1.8:
EQGRINC_H_pr(regg)..
    GRINC_H_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_h_pr(reg,klpr,regg) ) ;

* EQUATION 1.9:
EQGRINC_G_pr(regg)..
    GRINC_G_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_g_pr(reg,klpr,regg) ) +
    TSPREV_V(regg) + NTPREV_V(regg) + INMREV_V(regg) + TSEREV_V(regg) ;

* EQUATION 1.10:
EQGRINC_I_pr(regg)..
    GRINC_I_V(regg)
    =E=
    sum((reg,klpr), FACREV_V_pr(reg,klpr) * fac_distr_gfcf_pr(reg,klpr,regg) ) ;

* EQUATION 4.1:
EQPY_pr(regg,ind)$( Y(regg,ind) ne smax((reggg,indd), Y(reggg,indd) ) and
    Y(regg,ind) )..
    Y_V(regg,ind) * PY_V(regg,ind) *
    ( 1 - sum(reg, txd_ind(reg,regg,ind) ) -
    sum(reg, txd_inm(reg,regg,ind) ) - sum(reg, txd_tse(reg,regg,ind) ) )
    =E=
    sum(prd, INTER_USE_T_V(prd,regg,ind) * PIU_V(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum((reg,klpr), KL_V_pr(reg,klpr,regg,ind) * PKL_V_pr(reg,klpr) ) +
    sum(inm, TIM_INTER_USE_ROW(inm,regg,ind) * PROW_V ) +
    sum(tse, TIM_INTER_USE_ROW(tse,regg,ind) * PROW_V ) ;

* EQUATION 4.3:
EQPKL_pr(reg,klpr)..
    KLS_V_pr(reg,klpr)
    =E=
    sum((regg,ind), KL_V_pr(reg,klpr,regg,ind) ) ;

* EQUATION 2.6:
EQPnKL_pr(regg,ind)..
    PnKL_V(regg,ind) * nKL_V(regg,ind)
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

* EQUAION 2.5
EQKL_pr.SCALE(reg,klpr,regg,ind)$(KL_V_pr.L(reg,klpr,regg,ind) gt 0)
    = KL_V_pr.L(reg,klpr,regg,ind) ;
KL_V_pr.SCALE(reg,klpr,regg,ind)$(KL_V_pr.L(reg,klpr,regg,ind) gt 0)
    = KL_V_pr.L(reg,klpr,regg,ind) ;

EQKL_pr.SCALE(reg,klpr,regg,ind)$(KL_V_pr.L(reg,klpr,regg,ind) lt 0)
    = -KL_V_pr.L(reg,klpr,regg,ind) ;
KL_V_pr.SCALE(reg,klpr,regg,ind)$(KL_V_pr.L(reg,klpr,regg,ind) lt 0)
    = -KL_V_pr.L(reg,klpr,regg,ind) ;

* EQUATION 1.4
EQFACREV_pr.SCALE(reg,klpr)$(FACREV_V_pr.L(reg,klpr) gt 0)
    = FACREV_V_pr.L(reg,klpr) ;
FACREV_V_pr.SCALE(reg,klpr)$(FACREV_V_pr.L(reg,klpr) gt 0)
    = FACREV_V_pr.L(reg,klpr) ;

EQFACREV_pr.SCALE(reg,klpr)$(FACREV_V_pr.L(reg,klpr) lt 0)
    = -FACREV_V_pr.L(reg,klpr) ;
FACREV_V_pr.SCALE(reg,klpr)$(FACREV_V_pr.L(reg,klpr) lt 0)
    = -FACREV_V_pr.L(reg,klpr) ;

* EQUATION 1.8
EQGRINC_H_pr.SCALE(regg)$(GRINC_H_V.L(regg) gt 0)
    = GRINC_H_V.L(regg) ;

EQGRINC_H_pr.SCALE(regg)$(GRINC_H_V.L(regg) lt 0)
    = -GRINC_H_V.L(regg) ;

* EQUATION 1.9
EQGRINC_G_pr.SCALE(regg)$(GRINC_G_V.L(regg) gt 0)
    = GRINC_G_V.L(regg) ;

EQGRINC_G_pr.SCALE(regg)$(GRINC_G_V.L(regg) lt 0)
    = -GRINC_G_V.L(regg) ;

* EQUATION 1.10
EQGRINC_I_pr.SCALE(regg)$(GRINC_I_V.L(regg) gt 0)
    = GRINC_I_V.L(regg) ;

EQGRINC_I_pr.SCALE(regg)$(GRINC_I_V.L(regg) lt 0)
    = -GRINC_I_V.L(regg) ;

* EQUATION 4.1
EQPY_pr.SCALE(regg,ind)$(Y_V.L(regg,ind) gt 0)
    = Y_V.L(regg,ind) ;

EQPY_pr.SCALE(regg,ind)$(Y_V.L(regg,ind) lt 0)
    = -Y_V.L(regg,ind) ;

* EQUATION 4.3
EQPKL_pr.SCALE(reg,klpr)$(KLS_V_pr.L(reg,klpr) gt 0)
    = KLS_V_pr.L(reg,klpr) ;

EQPKL_pr.SCALE(reg,klpr)$(KLS_V_pr.L(reg,klpr) lt 0)
    = -KLS_V_pr.L(reg,klpr) ;

* EQUATION 2.6
EQPnKL_pr.SCALE(reg,ind)$(nKL_V.L(reg,ind) gt 0)
    = nKL_V.L(reg,ind) ;

EQPnKL_pr.SCALE(reg,ind)$(nKL_V.L(reg,ind) lt 0)
    = -nKL_V.L(reg,ind) ;


* ================= Define models with new variables/equations =================

* Define model with new household types

Model CGE_MCP_hh_types
/
CGE_MCP
-EQKL
-EQFACREV
-EQGRINC_H
-EQGRINC_G
-EQGRINC_I
-EQPY
-EQPKL
-EQPnKL

EQKL_pr.KL_V_pr
EQFACREV_pr.FACREV_V_pr
EQGRINC_H_pr.GRINC_H_V
EQGRINC_G_pr.GRINC_G_V
EQGRINC_I_pr.GRINC_I_V
EQPY_pr
EQPKL_pr.PKL_V_pr
EQPnKL_pr.PnKL_V

/
;

* ============================== Simulation setup ==============================

* Set value for experiment.
*KLS_V_pr.FX('EEU','GOS')  = 1.1 * KLS_pr('EEU','GOS') ;
KLS_V_pr.FX('EEU','HIGH')   = 1.1 * KLS_pr('EEU','HIGH')       ;

* Define options.
Option iterlim   = 20000000 ;
*Option iterlim   = 0 ;
Option decimals  = 7 ;
CGE_MCP.scaleopt = 1 ;
CGE_MCP_hh_types.scaleopt = 1 ;

* =============================== Solve statement ==============================

* Solve original model.
*Solve CGE_MCP using MCP ;

* Solve multiple household specification.
Solve CGE_MCP_hh_types using MCP ;



