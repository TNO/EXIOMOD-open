* File:   run_EXIOMOD.gms

$ontext startdoc
This file is the one to be used to run simulations from GAMS.
It is suggested to create a separate 'run_EXIOMOD' file for each simulation,
this will allow to exactly reproduce results from reports/presentations.
$offtext

$include configuration.gms


* OPTION 1: run all the files for every simulation, using $include
* Include base model file
*$include %project%/00_base_model_setup/scr/00_base_model_prepare_OpenEntrance.gms
*$exit

* Include file with extra simulation data
*$include %project%/00_base_model_setup/scr/read_extradata.gms
*$exit

********************************************************************************
* Set for simulation (do not outcomment)

* Choose from:
* 00_test_CFC_GOS
* 01_BAU_loop_fprod
* 01_BAU_loop_fprod_new
* 01_BAU
* 01_BAU_new
* 02_test_H2
* 03_test_elecmix
* 04_CO2tax
* 05_BAU_mat_reduction
* 05_mat_reduction
* 05_mat_reduction_v2 --> test why prices go up



$if not set scenario      $setglobal      scenario   '05_mat_reduction_v2'

* Do you want to calculate and export results from footprint?
* footprint_y   (yes)
* footprint_n   (no)

$if not set footprint_yn      $setglobal      footprint_yn         'footprint_y'
********************************************************************************

* Run simulation
$include %project%/02_project_model_setup/scr/simulation_%scenario%.gms
$exit

$include %project%/02_project_model_setup/scr/merge_gdx_files.gms
$exit

* OPTION 2: use save and restarts, this allows to run the data-related codes
* only ones. Be aware that for this options you would need to manually define
* names of save, log and lst files, as well as explicitly pass the global
* variables into each execute statement
* Execute base model file
Execute "if not exist 00_base_model_prepare.g00 gams EXIOMOD_base_model/scr/00_base_model_prepare.gms s=00_base_model_prepare o=00_base_model_prepare.lst lf=00_base_model_prepare.log lo=4 ide=1 pw=80 ps=0 --db_check=%db_check% --project=%project% --prodfunc=%prodfunc% --demnfunc=%demnfunc% --agg_check=%agg_check% --base_year=%base_year% --base_cur=%base_cur%"  ;

* Execute file with extra simulation data
Execute "if not exist trial_extradata.g00 gams %project%/00_base_model_setup/scr/trial_read_extradata.gms r=00_base_model_prepare s=trial_extradata o=trial_extradata.lst lf=trial_extradata.log lo=4 ide=1 pw=80 ps=0 --project=%project%"  ;

* Run simulation
Execute "gams %project%/00_base_model_setup/scr/trial_simulation.gms r=trial_extradata o=trial_simulation.lst lf=trial_simulation.log lo=4 ide=1 pw=80 ps=0 --project=%project% --prodfunc=%prodfunc% --demnfunc=%demnfunc% " ;

