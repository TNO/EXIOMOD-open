
* File:   project_COMPLEX/03_simulation_results/scr/save_simulation_results.gms
* Author: Jinxue Hu
* Date:   19 October 2015
* Adjusted: 14 April 2016

* Store simulation results after each year in the simulation run


*Endogenous variables

* Consumption
CONS_H_T_time(prd,regg,year)  =   CONS_H_T_V.L(prd,regg) ;
CONS_G_T_time(prd,regg,year)  =   CONS_G_T_V.L(prd,regg) ;
GFCF_T_time(prd,regg,year)    =   GFCF_T_V.L(prd,regg) ;

CAPREV_time(reg,year)         =   CAPREV_V.L(reg) ;
LABREV_time(reg,year)         =   LABREV_V.L(reg) ;
TSPREV_time(reg,year)         =   TSPREV_V.L(reg) ;
NTPREV_time(reg,year)         =   NTPREV_V.L(reg) ;
INMREV_time(reg,year)         =   INMREV_V.L(reg) ;
TSEREV_time(reg,year)         =   TSEREV_V.L(reg) ;

GRINC_H_time(regg,year)       =   GRINC_H_V.L(regg) ;
GRINC_G_time(regg,year)       =   GRINC_G_V.L(regg) ;
GRINC_I_time(regg,year)       =   GRINC_I_V.L(regg) ;
CBUD_H_time(regg,year)        =   CBUD_H_V.L(regg) ;
CBUD_G_time(regg,year)        =   CBUD_G_V.L(regg) ;
CBUD_I_time(regg,year)        =   CBUD_I_V.L(regg) ;


SCLFD_H_time(regg,year)       =   SCLFD_H_V.L(regg) ;
SCLFD_G_time(regg,year)       =   SCLFD_G_V.L(regg) ;
SCLFD_I_time(regg,year)       =   SCLFD_I_V.L(regg) ;

INCTRANSFER_time(reg,fd,regg,fdd,year) =   INCTRANSFER_V.L(reg,fd,regg,fdd) ;
TRANSFERS_ROW_time(reg,fd,year)        =   TRANSFERS_ROW_V.L(reg,fd) ;

$if %demnfunc% == "CES" $goto demnfunc_CES
CONS_H_T_MIN_time(prd,regg,year) =   CONS_H_T_MIN(prd,regg) ;
$label demnfunc_CES

* Production
Y_time(regg,ind,year)         =   Y_V.L(regg,ind) ;
X_time(reg,prd,year)          =   X_V.L(reg,prd) ;

INTER_USE_T_time(prd,regg,ind,year) =   INTER_USE_T_V.L(prd,regg,ind) ;

K_time(reg,regg,ind,year)     =   K_V.L(reg,regg,ind) ;
L_time(reg,regg,ind,year)     =   L_V.L(reg,regg,ind) ;
PnKL_time(regg,ind,year)      =   PnKL_V.L(regg,ind) ;


$if %prodfunc% == "KL" $goto prod_func_KL
nKLE_time(regg,ind,year)      =   nKLE_V.L(regg,ind) ;
nENER_time(regg,ind,year)     =   nENER_V.L(regg,ind) ;
nKL_time(regg,ind,year)       =   nKL_V.L(regg,ind) ;
ENER_time(prd,regg,ind,year)  =   ENER_V.L(prd,regg,ind) ;

PnENER_time(regg,ind,year)    =   PnENER_V.L(regg,ind) ;
PnKLE_time(regg,ind,year)     =   PnKLE_V.L(regg,ind) ;
$label prod_func_KL

* Trade
INTER_USE_D_time(prd,regg,ind,year) =   INTER_USE_D_V.L(prd,regg,ind) ;
INTER_USE_M_time(prd,regg,ind,year) =   INTER_USE_M_V.L(prd,regg,ind) ;

CONS_H_D_time(prd,regg,year)  =   CONS_H_D_V.L(prd,regg) ;
CONS_H_M_time(prd,regg,year)  =   CONS_H_M_V.L(prd,regg) ;
CONS_G_D_time(prd,regg,year)  =   CONS_G_D_V.L(prd,regg) ;
CONS_G_M_time(prd,regg,year)  =   CONS_G_M_V.L(prd,regg) ;
GFCF_D_time(prd,regg,year)    =   GFCF_D_V.L(prd,regg) ;
GFCF_M_time(prd,regg,year)    =   GFCF_M_V.L(prd,regg) ;
SV_time(reg,prd,regg,year)    =   SV_V.L(reg,prd,regg) ;

IMPORT_T_time(prd,regg,year)  =   IMPORT_T_V.L(prd,regg) ;
IMPORT_MOD_time(prd,regg,year)    =   IMPORT_MOD_V.L(prd,regg) ;
IMPORT_ROW_time(prd,regg,year)    =   IMPORT_ROW_V.L(prd,regg) ;
TRADE_time(reg,prd,regg,year) =   TRADE_V.L(reg,prd,regg) ;
EXPORT_ROW_time(reg,prd,year) =   EXPORT_ROW_V.L(reg,prd) ;

PIMP_T_time(prd,regg,year)    =   PIMP_T_V.L(prd,regg) ;
PIMP_MOD_time(prd,regg,year)  =   PIMP_MOD_V.L(prd,regg) ;

*Closure
PY_time(regg,ind,year)        =   PY_V.L(regg,ind) ;
P_time(reg,prd,year)          =   P_V.L(reg,prd) ;
PK_time(reg,year)             =   PK_V.L(reg) ;
PL_time(reg,year)             =   PL_V.L(reg) ;

PIU_time(prd,regg,ind,year)   =   PIU_V.L(prd,regg,ind) ;
PC_H_time(prd,regg,year)      =   PC_H_V.L(prd,regg) ;
PC_G_time(prd,regg,year)      =   PC_G_V.L(prd,regg) ;
PC_I_time(prd,regg,year)      =   PC_I_V.L(prd,regg) ;
PROW_time                     =   PROW_V.L ;
PAASCHE_time(regg,year)       =   PAASCHE_V.L(regg) ;
LASPEYRES_time(regg,year)     =   LASPEYRES_V.L(regg) ;
GDPCUR_time(regg,year)        =   GDPCUR_V.L(regg) ;
GDPCONST_time(regg,year)      =   GDPCONST_V.L(regg) ;
GDPDEF_time                   =   GDPDEF_V.L ;


*Exogenous variables
tc_h_time(prd,regg,year)      =   tc_h(prd,regg) ;
tc_g_time(prd,regg,year)      =   tc_g(prd,regg) ;
tc_gfcf_time(prd,regg,year)   =   tc_gfcf(prd,regg) ;

txd_ind_time(reg,regg,ind,year)   =   txd_ind(reg,regg,ind) ;
tc_ind_time(prd,regg,ind,year)    =   tc_ind(prd,regg,ind) ;

ty_time(reg,year)             = ty(reg) ;

*Complex specific parameters
prodK_time(regg,ind,year)     =   prodK(regg,ind) ;
prodL_time(regg,ind,year)     =   prodL(regg,ind) ;
