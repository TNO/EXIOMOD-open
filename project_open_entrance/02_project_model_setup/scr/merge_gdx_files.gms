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
    scen_OE     scenarios
/
$include %project%\02_project_model_setup\sets\scenario_OE.txt
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
INTER_USE_T_time(*,prd,regg,ind,year)
P_time(*,reg,prd,year)
PY_time(*,regg,ind,year)
PIU_time(*,prd,regg,ind,year)
PIMP_T_time(*,prd,regg,year)
IMPORT_T_time(*,prd,regg,year)
PL_time(*,reg,year)
CO2S_time(*,regg,year)
CO2REV_time(*,regg,year)
CO2_C_time(*,prd,regg,ind,year)
CO2_NC_time(*,regg,ind,year)
PCO2_time(*,regg,year)
L_time(*,reg,regg,ind,year)
K_time(*,reg,regg,ind,year)
ENER_time(*,ener,regg,ind,year)
PnENER_time(*,regg,ind,year)
EMIS_time(*,reg,*,emis,year)
GDPCONST_time(*,regg,year)
CONS_H_T_time(*,prd,regg,year)
CONS_G_T_time(*,prd,regg,year)
LASPEYRES_time(*,regg,year)
;

* Load parameters
$gdxin gdx\merged_gdx\merged.gdx

$load Y_time
$load X_time
$load INTER_USE_T_time
$load P_time
$load PY_time
$load PIU_time
$load PIMP_T_time
$load IMPORT_T_time
$load L_time
$load K_time
$load PL_time
$load CO2S_time
$load CO2REV_time
$load CO2_C_time
$load CO2_NC_time
$load PCO2_time
$load ENER_time
$load PnENER_time
$load EMIS_time
$load GDPCONST_time
$load CONS_H_T_time
$load CONS_G_T_time
$load LASPEYRES_time


* =================== Create data in values rather than volumes ================

parameters
    X_VAL_time(scen_OE,reg,prd,year)
    Y_VAL_time(scen_OE,reg,ind,year)
;

X_VAL_time(scen_OE,reg,prd,year)
    = X_time(scen_OE,reg,prd,year) * P_time(scen_OE,reg,prd,year) ;

Y_VAL_time(scen_OE,reg,ind,year)
    = Y_time(scen_OE,reg,ind,year) * PY_time(scen_OE,reg,ind,year) ;


* ========================== Total HH Consumption per region ===================

Parameters
    TOT_CONS_H_T_time(scen_OE,regg,year)
;


TOT_CONS_H_T_time(scen_OE,regg,year)
    = sum(prd, CONS_H_T_time(scen_OE,prd,regg,year) ) ;

* ========================== create results in indices =========================

Parameters
    Y_index(scen_OE,regg,ind,year,*)
    P_index(scen_OE,reg,prd,year,*)
    PY_index(scen_OE,regg,ind,year,*)
    L_index(scen_OE,reg,regg,ind,year,*)
    PL_index(scen_OE,reg,year,*)
    ENER_index(scen_OE,ener,regg,ind,year,*)
    PnENER_index(scen_OE,regg,ind,year,*)
    CO2S_index(scen_OE,regg,year,*)
    CO2REV_index(scen_OE,regg,year,*)
    CO2_C_index(scen_OE,prd,regg,ind,year,*)
    PCO2_value(scen_OE,regg,year,*)
    EMIS_index(scen_OE,reg,*,emis,year,*)
    GDPCONST_index(scen_OE,regg,year,*)
    TOT_CONS_H_T_index(scen_OE,regg,year,*)
    LASPEYRES_index(scen_OE,regg,year,*)
;


Y_index(scen_OE,regg,ind,year,'value')$Y_time(scen_OE,regg,ind,'2011')
        = Y_time(scen_OE,regg,ind,year)/ Y_time(scen_OE,regg,ind,'2011') ;

P_index(scen_OE,reg,prd,year,'value')
        = P_time(scen_OE,reg,prd,year) ;

PY_index(scen_OE,regg,ind,year,'value')
        = PY_time(scen_OE,regg,ind,year) ;

L_index(scen_OE,reg,regg,ind,year,'value')$L_time(scen_OE,reg,regg,ind,'2011')
        = L_time(scen_OE,reg,regg,ind,year)/ L_time(scen_OE,reg,regg,ind,'2011');

PL_index(scen_OE,reg,year,'value')
    = PL_time(scen_OE,reg,year);

ENER_index(scen_OE,ener,regg,ind,year,'value')$ENER_time(scen_OE,ener,regg,ind,'2011')
    = ENER_time(scen_OE,ener,regg,ind,year)/ ENER_time(scen_OE,ener,regg,ind,'2011');

PnENER_index(scen_OE,regg,ind,year,'value')
    = PnENER_time(scen_OE,regg,ind,year);

CO2S_index(scen_OE,regg,year,'value')$CO2S_time(scen_OE,regg,'2011')
    = CO2S_time(scen_OE,regg,year)/ CO2S_time(scen_OE,regg,'2011');

