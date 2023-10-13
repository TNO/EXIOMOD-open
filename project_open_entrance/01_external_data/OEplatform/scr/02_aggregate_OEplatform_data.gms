
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

    reg_OE_aggr(reg_OE,reg_data)        aggregation scheme for ref regions
/
$include %project%\01_external_data\OEplatform\sets\aggregation\region_OEplatform_to_data.txt
/

    var_OE_aggr(var_OE,ind_data)  aggregation scheme for ref sources
/
$include %project%\01_external_data\OEplatform\sets\aggregation\variable_OEplatform_to_data.txt
/

    var_OE_prd_aggr(var_OE,prd)  aggregation scheme for ref sources
/
$include %project%\01_external_data\OEplatform\sets\aggregation\variable_OEplatform_to_prd.txt
/

    var_OE_ind_aggr(var_OE,ind)  aggregation scheme for ref sources
/
$include %project%\01_external_data\OEplatform\sets\aggregation\variable_OEplatform_to_ind.txt
/

    year1_OE
/
YR2011*YR2050
/

    yr_OE_aggr(year1_OE,year)  aggregation scheme for ref sources
/
$include %project%\01_external_data\OEplatform\sets\aggregation\years_OEplatform_to_data.txt
/

;

Alias (year1_OE,yearr1_OE);


* ============================ Aggregation of years ============================

Parameters

* For interpolation of results
    year_OE_intpol1(year1_OE,year_OE)                 Helpvariable for interpolation
    year_OE_intpol2(year1_OE,year_OE)                 Helpvariable for interpolation

;

$libinclude xlimport year_OE_intpol1  %project%\01_external_data\OEplatform\sets\aggregation\Years_interpolation.xlsx    Years_interpolation1!a2:j10000
$libinclude xlimport year_OE_intpol2  %project%\01_external_data\OEplatform\sets\aggregation\Years_interpolation.xlsx    Years_interpolation2!a2:j10000


Display
    year_OE_intpol1
    year_OE_intpol2
;




