* File:   configuration.gms
* Author: Tatyana Bulavskaya
* Date:   26 May 2014

* gams-master-file: main.gms

$ontext startdoc
This is the configuration file for the core input-output model. The file allows
to configure the following control variables:

Variable           | Explanation
------------------ | -----------
`db_check`         | determine whether the database needs checking.
`agg_check`        | determine whether aggregation schemes need checking.
`base_year`        | select one of the years available in the database.
`base_cur`         | select one of the currencies available in the database.
`io_type`          | select one of input-output model types.
`simulation_setup` | select out of one of the preprogrammed simulation setup available in `scr/simulation/`.
$offtext

* database checking: set 'yes' to check the database on consistency
* set 'no' otherwise
$if not set db_check     $setglobal      db_check        'yes'

* name of the project folder, you can just keep it as project or give a more
* meaningful name
$if not set project      $setglobal      project         'project'

* aggregation checking: set 'yes' to check aggregation schemes between database
* and model set on consistency
* set 'no' otherwise
$if not set agg_check    $setglobal      agg_check       'yes'

* base year
$if not set base_year    $setglobal      base_year       '2007'

* base currency
$if not set base_cur     $setglobal      base_cur        'MEUR'
