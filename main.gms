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
*Execute "gams library/scr/simulation_prepare.gms s=sp1 lo=4 gdx=sp.gdx o=sp.lst lf=sp.log ide=1 --db_check=%db_check% --project=%project% --agg_check=%agg_check% --base_year=%base_year% --base_cur=%base_cur%"  ;

Execute "if not exist sp.g00 gams library/scr/simulation_prepare.gms s=sp lo=4 ide=1 gdx=sp.gdx o=sp.lst lf=sp.log --db_check=%db_check% --project=%project% --agg_check=%agg_check% --base_year=%base_year% --base_cur=%base_cur%"  ;

* Execute file with data supplied by the user

Execute "if not exist ud.g00 %project%/simulation/user_data.gms gams %project%/simulation/user_data.gms r=sp s=ud lo=4 ide=1 gdx=ud.gdx o=ud.lst lf=ud.log --project=%project%"  ;

*Execute "gams %project%/simulation/user_data.gms r=sp s=ud lo=4 gdx=ud.gdx o=ud.lst lf=ud.log ide=1 --project=%project%"  ;


* Run simulation.
*$include %project%/simulation/multipliers.gms
*$include %project%/simulation/final_demand_shock.gms
*$include %project%/simulation/trial_CGE.gms
*Execute "gams %project%/simulation/trial_CGE.gms r=sp2 lo=3 gdx=./%project%/results/trial_CGE%base_year%.gdx --project=%project% " ;
Execute "gams %project%/simulation/add_hh_types.gms r=ud lo=4 ide=1 o=hh_types.lst gdx=./%project%/results/add_hh_types%base_year%.gdx --project=%project% " ;
*
*check out this one:
*$include %project%/simulation/check_KL_nest_formulation.gms