CO2REV_index(scen_OE,regg,year,'value')$CO2REV_time(scen_OE,regg,'2011')
    = CO2REV_time(scen_OE,regg,year)/ CO2REV_time(scen_OE,regg,'2011') ;

CO2_C_index(scen_OE,prd,regg,ind,year,'value')$CO2_C_time(scen_OE,prd,regg,ind,'2011')
    = CO2_C_time(scen_OE,prd,regg,ind,year)/CO2_C_time(scen_OE,prd,regg,ind,'2011');

PCO2_value(scen_OE,regg,year,'value')
    = PCO2_time(scen_OE,regg,year);

EMIS_index(scen_OE,reg,ind,emis,year,'value')$EMIS_time(scen_OE,reg,ind,emis,'2011')
    = EMIS_time(scen_OE,reg,ind,emis,year)/EMIS_time(scen_OE,reg,ind,emis,'2011');

GDPCONST_index(scen_OE,regg,year,'value')$GDPCONST_time(scen_OE,regg,'2011')
    = GDPCONST_time(scen_OE,regg,year)/GDPCONST_time(scen_OE,regg,'2011');

TOT_CONS_H_T_index(scen_OE,regg,year,'value')$TOT_CONS_H_T_time(scen_OE,regg,'2011')
    = TOT_CONS_H_T_time(scen_OE,regg,year) / TOT_CONS_H_T_time(scen_OE,regg,'2011') ;

LASPEYRES_index(scen_OE,regg,year,'value')
    = LASPEYRES_time(scen_OE,regg,year) ;

Display
    Y_index
    P_index
    PY_index
    L_index
    PL_index
    ENER_index
    PnENER_index
    CO2S_index
    CO2REV_index
    CO2_C_index
    PCO2_value
    EMIS_index
    GDPCONST_index
;

* ========================== HH + GOV Consumption per region ===================

Parameters
    CONS_H_G_T_time(scen_OE,prd,regg,year)
;


CONS_H_G_T_time(scen_OE,prd,regg,year)
    = CONS_H_T_time(scen_OE,prd,regg,year)
        + CONS_G_T_time(scen_OE,prd,regg,year)  ;

* ========================== create results in same format as REMES ============

sets

    reg_REMES         list of regions in REMES data
/
$include %project%\03_simulation_results\sets\regions_REMES.txt
/

    ind_REMES         list of industries in REMES data
/
$include %project%\03_simulation_results\sets\industries_REMES.txt
/

    prd_REMES         list of products in REMES data
/
$include %project%\03_simulation_results\sets\products_REMES.txt
/

    year_REMES         list of years in REMES data
/
$include %project%\03_simulation_results\sets\years_REMES.txt
/

    reg_aggr_REMES(reg,reg_REMES)         aggregation of regions to REMES
/
$include %project%\03_simulation_results\sets\aggregation\regions_exiomod_to_remes.txt
/

    ind_aggr_REMES(ind,ind_REMES)         aggregation of industries to REMES
/
$include %project%\03_simulation_results\sets\aggregation\industries_exiomod_to_remes.txt
/

    prd_aggr_REMES(prd,prd_REMES)         aggregation of products to REMES
/
$include %project%\03_simulation_results\sets\aggregation\products_exiomod_to_remes.txt
/

    year_aggr_REMES(year,year_REMES)         aggregation of years to REMES
/
$include %project%\03_simulation_results\sets\aggregation\years_exiomod_to_remes.txt
/

;

alias
    (reg_REMES,regg_REMES)
    (prd_REMES,prdd_REMES)
    (ind_REMES,indd_REMES)
;


Parameters
    Y_remes(scen_OE,regg_REMES,ind_REMES,year_REMES,*)
    PCO2_remes(scen_OE,regg_REMES,year_REMES,*)
    GDPCONST_remes(scen_OE,regg_remes,year_remes,*)
    TOT_CONS_H_T_remes(scen_OE,regg_remes,year_remes,*)
    LASPEYRES_remes(scen_OE,regg_remes,year_remes,*)
;

Y_remes(scen_OE,regg_REMES,ind_REMES,year_REMES,'value')
    = sum(regg$reg_aggr_REMES(regg,regg_REMES),
        sum(ind$ind_aggr_REMES(ind,ind_REMES),
                sum(year$year_aggr_REMES(year,year_REMES),
      Y_index(scen_OE,regg,ind,year,'value')
) ) );


* Multiply by 1000 to have prices in euro/tonnes
PCO2_remes(scen_OE,regg_REMES,year_REMES,'value')
    = sum(regg$reg_aggr_REMES(regg,regg_REMES),
                sum(year$year_aggr_REMES(year,year_REMES),
      PCO2_value(scen_OE,regg,year,'value')*1000
) );

GDPCONST_remes(scen_OE,regg_REMES,year_REMES,'value')
    = sum(regg$reg_aggr_REMES(regg,regg_REMES),
                sum(year$year_aggr_REMES(year,year_REMES),
      GDPCONST_index(scen_OE,regg,year,'value')
) );

