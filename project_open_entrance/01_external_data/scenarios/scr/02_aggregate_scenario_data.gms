
$ontext

File:   02-aggregate-ref-data.gms
Author: Hettie Boonman
Date:   17-12-2019

This script processes the baseline data from CEPII (version 2.2).


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "elec"        ref electricity mix

    2. Data source (should be the same as name of the library)
    "_ref"        ref data

    3. Unit of measurement
    "_level"        absolute value for year t
    "_change"       annual change in t/(t-1)-1

Example of resulting parameter: elec_ref_change


INPUTS
    elec_ref_orig(reg_ref,source_ref,year_ref)      ref electricity data in
                                                    original classification

OUTPUTS
    elec_ref_change                                annual electricity mix change

annual change is expressed in t/(t-1)-1
$offtext

$oneolcom
$eolcom #


* ==================== Declaration of aggregation schemes ======================
Sets

    reg_sce_aggr(reg_sce,reg_data)        aggregation scheme for ref regions
/
$include %project%\01_external_data\scenarios\sets\aggregation\regions_sce_to_data.txt
/

    ind_sce_aggr(ind_sce,ind_data)  aggregation scheme for ref sources
/
$include %project%\01_external_data\scenarios\sets\aggregation\industries_sce_to_data.txt
/

    prd_sce_aggr(prd_sce,prd_data)  aggregation scheme for ref sources
/
$include %project%\01_external_data\scenarios\sets\aggregation\products_sce_to_data.txt
/

*    year1_sce
*/
*YR2007*YR2050
*/

    yr_sce_aggr(year1_sce,year)  aggregation scheme for ref sources
/
$include %project%\01_external_data\scenarios\sets\aggregation\years_sce_to_data.txt
/


    ind_elec(ind)
/
iELCC     'Production of electricity by coal'
iELCG     'Production of electricity by gas'
iELCN     'Production of electricity by nuclear'
iELCH     'Production of electricity by hydro'
iELCW     'Production of electricity by wind'
iELCO     'Production of electricity by petroleum and other oil derivatives'
iELCB     'Production of electricity by biomass and waste'
iELCS     'Production of electricity by solar photovoltaic'
iELCE     'Production of electricity nec'
iELCT     'Production of electricity by Geothermal'
/

    ind_ng(ind)
/
iH2
iNGAS
/

    ener_tran(ener)
/ pELEC, pBIO, pGSL, pNG
/

    ener_ind(ener)
/ pELEC, pNG, pOIL, pBIO, pCOA
/

    ener_serv(ener)
/ pELEC, pNG, pOIL, pBIO, pCOA
/

    ener_hh(ener)
/ pELEC, pNG, pOIL, pBIO, pCOA
/

    sce_sce_select(sce_sce)

    year_select(year)
/ 2011*2020 /
;

sce_sce_select(sce_sce) = yes;
sce_sce_select("REF")=no;


Alias
    (year1_sce,yearr1_sce)
    (ind_elec,indd_elec)
    (ind_ng,indd_ng)
    (ener_tran,enerr_tran)
    (ener_ind,enerr_ind)
    (ener_serv,enerr_serv)
    (ener_hh,enerr_hh)

;


* ==================== Create trajectories for ener_use_..._change =============

Parameters
    ener_use_tran_yrr(sce_sce,reg_OE,var_OE,year)            Energy use in EJ
                                                    # for transport sector
    ener_use_ind_yrr(sce_sce,reg_OE,var_OE,year)             Energy use in EJ
                                                    # for industries
    ener_use_hh_serv_yrr(sce_sce,reg_OE,var_OE,year)         Energy use in EJ
                                                    # for hh and services

    ener_use_tran_aggrr(sce_sce,prd,reg,ind,year)           Energy use in EJ
                                                    # for transport sector
    ener_use_ind_aggrr(sce_sce,prd,reg,ind,year)            Energy use in EJ
                                                    # for industries
    ener_use_serv_aggrr(sce_sce,prd,reg,ind,year)        Energy use in EJ
                                                    # for hh and services

    ener_use_tran_change(sce_sce,prd,reg,ind,year)

    ener_use_ind_change(sce_sce,prd,reg,ind,year)

    ener_use_serv_change(sce_sce,prd,reg,ind,year)
