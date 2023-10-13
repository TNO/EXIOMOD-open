
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

    year_EUS                        years in eurostat database
/
YEAR2007*YEAR2020
/

    reg_EUS                         regions in eurostat database
/
$include %project%/01_external_data/physical_extensions_2011/sets/eurostat_regions.txt
/

    reg_EUS_aggr(reg_EUS,reg_data)  aggregation regions in eurostat database
/
$include %project%/01_external_data/physical_extensions_2011/sets/aggregation/eurostat_regions_to_data.txt
/

    year_EUS_aggr(year_EUS,year)    aggregation years in edgar database
/
$include %project%/01_external_data/physical_extensions_2011/sets/aggregation/eurostat_year_to_data.txt
/

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


* =========================== 01_BAU ===========================================

* create scenarios for POP_scen_change and GDP_scen_change

Parameters
    GDP_eurostat_data(reg_EUS,year_EUS)    GDP in 2010 mln EUR by country for 2011-2020
    GDP_eurostat_yr(reg,year_EUS)
    GDP_eurostat_2007_2020(reg,year_EUS)
    GDP_eurostat_change(reg,year)

    GDP_yr(sce_sce,reg,year)
    POP_yr(sce_sce,reg,year)

    year_sce_intpol1(year1_sce,year_sce)       Help variable for interpolation
    year_sce_intpol2(year1_sce,year_sce)       Help variable for interpolation

    GDP_aggr(sce_sce,reg,year_sce)
    POP_aggr(sce_sce,reg,year_sce)

    GDP_scen_change(sce_sce,reg,year)      GDP growth wrt 2007
    POP_scen_change(sce_sce,reg,year)      POP growth wrt 2007
;

* Extra data from Eurostat for years 2011-2020
$libinclude xlimport GDP_eurostat_data      %project%\01_external_data\scenarios\data\GDP_Eurostat_tm2020.xlsx  Data!a10:o37

* Eurostat data aggregated to exiobase region definition
GDP_eurostat_yr(reg,year_EUS)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_EUS$reg_EUS_aggr(reg_EUS,reg_data),
         GDP_eurostat_data(reg_EUS,year_EUS) ) ) ;

* Eurostat: increase in gdp between 2007 and 2020
GDP_eurostat_2007_2020(reg,year_EUS)$GDP_eurostat_yr(reg,"YEAR2007")
    = GDP_eurostat_yr(reg,year_EUS) / GDP_eurostat_yr(reg,"YEAR2007") ;

GDP_eurostat_change(reg,year)
    = sum(year_EUS$year_EUS_aggr(year_EUS,year),
         GDP_eurostat_2007_2020(reg,year_EUS) )  ;

Display
    GDP_eurostat_2007_2020
    GDP_eurostat_change
;

* Aggregate over the regions
GDP_aggr(sce_sce,reg,year_sce)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
        GDP_data(sce_sce,reg_sce,year_sce) ) )  ;

POP_aggr(sce_sce,reg,year_sce)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
        POP_data(sce_sce,reg_sce,year_sce) ) )  ;

Display
    GDP_aggr
;

* For EU countries, replace GDP 2007, 2010, 2015, 2020 with data from Eurostat
*GDP_aggr(sce_sce,reg,'4')$GDP_eurostat_2007_2020(reg,"YEAR2020")
*    = GDP_eurostat_2007_2020(reg,"YEAR2020") ;
*GDP_aggr(sce_sce,reg,'3')$GDP_eurostat_2007_2020(reg,"YEAR2015")
*    = GDP_eurostat_2007_2020(reg,"YEAR2015") ;
*GDP_aggr(sce_sce,reg,'2')$GDP_eurostat_2007_2020(reg,"YEAR2010")
*    = GDP_eurostat_2007_2020(reg,"YEAR2010") ;
*GDP_aggr(sce_sce,reg,'1')$GDP_eurostat_2007_2020(reg,"YEAR2007")
*    = GDP_eurostat_2007_2020(reg,"YEAR2007") ;

Display
    GDP_aggr
;


$libinclude xlimport year_sce_intpol1  %project%\01_external_data\scenarios\sets\aggregation\Years_interpolation.xlsx    Years_interpolation1!a2:k10000
$libinclude xlimport year_sce_intpol2  %project%\01_external_data\scenarios\sets\aggregation\Years_interpolation.xlsx    Years_interpolation2!a2:k10000


* For the reference:
GDP_yr("REF",reg,year)
    =  sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             GDP_aggr("REF",reg,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((GDP_aggr("REF",reg,year_sce)-
                    GDP_aggr("REF",reg,year_sce-1))
                    $(GDP_aggr("REF",reg,year_sce-1)))
                    /sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
    )
;

