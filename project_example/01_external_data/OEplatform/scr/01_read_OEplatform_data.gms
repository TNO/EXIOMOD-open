$ontext

File:   01_read_OEplatform_data.gms
Author: Hettie Boonman
Date:   26-11-2020

This script reads in data from the OpenEnttrance platform.


PARAMETER NAME
Resulting parameters are named according to:


INPUTS
    %project%\01_external_data\OEplatform\data\GENeSYS-MOD-pathways_v1.0.xlsx

OUTPUTS
    OEdatabase_data(mod_OE,sce_OE,reg_OE,var_OE,unit_OE,year_OE)

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
    database_OE_data(mod_OE,sce_OE,reg_OE,var_OE,unit_OE,year_OE)   All data from
                                                                   # platform
;

$libinclude xlimport database_OE_data          %project%\01_external_data\OEplatform\data\GENeSYS-MOD-pathways_v1.0.xlsx    data!A1:M7705

Display database_OE_data;

$exit

