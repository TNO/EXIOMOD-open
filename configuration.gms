
*' configuration.gms
*' author: Tatyana Bulavskaya
*' date: 26 May 2014

$ontext
This is the configuration file for the core input-output model. The file allows
to configure the following control variables:
 - base_year, select one of the years available in the database.
 - base_cur, select one of the currencies available in the database.
 - io_type, select one of input-output model types.
 - simulation_setup, select out of one of the preprogrammed simulation setup
   available in scr/simulation/.
$offtext

* base year
$if not set base_year    $setglobal      base_year       2007

* base currency
$if not set base_cur     $setglobal      base_cur        MEUR

* model type
*$if not set io_type      $setglobal      io_type   product_technology
$if not set io_type      $setglobal      io_type   industry_technology


* simulation setup
*$if not set simulation_setup     $setglobal      simulation_setup        multipliers
$if not set simulation_setup     $setglobal      simulation_setup        final_demand_shock

