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
    year            / 2007*2050 /
;

Alias
    (year,yearr)
;

* Baseline
* Contains data, sets and scripts for processing the baseline data from CEPII (v2.1).
$include %project%\01_external_data\CEPII\scr\01_read_cepii_data.gms
$include %project%\01_external_data\CEPII\scr\02_aggregate_cepii_data.gms

* Physical extensions
* Contains data and scripts for processing the input data from the EXIOBASE
* physical extensions database v2.2.0.
$include %project%\01_external_data\physical_extensions\scr\01_read_EXIOBASE_physical_extensions_data.gms
$include %project%\01_external_data\physical_extensions\scr\02_aggregate_EXIOBASE_physical_extensions_data.gms