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
Sets
*    scen_PR     list of years in cepii data
*/
*$include %project%\02_project_model_setup\sets\scenario_CICERONE.txt
*/

    multiplier_type             Type of the multipliers to be calculated
/
    output_intrareg             'Intra-regional output multipliers'
    output_interreg             'Inter-regional output multipliers'
    output_global               'Global output multipliers'
    RMC_global                  'Global material use multipliers'
    biomass_global              'Global material use of biomass multipliers'
    wood_global                 'Global material use of wood multipliers'
    metal_global                'Global material use of metal multipliers'
    minerals_global             'Global material use of minerals multipliers'
    fuels_global                'Global material use of fuels multipliers'
    water_global
    WCG_agri
    WCB_agri
    WCB_manu
    WCB_elec
    WCB_dom
    WWB_manu
    WWB_elec
    WWB_dom
    'Arable land'
    'Used forest land and wood fuel'
    land_global
    CO2_c
    CO2_nc
    CH4_c
    CH4_nc
    N2O_c
    N2O_nc
    SOX_c
    SOX_nc
    NOX_c
    NOX_nc
    NH3
/



;

* ==========================  Merge gdx files ==================================

* Merge gdx files

$call 'gdxmerge gdx\*.gdx o=gdx\merged_gdx\merged.gdx'

* ========================== Choose variables to drop to XLSX ==================
*$exit


Parameters
Y_time(*,regg,ind,year)
X_time(*,reg,prd,year)
CONS_H_T_time(*,prd,regg,year)
L_time(*,reg,regg,ind,year)
INTER_USE_T_time(*,prd,regg,ind,year)
GDPCONST_time(*,regg,year)        GDP in constant prices (volume)
value_added_time(*,regg,ind,year)
ioc_loop(*,prd,reg,ind,year)
coprodB_loop(*,reg,prd,regg,ind,year)
FINAL_USE_time(*,reg,prd,reg,year)
TRADE_time(*,reg,prd,regg,year)
PXI_time(*,reg,year)
P_time(*,reg,prd,year)

* Footprint analysis
Y_year(*,reg,ind,year)
DEU_year(*,reg,ind,deu,year)
FINAL_USE_year(*,reg,prd,reg,year)
multipliers_year(*,reg,prd,multiplier_type,year)
Y_cons(*,reg,prd,year)
DEU_time(*,reg,ind,*,year)
RMC_cons(*,reg,prd,*,year)
EMIS_cons(*,reg,prd,*,year)
water_cons(*,reg,prd,*,year)
land_cons(*,reg,prd,*,year)
water_year(*,reg,ind,water,year)
land_year(*,reg,ind,res,year)
emis_time(*,reg,*,emis,year)

;

* Load parameters
$gdxin gdx\merged_gdx\merged.gdx

$load Y_time
$load X_time
$load CONS_H_T_time
$load L_time
$load INTER_USE_T_time
$load GDPCONST_time
$load value_added_time
*$load ioc_loop
$load FINAL_USE_time
$load TRADE_time
*$load PXI_time
$load P_time

* Footprint analysis
*$load Y_year
*$load DEU_year
*$load FINAL_USE_year
*$load multipliers_year
*$load Y_cons
*$load DEU_time
*$load RMC_cons
*$load EMIS_cons
*$load water_cons
*$load land_cons
*$load water_year
*$load land_year
*$load emis_time




* =========================== export to XLSX ===================================

$libinclude xldump Y_time            %project%/03_simulation_results/output/Results.xlsx  Y_time!
$libinclude xldump X_time            %project%/03_simulation_results/output/Results.xlsx  X_time!
$libinclude xldump CONS_H_T_time     %project%/03_simulation_results/output/Results.xlsx  CONS_H_T_time!
$libinclude xldump L_time            %project%/03_simulation_results/output/Results.xlsx  L_time!
$libinclude xldump INTER_USE_T_time  %project%/03_simulation_results/output/Results.xlsx  INTER_USE_T_time!
$libinclude xldump GDPCONST_time     %project%/03_simulation_results/output/Results.xlsx  GDPCONST_time!
$libinclude xldump value_added_time  %project%/03_simulation_results/output/Results.xlsx  value_added_time!
*$libinclude xldump ioc_loop          %project%/03_simulation_results/output/Results.xlsx  ioc_loop!
$libinclude xldump FINAL_USE_time    %project%/03_simulation_results/output/Results.xlsx  FINAL_USE_time!
$libinclude xldump TRADE_time        %project%/03_simulation_results/output/Results.xlsx  TRADE_time!
*$libinclude xldump PXI_time          %project%/03_simulation_results/output/Results.xlsx  PXI_time!
$libinclude xldump P_time            %project%/03_simulation_results/output/Results.xlsx  P_time!

$if not '%footprint_yn%' == 'footprint_y' $goto end_merge_gdx_files

*$libinclude xldump Y_year           %project%/03_simulation_results/output/Results.xlsx    Yprod_year!
*$libinclude xldump FINAL_USE_year   %project%/03_simulation_results/output/Results.xlsx    FD_year!
*$libinclude xldump multipliers_year %project%/03_simulation_results/output/Results.xlsx    multipliers_year!
*$libinclude xldump Y_cons           %project%/03_simulation_results/output/Results.xlsx    Ycons_year!
*$libinclude xldump EMIS_cons        %project%/03_simulation_results/output/Results.xlsx    EMIScons_year!
*$libinclude xldump emis_time        %project%/03_simulation_results/output/Results.xlsx    emis_time!
*$libinclude xldump DEU_time         %project%/03_simulation_results/output/Results.xlsx    DEU_time!
*$libinclude xldump RMC_cons         %project%/03_simulation_results/output/Results.xlsx    RMC_cons!

$label end_merge_gdx_files