TOT_CONS_H_T_remes(scen_OE,regg_REMES,year_REMES,'value')
    = sum(regg$reg_aggr_REMES(regg,regg_REMES),
                sum(year$year_aggr_REMES(year,year_REMES),
      TOT_CONS_H_T_index(scen_OE,regg,year,'value')
) );

LASPEYRES_remes(scen_OE,regg_REMES,year_REMES,'value')
    = sum(regg$reg_aggr_REMES(regg,regg_REMES),
                sum(year$year_aggr_REMES(year,year_REMES),
      LASPEYRES_index(scen_OE,regg,year,'value')
) );


Display
    Y_remes
    PCO2_remes
    GDPCONST_remes
    TOT_CONS_H_T_remes
    LASPEYRES_remes
;

* =========================== export to XLSX ===================================
$ontext
* For PAOLO*
$libinclude xldump Y_remes              %project%/03_simulation_results/output/Results_paolo.xlsx  Y_remes!
$libinclude xldump PCO2_remes           %project%/03_simulation_results/output/Results_paolo.xlsx  PCO2_remes!
$libinclude xldump GDPCONST_remes       %project%/03_simulation_results/output/Results_paolo.xlsx  GDPCONST_remes!
$libinclude xldump TOT_CONS_H_T_remes   %project%/03_simulation_results/output/Results_paolo.xlsx  TOT_CONS_H_T_remes!
$libinclude xldump LASPEYRES_remes      %project%/03_simulation_results/output/Results_paolo.xlsx  LASPEYRES_remes!
$offtext

*$ontext
* For our own analysis
$libinclude xldump Y_VAL_time           %project%/03_simulation_results/output/Results.xlsx  Y_VAL_time!
$libinclude xldump X_VAL_time           %project%/03_simulation_results/output/Results.xlsx  X_VAL_time!
$libinclude xldump Y_time               %project%/03_simulation_results/output/Results.xlsx  Y_time!
$libinclude xldump X_time               %project%/03_simulation_results/output/Results.xlsx  X_time!
$libinclude xldump INTER_USE_T_time     %project%/03_simulation_results/output/Results.xlsx  INTER_USE_T_time!
$libinclude xldump ENER_time            %project%/03_simulation_results/output/Results.xlsx  ENER_time!
$libinclude xldump CONS_H_T_time        %project%/03_simulation_results/output/Results.xlsx  CONS_H_T_time!
$libinclude xldump LASPEYRES_time       %project%/03_simulation_results/output/Results.xlsx  LASPEYRES_time!
$libinclude xldump CO2_C_time           %project%/03_simulation_results/output/Results.xlsx  CO2_C_time!
$libinclude xldump CO2_NC_time          %project%/03_simulation_results/output/Results.xlsx  CO2_NC_time!
$libinclude xldump CO2S_time            %project%/03_simulation_results/output/Results.xlsx  CO2S_time!
$libinclude xldump PCO2_time            %project%/03_simulation_results/output/Results.xlsx  PCO2_time!
$libinclude xldump EMIS_time            %project%/03_simulation_results/output/Results.xlsx  EMIS_time!
$libinclude xldump L_time               %project%/03_simulation_results/output/Results.xlsx  L_time!
$libinclude xldump GDPCONST_time        %project%/03_simulation_results/output/Results.xlsx  GDPCONST_time!
$libinclude xldump K_time               %project%/03_simulation_results/output/Results.xlsx  K_time!
$libinclude xldump CONS_H_G_T_time      %project%/03_simulation_results/output/Results.xlsx  CONS_H_G_T_time!
$libinclude xldump P_time               %project%/03_simulation_results/output/Results.xlsx  P_time!
*$offtext

$ontext
$libinclude xldump Y_time               %project%/03_simulation_results/output/Results_per_subscenario.xlsx  Y_time!
$libinclude xldump X_time               %project%/03_simulation_results/output/Results_per_subscenario.xlsx  X_time!
$libinclude xldump INTER_USE_T_time     %project%/03_simulation_results/output/Results_per_subscenario.xlsx  INTER_USE_T_time!
$libinclude xldump ENER_time            %project%/03_simulation_results/output/Results_per_subscenario.xlsx  ENER_time!
$libinclude xldump LASPEYRES_time       %project%/03_simulation_results/output/Results_per_subscenario.xlsx  LASPEYRES_time!
$libinclude xldump CO2S_time            %project%/03_simulation_results/output/Results_per_subscenario.xlsx  CO2S_time!
$libinclude xldump PCO2_time            %project%/03_simulation_results/output/Results_per_subscenario.xlsx  PCO2_time!
$libinclude xldump EMIS_time            %project%/03_simulation_results/output/Results_per_subscenario.xlsx  EMIS_time!
$libinclude xldump GDPCONST_time        %project%/03_simulation_results/output/Results_per_subscenario.xlsx  GDPCONST_time!
$libinclude xldump CONS_H_G_T_time      %project%/03_simulation_results/output/Results_per_subscenario.xlsx  CONS_H_G_T_time!
$offtext


$if not '%footprint_yn%' == 'footprint_y' $goto end_merge_gdx_files

**** nothing here yet.

$label end_merge_gdx_files