POP_yr("REF",reg,year)
    = sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             POP_aggr("REF",reg,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((POP_aggr("REF",reg,year_sce)-
                    POP_aggr("REF",reg,year_sce-1))
                    $(POP_aggr("REF",reg,year_sce-1)))
                    /sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
    )
;

Display
    GDP_yr
;

* For the other scenarios
GDP_yr(sce_sce_select,reg,year_select) = GDP_yr("REF",reg,year_select) ;
POP_yr(sce_sce_select,reg,year_select) = POP_yr("REF",reg,year_select) ;

GDP_yr(sce_sce_select,reg,year)$(ord(year) gt 10 and ord(year) lt 41)
    =  sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             GDP_aggr(sce_sce_select,reg,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((GDP_aggr(sce_sce_select,reg,year_sce)-
                    GDP_aggr(sce_sce_select,reg,year_sce-1))
                    $(GDP_aggr(sce_sce_select,reg,year_sce-1)))
                    /sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
    )
;


POP_yr(sce_sce_select,reg,year)$(ord(year) gt 10 and ord(year) lt 41)
    = sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             POP_aggr(sce_sce_select,reg,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((POP_aggr(sce_sce_select,reg,year_sce)-
                    POP_aggr(sce_sce_select,reg,year_sce-1))
                    $(POP_aggr(sce_sce_select,reg,year_sce-1)))
                    /sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
    )
;

Display
    GDP_yr
;

*sets
*    year_selection(year)
*    / 2011*2019 /
*;


* For EU replace trajectory by eurostat trajectories
* This has been removed because GDP-loop cannot find solutions anymore.
*GDP_yr(sce_sce,reg,year_selection)$GDP_eurostat_change(reg,year_selection)
*    = GDP_eurostat_change(reg,year_selection);

Display
    GDP_yr
;

* Change with respect to previous year
GDP_scen_change(sce_sce,reg,year)$GDP_yr(sce_sce,reg,year-1)
    = GDP_yr(sce_sce,reg,year) / GDP_yr(sce_sce,reg,year-1) ;

POP_scen_change(sce_sce,reg,year)$POP_yr(sce_sce,reg,year-1)
    = POP_yr(sce_sce,reg,year) / POP_yr(sce_sce,reg,year-1) ;


* All years/regions that have no GDP trajectory, set the change equal to 1.
GDP_scen_change(sce_sce,reg,year)$(not GDP_scen_change(sce_sce,reg,year))  = 1 ;
POP_scen_change(sce_sce,reg,year)$(not POP_scen_change(sce_sce,reg,year))  = 1 ;

* Take population and GDP for rest of the world regions from OECD and Worldbank
loop(year$( ord(year) le 8),
GDP_scen_change(sce_sce,"RWO",year) = GDP_gr_WB("RWO",year);
POP_scen_change(sce_sce,"RWO",year) = POP_gr_WB("RWO",year);
GDP_scen_change(sce_sce,"RWN",year) = GDP_gr_WB("RWN",year);
POP_scen_change(sce_sce,"RWN",year) = POP_gr_WB("RWN",year);
)
;

loop(year$( ord(year) ge 9),
GDP_scen_change(sce_sce,"RWO",year) = GDP_ROW_data(sce_sce,"RWO",year);
POP_scen_change(sce_sce,"RWO",year) = POP_ROW_data(sce_sce,"RWO",year);
GDP_scen_change(sce_sce,"RWN",year) = GDP_ROW_data(sce_sce,"RWN",year);
POP_scen_change(sce_sce,"RWN",year) = POP_ROW_data(sce_sce,"RWN",year);
)
;

Display
    GDP_scen_change
    POP_scen_change
;

* ============================== 02_elec_mix ===================================



Parameters
    techmix_yr(sce_sce,reg_OE,var_OE,year)       Technology mix in EJ per year

    techmix_aggr(sce_sce,reg,ind,year)           Technology mix in EJ per year

    techmix_shares(sce_sce,reg,ind,year)         Technology mix shares in perc

;


* Set year 2050
techmix_yr(sce_sce,reg_OE,var_OE,'2050')
    = sum(sce_OE, techmix_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2050','value') ) ;

Display
    techmix_yr
;

*Aggregate over regions and industries for 2050
techmix_aggr(sce_sce,reg,ind,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
            sum(ind_data$ind_aggr(ind_data,ind),
                sum(var_OE$var_OE_aggr(var_OE,ind_data),
       techmix_yr(sce_sce,reg_OE,var_OE,year) ) ) ) )  ;

Display
    techmix_aggr
;

* Create shares for 2050
techmix_shares(sce_sce,reg,ind,year)$sum(indd, techmix_aggr(sce_sce,reg,indd,year))
    = techmix_aggr(sce_sce,reg,ind,year)
    / sum(indd , techmix_aggr(sce_sce,reg,indd,year)) ;

Display
    techmix_shares
;

