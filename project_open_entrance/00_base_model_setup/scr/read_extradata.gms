* File:   %project%/00_base_model_setup/scr/trial_read_extradata.gms
* Author: Tatyana Bulavskaya
* Date:   11 August 2015
* Adjusted:

* gams-master-file: run_EXIOMOD.gms

$ontext startdoc
This code is used to read in external data for further trial simulations with
base CGE model.
$offtext


Sets
    year            / 2011*2050 /

    year1_sce
/
YR2007*YR2050
/

*    ener(prd)
*/
*$include %project%\00_base_model_setup\sets\products_model_energy.txt
*/

;

Alias
    (year,yearr)
;


* Data from worldbank
$include %project%\01_external_data\Worldbank\scr\01_read_worldbank_data.gms
$include %project%\01_external_data\Worldbank\scr\02_aggregate_worldbank_data.gms

* Data from OECD
$include %project%\01_external_data\OECD\scr\01_read_OECD_data.gms
$include %project%\01_external_data\OECD\scr\02_aggregate_OECD_data.gms

* Data from OpenEntrance platform
$include %project%\01_external_data\OEplatform\scr\01_read_OEplatform_data.gms
$include %project%\01_external_data\OEplatform\scr\02_aggregate_OEplatform_data.gms

* Scenario data
$include %project%\01_external_data\scenarios\scr\01_read_scenario_data.gms
$include %project%\01_external_data\scenarios\scr\02_aggregate_scenario_data_new2.gms

* Physical extensions
* Contains data and scripts for processing the input data from the EXIOBASE
* physical extensions database v2.2.0.
$include %project%\01_external_data\physical_extensions_2011\scr\01_read_EXIOBASE_physical_extensions_data.gms
$include %project%\01_external_data\physical_extensions_2011\scr\02_aggregate_EXIOBASE_physical_extensions_data.gms
$include %project%\01_external_data\physical_extensions_2011\scr\03_calculate_physical_coefficients_CO2cap.gms
$include %project%\01_external_data\physical_extensions_2011\scr\04_rescale_physical_coefficients_2011_CO2cap.gms
$include %project%\01_external_data\physical_extensions_2011\scr\05_rescale_physical_coefficients_2012-2050_CO2cap.gms



* Scenario data
