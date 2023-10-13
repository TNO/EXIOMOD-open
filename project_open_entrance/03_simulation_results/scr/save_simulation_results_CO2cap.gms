* File:   project_COMPLEX/03_simulation_results/scr/save_simulation_results.gms
* Author: Jinxue Hu
* Date:   19 October 2015
* Adjusted: 14 April 2016

* Store simulation results after each year in the simulation run


*Endogenous variables

*Complex specific parameters
CO2_C_time(prd,regg,ind,year) = CO2_C_V.L(prd,regg,ind) ;
CO2_NC_time(regg,ind,year)    = CO2_NC_V.L(regg,ind) ;
CO2REV_time(regg,year)        = CO2REV_V.L(regg) ;
CO2S_time(regg,year)          = CO2S_V.L(regg) ;
PCO2_time(regg,year)          = PCO2_V.L(regg) ;