;


* Set year 2011
* As if it is equal to 2015. (Reason, interpolation from 2015-2020 to 2011 gives
* too many negative numbers.
ener_use_tran_yrr(sce_sce,reg_OE,var_OE,'2011')
    = sum(sce_OE, ener_use_tran_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2015','value') ) ;
ener_use_ind_yrr(sce_sce,reg_OE,var_OE,'2011')
    = sum(sce_OE, ener_use_ind_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2015','value') ) ;
ener_use_hh_serv_yrr(sce_sce,reg_OE,var_OE,'2011')
    = sum(sce_OE, ener_use_hh_serv_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2015','value') ) ;

* Set year 2050
ener_use_tran_yrr(sce_sce,reg_OE,var_OE,'2050')
    = sum(sce_OE, ener_use_tran_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2050','value') ) ;
ener_use_ind_yrr(sce_sce,reg_OE,var_OE,'2050')
    = sum(sce_OE, ener_use_ind_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2050','value') ) ;
ener_use_hh_serv_yrr(sce_sce,reg_OE,var_OE,'2050')
    = sum(sce_OE, ener_use_hh_serv_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2050','value') ) ;

* Aggregate to region and product
ener_use_tran_aggrr(sce_sce,prd,reg,'iTRAN',year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_prd_aggr(var_OE,prd),
       ener_use_tran_yrr(sce_sce,reg_OE,var_OE,year) ) ) )   ;

ener_use_ind_aggrr(sce_sce,prd,reg,'iINDU',year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_prd_aggr(var_OE,prd),
       ener_use_ind_yrr(sce_sce,reg_OE,var_OE,year) ) ) )   ;

ener_use_serv_aggrr(sce_sce,prd,reg,'iSERV',year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_prd_aggr(var_OE,prd),
       ener_use_hh_serv_yrr(sce_sce,reg_OE,var_OE,year) ) ) )   ;


* INTERPOLATE REFERENCE
ener_use_tran_aggrr("REF",prd,reg,ind,year)$(ord(year) gt 1 and ord(year) lt 40)
    = ener_use_tran_aggrr("REF",prd,reg,ind,'2011')
        + (2010+ord(year)-2011)/(2050-2011)
        * (ener_use_tran_aggrr("REF",prd,reg,ind,'2050')
            - ener_use_tran_aggrr("REF",prd,reg,ind,'2011') )  ;

ener_use_ind_aggrr("REF",prd,reg,ind,year)$(ord(year) gt 1 and ord(year) lt 40)
    = ener_use_ind_aggrr("REF",prd,reg,ind,'2011')
        + (2010+ord(year)-2011)/(2050-2011)
        * (ener_use_ind_aggrr("REF",prd,reg,ind,'2050')
            - ener_use_ind_aggrr("REF",prd,reg,ind,'2011') )  ;

ener_use_serv_aggrr("REF",prd,reg,ind,year)$(ord(year) gt 1 and ord(year) lt 40)
    = ener_use_serv_aggrr("REF",prd,reg,ind,'2011')
        + (2010+ord(year)-2011)/(2050-2011)
        * (ener_use_serv_aggrr("REF",prd,reg,ind,'2050')
            - ener_use_serv_aggrr("REF",prd,reg,ind,'2011') )  ;

* FIX FIRST 10 YEARS FOR OTHER SCENARIOS
ener_use_tran_aggrr(sce_sce_select,prd,reg,ind,year_select) = ener_use_tran_aggrr("REF",prd,reg,ind,year_select) ;
ener_use_ind_aggrr(sce_sce_select,prd,reg,ind,year_select) = ener_use_ind_aggrr("REF",prd,reg,ind,year_select) ;
ener_use_serv_aggrr(sce_sce_select,prd,reg,ind,year_select) = ener_use_serv_aggrr("REF",prd,reg,ind,year_select) ;

* INTERPOLATE OTHER SCENARIOS
ener_use_tran_aggrr(sce_sce_select,prd,reg,ind,year)$(ord(year) gt 10 and ord(year) lt 40)
    = ener_use_tran_aggrr(sce_sce_select,prd,reg,ind,'2020')
        + (ord(year)-10)/(2050-2020)
        * (ener_use_tran_aggrr(sce_sce_select,prd,reg,ind,'2050')
            - ener_use_tran_aggrr(sce_sce_select,prd,reg,ind,'2020') )  ;

ener_use_ind_aggrr(sce_sce_select,prd,reg,ind,year)$(ord(year) gt 10 and ord(year) lt 40)
    = ener_use_ind_aggrr(sce_sce_select,prd,reg,ind,'2020')
        + (ord(year)-10)/(2050-2020)
        * (ener_use_ind_aggrr(sce_sce_select,prd,reg,ind,'2050')
            - ener_use_ind_aggrr(sce_sce_select,prd,reg,ind,'2020') )  ;

ener_use_serv_aggrr(sce_sce_select,prd,reg,ind,year)$(ord(year) gt 10 and ord(year) lt 40)
    = ener_use_serv_aggrr(sce_sce_select,prd,reg,ind,'2020')
        + (ord(year)-10)/(2050-2020)
        * (ener_use_serv_aggrr(sce_sce_select,prd,reg,ind,'2050')
            - ener_use_serv_aggrr(sce_sce_select,prd,reg,ind,'2020') )  ;



*Change with respect to year before.
ener_use_tran_change(sce_sce,prd,reg,ind,year)$ener_use_tran_aggrr(sce_sce,prd,reg,ind,year-1)
    = ener_use_tran_aggrr(sce_sce,prd,reg,ind,year) / ener_use_tran_aggrr(sce_sce,prd,reg,ind,year-1) ;

ener_use_ind_change(sce_sce,prd,reg,ind,year)$ener_use_ind_aggrr(sce_sce,prd,reg,ind,year-1)
    = ener_use_ind_aggrr(sce_sce,prd,reg,ind,year) / ener_use_ind_aggrr(sce_sce,prd,reg,ind,year-1) ;

ener_use_serv_change(sce_sce,prd,reg,ind,year)$ener_use_serv_aggrr(sce_sce,prd,reg,ind,year-1)
    = ener_use_serv_aggrr(sce_sce,prd,reg,ind,year) / ener_use_serv_aggrr(sce_sce,prd,reg,ind,year-1) ;

ener_use_tran_change(sce_sce,prd,reg,ind,'2011')$ener_use_tran_change(sce_sce,prd,reg,ind,'2012') = 1;
ener_use_tran_change(sce_sce,prd,reg,ind,'2012')
    $(not ener_use_tran_change(sce_sce,prd,reg,ind,'2012')
      and  ener_use_tran_change(sce_sce,prd,reg,ind,'2015') ) = 1;

ener_use_ind_change(sce_sce,prd,reg,ind,'2011')$ener_use_ind_change(sce_sce,prd,reg,ind,'2012') = 1;
ener_use_ind_change(sce_sce,prd,reg,ind,'2012')
    $(not ener_use_ind_change(sce_sce,prd,reg,ind,'2012')
      and  ener_use_ind_change(sce_sce,prd,reg,ind,'2015') ) = 1;

ener_use_serv_change(sce_sce,prd,reg,ind,'2011')$ener_use_serv_change(sce_sce,prd,reg,ind,'2012') = 1;
ener_use_tran_change(sce_sce,prd,reg,ind,'2012')
    $(not ener_use_serv_change(sce_sce,prd,reg,ind,'2012')
      and  ener_use_serv_change(sce_sce,prd,reg,ind,'2015') ) = 1;

Display

    ener_use_tran_yrr
    ener_use_ind_yrr
    ener_use_hh_serv_yrr

    ener_use_tran_aggrr
    ener_use_ind_aggrr
    ener_use_serv_aggrr

    ener_use_tran_change
    ener_use_ind_change
    ener_use_serv_change
;

* ============================ Fix the final year only =========================

Parameters
    techmix_yr(sce_sce,reg_OE,var_OE,year)               Technology mix in %
    ener_use_hh_serv_yr(sce_sce,reg_OE,var_OE,year)         Energy use in EJ
                                                    # for hh and services
;


* Set year 2050
techmix_yr(sce_sce,reg_OE,var_OE,'2050')
    = sum(sce_OE, techmix_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2050','value') ) ;
ener_use_hh_serv_yr(sce_sce,reg_OE,var_OE,'2050')
    = sum(sce_OE, ener_use_hh_serv_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2050','value') ) ;

Display
    techmix_yr
    ener_use_hh_serv_yr
;




*=============== Aggregate to correct region and industry level ================


Parameters
    techmix_aggr(sce_sce,reg,ind,year)                   Technology mix in %
    ener_use_hh_serv_aggr(sce_sce,reg,prd,year)          Energy use in EJ
                                                         # for hh and services
;

techmix_aggr(sce_sce,reg,ind,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
            sum(ind_data$ind_aggr(ind_data,ind),
                sum(var_OE$var_OE_aggr(var_OE,ind_data),
       techmix_yr(sce_sce,reg_OE,var_OE,year) ) ) ) )  ;

ener_use_hh_serv_aggr(sce_sce,reg,prd,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_prd_aggr(var_OE,prd),
       ener_use_hh_serv_yr(sce_sce,reg_OE,var_OE,year) ) ) )   ;


