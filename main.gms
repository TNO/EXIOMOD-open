* File:   main.gms

$ontext startdoc
This file is the one to be used to run simulations from GAMS.
It is suggested to create a separate 'main' file for each simulation, this will
allow to exactly reproduce results from reports/presentations.
$offtext

$include configuration.gms

* OPTION 1: run all the files for every simulation, using $include
* Include base model file
*$include EXIOMOD_base_model/scr/00_simulation_prepare.gms

* Include file with extra simulation data
*$include %project%/00-principal/scr/trial_read_extradata.gms

* Run simulation
*$include %project%/00-principal/scr/trial_simulation.gms
*$exit

* OPTION 2: use save and restarts, this allows to run the data-related codes
* only ones. Be aware that for this options you would need to manually define
* names of save, log and lst files, as well as explicitly pass the global
* variables into each execute statement
* Execute base model file
Execute "if not exist 00_simulation_prepare.g00 gams EXIOMOD_base_model/scr/00_simulation_prepare.gms s=00_simulation_prepare o=00_simulation_prepare.lst lf=00_simulation_prepare.log lo=4 ide=1 pw=80 ps=0 --db_check=%db_check% --project=%project% --prodfunc=%prodfunc% --demnfunc=%demnfunc% --agg_check=%agg_check% --base_year=%base_year% --base_cur=%base_cur%"  ;

* Execute file with extra simulation data
Execute "if not exist trial_extradata.g00 gams %project%/00-principal/scr/trial_read_extradata.gms r=00_simulation_prepare s=trial_extradata o=trial_extradata.lst lf=trial_extradata.log lo=4 ide=1 pw=80 ps=0 --project=%project%"  ;

* Run simulation
Execute "gams %project%/00-principal/scr/trial_simulation.gms r=trial_extradata o=trial_simulation.lst lf=trial_simulation.log lo=4 ide=1 pw=80 ps=0 --project=%project% " ;

