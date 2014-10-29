* File:   main.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014

$ontext startdoc
 * Include `%simulation_setup%.gms`, where simulation setup, solve statement and
   post-processing of the results are defined. `%simulation%` is set within
   `configuration.gms`
$offtext

$include configuration.gms

$include library/scr/simulation_prepare.gms

* Run simulation.
*$include %project%/simulation/multipliers.gms
*$include %project%/simulation/final_demand_shock.gms
$include %project%/simulation/trial_CGE.gms
*$include %project%/simulation/check_KL_nest_formulation.gms