;

Display
    techmix_aggr
    ener_use_hh_serv_aggr
;

*====================== create shares ==========================================

Parameters
    techmix_shares(sce_sce,reg,ind,year)                Technology mix in %
    ener_use_hh_shares(sce_sce,prd,reg,year)            Energy use in EJ
                                                        # for hh and services
;

techmix_shares(sce_sce,reg,ind,year)$sum(indd, techmix_aggr(sce_sce,reg,indd,year))
    =
    techmix_aggr(sce_sce,reg,ind,year) / sum(indd , techmix_aggr(sce_sce,reg,indd,year)) ;


ener_use_hh_shares(sce_sce,prd,reg,year)$sum(prdd, ener_use_hh_serv_aggr(sce_sce,reg,prdd,year))
    =
    ener_use_hh_serv_aggr(sce_sce,reg,prd,year) / sum(prdd, ener_use_hh_serv_aggr(sce_sce,reg,prdd,year)) ;

Display
    techmix_shares
    ener_use_hh_shares
;


* =============== Create values for 2011 =======================================

* Technology mix
techmix_shares(sce_sce,reg,ind_elec,'2011')
    $sum((reggg,indd_elec),coprodB(reg,'pELEC',reggg,indd_elec))
    = coprodB(reg,'pELEC',reg,ind_elec)
        / sum((reggg,indd_elec),coprodB(reg,'pELEC',reggg,indd_elec))  ;

