
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


* Set year 2020
ener_use_tran_yrr(sce_sce,reg_OE,var_OE,'2020')
    = sum(sce_OE, ener_use_tran_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2020','value') ) ;
ener_use_ind_yrr(sce_sce,reg_OE,var_OE,'2020')
    = sum(sce_OE, ener_use_ind_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2020','value') ) ;
ener_use_hh_serv_yrr(sce_sce,reg_OE,var_OE,'2020')
    = sum(sce_OE, ener_use_hh_serv_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2020','value') ) ;

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


* INTERPOLATE OTHER SCENARIOS
ener_use_tran_aggrr(sce_sce,prd,reg,ind,year)$(ord(year) gt 10 and ord(year) lt 40)
    = ener_use_tran_aggrr(sce_sce,prd,reg,ind,'2020')
        + (ord(year)-10)/(2050-2020)
        * (ener_use_tran_aggrr(sce_sce,prd,reg,ind,'2050')
            - ener_use_tran_aggrr(sce_sce,prd,reg,ind,'2020') )  ;

ener_use_ind_aggrr(sce_sce,prd,reg,ind,year)$(ord(year) gt 10 and ord(year) lt 40)
    = ener_use_ind_aggrr(sce_sce,prd,reg,ind,'2020')
        + (ord(year)-10)/(2050-2020)
        * (ener_use_ind_aggrr(sce_sce,prd,reg,ind,'2050')
            - ener_use_ind_aggrr(sce_sce,prd,reg,ind,'2020') )  ;

ener_use_serv_aggrr(sce_sce,prd,reg,ind,year)$(ord(year) gt 10 and ord(year) lt 40)
    = ener_use_serv_aggrr(sce_sce,prd,reg,ind,'2020')
        + (ord(year)-10)/(2050-2020)
        * (ener_use_serv_aggrr(sce_sce,prd,reg,ind,'2050')
            - ener_use_serv_aggrr(sce_sce,prd,reg,ind,'2020') )  ;



*Change with respect to year before.
ener_use_tran_change(sce_sce,prd,reg,ind,year)$ener_use_tran_aggrr(sce_sce,prd,reg,ind,year-1)
    = ener_use_tran_aggrr(sce_sce,prd,reg,ind,year) / ener_use_tran_aggrr(sce_sce,prd,reg,ind,year-1) ;

ener_use_ind_change(sce_sce,prd,reg,ind,year)$ener_use_ind_aggrr(sce_sce,prd,reg,ind,year-1)
    = ener_use_ind_aggrr(sce_sce,prd,reg,ind,year) / ener_use_ind_aggrr(sce_sce,prd,reg,ind,year-1) ;

ener_use_serv_change(sce_sce,prd,reg,ind,year)$ener_use_serv_aggrr(sce_sce,prd,reg,ind,year-1)
    = ener_use_serv_aggrr(sce_sce,prd,reg,ind,year) / ener_use_serv_aggrr(sce_sce,prd,reg,ind,year-1) ;


* set changevalues to 1 in years 2011-2020
loop(year$( ord(year) le 11 ),

ener_use_tran_change(sce_sce,prd,reg,ind,year)
    $(not ener_use_tran_change(sce_sce,prd,reg,ind,year)
      and  ener_use_tran_change(sce_sce,prd,reg,ind,'2022') ) = 1;

ener_use_ind_change(sce_sce,prd,reg,ind,year)
    $(not ener_use_ind_change(sce_sce,prd,reg,ind,year)
      and  ener_use_ind_change(sce_sce,prd,reg,ind,'2022') ) = 1;

ener_use_serv_change(sce_sce,prd,reg,ind,year)
    $(not ener_use_serv_change(sce_sce,prd,reg,ind,year)
      and  ener_use_serv_change(sce_sce,prd,reg,ind,'2022') ) = 1;

);

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


* =============== Create values for 2011 or 2020 ===============================


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

* Assumption: in the reference, there is no change in household spending.
* The other scenarios are equal to the reference scenario between 2011-2020.
* Therefore household shares in 2011 equal household shares in 2020.
loop(year$( ord(year) le 10 ),

ener_use_hh_shares(sce_sce,ener_hh,regg,year)
    $(sum(enerr_hh, theta_h(enerr_hh,regg)) and sum(prd,ener_use_hh_shares(sce_sce,prd,regg,'2050')))
    = theta_h(ener_hh,regg)
        / sum(enerr_hh, theta_h(enerr_hh,regg)) ;

);

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

$ontext
ener_use_hh_shares("REF",prd,reg,year)$(ord(year) gt 1 and ord(year) lt 40)
    = ener_use_hh_shares("REF",prd,reg,'2011')
        + (2010+ord(year)-2011)/(2050-2011)
        * (ener_use_hh_shares("REF",prd,reg,'2050')
            - ener_use_hh_shares("REF",prd,reg,'2011') )  ;
$offtext

* Note that the first 10 years should be equal to the reference scenario
techmix_shares(sce_sce_select,reg,ind_elec,year_select) = techmix_shares("REF",reg,ind_elec,year_select) ;
ener_use_hh_shares(sce_sce_select,prd,reg,year_select) = ener_use_hh_shares("REF",prd,reg,year_select) ;


* Interpolate the remaining 30 years
techmix_shares(sce_sce_select,reg,ind_elec,year)$(ord(year) gt 10 and ord(year) lt 40)
    = techmix_shares(sce_sce_select,reg,ind_elec,'2020')
        + (ord(year)-10)/(2050-2020)
        * (techmix_shares(sce_sce_select,reg,ind_elec,'2050')
            - techmix_shares(sce_sce_select,reg,ind_elec,'2020') )  ;

ener_use_hh_shares(sce_sce,prd,reg,year)$(ord(year) gt 10 and ord(year) lt 40)
    = ener_use_hh_shares(sce_sce,prd,reg,'2020')
        + (ord(year)-10)/(2050-2020)
        * (ener_use_hh_shares(sce_sce,prd,reg,'2050')
            - ener_use_hh_shares(sce_sce,prd,reg,'2020') )  ;


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

ener_eff_change(sce_sce,reg,year)$ener_eff_data(sce_sce,reg,year-1)
    = ener_eff_data(sce_sce,reg,year) / ener_eff_data(sce_sce,reg,year-1) ;

oil_price_change(sce_sce,year)$energy_prices_WEO_data(sce_sce,'EU - crude oil',year-1)
    = energy_prices_WEO_data(sce_sce,'EU - crude oil',year)
        / energy_prices_WEO_data(sce_sce,'EU - crude oil',year-1) ;

mat_red_change(sce_sce,reg,year)$mat_red_data(sce_sce,reg,year-1)
    = mat_red_data(sce_sce,reg,year)/ mat_red_data(sce_sce,reg,year-1) ;


* For reference, the change is always equal to 1.
mat_red_change("REF",reg,year)  = 1 ;
* Year 2011-2020 should also have change equal to 1.
loop(year$( ord(year) le 10 ),
mat_red_change(sce_sce,reg,year)$mat_red_change(sce_sce,reg,"2022") = 1 ;
) ;


* All regions that have no GDP trajectory, set the change equal to 1.
GDP_scen_change(sce_sce,reg,year)$(not GDP_scen_change(sce_sce,reg,year))   = 1 ;
POP_scen_change(sce_sce,reg,year)$(not POP_scen_change(sce_sce,reg,year))   = 1 ;
ener_eff_change(sce_sce,reg,'2011')$(ener_eff_change(sce_sce,reg,'2012'))   = 1 ;
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
gas_use_tran_aggrr(sce_sce,reg,ind,'2050')
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_ind_aggr(var_OE,ind),
       ener_use_tran_yrr(sce_sce,reg_OE,var_OE,'2050') ) ) )   ;

