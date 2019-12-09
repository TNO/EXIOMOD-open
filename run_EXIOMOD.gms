* File:   run_EXIOMOD.gms

$ontext startdoc
This file is the one to be used to run simulations from GAMS.
It is suggested to create a separate 'run_EXIOMOD' file for each simulation,
this will allow to exactly reproduce results from reports/presentations.
$offtext

$include configuration.gms

$ontext
Parameter
coprodB2(reg,prd,regg,ind)           Same as coprodB, so we don't change the
*                                     # actual coprodB table
end_result(reg,ind_elec,year)        What you want to replace in coprodB
coprodB2_loop(reg,prd,regg,ind,year)  Keep track of coprodB over the years
coprodB2_display(reg,ind_elec)
coprodB2_loop_display(reg,ind_elec,year)
Combine_coprod_WEO(reg,ind_elec,*)
year_par(year)
check_year(year)
elec_WEO_scaled(reg,ind_elec,year)
;


coprodB2_display(reg,ind_elec) =  coprodB(reg,"pELCC",reg,ind_elec)  ;
coprodB2(reg,prd,regg,ind) = coprodB(reg,prd,regg,ind) ;

coprodB2_loop(reg,prd,regg,ind,"2011") =  coprodB2(reg,prd,regg,ind)  ;
coprodB2_loop(reg,"pELCC",reg,ind_elec,"2016") =  elec_WEO_shares(reg,ind_elec,"2016")
    * sum((ind_elecc,reggg), coprodB(reg,"pELCC",reggg,ind_elecc) ) ;
coprodB2_loop_display(reg,ind_elec,"2011") = coprodB2_loop(reg,"pELCC",reg,ind_elec,"2011")  ;
coprodB2_loop_display(reg,ind_elec,"2016") = coprodB2_loop(reg,"pELCC",reg,ind_elec,"2016")  ;

loop(year$( ord(year) ge 2 and ord(year) le 5 ),
    year_par(year) = ord(year) ;

*Shock in coprodB
coprodB2(reg,"pELCC",reg,ind_elec)
    = ( year_par(year) - 1 ) / 5 * elec_WEO_shares(reg,ind_elec,"2016")
    * sum((ind_elecc,reggg), coprodB2(reg,"pELCC",reggg,ind_elecc) )
    + (5 - (year_par(year)-1) ) / 5 * coprodB2(reg,"pELCC",reg,ind_elec) ;
coprodB2_loop(reg,prd,regg,ind,year) =  coprodB2(reg,prd,regg,ind)  ;
coprodB2_loop_display(reg,ind_elec,year) = coprodB2_loop(reg,"pELCC",reg,ind_elec,year) ;
check_year(year) =  (year_par(year)-1) / 5 +  (5 - (year_par(year)-1) ) / 5 ;
elec_WEO_scaled(reg,ind_elec,year) = elec_WEO_shares(reg,ind_elec,"2016")
                                     * sum((ind_elecc,reggg), coprodB2(reg,"pELCC",reggg,ind_elecc) ) ;
);


*Combine_coprod_WEO(reg,ind_elec,"WEO") =
*end_result_display(reg,ind_elec) ;

*Combine_coprod_WEO(reg,ind_elec,"coprod") =
*coprodB2_display(reg,ind_elec) ;


Display
ind_elec
elec_WEO_shares
elec_WEO_scaled
coprodB2_loop_display
*end_result
*Combine_coprod_WEO
check_year
;

*Export coprodB and end_result to Excel
*$libinclude xldump Combine_coprod_WEO  project_open_entrance/03_simulation_results/output/Results.xlsx    Results!    ;
*$libinclude xldump Combine_coprod_WEO  project_open_entrance/03_simulation_results/output/Results.xlsx    Results!    ;
$offtext

Display
elec_WEO_data
elec_WEO_shares
;






* OPTION 1: run all the files for every simulation, using $include
* Include base model file
*$include EXIOMOD_base_model/scr/00_base_model_prepare.gms
*$exit
* Include file with extra simulation data
*$include %project%/00_base_model_setup/scr/trial_read_extradata.gms
*$exit
* Run simulation
$include %project%/00_base_model_setup/scr/trial_simulation.gms
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

