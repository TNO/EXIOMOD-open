
$ontext

File:   01_read_scenario_data.gms
Author: Hettie Boonman
Date:   26-11-2020

This script reads in data from a scenario (no official source).


PARAMETER NAME


INPUTS
    %project%\01_external_data\scenarios\data\Scenario_input_communication_file.xlsx

OUTPUTS
    GDP_data(reg_sce,year_sce)                           GDP growth wrt 2007
    POP_data(reg_sce,year_sce)                           POP growth wrt 2007
    mat_red_data(year)                                   Reduction in materials
                                                         # (index, 2011=100)

$offtext

$oneolcom
$eolcom #
* ============================ Declaration of sets =============================

sets

    reg_sce         list of regions in scenarios data
/
$include %project%\01_external_data\scenarios\sets\country_scenario.txt
/

    ind_sce         list of industries in scenarios data
/
$include %project%\01_external_data\scenarios\sets\industry_scenario.txt
/

    prd_sce         list of products in scenarios data
/
$include %project%\01_external_data\scenarios\sets\product_scenario.txt
/

    year_sce        list of years in scenarios data
/
$include %project%\01_external_data\scenarios\sets\year_scenario.txt
/

;

* ================================ Load data ===================================

Parameters
    GDP_data(reg_sce,year_sce)                           GDP growth wrt 2007
    POP_data(reg_sce,year_sce)                           POP growth wrt 2007
    mat_red_data(year)                                   Reduction in materials
                                                         # (index, 2011=100)
;

$libinclude xlimport GDP_data               %project%\01_external_data\scenarios\data\Scenario_input_communication_file.xlsx    GDP!A3:K10000
$libinclude xlimport POP_data               %project%\01_external_data\scenarios\data\Scenario_input_communication_file.xlsx    Population!A3:K10000
$libinclude xlimport mat_red_data           %project%\01_external_data\scenarios\data\Scenario_input_communication_file.xlsx    Materials!B1:AO2

Display
    GDP_data
    POP_data
    mat_red_data
;

$exit

