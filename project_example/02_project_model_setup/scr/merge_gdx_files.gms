* File:   %project%/00_base_model_setup/scr/trial_simulation.gms
* Author: Hettie Boonman
* Date:   31th Januari 2018
* Adjusted:

* gams-master-file: run_EXIOMOD.gms

$ontext startdoc

$offtext


* activate end of line comment and specify the activating character

$oneolcom
$eolcom #


* ========================== Include sets ======================================


* ==========================  Merge gdx files ==================================

* Merge gdx files

$call 'gdxmerge gdx\*.gdx o=gdx\merged_gdx\merged.gdx'

* ========================== Choose variables to drop to XLSX ==================
*$exit


Parameters
Y_time(*,regg,ind,year)
X_time(*,reg,prd,year)
INTER_USE_T_time(*,prd,regg,ind,year)
INTER_USE_M_time(*,prd,regg,ind,year)
INTER_USE_D_time(*,prd,regg,ind,year)
ioc_loop(*,prd,reg,ind,year)
P_time(*,reg,prd,year)
PY_time(*,regg,ind,year)
PIU_time(*,prd,regg,ind,year)
PIMP_T_time(*,prd,regg,year)
IMPORT_T_time(*,prd,regg,year)
PL_time(*,reg,year)
;

* Load parameters
$gdxin gdx\merged_gdx\merged.gdx

$load Y_time
$load X_time
$load INTER_USE_T_time
$load INTER_USE_D_time
$load INTER_USE_M_time
$load ioc_loop
$load P_time
$load PY_time
$load PIU_time
$load PIMP_T_time
$load IMPORT_T_time
$load PL_time


* =========================== export to XLSX ===================================
$libinclude xldump Y_time            %project%/03_simulation_results/output/Results.xlsx  Y_time!
$libinclude xldump X_time            %project%/03_simulation_results/output/Results.xlsx  X_time!
$libinclude xldump INTER_USE_T_time  %project%/03_simulation_results/output/Results.xlsx  INTER_USE_T_time!
$libinclude xldump INTER_USE_M_time  %project%/03_simulation_results/output/Results.xlsx  INTER_USE_M_time!
$libinclude xldump INTER_USE_D_time  %project%/03_simulation_results/output/Results.xlsx  INTER_USE_D_time!
$libinclude xldump P_time            %project%/03_simulation_results/output/Results.xlsx  P_time!
$libinclude xldump PY_time           %project%/03_simulation_results/output/Results.xlsx  PY_time!
$libinclude xldump PIU_time          %project%/03_simulation_results/output/Results.xlsx  PIU_time!
$libinclude xldump PIMP_T_time       %project%/03_simulation_results/output/Results.xlsx  PIMP_T_time!
$libinclude xldump IMPORT_T_time     %project%/03_simulation_results/output/Results.xlsx  IMPORT_T_time!
$libinclude xldump PL_time           %project%/03_simulation_results/output/Results.xlsx  PL_time!

