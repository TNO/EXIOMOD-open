
Sets
    year            / 2007*2050 /
;

Alias
    (year,yearr)
;

* Baseline
* Contains data, sets and scripts for processing the baseline data from CEPII (v2.1).
$include %project%\CEPII_baseline\scr\01-read-cepii-data.gms
$include %project%\CEPII_baseline\scr\02-aggregate-cepii-data.gms

* Physical extensions
* Contains data and scripts for processing the input data from the EXIOBASE
* physical extensions database v2.2.0.
$include %project%\EXIOBASE_physical_extensions\scr\01-read-EXIOBASE-physical-extensions-data.gms
$include %project%\EXIOBASE_physical_extensions\scr\02-aggregate-EXIOBASE-physical-extensions-data.gms