* If value 2050>0 and value 2011=0, add a very very small value in coprodB
* in 2011
techmix_shares(sce_sce,reg,ind_elec,'2011')
    $(techmix_shares(sce_sce,reg,ind_elec,'2050')  and not techmix_shares(sce_sce,reg,ind_elec,'2011') )
     = 0.0000000001 ;


ener_use_hh_shares(sce_sce,ener_hh,regg,'2011')
    $(sum(enerr_hh, theta_h(enerr_hh,regg)) and sum(prd,ener_use_hh_shares(sce_sce,prd,regg,'2050')))
    = theta_h(ener_hh,regg)
        / sum(enerr_hh, theta_h(enerr_hh,regg)) ;

Display
    techmix_shares
    ener_use_hh_shares
;



* =============== Interpolate year 2011 to year 2050 ===========================

* Find trajectory for reference scenario
techmix_shares("REF",reg,ind_elec,year)$(ord(year) gt 1 and ord(year) lt 40)
    = techmix_shares("REF",reg,ind_elec,'2011')
        + (2010+ord(year)-2011)/(2050-2011)
        * (techmix_shares("REF",reg,ind_elec,'2050')
            - techmix_shares("REF",reg,ind_elec,'2011') )  ;

ener_use_hh_shares("REF",prd,reg,year)$(ord(year) gt 1 and ord(year) lt 40)
    = ener_use_hh_shares("REF",prd,reg,'2011')
        + (2010+ord(year)-2011)/(2050-2011)
        * (ener_use_hh_shares("REF",prd,reg,'2050')
            - ener_use_hh_shares("REF",prd,reg,'2011') )  ;


