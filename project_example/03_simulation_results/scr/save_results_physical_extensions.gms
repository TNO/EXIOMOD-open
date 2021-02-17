$ontext
File:   save_results_physical_extensions.gms
Author: Jinxue Hu
Date:   23 November 2017

This file estimates the EXIOBASE physical extensions using the simulation results.
$offtext

* ********************** Estimate results physical indicators ******************

Parameter
    DEU_time(reg,ind,deu,year)      domestic extraction used in kt
    UDE_time(reg,ind,ude,year)      unused domestic extraction in kt
    WATER_time(reg,*,water,year)    water use in Mm3
    LAND_time(reg,ind,res,year)     land use coefficient in km2
    EMIS_time(reg,*,emis,year)      emissions in kt CO2-eq or I-TEQ kt

;
DEU_time(reg,ind,deu,year)
        = coef_deu(reg,ind,deu) * Y_time(reg,ind,year)
        / 1000000 ;

UDE_time(reg,ind,ude,year)
        = coef_ude(reg,ind,ude) * Y_time(reg,ind,year)
        / 1000000 ;

WATER_time(reg,ind,water,year)
        = coef_water(reg,ind,water) * Y_time(reg,ind,year)
        / 1000000 ;

WATER_time(reg,"FCH",water,year)
        = coef_water(reg,"FCH",water) * sum(prd,CONS_H_T_time(prd,reg,year))
        / 1000000  ;

LAND_time(reg,ind,res,year)
        = coef_land(reg,ind,res) * Y_time(reg,ind,year) ;

EMIS_time(reg,ind,emis,year)
        = (coef_emis_c_year(reg,ind,emis,year) * sum(ener_CO2, INTER_USE_T_time(ener_CO2,reg,ind,year) )
         + coef_emis_nc_year(reg,ind,emis,year) * Y_time(reg,ind,year) )
         / 1000000 ;

EMIS_time(reg,"FCH",emis,year)
        = coef_emis_c_year(reg,"FCH",emis,year)  * sum(ener_CO2, CONS_H_T_time(ener_CO2,reg,year) )
         / 1000000 ;

EMIS_time(reg,"FCG",emis,year)
        = coef_emis_c_year(reg,"FCG",emis,year)  * sum(ener_CO2, CONS_G_T_time(ener_CO2,reg,year) )
         / 1000000 ;

Display
    DEU_time
    UDE_time
    WATER_time
    LAND_time
    EMIS_time
;
