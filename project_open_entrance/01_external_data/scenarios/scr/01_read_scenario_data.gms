
$ontext

File:   01-read-ref-data.gms
Author: Hettie Boonman
Date:   17-12-2019

This script reads in template data from the EU reference scenario.


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "elec"        electricity (TWh)

    2. Data source (should be the same as name of the library)
    "_ref"        EU reference database database

    3. Extension "_orig" is added to indicate that it is not processed

Example of resulting parameter: elec_ref_orig


INPUTS
    %project%\library_ref\data\data_template.xlsx

OUTPUTS
    elec_ref_orig(reg_ref, source_ref, year_ref)     ref electricity mix in
                                                     original classification
    elec_ref_perc(reg_ref,source_ref,year_ref)       percentage change in
                                                     electricity mix

$offtext

$oneolcom
$eolcom #
* ============================ Declaration of sets =============================

sets

    reg_sce         list of regions in scenarios data
/
$include %project%\01_external_data\scenarios\sets\country_scenario.txt
/

    ind_sce         list of industries in scenarios data
/
$include %project%\01_external_data\scenarios\sets\industry_scenario.txt
/

    prd_sce         list of products in scenarios data
/
$include %project%\01_external_data\scenarios\sets\product_scenario.txt
/

    year_sce        list of years in scenarios data
/
$include %project%\01_external_data\scenarios\sets\year_scenario.txt
/

    sce_sce        list of years in scenarios data
/
$include %project%\01_external_data\scenarios\sets\scenario_scenario.txt
/

;

* ================================ Load data ===================================

Parameters

* EU reference scenario
    REF_CO2budget_data(reg_sce,*)                     CO2 budget in 2050 in %
                                                      # wrt 2007

* Gradual development
    GD_techmix_data(*,*,reg_OE,var_OE,*,year_OE,*)    Technology mix in %
    GD_CO2budget_data(reg_sce,*)                      CO2 budget in 2050 in %
                                                      # wrt 2007
    GD_POP_data(reg_sce,year_sce)                     POP growth wrt 2007
    GD_POP_ROW_data(reg,year)                         POP growth wrt 2011 for
                                                      # ROW regions
    GD_GDP_data(reg_sce,year_sce)                     GDP growth wrt 2007
    GD_GDP_ROW_data(reg,year)                         POP growth wrt 2011 for
                                                      # ROW regions
    GD_mat_red_data(reg,year)                         Reduction in materials
                                                      # (index, 2011=100)
    GD_ener_eff_data(reg,year)                        Energy efficiency index
                                                      # (index, 2007 = 1)
    GD_energy_prices_WEO_data(*,year)                 Energy prices from WEO2020
                                                      # for crude oil ($/barrel),
                                                      # gas($/MBtu), steam coal
                                                      # ($/tonne)
    GD_ener_use_tran_data(*,*,reg_OE,var_OE,*,year_OE,*)    # Energy use in EJ/yr
                                                            # for transport sector
    GD_ener_use_ind_data(*,*,reg_OE,var_OE,*,year_OE,*)     # Energy use in EJ/yr
                                                            # for industries
    GD_ener_use_hh_serv_data(*,*,reg_OE,var_OE,*,year_OE,*) # Energy use in EJ/yr
                                                            # for hh and services

* Directed transition
    DT_techmix_data(*,*,reg_OE,var_OE,*,year_OE,*)    Technology mix in %
    DT_CO2budget_data(reg_sce,*)                      CO2 budget in 2050 in %
                                                      # wrt 2007
    DT_POP_data(reg_sce,year_sce)                     POP growth wrt 2007
    DT_POP_ROW_data(reg,year)                         POP growth wrt 2011 for
                                                      # ROW regions
    DT_GDP_data(reg_sce,year_sce)                     GDP growth wrt 2007
    DT_GDP_ROW_data(reg,year)                         POP growth wrt 2011 for
                                                      # ROW regions
    DT_mat_red_data(reg,year)                         Reduction in materials
                                                      # (index, 2011=100)
    DT_ener_eff_data(reg,year)                        Energy efficiency index
                                                      # (index, 2007 = 1)
    DT_energy_prices_WEO_data(*,year)                 Energy prices from WEO2020
                                                      # for crude oil ($/barrel),
                                                      # gas($/MBtu), steam coal
                                                      # ($/tonne)
    DT_ener_use_tran_data(*,*,reg_OE,var_OE,*,year_OE,*)    # Energy use in EJ/yr
                                                            # for transport sector
    DT_ener_use_ind_data(*,*,reg_OE,var_OE,*,year_OE,*)     # Energy use in EJ/yr
                                                            # for industries
    DT_ener_use_hh_serv_data(*,*,reg_OE,var_OE,*,year_OE,*) # Energy use in EJ/yr
                                                            # for hh and services

