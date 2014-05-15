
$ontext
this is the main code, here we include all the sub-codes
$offtext

*select model type
$if not set io_type      $set   io_type   product_technology
*$if not set io_type      $set   io_type   industry_technology

$include scr/sets_database.gms
$include scr/load_database.gms

$include scr/sets_model.gms
$include scr/aggregate_database.gms

$include scr/model_parameters.gms
$include scr/model_variables_equations.gms

$include scr/simulation_multipliers.gms
*$include scr/simulation_shock.gms

execute "del scr\*.~gm"