* File:   %project%/00_base_model_setup/scr/trial_read_extradata.gms
* Author: Tatyana Bulavskaya
* Organization: TNO, Netherlands
* Date:   11 August 2015
* Adjusted: 17 Februari 2021 by Hettie Boonman

* gams-master-file: run_EXIOMOD.gms

********************************************************************************
* THIS MODEL IS A CUSTOM-LICENSE MODEL.
* EXIOMOD 2.0 shall not be used for commercial purposes until an exploitation
* aggreement is signed, subject to similar conditions as for the underlying
* database (EXIOBASE). EXIOBASE limitations are based on open source license
* agreements to be found here:
* http://exiobase.eu/index.php/terms-of-use

* For information on a license, please contact: hettie.boonman@tno.nl
********************************************************************************

$ontext startdoc
This code is used to read in external data for further trial simulations with
base CGE model.
$offtext


Sets
    year            / 2011*2050 /
;

Alias
    (year,yearr)
;


* Scenario data
$include %project%\01_external_data\scenarios\scr\01_read_scenario_data.gms
$include %project%\01_external_data\scenarios\scr\02_aggregate_scenario_data.gms

* Data from OpenEntrance platform
$include %project%\01_external_data\OEplatform\scr\01_read_OEplatform_data.gms
$include %project%\01_external_data\OEplatform\scr\02_aggregate_OEplatform_data.gms