* Societal commitment
    SC_techmix_data(*,*,reg_OE,var_OE,*,year_OE,*)    Technology mix in %
    SC_CO2budget_data(reg_sce,*)                      CO2 budget in 2050 in %
                                                      # wrt 2007
    SC_POP_data(reg_sce,year_sce)                     POP growth wrt 2007
    SC_POP_ROW_data(reg,year)                         POP growth wrt 2011 for
                                                      # ROW regions
    SC_GDP_data(reg_sce,year_sce)                     GDP growth wrt 2007
    SC_GDP_ROW_data(reg,year)                         POP growth wrt 2011 for
                                                      # ROW regions
    SC_mat_red_data(reg,year)                         Reduction in materials
                                                      # (index, 2011=100)
    SC_ener_eff_data(reg,year)                        Energy efficiency index
                                                      # (index, 2007 = 1)
    SC_energy_prices_WEO_data(*,year)                 Energy prices from WEO2020
                                                      # for crude oil ($/barrel),
                                                      # gas($/MBtu), steam coal
                                                      # ($/tonne)
    SC_ener_use_tran_data(*,*,reg_OE,var_OE,*,year_OE,*)    # Energy use in EJ/yr
                                                            # for transport sector
    SC_ener_use_ind_data(*,*,reg_OE,var_OE,*,year_OE,*)     # Energy use in EJ/yr
                                                            # for industries
    SC_ener_use_hh_serv_data(*,*,reg_OE,var_OE,*,year_OE,*) # Energy use in EJ/yr
                                                            # for hh and services

* Techno friendly
    TF_techmix_data(*,*,reg_OE,var_OE,*,year_OE,*)    Technology mix in %
    TF_CO2budget_data(reg_sce,*)                      CO2 budget in 2050 in %
                                                      # wrt 2007
    TF_POP_data(reg_sce,year_sce)                     POP growth wrt 2007
    TF_POP_ROW_data(reg,year)                         POP growth wrt 2011 for
                                                      # ROW regions
    TF_GDP_data(reg_sce,year_sce)                     GDP growth wrt 2007
    TF_GDP_ROW_data(reg,year)                         POP growth wrt 2011 for
                                                      # ROW regions
    TF_mat_red_data(reg,year)                         Reduction in materials
                                                      # (index, 2011=100)
    TF_ener_eff_data(reg,year)                        Energy efficiency index
                                                      # (index, 2007 = 1)
    TF_energy_prices_WEO_data(*,year)                 Energy prices from WEO2020
                                                      # for crude oil ($/barrel),
                                                      # gas($/MBtu), steam coal
                                                      # ($/tonne)
    TF_ener_use_tran_data(*,*,reg_OE,var_OE,*,year_OE,*)    # Energy use in EJ/yr
                                                            # for transport sector
    TF_ener_use_ind_data(*,*,reg_OE,var_OE,*,year_OE,*)     # Energy use in EJ/yr
                                                            # for industries
    TF_ener_use_hh_serv_data(*,*,reg_OE,var_OE,*,year_OE,*) # Energy use in EJ/yr
                                                            # for hh and services

;

* Reference
$libinclude xlimport REF_CO2budget_data         %project%\01_external_data\scenarios\data\Scenario_input_communication_fileREF_TNO.xlsx    CO2budget!A3:B10000

* Gradual development
$libinclude xlimport GD_techmix_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    techmix_v2!A1:G1498
$libinclude xlimport GD_CO2budget_data          %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    CO2budget!A3:B10000
$libinclude xlimport GD_POP_data                %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    Population!A3:K34
$libinclude xlimport GD_POP_ROW_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    POP_ROW!A2:AO4
$libinclude xlimport GD_GDP_data                %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    GDP!A3:K34
$libinclude xlimport GD_GDP_ROW_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    GDP_ROW!A2:AO4
$libinclude xlimport GD_mat_red_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    Materials!A3:AO33
$libinclude xlimport GD_ener_eff_data           %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    Energy_efficiency!A1:AO31
$libinclude xlimport GD_energy_prices_WEO_data  %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    oil_price!A36:AO39
$libinclude xlimport GD_ener_use_tran_data      %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    energy_use_transport!A1:G777
$libinclude xlimport GD_ener_use_ind_data       %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    energy_use_industries!A1:G1216
$libinclude xlimport GD_ener_use_hh_serv_data   %project%\01_external_data\scenarios\data\Scenario_input_communication_fileGD_TNO.xlsx    energy_use_hh_and_serv!A1:G1158


