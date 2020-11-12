
$ontext

File:   01-read-ref-data.gms
Author: Anke van den Beukel
Date:   17-12-2019

This script reads in template data from the EU reference scenario.


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "elec"        electricity (TWh)

    2. Data source (should be the same as name of the library)
    "_ref"        EU reference database database

    3. Extension "_orig" is added to indicate that it is not processed

Example of resulting parameter: elec_ref_orig


INPUTS
    %project%\library_ref\data\data_template.xlsx

OUTPUTS
    elec_ref_orig(reg_ref, source_ref, year_ref)     ref electricity mix in
                                                     original classification
    elec_ref_perc(reg_ref,source_ref,year_ref)       percentage change in
                                                     electricity mix

$offtext

$oneolcom
$eolcom #
* ============================ Declaration of sets =============================

sets

    reg_OE         list of regions in scenarios data
/
$include %project%\01_external_data\OEplatform\sets\region_OEplatform.txt
/

    mod_OE         list of models in scenarios data
/
$include %project%\01_external_data\OEplatform\sets\model_OEplatform.txt
/

    sce_OE         list of scenarios in scenarios data
/
$include %project%\01_external_data\OEplatform\sets\scenario_OEplatform.txt
/

    unit_OE        list of units in scenarios data
/
$include %project%\01_external_data\OEplatform\sets\unit_OEplatform.txt
/

    var_OE        list of variables in scenarios data
/
$include %project%\01_external_data\OEplatform\sets\variable_OEplatform.txt
/

    year_OE        list of years in scenarios data
/
$include %project%\01_external_data\OEplatform\sets\year_OEplatform.txt
/
;

* ================================ Load data ===================================

Parameters
    OEdatabase_data(mod_OE,sce_OE,reg_OE,var_OE,unit_OE,year_OE)      all data from platfrom
;

$libinclude xlimport OEdatabase_data           %project%\01_external_data\OEplatform\data\GENeSYS-MOD-pathways_v1.0.xlsx    data!A1:M7705

Display OEdatabase_data;

$exit