* Set year 2011 (consistent with EXIOBASE).
techmix_shares(sce_sce,reg,ind_elec,'2011')
    $sum((reggg,indd_elec),coprodB(reg,'pELEC',reggg,indd_elec))
    = coprodB(reg,'pELEC',reg,ind_elec)
        / sum((reggg,indd_elec),coprodB(reg,'pELEC',reggg,indd_elec))  ;

* If value 2050>0 and value 2011=0, add a very very small value in coprodB
* in 2011
techmix_shares(sce_sce,reg,ind_elec,'2011')
    $(techmix_shares(sce_sce,reg,ind_elec,'2050')
        and not techmix_shares(sce_sce,reg,ind_elec,'2011') )
     = 0.0000000001 ;

* Reference scenario: Interpolate year 2011 to 2050
techmix_shares("REF",reg,ind_elec,year)$(ord(year) gt 1 and ord(year) lt 40)
    = techmix_shares("REF",reg,ind_elec,'2011')
        + (2010+ord(year)-2011)/(2050-2011)
        * (techmix_shares("REF",reg,ind_elec,'2050')
            - techmix_shares("REF",reg,ind_elec,'2011') )  ;

* Other scenarios: First 10 years is equal to the reference scenario
techmix_shares(sce_sce_select,reg,ind_elec,year_select)
    = techmix_shares("REF",reg,ind_elec,year_select) ;

* Other scenarios: Interpolate the remaining 30 years
techmix_shares(sce_sce_select,reg,ind_elec,year)$(ord(year) gt 10 and ord(year) lt 40)
    = techmix_shares(sce_sce_select,reg,ind_elec,'2020')
        + (ord(year)-10)/(2050-2020)
        * (techmix_shares(sce_sce_select,reg,ind_elec,'2050')
            - techmix_shares(sce_sce_select,reg,ind_elec,'2020') )  ;


Display
    techmix_shares
;


* ============================== 03_ener_efficiency ============================

Parameters
    ener_eff_change(sce_sce,reg,year)
;

* Change in energy efficiency
ener_eff_change(sce_sce,reg,year)$ener_eff_data(sce_sce,reg,year-1)
    = ener_eff_data(sce_sce,reg,year) / ener_eff_data(sce_sce,reg,year-1) ;

* Set year 2011 to one
ener_eff_change(sce_sce,reg,'2011')$(ener_eff_change(sce_sce,reg,'2012'))   = 1 ;

Display
    ener_eff_change
;

* ============================== 04_energy_share_hh ============================


Parameters
    ener_use_hh_serv_yr(sce_sce,reg_OE,var_OE,year)  Energy use in EJ
                                                     # for hh and services
    ener_use_hh_serv_aggr(sce_sce,reg,prd,year)      Energy use in EJ
                                                     # for households
    ener_use_hh_shares(sce_sce,prd,reg,year)         Energy use in percentages
                                                     # for households
;

* Set year 2050
ener_use_hh_serv_yr(sce_sce,reg_OE,var_OE,'2050')
    = sum(sce_OE, ener_use_hh_serv_data(sce_sce,'GENeSYS-MOD2.9',sce_OE,reg_OE,var_OE,'EJ/yr','2050','value') ) ;

*Aggregate over regions and products for 2050
ener_use_hh_serv_aggr(sce_sce,reg,prd,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OE$reg_OE_aggr(reg_OE,reg_data),
                sum(var_OE$var_OE_prd_aggr(var_OE,prd),
       ener_use_hh_serv_yr(sce_sce,reg_OE,var_OE,year) ) ) )   ;

* Create shares for 2050
ener_use_hh_shares(sce_sce,prd,reg,year)
    $sum(prdd, ener_use_hh_serv_aggr(sce_sce,reg,prdd,year))
    =
    ener_use_hh_serv_aggr(sce_sce,reg,prd,year)
    / sum(prdd, ener_use_hh_serv_aggr(sce_sce,reg,prdd,year)) ;

* All scenarios: Set year 2011-2020 (consistent with EXIOBASE).
* Assumption: in the reference, there is no change in household spending.
* The other scenarios are equal to the reference scenario between 2011-2020.
* Therefore household shares in 2011 equal household shares in 2020.
loop(year$( ord(year) le 10 ),

ener_use_hh_shares(sce_sce,ener_hh,regg,year)
    $(sum(enerr_hh, theta_h(enerr_hh,regg)) and sum(prd,ener_use_hh_shares(sce_sce,prd,regg,'2050')))
    = theta_h(ener_hh,regg)
        / sum(enerr_hh, theta_h(enerr_hh,regg)) ;

);


* Other scenarios: First 10 years is equal to the reference scenario
ener_use_hh_shares(sce_sce_select,prd,reg,year_select) = ener_use_hh_shares("REF",prd,reg,year_select) ;