* Note that the first 10 years should be equal to the reference scenario
techmix_shares(sce_sce_select,reg,ind_elec,year_select) = techmix_shares("REF",reg,ind_elec,year_select) ;
ener_use_hh_shares(sce_sce_select,prd,reg,year_select) = ener_use_hh_shares("REF",prd,reg,year_select) ;


* Interpolate the remaining 30 years
techmix_shares(sce_sce_select,reg,ind_elec,year)$(ord(year) gt 10 and ord(year) lt 40)
    = techmix_shares(sce_sce_select,reg,ind_elec,'2020')
        + (ord(year)-10)/(2050-2020)
        * (techmix_shares(sce_sce_select,reg,ind_elec,'2050')
            - techmix_shares(sce_sce_select,reg,ind_elec,'2020') )  ;

ener_use_hh_shares(sce_sce_select,prd,reg,year)$(ord(year) gt 10 and ord(year) lt 40)
    = ener_use_hh_shares(sce_sce_select,prd,reg,'2020')
        + (ord(year)-10)/(2050-2020)
        * (ener_use_hh_shares(sce_sce_select,prd,reg,'2050')
            - ener_use_hh_shares(sce_sce_select,prd,reg,'2020') )  ;


Display
    techmix_shares
    ener_use_hh_shares
;


* ============================ Aggregation of years ============================

Parameters
    GDP_yr(sce_sce,reg_sce,year)                            GDP growth wrt 2007
    POP_yr(sce_sce,reg_sce,year)                            POP growth wrt 2007
    CO2budget_yr(sce_sce,reg_sce,year)

* For interpolation of results
    year_sce_intpol1(year1_sce,year_sce)                 Helpvariable for interpolation
    year_sce_intpol2(year1_sce,year_sce)                 Helpvariable for interpolation

;

$libinclude xlimport year_sce_intpol1  %project%\01_external_data\scenarios\sets\aggregation\Years_interpolation.xlsx    Years_interpolation1!a2:k10000
$libinclude xlimport year_sce_intpol2  %project%\01_external_data\scenarios\sets\aggregation\Years_interpolation.xlsx    Years_interpolation2!a2:k10000


* For the reference:
GDP_yr("REF",reg_sce,year)
         =  sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             GDP_data("REF",reg_sce,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((GDP_data("REF",reg_sce,year_sce)-
                    GDP_data("REF",reg_sce,year_sce-1))$(GDP_data("REF",reg_sce,year_sce-1)))/sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
            )
;

POP_yr("REF",reg_sce,year)
         = sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             POP_data("REF",reg_sce,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((POP_data("REF",reg_sce,year_sce)-
                    POP_data("REF",reg_sce,year_sce-1))$(POP_data("REF",reg_sce,year_sce-1)))/sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
            )
