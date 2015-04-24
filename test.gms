
$include configuration.gms

$include library/scr/sets_database.gms
$include library/scr/load_database.gms
$include library/scr/sets_model.gms
$include library/scr/aggregate_database.gms

$batinclude phase.gms additional_sets
$batinclude phase.gms parameters_declaration
$batinclude phase.gms parameters_calibration
$batinclude phase.gms equations_declaration
$batinclude phase.gms equations_definition
$batinclude phase.gms equations_bounds

$include library/scr/declare_model.gms

* Define options.
*Option iterlim   = 20000000 ;
Option iterlim   = 0 ;
Option decimals  = 7 ;
CGE_MCP.scaleopt = 1 ;

* Solve original model.
Solve CGE_MCP using MCP ;