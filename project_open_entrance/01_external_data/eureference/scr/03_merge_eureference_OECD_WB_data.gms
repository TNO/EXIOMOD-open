
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

sets
    reg_EU_mod(reg)

/ AUT, BEL, BGR, HRV, CZE, CYP, DNK, EST, FIN, FRA, DEU, GRC, HUN, IRL, ITA, LVA,
  LTU, LUX, MLT, NLD, POL, PRT, ROU, SVK, SVN, ESP, SWE, GBR /

    reg_WRLD_mod(reg)
/RWO, RWN  /

;

* ============================ Aggregation of years ==========================

Parameters
    GDP_CICERONE_change(reg,year)         GDP in 2010 US dollars
    POP_CICERONE_change(reg,year)         Total population
;



loop(year$( ord(year) le 40 ),

if(ord(year) lt 9,
    GDP_CICERONE_change(reg,year) = GDP_gr_WB(reg,year) ;
    POP_CICERONE_change(reg,year) = POP_gr_WB(reg,year) ;
) ;

if(ord(year) gt 8,
* Phase out share of changes in inventories
    GDP_CICERONE_change(reg_EU_mod,year) = GDP_gr_EU(reg_EU_mod,year) ;
    GDP_CICERONE_change(reg_WRLD_mod,year) = GDP_gr_OECD(reg_WRLD_mod,year) ;
    POP_CICERONE_change(reg_EU_mod,year) = POP_gr_EU(reg_EU_mod,year) ;
    POP_CICERONE_change(reg_WRLD_mod,year) = POP_gr_OECD(reg_WRLD_mod,year) ;
) ;


);




Display
    GDP_CICERONE_change
    POP_CICERONE_change
;