;


CO2budget_yr("REF",reg_sce,year)
    =   sum(year1_sce$yr_sce_aggr(year1_sce,year),

        1 -
        ( ord(year1_sce) - 1 ) *
        (1 - CO2budget_data("REF",reg_sce,'CO2budgetperc'))/(2050-2007)

        )
;

* UK does not exist, we have data for GB.
CO2budget_yr(sce_sce,"UK",year) = 0;

* For the other scenarios
GDP_yr(sce_sce_select,reg_sce,year_select)          = GDP_yr("REF",reg_sce,year_select) ;
POP_yr(sce_sce_select,reg_sce,year_select)          = POP_yr("REF",reg_sce,year_select) ;
CO2budget_yr(sce_sce_select,reg_sce,year_select)    = CO2budget_yr("REF",reg_sce,year_select) ;




GDP_yr(sce_sce_select,reg_sce,year)$(ord(year) gt 10 and ord(year) lt 41)
         =  sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             GDP_data(sce_sce_select,reg_sce,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((GDP_data(sce_sce_select,reg_sce,year_sce)-
                    GDP_data(sce_sce_select,reg_sce,year_sce-1))$(GDP_data(sce_sce_select,reg_sce,year_sce-1)))/sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
            )
;


POP_yr(sce_sce_select,reg_sce,year)$(ord(year) gt 10 and ord(year) lt 41)
         = sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             POP_data(sce_sce_select,reg_sce,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((POP_data(sce_sce_select,reg_sce,year_sce)-
                    POP_data(sce_sce_select,reg_sce,year_sce-1))$(POP_data(sce_sce_select,reg_sce,year_sce-1)))/sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
            )
;


Display year1_sce ;

CO2budget_yr(sce_sce_select,reg_sce,year)$(ord(year) gt 10 and ord(year) lt 41)
    =   sum(year1_sce$yr_sce_aggr(year1_sce,year),

        CO2budget_yr(sce_sce_select,reg_sce,"2020")
        + (ord(year)-10)/(2050-2020)
        * ( CO2budget_data(sce_sce_select,reg_sce,'CO2budgetperc')
            - CO2budget_yr(sce_sce_select,reg_sce,"2020") )

        )
;



Display
    GDP_yr
    POP_yr
    CO2budget_yr
;



* ========================== Aggregate prd and ind =============================

Parameters
    GDP_aggr(sce_sce,reg,year)                            GDP growth wrt 2007
    POP_aggr(sce_sce,reg,year)                            POP growth wrt 2007
    CO2budget_aggr(sce_sce,reg,year)
;


GDP_aggr(sce_sce,reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
       GDP_yr(sce_sce,reg_sce,year) ) )  ;

POP_aggr(sce_sce,reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
       POP_yr(sce_sce,reg_sce,year) ) )  ;

CO2budget_aggr(sce_sce,reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
       CO2budget_yr(sce_sce,reg_sce,year) ) ) ;


Display
    GDP_aggr
    POP_aggr
    CO2budget_aggr
;



* ========================== Create index wrt year before ======================

* Because the indices above can be aggregated over products and industries
* Because the base year changed from 2007 to 2011 in our case

Parameters
    GDP_scen_change(sce_sce,reg,year)                            GDP growth wrt 2007
    POP_scen_change(sce_sce,reg,year)                            POP growth wrt 2007
    mat_red_change(sce_sce,reg,year)
    ener_eff_change(sce_sce,reg,year)
    oil_price_change(sce_sce,year)
;

GDP_scen_change(sce_sce,reg,year)$GDP_aggr(sce_sce,reg,year-1)
    = GDP_aggr(sce_sce,reg,year) / GDP_aggr(sce_sce,reg,year-1) ;

