* File:   library/scr/simulation_prepare.gms
* Author: Jelmer Ypma
* Date:   3 October 2014

$ontext

This script calls the files that are needed in preparation for running a
simulation. The database is loaded and aggregated, model parameters are
defined and calibrated, the different model equations are defined, and
initial values for all the variables are set. The code consists
of the following parts:

 * Include `configuration.gms`, where some key parameters relevant for data,
   model and simulation choices are set.
 * Include `sets_database.gms`, where sets used in the database are declared.
 * Include `load_database.gms`, where external input-output/supply-use database
   is loaded.
 * Include `sets_model.gms`, where sets used in the model are declared and their
   relations for the sets in the database are defined.
 * Include `aggregate_database.gms`, where the database is aggregated to the
   dimensions of the model, identified in `sets_model.gms`.
*  Include `user_data.gms`,  which reads in project specific data (e.g. on elasticities).
* Include `model_parameters.gms`, where key parameters of input-output model
   are defined.
 * Include `model_variables_equations.gms`, where variables, equations and the
   model itself are defined.

More specific explanation of each of the included part of the script can be
found in the corresponding `.gms` file. These explanation blocks include which
inputs are necessary for the scripts to run and which changes are possible.

$offtext

$include library/scr/sets_database.gms
$include library/scr/load_database.gms

$include library/scr/sets_model.gms
$include library/scr/aggregate_database.gms

$include library/scr/user_data.gms

$include library/scr/model_parameters.gms
$include library/scr/model_variables_equations.gms
