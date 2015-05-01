* File:   library/scr/00_simulation_prepare.gms
* Author: Tatyana Bulavskaya
* Date:   29 April 2015
* Adjusted:

* gams-master-file: main.gms

$ontext startdoc
This script calls the files that are needed in preparation for running a
simulation. The database is loaded and aggregated, various modules of the model
are included in which parameters are defined and calibrated, the different model
equations are defined, initial values for all the variables are set, and
base-model is defined. The code consists of the following parts:

- Include `sets_database.gms`, where sets used in the database are declared.
- Include `load_database.gms`, where external input-output/supply-use database
  is loaded.
- Include `sets_model.gms`, where sets used in the model are declared and their
  relations for the sets in the database are defined.
- Include `aggregate_database.gms`, where the database is aggregated to the
  dimensions of the model, identified in `sets_model.gms`.
- Include phases of all the modules. The exact modules are specified with
  `phase.gms`.
- Include `declare_model.gms`, where the model equations are stated.

More specific explanation of each of the included part of the script can be
found in the corresponding `.gms` file. These explanation blocks include which
inputs are necessary for the scripts to run and which changes are possible.
$offtext

$include library/scr/01_sets_database.gms
$include library/scr/02_load_database.gms

$include library/scr/03_sets_model.gms
$include library/scr/04_aggregate_database.gms

$batinclude library/includes/phase.gms additional_sets
$batinclude library/includes/phase.gms parameters_declaration
$batinclude library/includes/phase.gms parameters_calibration
$batinclude library/includes/phase.gms equations_declaration
$batinclude library/includes/phase.gms equations_definition
$batinclude library/includes/phase.gms equations_bounds

$include library/scr/09_declare_model.gms