POP_scen_change(sce_sce,reg,year)$POP_aggr(sce_sce,reg,year-1)
    = POP_aggr(sce_sce,reg,year) / POP_aggr(sce_sce,reg,year-1) ;

mat_red_change(sce_sce,reg,year)$mat_red_data(sce_sce,reg,year-1)
    = mat_red_data(sce_sce,reg,year)/ mat_red_data(sce_sce,reg,year-1) ;

ener_eff_change(sce_sce,reg,year)$ener_eff_data(sce_sce,reg,year-1)
    = ener_eff_data(sce_sce,reg,year) / ener_eff_data(sce_sce,reg,year-1) ;

oil_price_change(sce_sce,year)$energy_prices_WEO_data(sce_sce,'EU - crude oil',year-1)
    = energy_prices_WEO_data(sce_sce,'EU - crude oil',year)
        / energy_prices_WEO_data(sce_sce,'EU - crude oil',year-1) ;

* All regions that have no GDP trajectory, set the change equal to 1.
GDP_scen_change(sce_sce,reg,year)$(not GDP_scen_change(sce_sce,reg,year))   = 1 ;
POP_scen_change(sce_sce,reg,year)$(not POP_scen_change(sce_sce,reg,year))   = 1 ;
ener_eff_change(sce_sce,reg,'2011')$(ener_eff_change(sce_sce,reg,'2012'))   = 1 ;
mat_red_change(sce_sce,reg,'2011')$mat_red_change(sce_sce,reg,'2012') = 1 ;
oil_price_change(sce_sce,'2011') = 1 ;


* Take population and GDP for rest of the world regions from OECD and Worldbank

loop(year$( ord(year) le 8),
GDP_scen_change(sce_sce,"RWO",year) = GDP_gr_WB("RWO",year);
POP_scen_change(sce_sce,"RWO",year) = POP_gr_WB("RWO",year);
GDP_scen_change(sce_sce,"RWN",year) = GDP_gr_WB("RWN",year);
POP_scen_change(sce_sce,"RWN",year) = POP_gr_WB("RWN",year);
)
;

loop(year$( ord(year) ge 9),
GDP_scen_change(sce_sce,"RWO",year) = GDP_gr_OECD("RWO",year);
POP_scen_change(sce_sce,"RWO",year) = POP_gr_OECD("RWO",year);
GDP_scen_change(sce_sce,"RWN",year) = GDP_gr_OECD("RWN",year);
POP_scen_change(sce_sce,"RWN",year) = POP_gr_OECD("RWN",year);
)
;



Display
    GDP_scen_change
    POP_scen_change
    ener_eff_change
    mat_red_change
    oil_price_change
;


* ============================ Split between hydrogen and gas ==================

* We use the demand for hydrogen and gas between 2011 and 2050 for transport
* hh, services and industy as proxy for shift between gas and hydrogen

Parameters
    gas_use_tran_aggrr(sce_sce,reg,ind,year)
    gas_use_ind_aggrr(sce_sce,reg,ind,year)
    gas_use_serv_aggrr(sce_sce,reg,ind,year)
    gas_use_aggrr(sce_sce,reg,ind,year)
    gas_use_share(sce_sce,reg,ind,year)
;

* Aggregate to region and product
gas_use_tran_aggrr(sce_sce,reg,ind,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_ind_aggr(var_OE,ind),
       ener_use_tran_yrr(sce_sce,reg_OE,var_OE,year) ) ) )   ;

gas_use_ind_aggrr(sce_sce,reg,ind,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_ind_aggr(var_OE,ind),
       ener_use_ind_yrr(sce_sce,reg_OE,var_OE,year) ) ) )   ;

gas_use_serv_aggrr(sce_sce,reg,ind,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_ind_aggr(var_OE,ind),
       ener_use_hh_serv_yrr(sce_sce,reg_OE,var_OE,year) ) ) )   ;