gas_use_ind_aggrr(sce_sce,reg,ind,'2050')
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_ind_aggr(var_OE,ind),
       ener_use_ind_yrr(sce_sce,reg_OE,var_OE,'2050') ) ) )   ;

gas_use_serv_aggrr(sce_sce,reg,ind,'2050')
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_ind_aggr(var_OE,ind),
       ener_use_hh_serv_yrr(sce_sce,reg_OE,var_OE,'2050') ) ) )   ;

* Aggregate for 2050
gas_use_aggrr(sce_sce,reg,ind,year)
    = gas_use_tran_aggrr(sce_sce,reg,ind,year)
    + gas_use_ind_aggrr(sce_sce,reg,ind,year)
    + gas_use_serv_aggrr(sce_sce,reg,ind,year) ;

* Calculate shares for 2050
gas_use_share(sce_sce,reg,ind,year)$sum((indd) ,gas_use_aggrr(sce_sce,reg,indd,year))
    = gas_use_aggrr(sce_sce,reg,ind,year)
        / sum((indd) ,gas_use_aggrr(sce_sce,reg,indd,year)) ;

* There is no gas-share in reference. Set year 2011-2050
gas_use_share("REF",reg,ind_ng,year)
    = coprodB(reg,'pNG',reg,ind_ng)/ sum(indd_ng, coprodB(reg,'pNG',reg,indd_ng)) ;

* Gas-share for all other scenarios. Set year 2011-2020
gas_use_share(sce_sce_select,reg,ind,year_select) = gas_use_share("REF",reg,ind,year_select) ;

