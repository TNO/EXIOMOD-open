
$ontext

File:   02-aggregate-baseline-data.gms
Author: Hettie Boonman
Date:   18-09-2019

This script processes in the baseline data from 2012 aging report.


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "GDP"        GDP

    2. Data source (should be the same as name of the library)
    "_EU"        Worldbank database

    3. Unit of measurement
    "_level"        absolute value for year t
    "_change"       annual change in t/(t-1)-1

Example of resulting parameter: GDP_EU_change


INPUTS

    GDP_EU_orig(reg_EU,year_EU)         GDP in 2010 US dollars
    POP_EU_orig(reg_EU,year_EU)         Total population


OUTPUTS
    GDP_gr_EU(reg,year)                  annual growth in GDP
    POP_gr_EU(reg,year)                  annual growth in population

annual change is expressed in t/(t-1)
$offtext

$oneolcom
$eolcom #


* ==================== Declaration of aggregation schemes ======================
Sets

    reg_EU_aggr(reg_EU,reg_data)    aggregation scheme for cepii regions
/
$include %project%\01_external_data\eureference\sets\aggregation\regions_euref_to_data.txt
*$include %project%\01_external_data\aging_report_2012\sets\aggregation\regions_missing_aging_to_model.txt
/

    year_EU_aggr(year_EU,year)      aggregation scheme for cepii years
/
$include %project%\01_external_data\eureference\sets\aggregation\years_euref_to_model.txt
/

    year_EU_aggr2(year_EU,year)      aggregation scheme for cepii years
/
$include %project%\01_external_data\eureference\sets\aggregation\years_euref_to_model2.txt
/

;

Alias (reg_EU,regg_EU) ;

* ============================ Aggregation of years ==========================

Parameters
    GDP_EU_yr(reg_EU,year)         GDP in 2010 US dollars
    POP_EU_yr(reg_EU,year)         Total population

;

GDP_EU_yr(reg_EU,year)=
    sum(year_EU$year_EU_aggr2(year_EU,year),GDP_EU_orig(reg_EU,year_EU)) +
        ( ord(year)/5 - floor(ord(year)/5 ) ) *
            ( sum(year_EU$year_EU_aggr(year_EU,year),GDP_EU_orig(reg_EU,year_EU)) -
                sum(year_EU$year_EU_aggr2(year_EU,year),GDP_EU_orig(reg_EU,year_EU) ) ) ;

GDP_EU_yr(reg_EU,year)$( ord(year)/5 eq floor(ord(year)/5 ) )
     = sum(year_EU$year_EU_aggr(year_EU,year),GDP_EU_orig(reg_EU,year_EU)) ;


POP_EU_yr(reg_EU,year)=
    sum(year_EU$year_EU_aggr2(year_EU,year),POP_EU_orig(reg_EU,year_EU)) +
        ( ord(year)/5 - floor(ord(year)/5 ) ) *
            ( sum(year_EU$year_EU_aggr(year_EU,year),POP_EU_orig(reg_EU,year_EU)) -
                sum(year_EU$year_EU_aggr2(year_EU,year),POP_EU_orig(reg_EU,year_EU) ) ) ;

POP_EU_yr(reg_EU,year)$( ord(year)/5 eq floor(ord(year)/5 ) )
     = sum(year_EU$year_EU_aggr(year_EU,year),POP_EU_orig(reg_EU,year_EU)) ;


Display
    GDP_EU_yr
    POP_EU_yr
;

* ============================ Aggregation of regions ==========================


* Note that this is the simplified way, I was too lazy to connect all regions in
* the world to all the EXIOBASE regions.

Parameters
    GDP_EU_reg(reg,year)            GDP in 2010 US dollars
    POP_EU_reg(reg,year)         Total population
;


GDP_EU_reg(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_EU$reg_EU_aggr(reg_EU,reg_data),
          GDP_EU_yr(reg_EU,year)  ) ) ;

POP_EU_reg(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_EU$reg_EU_aggr(reg_EU,reg_data),
          POP_EU_yr(reg_EU,year)  ) ) ;

Display
    GDP_EU_reg
    POP_EU_reg
;

* ====================== percentage to ratio change ============================

Parameters
    GDP_gr_EU(reg,year)                  annual growth in GDP
    POP_gr_EU(reg,year)                  annual growth in population
;

GDP_gr_EU(reg,year)$GDP_EU_reg(reg,year-1)
         = GDP_EU_reg(reg,year) / GDP_EU_reg(reg,year-1) ;

POP_gr_EU(reg,year)$POP_EU_reg(reg,year-1)
         = POP_EU_reg(reg,year) / POP_EU_reg(reg,year-1) ;

Display GDP_gr_EU;

* ======================= Baseyear should have value one =======================

GDP_gr_EU(reg,"2011")$GDP_gr_EU(reg,"2012")              = 1 ;
POP_gr_EU(reg,"2011")$POP_gr_EU(reg,"2012")              = 1 ;

Display GDP_gr_EU;


