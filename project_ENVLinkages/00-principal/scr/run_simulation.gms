
* File:     project_ENVLinkages\00-principal\scr\run_simulation.gms
* Author:   Tatyana Bulavskaya
* Date:     25 June 2015

* gams-master-file: main.gms

$oneolcom
$eolcom #

* ======== Declaration and definition of simulation specific parameters ========

Sets
    prd_ener(prd)                       sub-set of energy products for
                                        # productivity in baseline
/
p014
p023
p030
p042
/

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

    ind_elec_nucl(ind)                  sub-set of nuclear electricity producing
                                        # industries
/
i032
/

    reg_ffsub(reg)                      countries where fossil fuel subsidy
                                        # reform is implemented
/
CN
BR
IN
RU
ID
ZA
MX
/
;

Parameter
    tc_h_ref(prd,regg,year)             new consumption tax rates for fossil
                                        # fuel subsidy reform
    elec_mix(regg,ind,year)             electricity mix
;

tc_h_ref(prd,regg,year) = tc_h(prd,regg) ;

* tax on households on energy products in selected regions grows gradually
* till 2020 to the EU level.
loop(year$( ord(year) ge 8 and ord(year) le 20 ),
    tc_h_ref(prd_ener,reg_ffsub,year)$( tc_h_ref(prd_ener,reg_ffsub,year) lt
        tc_h(prd_ener,"EU") ) =
        tc_h_ref(prd_ener,reg_ffsub,year - 1) +
        ( tc_h(prd_ener,"EU") - tc_h(prd_ener,reg_ffsub) ) / 13 ;
) ;

loop(year$( ord(year) ge 21 and ord(year) le 35 ),
    tc_h_ref(prd_ener,reg_ffsub,year) =
        tc_h_ref(prd_ener,reg_ffsub,year - 1) ;
) ;

Display
tc_h_ref
;


elec_mix(regg,ind_elec,year) =
    sum(prd_elec, coprodB(regg,prd_elec,regg,ind_elec) ) ;


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

Parameters
    GDPCONST_save(regg,*)
    Y_save(regg,*)
    INTER_USE_save(regg,*)
    CONS_H_save(regg,*)
    CONS_G_save(regg,*)
    GFCF_save(regg,*)
    SV_save(regg,*)
;


$include    %project%\00-principal\scr\save_simulation_results_declaration_parameters.gms

* = Declaration and definition of simulation specific variables and/or equations


* ====== Define levels and lower and upper bounds and fixed new variables ======


* ======================= Scale new variables/equations ========================


* ================= Define models with new variables/equations =================


* ============================== Simulation setup ==============================

* start loop over years
*loop(year$( ord(year) eq 8),
loop(year$( ord(year) ge 35 and ord(year) le 35 ),

* CEPII baseline
* always use baseline independent of the %scenario%
$ontext
KLS(reg,kl)             = KLS_V.L(reg,kl) ;
KLS_V.FX(reg,"GOS")     = KLS(reg,"GOS") * KS_CEPII_change(reg,year) ;
KLS_V.FX(reg,"COE")     = KLS(reg,"COE") * LS_CEPII_change(reg,year) ;

fprod(kl,regg,ind)      = fprod(kl,regg,ind) *
    PRODKL_CEPII_change(regg,year) ;
ioc(prd_ener,regg,ind)  = ioc(prd_ener,regg,ind) /
    PRODE_CEPII_change(regg,year) ;

* reduce the share of output that is inventories
theta_sv(reg,prd,regg) = theta_sv(reg,prd,regg) * 0.98 ;

* transfers from the government to the households grows at the rate of population
GTRF(reg) = GTRF(reg) * LS_CEPII_change(reg,year) ;
$offtext

* fossil fuel tax reform
*tc_h(prd,regg) = tc_h_ref(prd,regg,year) ;


* =============================== Solve statement ==============================
Option iterlim = 10000 ;
Option reslim  = 10000 ;
Option decimals = 8 ;
Option nlp = conopt3 ;
CGE_MCP.scaleopt = 1 ;
*Solve CGE_MCP using MCP ;

GDPCONST_save(regg,"BL")   = GDPCONST_V.L(regg) ;
Y_save(regg,"BL")          = sum(ind, Y_V.L(regg,ind) ) ;
INTER_USE_save(regg,"BL")  = sum((prd,ind), INTER_USE_T_V.L(prd,regg,ind) ) ;
CONS_H_save(regg,"BL")     = sum(prd, CONS_H_T_V.L(prd,regg) * tc_h_0(prd,regg) ) ;
CONS_G_save(regg,"BL")     = sum(prd, CONS_G_T_V.L(prd,regg) * tc_g_0(prd,regg) ) ;
GFCF_save(regg,"BL")       = sum(prd, GFCF_T_V.L(prd,regg) * tc_gfcf_0(prd,regg) ) ;
SV_save(regg,"BL")         = sum((reg,prd), SV_V.L(reg,prd,regg) * tc_sv_0(prd,regg) ) ;


* Store simulation results after each year
*$include %project%\00-principal\scr\save_simulation_results.gms

* fossil fuel tax reform
tc_h(prd,regg) = tc_h_ref(prd,regg,year) ;
Solve CGE_MCP using MCP ;

GDPCONST_save(regg,"FF")   = GDPCONST_V.L(regg) ;
Y_save(regg,"FF")          = sum(ind, Y_V.L(regg,ind) ) ;
INTER_USE_save(regg,"FF")  = sum((prd,ind), INTER_USE_T_V.L(prd,regg,ind) ) ;
CONS_H_save(regg,"FF")     = sum(prd, CONS_H_T_V.L(prd,regg) * tc_h_0(prd,regg) ) ;
CONS_G_save(regg,"FF")     = sum(prd, CONS_G_T_V.L(prd,regg) * tc_g_0(prd,regg) ) ;
GFCF_save(regg,"FF")       = sum(prd, GFCF_T_V.L(prd,regg) * tc_gfcf_0(prd,regg) ) ;
SV_save(regg,"FF")         = sum((reg,prd), SV_V.L(reg,prd,regg) * tc_sv_0(prd,regg) ) ;

* end loop over years
) ;

Display
GDPCONST_save
Y_save
INTER_USE_save
CONS_H_save
CONS_G_save
GFCF_save
SV_save
;

* ========================= Post-processing of results =========================

$ontext
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
$offtext

Execute_Unload 'results_FFEurope'
