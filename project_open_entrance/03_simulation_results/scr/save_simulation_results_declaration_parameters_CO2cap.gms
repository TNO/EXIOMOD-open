* File:   project_COMPLEX/03_simulation_results/scr/save_simulation_results_declaration_parameters_CO2cap.gms
* Author: Jinxue Hu
* Date:   19 October 2015
* Adjusted: 14 April 2016

* Declaration of parameters for storing simulation results
*$oneolcom
*$eolcom #

Parameters
CO2_C_time(prd,regg,ind,year)   CO2 emissions by each industry in Mt
                                # includes both combustion and non-
                                # combustion activity)
CO2_NC_time(regg,ind,year)      CO2 emissions by each industry in Mt
                                # includes both combustion and non-
                                # combustion activity)
CO2REV_time(regg,year)          Revenue from carbon tax

CO2S_time(regg,year)            This is an exogenous variable: CO2 carbon
                                # budget
PCO2_time(regg,year)            Price for CO2
;
