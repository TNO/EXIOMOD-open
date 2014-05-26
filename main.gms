
*' main.gms
*' author: Tatyana Bulavskaya
*' date: 14 May 2014

$ontext
This is the 'main.gms' code for the core input-output model. The code consists
of the following parts:
 - Include 'configuration.gms', where some key parameters relevant for data,
   model and simulation choices are set.
 - Include 'sets_database.gms', where sets used in the database are declared.
 - Include 'load_database.gms', where external input-output/supply-use database
   is loaded.
 - Include 'sets_model.gms', where sets used in the model are declared and their
   relations for the sets in the database are defined.
 - Include 'aggregate_database.gms', where the database is aggregated to the
   dimensions of the model, identified in 'sets_model.gms'.
 - Include 'model_parameters.gms', where key parameters of input-output model
   are defined.
 - Include 'model_variables_equations.gms', where variables, equations and the
   model itself are defined.
 - Include '%simulation_setup%.gms', where simulation setup, solve statement and
   post-processing of the results are defined. %simulation% is set within
   'configuration.gms'
 - Clear up possible temporary files produced by GAMS
More specific explanation of each of the included part of the script can be
found in the corresponding .gms file. These explanation blocks include which
inputs are necessary for the scripts to run and which changes are possible
$offtext

$include configuration.gms

$include scr/sets_database.gms
$include scr/load_database.gms

$include scr/sets_model.gms
$include scr/aggregate_database.gms

$include scr/model_parameters.gms
$include scr/model_variables_equations.gms

$include scr/simulation/%simulation_setup%.gms

execute "del scr\*.~gm"
