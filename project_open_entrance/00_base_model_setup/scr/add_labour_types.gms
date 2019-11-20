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
-l

2. List of equations that need to be changed
-EQL
-EQPY
-EQPL

3. List of variables that need to be changed
-KL
-PL

4. List of parameter that need to be changed
-LS
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
    prodL_pr(lpr,regg,ind)      parameter on productivity of labour in the nest
                                # of aggregated factors of production

    wz_share(reg,lpr)           wages share of different skill levels
    VALUE_ADDED_pr(reg,vapr,regg,ind) value added in model aggregation
    VALUE_ADDED_DISTR_pr(reg,vapr,regg,fd) value added in model aggregation
    aL_pr(reg,lpr,regg,ind)     relative share parameter for labour skill levels
                                # within the capital-labour nes  (relation in
                                # volume)

    LS_pr(reg,lpr)              supply of labour per skill level (volume)
    l_distr_h_pr(reg,lpr,regg)  distribution shares of labour income to
                                # household budget (shares in value)
    l_distr_g_pr(reg,lpr,regg)  distribution shares of labour income to
                                # government budget (shares in value)
    l_distr_gfcf_pr(reg,lpr,regg)   distribution shares of labour income to
                                # gross fixed capital formation budget (shares
                                # in value)
;

prodL_pr(lpr,regg,ind) = prodL(regg,ind) ;

wz_share(reg,lpr) = sum(ind, lz_share(reg,ind,lpr)) / sum(ind, 1) ;
wz_share(reg,lpr) = wz_share(reg,lpr) / sum(lprr, wz_share(reg,lprr)) ;

loop(k,
    VALUE_ADDED_pr(reg,vapr,regg,ind)$sameas(vapr,k) =
    VALUE_ADDED(reg,k,regg,ind) ;
) ;
VALUE_ADDED_pr(reg,lpr,regg,ind) =
    sum(l, VALUE_ADDED(reg,l,regg,ind) ) * lz_share(regg,ind,lpr) ;
VALUE_ADDED_pr(reg,lpr,regg,ind)$( sum(lprr, lz_share(regg,ind,lprr) ) eq 0 ) =
    sum(l, VALUE_ADDED(reg,l,regg,ind) ) * wz_share(regg,lpr) ;

loop(k,
    VALUE_ADDED_DISTR_pr(reg,vapr,regg,fd)$sameas(vapr,k) =
    VALUE_ADDED_DISTR(reg,k,regg,fd) ;
) ;
VALUE_ADDED_DISTR_pr(reg,lpr,regg,fd)$sum(l, VALUE_ADDED_DISTR(reg,l,regg,fd) )
    = sum(ind, VALUE_ADDED_pr(reg,lpr,regg,ind) ) *
    sum(l, VALUE_ADDED_DISTR(reg,l,regg,fd) ) /
    sum((l,fdd), VALUE_ADDED_DISTR(reg,l,regg,fdd) ) ;

l_distr_h_pr(reg,lpr,regg) = l_distr_h(reg,regg) ;

l_distr_g_pr(reg,lpr,regg) = l_distr_g(reg,regg) ;

l_distr_gfcf_pr(reg,lpr,regg) = l_distr_gfcf(reg,regg) ;

LS_pr(reg,lpr)
    = sum((regg,ind),VALUE_ADDED_pr(reg,lpr,regg,ind) ) ;

aL_pr(reg,lpr,regg,ind)$VALUE_ADDED_pr(reg,lpr,regg,ind)
    = VALUE_ADDED_pr(reg,lpr,regg,ind) /
    ( sum((reggg,va)$(k(va) or l(va)), VALUE_ADDED(reggg,va,regg,ind) ) /
    prodL_pr(lpr,regg,ind) )  *
    prodL_pr(lpr,regg,ind)**( -elasKL(regg,ind) ) ;

Display
lz_share
wz_share
VALUE_ADDED_pr
VALUE_ADDED_DISTR_pr
LS_pr
aL
aL_pr
l_distr_h
l_distr_h_pr
l_distr_g
l_distr_g_pr
l_distr_gfcf
l_distr_gfcf_pr
;

