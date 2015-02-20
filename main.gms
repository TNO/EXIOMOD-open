* File:   main.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014

$ontext startdoc
 * Include `%simulation_setup%.gms`, where simulation setup, solve statement and
   post-processing of the results are defined. `%simulation%` is set within
   `configuration.gms`
$offtext

$include configuration.gms

* Execute data-creation file
Execute "gams library/scr/simulation_prepare.gms s=sp gdx=sp.gdx lo=3 --db_check=%db_check% --project=%project% --agg_check=%agg_check% --base_year=%base_year% --base_cur=%base_cur%"  ;

*Execute "if not exist sp.g00 gams library/scr/simulation_prepare.gms s=sp gdx=sp.gdx lo=2 --db_check=%db_check% --project=%project% --agg_check=%agg_check% --base_year=%base_year% --base_cur=%base_cur%"  ;

* Run simulation.
*$include %project%/simulation/multipliers.gms
*$include %project%/simulation/final_demand_shock.gms
*$include %project%/simulation/trial_CGE.gms
Execute "gams %project%/simulation/trial_CGE.gms r=sp lo=3 gdx=.%project%\results\trial_CGE%base_year%.gdx --db_check=%db_check% --project=%project% --agg_check=%agg_check% --base_year=%base_year% --base_cur=%base_cur%" ;

*$include %project%/simulation/check_KL_nest_formulation.gms