* Directed transition
$libinclude xlimport DT_techmix_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    techmix_v2!A1:G1498
$libinclude xlimport DT_CO2budget_data          %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    CO2budget!A3:B10000
$libinclude xlimport DT_POP_data                %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    Population!A3:K34
$libinclude xlimport DT_POP_ROW_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    POP_ROW!A2:AO4
$libinclude xlimport DT_GDP_data                %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    GDP!A3:K34
$libinclude xlimport DT_GDP_ROW_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    GDP_ROW!A2:AO4
$libinclude xlimport DT_mat_red_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    Materials!A3:AO33
$libinclude xlimport DT_ener_eff_data           %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    Energy_efficiency!A1:AO31
$libinclude xlimport DT_energy_prices_WEO_data  %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    oil_price!A36:AO39
$libinclude xlimport DT_ener_use_tran_data      %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    energy_use_transport!A1:G777
$libinclude xlimport DT_ener_use_ind_data       %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    energy_use_industries!A1:G1216
$libinclude xlimport DT_ener_use_hh_serv_data   %project%\01_external_data\scenarios\data\Scenario_input_communication_fileDT_TNO.xlsx    energy_use_hh_and_serv!A1:G1158


* Societal commitment
$libinclude xlimport SC_techmix_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    techmix_v2!A1:G1498
$libinclude xlimport SC_CO2budget_data          %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    CO2budget!A3:B10000
$libinclude xlimport SC_POP_data                %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    Population!A3:K34
$libinclude xlimport SC_POP_ROW_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    POP_ROW!A2:AO4
$libinclude xlimport SC_GDP_data                %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    GDP!A3:K34
$libinclude xlimport SC_GDP_ROW_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    GDP_ROW!A2:AO4
$libinclude xlimport SC_mat_red_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    Materials!A3:AO33
$libinclude xlimport SC_ener_eff_data           %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    Energy_efficiency!A1:AO31
$libinclude xlimport SC_energy_prices_WEO_data  %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    oil_price!A36:AO39
$libinclude xlimport SC_ener_use_tran_data      %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    energy_use_transport!A1:G777
$libinclude xlimport SC_ener_use_ind_data       %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    energy_use_industries!A1:G1216
$libinclude xlimport SC_ener_use_hh_serv_data   %project%\01_external_data\scenarios\data\Scenario_input_communication_fileSC_TNO.xlsx    energy_use_hh_and_serv!A1:G1158


* Techno-friendly
$libinclude xlimport TF_techmix_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    techmix_v2!A1:G1498
$libinclude xlimport TF_CO2budget_data          %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    CO2budget!A3:B10000
$libinclude xlimport TF_POP_data                %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    Population!A3:K34
$libinclude xlimport TF_POP_ROW_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    POP_ROW!A2:AO4
$libinclude xlimport TF_GDP_data                %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    GDP!A3:K34
$libinclude xlimport TF_GDP_ROW_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    GDP_ROW!A2:AO4
$libinclude xlimport TF_mat_red_data            %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    Materials!A3:AO33
$libinclude xlimport TF_ener_eff_data           %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    Energy_efficiency!A1:AO31
$libinclude xlimport TF_energy_prices_WEO_data  %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    oil_price!A36:AO39
$libinclude xlimport TF_ener_use_tran_data      %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    energy_use_transport!A1:G777
$libinclude xlimport TF_ener_use_ind_data       %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    energy_use_industries!A1:G1216
$libinclude xlimport TF_ener_use_hh_serv_data   %project%\01_external_data\scenarios\data\Scenario_input_communication_fileTF_TNO.xlsx    energy_use_hh_and_serv!A1:G1158

* ============== place all data in one data parameter ==========================


