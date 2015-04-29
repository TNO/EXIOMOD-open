* File:   main.gms
* Author: Tatyana Bulavskaya
* Date:   29 April 2015

$include configuration.gms
$include library/scr/simulation_prepare_modules.gms
$include %project%/simulation/trial_CGE.gms

$exit
* Execute data-creation file
Execute "if not exist sp.g00 gams library/scr/simulation_prepare_modules.gms s=sp gdx=sp.gdx o=simulation_prepare_modules.lst lo=4 ide=1 pw=80 ps=0 --db_check=%db_check% --project=%project% --agg_check=%agg_check% --base_year=%base_year% --base_cur=%base_cur%"  ;

* Run simulation
Execute "gams %project%/simulation/trial_CGE.gms r=sp lo=4 ide=1 pw=80 ps=0 o=trial_CGE.lst lf=trial_CGE.log gdx=trial_CGE.gdx --project=%project% " ;
