
Sets
    year    simulation years           / 2001*2050 /
;

Alias
    (year,years)
;

* Library baseline
* This library contains data, sets and scripts for processing the baseline data from CEPII (v2.2).
$include %project%\01_CEPII_baseline\scr\01-read-cepii-data.gms
$include %project%\01_CEPII_baseline\scr\02-aggregate-cepii-data.gms


* Library physical extensions
* This library contains data and scripts for processing the input data
* from the EXIOBASE physical extensions database v2.2.0.
*$include %project%\library_physical_extensions\scr\01-read-EXIOBASE-physical-extensions-data.gms
*$include %project%\library_physical_extensions\scr\02-aggregate-EXIOBASE-physical-extensions-data.gms
*$include %project%\library_physical_extensions\scr\03-calculate-physical-coefficients.gms
