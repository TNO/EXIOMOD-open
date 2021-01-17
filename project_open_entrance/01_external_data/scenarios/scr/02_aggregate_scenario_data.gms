
$ontext

File:   02-aggregate-ref-data.gms
Author: Anke van den Beukel
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

    year1_sce
/
YR2007*YR2050
/

    yr_sce_aggr(year1_sce,year)  aggregation scheme for ref sources
/
$include %project%\01_external_data\scenarios\sets\aggregation\years_sce_to_data.txt
/

;

Alias (year1_sce,yearr1_sce);


* ============================ Aggregation of years ============================

Parameters
    techmix_yr(reg_sce,ind_sce,year,prd_sce)       Technology mix in %
    GDP_yr(reg_sce,year)                            GDP growth wrt 2007
    POP_yr(reg_sce,year)                            POP growth wrt 2007
    CO2budget_yr(reg_sce,year)


* For interpolation of results
    year_sce_intpol1(year1_sce,year_sce)                 Helpvariable for interpolation
    year_sce_intpol2(year1_sce,year_sce)                 Helpvariable for interpolation

;

$libinclude xlimport year_sce_intpol1  %project%\01_external_data\scenarios\sets\aggregation\Years_interpolation.xlsx    Years_interpolation1!a2:k10000
$libinclude xlimport year_sce_intpol2  %project%\01_external_data\scenarios\sets\aggregation\Years_interpolation.xlsx    Years_interpolation2!a2:k10000



techmix_yr(reg_sce,ind_sce,year,prd_sce)
         = sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             techmix_data(reg_sce,ind_sce,year_sce,prd_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((techmix_data(reg_sce,ind_sce,year_sce,prd_sce)-
                    techmix_data(reg_sce,ind_sce,year_sce-1,prd_sce))$(techmix_data(reg_sce,ind_sce,year_sce-1,prd_sce)))/sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )

            )
;

GDP_yr(reg_sce,year)
         =  sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             GDP_data(reg_sce,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((GDP_data(reg_sce,year_sce)-
                    GDP_data(reg_sce,year_sce-1))$(GDP_data(reg_sce,year_sce-1)))/sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
            )
;

POP_yr(reg_sce,year)
         = sum(year1_sce$yr_sce_aggr(year1_sce,year),

            sum(year_sce$year_sce_intpol2(year1_sce,year_sce),
             POP_data(reg_sce,year_sce) )
 +            sum(year_sce$year_sce_intpol1(year1_sce,year_sce),
                year_sce_intpol1(year1_sce,year_sce)*
                  ((POP_data(reg_sce,year_sce)-
                    POP_data(reg_sce,year_sce-1))$(POP_data(reg_sce,year_sce-1)))/sum(yearr1_sce,year_sce_intpol2(yearr1_sce,year_sce))  )
            )
;



CO2budget_yr(reg_sce,year)
    =   sum(year1_sce$yr_sce_aggr(year1_sce,year),

        1 -
        ( ord(year1_sce) - 1 ) *
        (1 - CO2budget_data(reg_sce,'CO2budgetperc'))/(2050-2007)

        )
;



Display
    techmix_yr
    GDP_yr
    POP_yr
    CO2budget_yr
;




* ========================== Aggregate prd and ind =============================

Parameters
    techmix_aggr(reg,ind,year,prd)                Technology mix in %
    GDP_aggr(reg,year)                            GDP growth wrt 2007
    POP_aggr(reg,year)                            POP growth wrt 2007
    CO2budget_aggr(reg,year)
;


techmix_aggr(reg,ind,year,prd)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
            sum(ind_data$ind_aggr(ind_data,ind),
                sum(ind_sce$ind_sce_aggr(ind_sce,ind_data),
                    sum(prd_data$prd_aggr(prd_data,prd),
                        sum(prd_sce$prd_sce_aggr(prd_sce,prd_data),
       techmix_yr(reg_sce,ind_sce,year,prd_sce) ) ) ) ) ) ) ;

GDP_aggr(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
       GDP_yr(reg_sce,year) ) )  ;

POP_aggr(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
       POP_yr(reg_sce,year) ) )  ;

CO2budget_aggr(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_sce$reg_sce_aggr(reg_sce,reg_data),
       CO2budget_yr(reg_sce,year) ) ) ;

Display
    techmix_aggr
    GDP_aggr
    POP_aggr
    CO2budget_aggr
;




* ========================== Create index wrt 2011 =========================

* Because the indices above can be aggregated over products and industries
* Because the base year changed from 2007 to 2011 in our case

Parameters
    techmix_norm(reg,ind,year,prd)                  Technology mix in %
    GDP_change_2011(reg,year)                            GDP growth wrt 2007
    POP_change_2011(reg,year)                            POP growth wrt 2007
    CO2budget_change_2011(reg,year)
;

techmix_norm(reg,ind,year,prd)
    $ sum(prdd, techmix_aggr(reg,ind,year,prdd) )
    = techmix_aggr(reg,ind,year,prd)
        / sum(prdd, techmix_aggr(reg,ind,year,prdd) );

GDP_change_2011(reg,year)$GDP_aggr(reg,'2011')
    = GDP_aggr(reg,year) / GDP_aggr(reg,'2011') ;

POP_change_2011(reg,year)$POP_aggr(reg,'2011')
    = POP_aggr(reg,year) / POP_aggr(reg,'2011') ;

CO2budget_change_2011(reg,year)$CO2budget_aggr(reg,'2011')
    = CO2budget_aggr(reg,year) / CO2budget_aggr(reg,'2011') ;

* All regions that have no GDP trajectory, set the change equal to 1.
GDP_change_2011(reg,year)$(not GDP_change_2011(reg,year)) = 1 ;
POP_change_2011(reg,year)$(not POP_change_2011(reg,year)) = 1 ;
CO2budget_change_2011(reg,year)$(not CO2budget_change_2011(reg,year)) = 1 ;

Display
    techmix_norm
    GDP_change_2011
    POP_change_2011
    CO2budget_change_2011
;


* ========================== Create index wrt year before ======================

* Because the indices above can be aggregated over products and industries
* Because the base year changed from 2007 to 2011 in our case

Parameters
    techmix_norm(reg,ind,year,prd)                Technology mix in %
    GDP_scen_change(reg,year)                            GDP growth wrt 2007
    POP_scen_change(reg,year)                            POP growth wrt 2007
    CO2budget_change(reg,year)
    mat_red_change(year)
;

GDP_scen_change(reg,year)$GDP_aggr(reg,year-1)
    = GDP_aggr(reg,year) / GDP_aggr(reg,year-1) ;

POP_scen_change(reg,year)$POP_aggr(reg,year-1)
    = POP_aggr(reg,year) / POP_aggr(reg,year-1) ;

CO2budget_change(reg,year)$CO2budget_aggr(reg,year-1)
    = CO2budget_aggr(reg,year) / CO2budget_aggr(reg,year-1) ;

mat_red_change(year)$mat_red_data(year-1)
    = mat_red_data(year)/ mat_red_data(year-1) ;

* All regions that have no GDP trajectory, set the change equal to 1.
GDP_scen_change(reg,year)$(not GDP_scen_change(reg,year)) = 1 ;
POP_scen_change(reg,year)$(not POP_scen_change(reg,year)) = 1 ;
CO2budget_change(reg,year)$(not CO2budget_change(reg,year)) = 1 ;
mat_red_change('2011') = 1 ;

Display
    GDP_scen_change
    POP_scen_change
    CO2budget_change
    mat_red_change
;