* Gas-share for all other scenarios. Set year 2020-2050
*gas_use_share(sce_sce,reg,ind,year)$(ord(year) gt 10 and ord(year) lt 40)
*    = gas_use_share(sce_sce,reg,ind,'2020')
*        + (ord(year)-10)/(2050-2020)
*        * (gas_use_share(sce_sce,reg,ind,'2050')
*            - gas_use_share(sce_sce,reg,ind,'2020') )  ;


* Make very gradual changes in the beginning, or model will crash.
gas_use_share(sce_sce,reg,ind,year)$(ord(year) gt 13 and ord(year) lt 40) = 0 ;

gas_use_share(sce_sce,reg,'iH2','2021')$gas_use_share(sce_sce,reg,'iH2','2011')
    = 0.001 ;
gas_use_share(sce_sce,reg,'iH2','2022')$gas_use_share(sce_sce,reg,'iH2','2011')
    = 0.01 ;
gas_use_share(sce_sce,reg,'iH2','2023')$gas_use_share(sce_sce,reg,'iH2','2011')
    = 0.03 ;

gas_use_share(sce_sce,reg,'iNGAS','2021')$gas_use_share(sce_sce,reg,'iNGAS','2011')
    = 1-0.001 ;
gas_use_share(sce_sce,reg,'iNGAS','2022')$gas_use_share(sce_sce,reg,'iNGAS','2011')
    = 1-0.01 ;
gas_use_share(sce_sce,reg,'iNGAS','2023')$gas_use_share(sce_sce,reg,'iNGAS','2011')
    = 1-0.03 ;



* Gas-share for all other scenarios. Set year 2020-2050
gas_use_share(sce_sce,reg,ind,year)$(ord(year) gt 13 and ord(year) lt 40)
    = gas_use_share(sce_sce,reg,ind,'2023')
        + (ord(year)-13)/(2050-2023)
        * (gas_use_share(sce_sce,reg,ind,'2050')
            - gas_use_share(sce_sce,reg,ind,'2023') )  ;


* Some countries need extra slow change in the beginning because they have
* such high production of pNG in the industry iNGAS.

sets
    reg_gas(reg)
;

reg_gas(reg) = no;
reg_gas("AUT") = yes;
reg_gas("NLD") = yes;
reg_gas("ESP") = yes;
reg_gas("GBR") = yes;
reg_gas("FRA") = yes;
reg_gas("DEU") = yes;

* Make very gradual changes in the beginning, or model will crash.
gas_use_share(sce_sce,reg_gas,ind,year)$(ord(year) gt 14 and ord(year) lt 40) = 0 ;

gas_use_share(sce_sce,reg_gas,'iH2','2021')$gas_use_share(sce_sce,reg_gas,'iH2','2011')
    = 0.0001 ;
gas_use_share(sce_sce,reg_gas,'iH2','2022')$gas_use_share(sce_sce,reg_gas,'iH2','2011')
    = 0.001 ;
gas_use_share(sce_sce,reg_gas,'iH2','2023')$gas_use_share(sce_sce,reg_gas,'iH2','2011')
    = 0.01 ;
gas_use_share(sce_sce,reg_gas,'iH2','2024')$gas_use_share(sce_sce,reg_gas,'iH2','2011')
    = 0.03 ;

gas_use_share(sce_sce,reg_gas,'iNGAS','2021')$gas_use_share(sce_sce,reg_gas,'iNGAS','2011')
    = 1-0.0001 ;
gas_use_share(sce_sce,reg_gas,'iNGAS','2022')$gas_use_share(sce_sce,reg_gas,'iNGAS','2011')
    = 1-0.001 ;
gas_use_share(sce_sce,reg_gas,'iNGAS','2023')$gas_use_share(sce_sce,reg_gas,'iNGAS','2011')
    = 1-0.01 ;
gas_use_share(sce_sce,reg_gas,'iNGAS','2024')$gas_use_share(sce_sce,reg_gas,'iNGAS','2011')
    = 1-0.03 ;


* Gas-share for all other scenarios. Set year 2020-2050
gas_use_share(sce_sce,reg_gas,ind,year)$(ord(year) gt 14 and ord(year) lt 40)
    = gas_use_share(sce_sce,reg_gas,ind,'2024')
        + (ord(year)-14)/(2050-2024)
        * (gas_use_share(sce_sce,reg_gas,ind,'2050')
            - gas_use_share(sce_sce,reg_gas,ind,'2024') )  ;

Display
    gas_use_tran_aggrr
    gas_use_ind_aggrr
    gas_use_serv_aggrr
    gas_use_aggrr
    gas_use_share
;

* ============================ Split between hydrogen and gas ==================
$ontext
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
$offtext