* All scenarios: Interpolate the remaining 30 years
ener_use_hh_shares(sce_sce,prd,reg,year)$(ord(year) gt 10 and ord(year) lt 40)
    = ener_use_hh_shares(sce_sce,prd,reg,'2020')
        + (ord(year)-10)/(2050-2020)
        * (ener_use_hh_shares(sce_sce,prd,reg,'2050')
            - ener_use_hh_shares(sce_sce,prd,reg,'2020') )  ;

Display
    ener_use_hh_shares
;


* ============================== 05_CO2_cap_CO2_efficiency =====================

Parameters
    CO2budget_yr(sce_sce,reg_sce,year)

    CO2budget_aggr(sce_sce,reg,year)
;


* Reference 2011-2050: Interpolate over the years
CO2budget_yr("REF",reg_sce,year)
    =   sum(year1_sce$yr_sce_aggr(year1_sce,year),
        1 -
        ( ord(year1_sce) - 1 ) *
        (1 - CO2budget_data("REF",reg_sce,'CO2budgetperc'))/(2050-2007)
        )
;

Display CO2budget_yr, yr_sce_aggr, year1_sce;


* All scenarios: UK does not exist, we have data for GB.
CO2budget_yr(sce_sce,"UK",year) = 0;

* Other scenarios 2011-2020: set scenario equal to reference scenario
CO2budget_yr(sce_sce_select,reg_sce,year_select)
    = CO2budget_yr("REF",reg_sce,year_select) ;

* Other scenarios 2021-2050: Interpolate over the years
CO2budget_yr(sce_sce_select,reg_sce,year)$(ord(year) gt 10 and ord(year) lt 41)
    =   sum(year1_sce$yr_sce_aggr(year1_sce,year),
        CO2budget_yr(sce_sce_select,reg_sce,"2020")
        + (ord(year)-10)/(2050-2020)
        * ( CO2budget_data(sce_sce_select,reg_sce,'CO2budgetperc')
            - CO2budget_yr(sce_sce_select,reg_sce,"2020") )
        )
;

CO2budget_aggr(sce_sce,reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
       CO2budget_yr(sce_sce,reg_sce,year) ) ) ;

Display
    CO2budget_aggr
;


* ============================== 06_mat_reduction ==============================

* Because the indices above can be aggregated over products and industries
* Because the base year changed from 2007 to 2011 in our case

Parameters
    mat_red_change(sce_sce,reg,year)

;

mat_red_change(sce_sce,reg,year)$mat_red_data(sce_sce,reg,year-1)
    = mat_red_data(sce_sce,reg,year)/ mat_red_data(sce_sce,reg,year-1) ;

* For reference, the change is always equal to 1.
mat_red_change("REF",reg,year)  = 1 ;
* Year 2011-2020 should also have change equal to 1.
loop(year$( ord(year) le 10 ),
mat_red_change(sce_sce,reg,year)$mat_red_change(sce_sce,reg,"2022") = 1 ;
) ;

Display
    mat_red_change
;

* ============================== 08_transport_shares ===========================


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


* set change-values to 1 in years 2011-2020
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
    ener_use_tran_change
    ener_use_ind_change
    ener_use_serv_change
;


* ============================== 09_gas_mix ====================================

* We use the demand for hydrogen and gas between 2011 and 2050 for transport
* hh, services and industy as proxy for shift between gas and hydrogen

Parameters
    gas_use_tran_aggrr(sce_sce,reg,ind,year)
    gas_use_ind_aggrr(sce_sce,reg,ind,year)
    gas_use_serv_aggrr(sce_sce,reg,ind,year)
    gas_use_aggrr(sce_sce,reg,ind,year)
    gas_use_share(sce_sce,reg,ind,year)
;

* In 2050: Aggregate to region and product
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

* In 2050: Aggregate transport, industry and services
gas_use_aggrr(sce_sce,reg,ind,year)
    = gas_use_tran_aggrr(sce_sce,reg,ind,year)
    + gas_use_ind_aggrr(sce_sce,reg,ind,year)
    + gas_use_serv_aggrr(sce_sce,reg,ind,year) ;

* In 2050: calculate shares
gas_use_share(sce_sce,reg,ind,year)$sum((indd) ,gas_use_aggrr(sce_sce,reg,indd,year))
    = gas_use_aggrr(sce_sce,reg,ind,year)
        / sum((indd) ,gas_use_aggrr(sce_sce,reg,indd,year)) ;

* For year 2011-2050 and reference: calculate gas-share
gas_use_share("REF",reg,ind_ng,year)
    = coprodB(reg,'pNG',reg,ind_ng)/ sum(indd_ng, coprodB(reg,'pNG',reg,indd_ng)) ;

* For other scenarios. Set year 2011-2020 equal to reference
gas_use_share(sce_sce_select,reg,ind,year_select) = gas_use_share("REF",reg,ind,year_select) ;

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




