Parameters

    techmix_data(sce_sce,*,*,reg_OE,var_OE,*,year_OE,*)    Technology mix in %
    CO2budget_data(sce_sce,reg_sce,*)                      CO2 budget in 2050 in %
                                                           # wrt 2007
    POP_data(sce_sce,reg_sce,year_sce)                     POP growth wrt 2007
    POP_ROW_data(sce_sce,reg,year)                         POP growth wrt 2011 for
                                                           # ROW regions
    GDP_data(sce_sce,reg_sce,year_sce)                     GDP growth wrt 2007
    GDP_ROW_data(sce_sce,reg,year)                         POP growth wrt 2011 for
                                                           # ROW regions
    mat_red_data(sce_sce,reg,year)                         Reduction in materials
                                                           # (index, 2011=100)
    ener_eff_data(sce_sce,reg,year)                        Energy efficiency index
                                                           # (index, 2007 = 1)
    energy_prices_WEO_data(sce_sce,*,year)                 Energy prices from WEO2020
                                                           # for crude oil ($/barrel),
                                                           # gas($/MBtu), steam coal
                                                           # ($/tonne)
    ener_use_tran_data(sce_sce,*,*,reg_OE,var_OE,*,year_OE,*)   # Energy use in EJ/yr
                                                                # for transport sector
    ener_use_ind_data(sce_sce,*,*,reg_OE,var_OE,*,year_OE,*)    # Energy use in EJ/yr
                                                                # for industries
    ener_use_hh_serv_data(sce_sce,*,*,reg_OE,var_OE,*,year_OE,*) # Energy use in EJ/yr
                                                                 # for hh and services


;

* Gradual development
CO2budget_data('GD',reg_sce,'CO2budgetperc')
    = GD_CO2budget_data(reg_sce,'CO2budgetperc') ;