Equations
    EQL_pr(reg,lpr,regg,ind)    demand for production factor labour by skill
    EQLABREV_pr(reg,lpr)        revenue from labour by skill level
    EQGRINC_H_pr(regg)          gross income of households
    EQGRINC_G_pr(regg)          gross income of government
    EQGRINC_I_pr(regg)          gross income of investment agent

    EQPY_pr(regg,ind)           zero-profit condition (including possible
                                # margins)
    EQPL_pr(reg,lpr)            balance on labour market by skill level
    EQPnKL_pr(regg,ind)         balance between specific production factors
                                # price and aggregate production factors price
;

Variables
    L_V_pr(reg,lpr,regg,ind)    use of production factor labour by skill level
    LABREV_V_pr(reg,lpr)        revenue from labour by skill level
    PL_V_pr(reg,lpr)            labour price by skill level
    LS_V_pr(reg,lpr)            supply of labour by skill level
;

* ============= Define new variables/equations ============================

* EQUATION 2.5:
EQL_pr(reg,lpr,regg,ind)$VALUE_ADDED_pr(reg,lpr,regg,ind)..
    L_V_pr(reg,lpr,regg,ind)
    =E=
    ( nKL_V(regg,ind) / prodL_pr(lpr,regg,ind) ) * aL_pr(reg,lpr,regg,ind) *
    ( PL_V_pr(reg,lpr) /
    ( prodL_pr(lpr,regg,ind) * PnKL_V(regg,ind) ) )**( -elasKL(regg,ind) ) ;

* EQUATION 1.4:
EQLABREV_pr(reg,lpr)..
    LABREV_V_pr(reg,lpr)
    =E=
    sum((regg,ind), L_V_pr(reg,lpr,regg,ind) * PL_V_pr(reg,lpr) ) ;

* EQUATION 1.8:
EQGRINC_H_pr(regg)..
    GRINC_H_V(regg)
    =E=
    sum(reg, CAPREV_V(reg) * k_distr_h(reg,regg) ) +
    sum((reg,lpr), LABREV_V_pr(reg,lpr) * l_distr_h_pr(reg,lpr,regg) ) ;

* EQUATION 1.9:
EQGRINC_G_pr(regg)..
    GRINC_G_V(regg)
    =E=
    sum(reg, CAPREV_V(reg) * k_distr_g(reg,regg) ) +
    sum((reg,lpr), LABREV_V_pr(reg,lpr) * l_distr_g_pr(reg,lpr,regg) ) +
    TSPREV_V(regg) + NTPREV_V(regg) + INMREV_V(regg) + TSEREV_V(regg) ;

* EQUATION 1.10:
EQGRINC_I_pr(regg)..
    GRINC_I_V(regg)
    =E=
    sum(reg, CAPREV_V(reg) * k_distr_gfcf(reg,regg) ) +
    sum((reg,lpr), LABREV_V_pr(reg,lpr) * l_distr_gfcf_pr(reg,lpr,regg) ) ;

* EQUATION 4.1:
EQPY_pr(regg,ind)$( Y(regg,ind) ne smax((reggg,indd), Y(reggg,indd) ) and
    Y(regg,ind) )..
    Y_V(regg,ind) * PY_V(regg,ind) *
    ( 1 - sum(reg, txd_ind(reg,regg,ind) ) -
    sum(reg, txd_inm(reg,regg,ind) ) - sum(reg, txd_tse(reg,regg,ind) ) )
    =E=
    sum(prd, INTER_USE_T_V(prd,regg,ind) * PIU_V(prd,regg,ind) *
    ( 1 + tc_ind(prd,regg,ind) ) ) +
    sum(reg, K_V(reg,regg,ind) * PK_V(reg) ) +
    sum((reg,lpr), L_V_pr(reg,lpr,regg,ind) * PL_V_pr(reg,lpr) ) +
    sum(inm, TIM_INTER_USE_ROW(inm,regg,ind) * PROW_V ) +
    sum(tse, TIM_INTER_USE_ROW(tse,regg,ind) * PROW_V ) ;

* EQUATION 4.3:
EQPL_pr(reg,lpr)..
    LS_V_pr(reg,lpr)
    =E=
    sum((regg,ind), L_V_pr(reg,lpr,regg,ind) ) ;

* EQUATION 2.6:
EQPnKL_pr(regg,ind)..
    PnKL_V(regg,ind) * nKL_V(regg,ind)
    =E=
    sum(reg, PK_V(reg) * K_V(reg,regg,ind) ) +
    sum((reg,lpr), PL_V_pr(reg,lpr) * L_V_pr(reg,lpr,regg,ind)) ;

* ======== Define levels and lower and upper bounds and fixed variables ========

L_V_pr.L(reg,lpr,regg,ind) = VALUE_ADDED_pr(reg,lpr,regg,ind) ;
L_V_pr.FX(reg,lpr,regg,ind)$(L_V_pr.L(reg,lpr,regg,ind) = 0 ) = 0 ;

LABREV_V_pr.L(reg,lpr) = sum((regg,fd), VALUE_ADDED_DISTR_pr(reg,lpr,regg,fd) ) ;
LABREV_V_pr.FX(reg,lpr)$(LABREV_V_pr.L(reg,lpr) = 0) = 0 ;

PL_V_pr.L(reg,lpr)       = 1 ;
PL_V_pr.FX(reg,lpr)$(LS_pr(reg,lpr) = 0)       = 0 ;

* Exogenous variables are fixed to their calibrated value.
LS_V_pr.FX(reg,lpr)                   = LS_pr(reg,lpr) ;

* ============= Scale and define levels of new variables/equations =============

* EQUAION 2.5
EQL_pr.SCALE(reg,lpr,regg,ind)$(L_V_pr.L(reg,lpr,regg,ind) gt 0)
    = L_V_pr.L(reg,lpr,regg,ind) ;
L_V_pr.SCALE(reg,lpr,regg,ind)$(L_V_pr.L(reg,lpr,regg,ind) gt 0)
    = L_V_pr.L(reg,lpr,regg,ind) ;

EQL_pr.SCALE(reg,lpr,regg,ind)$(L_V_pr.L(reg,lpr,regg,ind) lt 0)
    = -L_V_pr.L(reg,lpr,regg,ind) ;
L_V_pr.SCALE(reg,lpr,regg,ind)$(L_V_pr.L(reg,lpr,regg,ind) lt 0)
    = -L_V_pr.L(reg,lpr,regg,ind) ;

* EQUATION 1.4
EQLABREV_pr.SCALE(reg,lpr)$(LABREV_V_pr.L(reg,lpr) gt 0)
    = LABREV_V_pr.L(reg,lpr) ;
LABREV_V_pr.SCALE(reg,lpr)$(LABREV_V_pr.L(reg,lpr) gt 0)
    = LABREV_V_pr.L(reg,lpr) ;

EQLABREV_pr.SCALE(reg,lpr)$(LABREV_V_pr.L(reg,lpr) lt 0)
    = -LABREV_V_pr.L(reg,lpr) ;
LABREV_V_pr.SCALE(reg,lpr)$(LABREV_V_pr.L(reg,lpr) lt 0)
    = -LABREV_V_pr.L(reg,lpr) ;

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
EQPL_pr.SCALE(reg,lpr)$(LS_V_pr.L(reg,lpr) gt 0)
    = LS_V_pr.L(reg,lpr) ;

EQPL_pr.SCALE(reg,lpr)$(LS_V_pr.L(reg,lpr) lt 0)
    = -LS_V_pr.L(reg,lpr) ;

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
-EQL
-EQLABREV
-EQGRINC_H
-EQGRINC_G
-EQGRINC_I
-EQPY
-EQPL
-EQPnKL

EQL_pr.L_V_pr
EQLABREV_pr.LABREV_V_pr
EQGRINC_H_pr.GRINC_H_V
EQGRINC_G_pr.GRINC_G_V
EQGRINC_I_pr.GRINC_I_V
EQPY_pr
EQPL_pr.PL_V_pr
EQPnKL_pr.PnKL_V

/
;

* ============================== Simulation setup ==============================

* Set value for experiment.
LS_V_pr.FX('EEU','HIGH') = 1.1 * LS_pr('EEU','HIGH')       ;

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
