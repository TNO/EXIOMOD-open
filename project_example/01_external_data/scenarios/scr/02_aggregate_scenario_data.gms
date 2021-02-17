
$ontext

File:   02_aggregate_scenario_data.gms
Author: Hettie Boonman
Date:   26-11-2020

This script processes data from a scenario (no official source).


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "GDP"                               Gross Domestic Product

    2. Data source (should be the same as name of the library)
    "_scen"                             Data from scenario

    3. Unit of measurement
    "_yr"                               data interpolated by year
    "_aggr"                             data aggregated by prd and ind
    "_change"                           annual change in t/(t-1)-1

Example of resulting parameter: GDP_scen_change


INPUTS
    GDP_data(reg_sce,year_sce)                           GDP growth wrt 2007
    POP_data(reg_sce,year_sce)                           POP growth wrt 2007
    mat_red_data(year)                                   Reduction in materials
                                                         # (index, 2011=100)

OUTPUTS
    GDP_scen_change(reg,year)                            Annual change GDP
    POP_scen_change(reg,year)                            Annual change populatio
    mat_red_scen_change(year)                            Annual change material
                                                         # use

annual change is expressed in t/(t-1)-1
$offtext

$oneolcom
$eolcom #


* ==================== Declaration of aggregation schemes ======================
Sets

    reg_sce_aggr(reg_sce,reg_data)      aggregation scheme for ref regions
/
$include %project%\01_external_data\scenarios\sets\aggregation\regions_sce_to_data.txt
/

    ind_sce_aggr(ind_sce,ind_data)      aggregation scheme for ref sources
/
$include %project%\01_external_data\scenarios\sets\aggregation\industries_sce_to_data.txt
/

    prd_sce_aggr(prd_sce,prd_data)      aggregation scheme for ref sources
/
$include %project%\01_external_data\scenarios\sets\aggregation\products_sce_to_data.txt
/

    year1_sce
/
YR2007*YR2050
/

    yr_sce_aggr(year1_sce,year)         aggregation scheme for ref sources
/
$include %project%\01_external_data\scenarios\sets\aggregation\years_sce_to_data.txt
/

;

Alias (year1_sce,yearr1_sce);


* ============================ Aggregation of years ============================

Parameters
    techmix_yr(reg_sce,ind_sce,year,prd_sce)      Technology mix in %
    GDP_yr(reg_sce,year)                          GDP growth wrt 2007
    POP_yr(reg_sce,year)                          POP growth wrt 2007
    CO2budget_yr(reg_sce,year)


* For interpolation of results
    year_sce_intpol1(year1_sce,year_sce)          Helpvariable for interpolation
    year_sce_intpol2(year1_sce,year_sce)          Helpvariable for interpolation

;

$libinclude xlimport year_sce_intpol1  %project%\01_external_data\scenarios\sets\aggregation\Years_interpolation.xlsx    Years_interpolation1!a2:k10000
$libinclude xlimport year_sce_intpol2  %project%\01_external_data\scenarios\sets\aggregation\Years_interpolation.xlsx    Years_interpolation2!a2:k10000



GDP_yr(reg_sce,year)
         =  sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             GDP_data(reg_sce,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((GDP_data(reg_sce,year_sce)-
                    GDP_data(reg_sce,year_sce-1))
                    $(GDP_data(reg_sce,year_sce-1)))
                    /sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
            )
;

POP_yr(reg_sce,year)
         = sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             POP_data(reg_sce,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((POP_data(reg_sce,year_sce)-
                    POP_data(reg_sce,year_sce-1))
                    $(POP_data(reg_sce,year_sce-1)))
                    /sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
            )
;



Display
    GDP_yr
    POP_yr
;




* ========================== Aggregate prd and ind =============================

Parameters
    techmix_aggr(reg,ind,year,prd)                Technology mix in %
    GDP_aggr(reg,year)                            GDP growth wrt 2007
    POP_aggr(reg,year)                            POP growth wrt 2007
    CO2budget_aggr(reg,year)
;


GDP_aggr(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
       GDP_yr(reg_sce,year) ) )  ;

POP_aggr(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
       POP_yr(reg_sce,year) ) )  ;


Display
    GDP_aggr
    POP_aggr
;


* ========================== Create index wrt year before ======================

* Because the indices above can be aggregated over products and industries
* Because the base year changed from 2007 to 2011 in our case

Parameters
    GDP_scen_change(reg,year)                            Annual change GDP
    POP_scen_change(reg,year)                            Annual change populatio
    mat_red_scen_change(year)                            Annual change material
                                                         # use
;

GDP_scen_change(reg,year)$GDP_aggr(reg,year-1)
    = GDP_aggr(reg,year) / GDP_aggr(reg,year-1) ;

POP_scen_change(reg,year)$POP_aggr(reg,year-1)
    = POP_aggr(reg,year) / POP_aggr(reg,year-1) ;

mat_red_scen_change(year)$mat_red_data(year-1)
    = mat_red_data(year)/ mat_red_data(year-1) ;

* All regions that have no GDP trajectory, set the change equal to 1.
GDP_scen_change(reg,year)$(not GDP_scen_change(reg,year)) = 1 ;
POP_scen_change(reg,year)$(not POP_scen_change(reg,year)) = 1 ;
mat_red_scen_change('2011') = 1 ;

Display
    GDP_scen_change
    POP_scen_change
    mat_red_scen_change
;


