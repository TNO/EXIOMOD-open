
* File:   project_ENVLinkages/00-principal/scr/save_simulation_results.gms
* Author: Jinxue Hu
* Date:   19 February 2015

* Store simulation results after each year in the simulation run


*Endogenous variables

Y_%scenario%(regg,ind,year)                     = Y_V.L(regg,ind) ;
X_%scenario%(reg,prd,year)                      = X_V.L(reg,prd) ;

INTER_USE_T_%scenario%(prd,regg,ind,year)       = INTER_USE_T_V.L(prd,regg,ind) ;
INTER_USE_D_%scenario%(prd,regg,ind,year)       = INTER_USE_D_V.L(prd,regg,ind) ;
INTER_USE_M_%scenario%(prd,regg,ind,year)       = INTER_USE_M_V.L(prd,regg,ind) ;

VA_%scenario%(regg,ind,year)                    = VA_V.L(regg,ind) ;
KL_%scenario%(reg,va,regg,ind,year)             = KL_V.L(reg,va,regg,ind) ;


CONS_H_T_%scenario%(prd,regg,year)              = CONS_H_T_V.L(prd,regg) ;
CONS_H_D_%scenario%(prd,regg,year)              = CONS_H_D_V.L(prd,regg) ;
CONS_H_M_%scenario%(prd,regg,year)              = CONS_H_M_V.L(prd,regg) ;

CONS_G_T_%scenario%(prd,regg,year)              = CONS_G_T_V.L(prd,regg) ;
CONS_G_D_%scenario%(prd,regg,year)              = CONS_G_D_V.L(prd,regg) ;
CONS_G_M_%scenario%(prd,regg,year)              = CONS_G_M_V.L(prd,regg) ;

GFCF_T_%scenario%(prd,regg,year)                = GFCF_T_V.L(prd,regg) ;
GFCF_D_%scenario%(prd,regg,year)                = GFCF_D_V.L(prd,regg) ;
GFCF_M_%scenario%(prd,regg,year)                = GFCF_M_V.L(prd,regg) ;

SV_%scenario%(reg,prd,regg,year)                = SV_V.L(reg,prd,regg) ;

IMPORT_T_%scenario%(prd,regg,year)              = IMPORT_T_V.L(prd,regg)   ;
IMPORT_MOD_%scenario%(prd,regg,year)            = IMPORT_MOD_V.L(prd,regg) ;
IMPORT_ROW_%scenario%(prd,regg,year)            = IMPORT_ROW_V.L(prd,regg) ;
TRADE_%scenario%(reg,prd,regg,year)             = TRADE_V.L(reg,prd,regg)  ;
EXPORT_ROW_%scenario%(reg,prd,year)             = EXPORT_ROW_V.L(reg,prd)  ;

FACREV_%scenario%(reg,va,year)                  = FACREV_V.L(reg,va) ;
TSPREV_%scenario%(reg,year)                     = TSPREV_V.L(reg) ;
NTPREV_%scenario%(reg,year)                     = NTPREV_V.L(reg) ;
TIMREV_%scenario%(reg,year)                     = TIMREV_V.L(reg) ;

GRINC_H_%scenario%(regg,year)                   = GRINC_H_V.L(regg) ;
GRINC_G_%scenario%(regg,year)                   = GRINC_G_V.L(regg) ;
GRINC_I_%scenario%(regg,year)                   = GRINC_I_V.L(regg) ;
CBUD_H_%scenario%(regg,year)                    = CBUD_H_V.L(regg)  ;
CBUD_G_%scenario%(regg,year)                    = CBUD_G_V.L(regg)  ;
CBUD_I_%scenario%(regg,year)                    = CBUD_I_V.L(regg)  ;

PY_%scenario%(regg,ind,year)                    = PY_V.L(regg,ind) ;
P_%scenario%(reg,prd,year)                      = P_V.L(reg,prd) ;
PKL_%scenario%(reg,va,year)                     = PKL_V.L(reg,va) ;
PVA_%scenario%(regg,ind,year)                   = PVA_V.L(regg,ind) ;
PIU_%scenario%(prd,regg,ind,year)               = PIU_V.L(prd,regg,ind) ;

PC_H_%scenario%(prd,regg,year)                  = PC_H_V.L(prd,regg)     ;
PC_G_%scenario%(prd,regg,year)                  = PC_G_V.L(prd,regg)     ;
PC_I_%scenario%(prd,regg,year)                  = PC_I_V.L(prd,regg)     ;
PIMP_T_%scenario%(prd,regg,year)                = PIMP_T_V.L(prd,regg)   ;
PIMP_MOD_%scenario%(prd,regg,year)              = PIMP_MOD_V.L(prd,regg) ;
SCLFD_H_%scenario%(regg,year)                   = SCLFD_H_V.L(regg)      ;
SCLFD_G_%scenario%(regg,year)                   = SCLFD_G_V.L(regg)      ;
SCLFD_I_%scenario%(regg,year)                   = SCLFD_I_V.L(regg)      ;
PROW_%scenario%(year)                           = PROW_V.L ;

PAASCHE_%scenario%(regg,year)                   = PAASCHE_V.L(regg) ;
LASPEYRES_%scenario%(regg,year)                 = LASPEYRES_V.L(regg) ;

GDPCUR_%scenario%(regg,year)                    = GDPCUR_V.L(regg)    ;
GDPCONST_%scenario%(regg,year)                  = GDPCONST_V.L(regg)  ;
GDPDEF_%scenario%(year)                         = GDPDEF_V.L          ;

* Exogenous variables
KLS_%scenario%(reg,va,year)                     = KLS_V.L(reg,va) ;
INCTRANSFER_%scenario%(reg,fd,regg,fdd,year)    = INCTRANSFER_V.L(reg,fd,regg,fdd) ;
SV_ROW_%scenario%(prd,regg,year)                = SV_ROW_V.L(prd,regg) ;
TRANSFERS_ROW_%scenario%(reg,fd,year)           = TRANSFERS_ROW_V.L(reg,fd) ;


* New variables declared in simulation setup
tc_ind_%scenario%(prd,regg,ind,year)            = tc_ind(prd,regg,ind) ;
tc_h_%scenario%(prd,regg,year)                  = tc_h(prd,regg) ;
