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
Execute "if not exist 00_sp.g00 gams library/scr/00_simulation_prepare.gms s=00_sp gdx=00_sp.gdx o=00_simulation_prepare.lst lo=4 ide=1 pw=80 ps=0 --db_check=%db_check% --project=%project% --agg_check=%agg_check% --base_year=%base_year% --base_cur=%base_cur%"  ;

* Execute file with user data
Execute "if not exist lt.g00 gams %project%/00-principal/scr/read_labour_types_data.gms r=00_sp s=lt lo=4 ide=1 pw=80 ps=0 gdx=lt.gdx o=lt.lst lf=lt.log --project=%project%"  ;

* Run simulation
Execute "gams %project%/00-principal/scr/add_labour_types.gms r=lt lo=4 ide=1 pw=80 ps=0 o=add_labour_types.lst lf=add_labour_types.log gdx=add_hh_types.gdx --project=%project% " ;

