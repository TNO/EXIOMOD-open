
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
    "_OECD"        Worldbank database

    3. Unit of measurement
    "_level"        absolute value for year t
    "_change"       annual change in t/(t-1)-1

Example of resulting parameter: GDP_OECD_change


INPUTS

    GDP_OECD_orig(reg_OECD,year_OECD)         real GDP (long term, mln dollar)
    POP_OECD_orig(reg_OECD,year_OECD)         Total population


OUTPUTS


annual change is expressed in t/(t-1)
$offtext

$oneolcom
$eolcom #


* ==================== Declaration of aggregation schemes ======================
Sets

    reg_OECD_aggr(reg_data,reg_OECD)    aggregation scheme for cepii regions
/
$include %project%\01_external_data\OECD\sets\aggregation\regions_OECD_to_data.txt
/

    year_OECD_aggr(year_OECD,year)      aggregation scheme for cepii years
/
$include %project%\01_external_data\OECD\sets\aggregation\years_OECD_to_data.txt
/

;

Alias (reg_OECD,regg_OECD) ;

* ============================ Aggregation of years ==========================

Parameters
    GDP_OECD_yr(reg_OECD,year)         real GDP (long term, mln dollar)
    POP_OECD_yr(reg_OECD,year)         Total population


;

GDP_OECD_yr(reg_OECD,year)
    = sum(year_OECD$year_OECD_aggr(year_OECD,year),
          GDP_OECD_orig(reg_OECD,year_OECD)  ) ;

POP_OECD_yr(reg_OECD,year)
    = sum(year_OECD$year_OECD_aggr(year_OECD,year),
          POP_OECD_orig(reg_OECD,year_OECD)  ) ;


* ============================ Aggregation of regions ==========================


Parameters
    GDP_OECD_reg(reg,year)            real GDP (long term, mln dollar)
    POP_OECD_reg(reg,year)            Total population
;


GDP_OECD_reg(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OECD$reg_OECD_aggr(reg_data,reg_OECD),
          GDP_OECD_yr(reg_OECD,year)  ) ) ;

POP_OECD_reg(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_OECD$reg_OECD_aggr(reg_data,reg_OECD),
          POP_OECD_yr(reg_OECD,year)  ) ) ;


Display
    GDP_OECD_reg
    POP_OECD_reg
;

* ====================== percentage to ratio change ============================

Parameters
    GDP_gr_OECD(reg,year)                   annual growth in GDP
    POP_gr_OECD(reg,year)                   annual growth in population
;

GDP_gr_OECD(reg,year)$GDP_OECD_reg(reg,year-1)
         = GDP_OECD_reg(reg,year) / GDP_OECD_reg(reg,year-1) ;
POP_gr_OECD(reg,year)$POP_OECD_reg(reg,year-1)
         = POP_OECD_reg(reg,year) / POP_OECD_reg(reg,year-1) ;

Display GDP_gr_OECD;




