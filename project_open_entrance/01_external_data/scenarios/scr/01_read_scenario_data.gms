
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
    techmix_data(reg_sce,ind_sce,year_sce,prd_sce)       Technology mix in %
    CO2budget_data(reg_sce,*)                            CO2 budget in 2050 in %
                                                         # wrt 2007
    GDP_data(reg_sce,year_sce)                           GDP growth wrt 2007
    POP_data(reg_sce,year_sce)                           POP growth wrt 2007
;

$libinclude xlimport techmix_data           %project%\01_external_data\scenarios\data\Scenario_input_communication_file.xlsx    techmix!A2:P10000
$libinclude xlimport CO2budget_data         %project%\01_external_data\scenarios\data\Scenario_input_communication_file.xlsx    CO2budget!A3:B10000
$libinclude xlimport GDP_data               %project%\01_external_data\scenarios\data\Scenario_input_communication_file.xlsx    GDP!A3:K10000
$libinclude xlimport POP_data               %project%\01_external_data\scenarios\data\Scenario_input_communication_file.xlsx    Population!A3:K10000

Display techmix_data, CO2budget_data, GDP_data, POP_data;

$exit

