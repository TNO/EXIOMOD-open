
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
    "_WB"        Worldbank database

    3. Unit of measurement
    "_level"        absolute value for year t
    "_change"       annual change in t/(t-1)-1

Example of resulting parameter: GDP_WB_change


INPUTS

    GDP_WB_orig(reg_WB,year_WB)         GDP in 2010 US dollars
    POP_WB_orig(reg_WB,year_WB)         Total population
    LAB_FORCE_WB_orig(reg_WB,year_WB)   Labour force (15-64) (thousands)


OUTPUTS
    GDP_gr_WB(reg,year)                  annual growth in GDP
    LAB_FORCE_gr_WB(reg,year)            annual growth in labor force (15-64)
    POP_gr_WB(reg,year)                  annual growth in population

annual change is expressed in t/(t-1)
$offtext

$oneolcom
$eolcom #


* ==================== Declaration of aggregation schemes ======================
Sets

    reg_WB_aggr(reg_data,reg_WB)    aggregation scheme for cepii regions
/
$include %project%\01_external_data\Worldbank\sets\aggregation\regions_WB_to_data.txt
*$include %project%\01_external_data\aging_report_2012\sets\aggregation\regions_missing_aging_to_model.txt
/

    year_WB_aggr(year_WB,year)      aggregation scheme for cepii years
/
$include %project%\01_external_data\Worldbank\sets\aggregation\years_WB_to_data.txt
/

;

Alias (reg_WB,regg_WB) ;

* ============================ Aggregation of years ==========================

Parameters
    GDP_WB_yr(reg_WB,year)         GDP in 2010 US dollars
    POP_WB_yr(reg_WB,year)         Total population
    LAB_FORCE_WB_yr(reg_WB,year)   Labour force (15-64) (thousands)

;

GDP_WB_yr(reg_WB,year)
    = sum(year_WB$year_WB_aggr(year_WB,year),
          GDP_WB_orig(reg_WB,year_WB)  ) ;

POP_WB_yr(reg_WB,year)
    = sum(year_WB$year_WB_aggr(year_WB,year),
          POP_WB_orig(reg_WB,year_WB)  ) ;

LAB_FORCE_WB_yr(reg_WB,year)
    = sum(year_WB$year_WB_aggr(year_WB,year),
          LAB_FORCE_WB_orig(reg_WB,year_WB)  ) ;

* ============================ Aggregation of regions ==========================


* Note that this is the simplified way, I was too lazy to connect all regions in
* the world to all the EXIOBASE regions.

Parameters
    GDP_WB_reg(reg,year)            GDP in 2010 US dollars
    POP_WB_reg(reg,year)         Total population
    LAB_FORCE_WB_reg(reg,year)   Labour force (15-64) (thousands)
;


GDP_WB_reg(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_WB$reg_WB_aggr(reg_data,reg_WB),
          GDP_WB_yr(reg_WB,year)  ) ) ;

POP_WB_reg(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_WB$reg_WB_aggr(reg_data,reg_WB),
          POP_WB_yr(reg_WB,year)  ) ) ;

LAB_FORCE_WB_reg(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_WB$reg_WB_aggr(reg_data,reg_WB),
          LAB_FORCE_WB_yr(reg_WB,year)  ) ) ;

Display
    GDP_WB_reg
    POP_WB_reg
    LAB_FORCE_WB_reg
;

* ====================== percentage to ratio change ============================

Parameters
    GDP_gr_WB(reg,year)                  annual growth in GDP
    LAB_FORCE_gr_WB(reg,year)            annual growth in labor force (15-64)
    POP_gr_WB(reg,year)                  annual growth in population
;

GDP_gr_WB(reg,year)$GDP_WB_reg(reg,year-1)
         = GDP_WB_reg(reg,year) / GDP_WB_reg(reg,year-1) ;
LAB_FORCE_gr_WB(reg,year)$LAB_FORCE_WB_reg(reg,year-1)
         = LAB_FORCE_WB_reg(reg,year) / LAB_FORCE_WB_reg(reg,year-1) ;
POP_gr_WB(reg,year)$POP_WB_reg(reg,year-1)
         = POP_WB_reg(reg,year) / POP_WB_reg(reg,year-1) ;

Display GDP_gr_WB;

* ======================= Baseyear should have value one =======================

GDP_gr_WB(reg,"2011")$GDP_gr_WB(reg,"2012")              = 1 ;
LAB_FORCE_gr_WB(reg,"2011")$LAB_FORCE_gr_WB(reg,"2012")  = 1 ;
POP_gr_WB(reg,"2011")$POP_gr_WB(reg,"2012")              = 1 ;

Display GDP_gr_WB;