techmix_data('GD','GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = GD_techmix_data('GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
POP_data('GD',reg_sce,year_sce)
    = GD_POP_data(reg_sce,year_sce) ;
POP_ROW_data('GD',reg,year)
    = GD_POP_ROW_data(reg,year) ;
GDP_data('GD',reg_sce,year_sce)
    = GD_GDP_data(reg_sce,year_sce) ;
GDP_ROW_data('GD',reg,year)
    = GD_GDP_ROW_data(reg,year) ;
mat_red_data('GD',reg,year)
    = GD_mat_red_data(reg,year);
ener_eff_data('GD',reg,year)
    = GD_ener_eff_data(reg,year) ;
energy_prices_WEO_data('GD','EU - crude oil',year)
    = GD_energy_prices_WEO_data('EU - crude oil',year) ;
ener_use_tran_data('GD','GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = GD_ener_use_tran_data('GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
ener_use_ind_data('GD','GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = GD_ener_use_ind_data('GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
ener_use_hh_serv_data('GD','GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = GD_ener_use_hh_serv_data('GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;


* Reference
CO2budget_data('REF',reg_sce,'CO2budgetperc')
    = REF_CO2budget_data(reg_sce,'CO2budgetperc') ;
techmix_data('REF','GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = GD_techmix_data('GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
POP_data('REF',reg_sce,year_sce)
    = GD_POP_data(reg_sce,year_sce) ;
POP_ROW_data('REF',reg,year)
    = GD_POP_ROW_data(reg,year) ;
GDP_data('REF',reg_sce,year_sce)
    = GD_GDP_data(reg_sce,year_sce) ;
GDP_ROW_data('REF',reg,year)
    = GD_GDP_ROW_data(reg,year) ;
* mat_red_data('REF',reg,year) does not exist
ener_eff_data('REF',reg,year)
    = GD_ener_eff_data(reg,year) ;
energy_prices_WEO_data('REF','EU - crude oil',year)
    = GD_energy_prices_WEO_data('EU - crude oil',year) ;
ener_use_tran_data('REF','GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = GD_ener_use_tran_data('GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
ener_use_ind_data('REF','GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = GD_ener_use_ind_data('GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
ener_use_hh_serv_data('REF','GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = GD_ener_use_hh_serv_data('GENeSYS-MOD2.9','GradualDevelopment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;




* Directed transition
CO2budget_data('DT',reg_sce,'CO2budgetperc')
    = DT_CO2budget_data(reg_sce,'CO2budgetperc') ;
techmix_data('DT','GENeSYS-MOD2.9','DirectedTransition1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = DT_techmix_data('GENeSYS-MOD2.9','DirectedTransition1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
POP_data('DT',reg_sce,year_sce)
    = DT_POP_data(reg_sce,year_sce) ;
POP_ROW_data('DT',reg,year)
    = DT_POP_ROW_data(reg,year) ;
GDP_data('DT',reg_sce,year_sce)
    = DT_GDP_data(reg_sce,year_sce) ;
GDP_ROW_data('DT',reg,year)
    = DT_GDP_ROW_data(reg,year) ;
mat_red_data('DT',reg,year)
    = DT_mat_red_data(reg,year);
ener_eff_data('DT',reg,year)
    = DT_ener_eff_data(reg,year) ;
energy_prices_WEO_data('DT','EU - crude oil',year)
    = DT_energy_prices_WEO_data('EU - crude oil',year) ;
ener_use_tran_data('DT','GENeSYS-MOD2.9','DirectedTransition1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = DT_ener_use_tran_data('GENeSYS-MOD2.9','DirectedTransition1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
ener_use_ind_data('DT','GENeSYS-MOD2.9','DirectedTransition1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = DT_ener_use_ind_data('GENeSYS-MOD2.9','DirectedTransition1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
ener_use_hh_serv_data('DT','GENeSYS-MOD2.9','DirectedTransition1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = DT_ener_use_hh_serv_data('GENeSYS-MOD2.9','DirectedTransition1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;


* Societal commitment
CO2budget_data('SC',reg_sce,'CO2budgetperc')
    = SC_CO2budget_data(reg_sce,'CO2budgetperc') ;
techmix_data('SC','GENeSYS-MOD2.9','SocietalCommitment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = SC_techmix_data('GENeSYS-MOD2.9','SocietalCommitment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
POP_data('SC',reg_sce,year_sce)
    = SC_POP_data(reg_sce,year_sce) ;
POP_ROW_data('SC',reg,year)
    = SC_POP_ROW_data(reg,year) ;
GDP_data('SC',reg_sce,year_sce)
    = SC_GDP_data(reg_sce,year_sce) ;
GDP_ROW_data('SC',reg,year)
    = SC_GDP_ROW_data(reg,year) ;
mat_red_data('SC',reg,year)
    = SC_mat_red_data(reg,year);
ener_eff_data('SC',reg,year)
    = SC_ener_eff_data(reg,year) ;
energy_prices_WEO_data('SC','EU - crude oil',year)
    = SC_energy_prices_WEO_data('EU - crude oil',year) ;
ener_use_tran_data('SC','GENeSYS-MOD2.9','SocietalCommitment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = SC_ener_use_tran_data('GENeSYS-MOD2.9','SocietalCommitment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
ener_use_ind_data('SC','GENeSYS-MOD2.9','SocietalCommitment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = SC_ener_use_ind_data('GENeSYS-MOD2.9','SocietalCommitment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
ener_use_hh_serv_data('SC','GENeSYS-MOD2.9','SocietalCommitment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = SC_ener_use_hh_serv_data('GENeSYS-MOD2.9','SocietalCommitment1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;

* Techno friendly
CO2budget_data('TF',reg_sce,'CO2budgetperc')
    = TF_CO2budget_data(reg_sce,'CO2budgetperc') ;
techmix_data('TF','GENeSYS-MOD2.9','Techno-Friendly1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = TF_techmix_data('GENeSYS-MOD2.9','Techno-Friendly1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
POP_data('TF',reg_sce,year_sce)
    = TF_POP_data(reg_sce,year_sce) ;
POP_ROW_data('TF',reg,year)
    = TF_POP_ROW_data(reg,year) ;
GDP_data('TF',reg_sce,year_sce)
    = TF_GDP_data(reg_sce,year_sce) ;
GDP_ROW_data('TF',reg,year)
    = TF_GDP_ROW_data(reg,year) ;
mat_red_data('TF',reg,year)
    = TF_mat_red_data(reg,year);
ener_eff_data('TF',reg,year)
    = TF_ener_eff_data(reg,year) ;
energy_prices_WEO_data('TF','EU - crude oil',year)
    = TF_energy_prices_WEO_data('EU - crude oil',year) ;
ener_use_tran_data('TF','GENeSYS-MOD2.9','Techno-Friendly1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = TF_ener_use_tran_data('GENeSYS-MOD2.9','Techno-Friendly1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
ener_use_ind_data('TF','GENeSYS-MOD2.9','Techno-Friendly1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = TF_ener_use_ind_data('GENeSYS-MOD2.9','Techno-Friendly1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
ener_use_hh_serv_data('TF','GENeSYS-MOD2.9','Techno-Friendly1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value')
    = TF_ener_use_hh_serv_data('GENeSYS-MOD2.9','Techno-Friendly1.0',reg_OE,var_OE,'EJ/yr',year_OE,'value') ;