* Interpolate for reference scenario
gas_use_tran_aggrr(sce_sce,reg,ind,year)$(ord(year) gt 1 and ord(year) lt 40)
    = gas_use_tran_aggrr(sce_sce,reg,ind,'2011')
        + (2010+ord(year)-2011)/(2050-2011)
        * (gas_use_tran_aggrr(sce_sce,reg,ind,'2050')
            - gas_use_tran_aggrr(sce_sce,reg,ind,'2011') )  ;

gas_use_ind_aggrr(sce_sce,reg,ind,year)$(ord(year) gt 1 and ord(year) lt 40)
    = gas_use_ind_aggrr(sce_sce,reg,ind,'2011')
        + (2010+ord(year)-2011)/(2050-2011)
        * (gas_use_ind_aggrr(sce_sce,reg,ind,'2050')
            - gas_use_ind_aggrr(sce_sce,reg,ind,'2011') )  ;

gas_use_serv_aggrr(sce_sce,reg,ind,year)$(ord(year) gt 1 and ord(year) lt 40)
    = gas_use_serv_aggrr(sce_sce,reg,ind,'2011')
        + (2010+ord(year)-2011)/(2050-2011)
        * (gas_use_serv_aggrr(sce_sce,reg,ind,'2050')
            - gas_use_serv_aggrr(sce_sce,reg,ind,'2011') )  ;


* The other scenarios are equal to reference scenario for years 2011-2020:
gas_use_tran_aggrr(sce_sce_select,reg,ind,year_select) = gas_use_tran_aggrr("REF",reg,ind,year_select) ;
gas_use_ind_aggrr(sce_sce_select,reg,ind,year_select)  = gas_use_ind_aggrr("REF",reg,ind,year_select) ;
gas_use_serv_aggrr(sce_sce_select,reg,ind,year_select) = gas_use_serv_aggrr("REF",reg,ind,year_select) ;


gas_use_tran_aggrr(sce_sce,reg,ind,year)$(ord(year) gt 10 and ord(year) lt 40)
    = gas_use_tran_aggrr(sce_sce,reg,ind,'2020')
        + (ord(year)-10)/(2050-2020)
        * (gas_use_tran_aggrr(sce_sce,reg,ind,'2050')
            - gas_use_tran_aggrr(sce_sce,reg,ind,'2020') )  ;

gas_use_ind_aggrr(sce_sce,reg,ind,year)$(ord(year) gt 10 and ord(year) lt 40)
    = gas_use_ind_aggrr(sce_sce,reg,ind,'2020')
        + (ord(year)-10)/(2050-2020)
        * (gas_use_ind_aggrr(sce_sce,reg,ind,'2050')
            - gas_use_ind_aggrr(sce_sce,reg,ind,'2020') )  ;

gas_use_serv_aggrr(sce_sce,reg,ind,year)$(ord(year) gt 10 and ord(year) lt 40)
    = gas_use_serv_aggrr(sce_sce,reg,ind,'2020')
        + (ord(year)-10)/(2050-2020)
        * (gas_use_serv_aggrr(sce_sce,reg,ind,'2050')
            - gas_use_serv_aggrr(sce_sce,reg,ind,'2020') )  ;


gas_use_aggrr(sce_sce,reg,ind,year)
    = gas_use_tran_aggrr(sce_sce,reg,ind,year)
    + gas_use_ind_aggrr(sce_sce,reg,ind,year)
    + gas_use_serv_aggrr(sce_sce,reg,ind,year) ;

* Calculate shares
gas_use_share(sce_sce,reg,ind,year)$sum((indd) ,gas_use_aggrr(sce_sce,reg,indd,year))
    = gas_use_aggrr(sce_sce,reg,ind,year)
        / sum((indd) ,gas_use_aggrr(sce_sce,reg,indd,year)) ;



Display
    gas_use_tran_aggrr
    gas_use_ind_aggrr
    gas_use_serv_aggrr
    gas_use_aggrr
    gas_use_share
;

