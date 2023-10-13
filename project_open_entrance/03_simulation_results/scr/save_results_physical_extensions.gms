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


* -------------- if we are dealing with CO2 efficiency -------------------------

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

* For CO2 emissions

EMIS_time(reg,ind,"CO2_nc",year)
        = ( coef_emis_nc_t('%OEscen%',reg,ind,"CO2_nc",year) * Y_time(reg,ind,year) )
         / 1000000 ;

EMIS_time(reg,ind,"CO2_c",year)
        = sum(ener_CO2,
        (coef_emis_c_t('%OEscen%',ener_CO2,reg,ind,"CO2_c",year)
            * INTER_USE_T_time(ener_CO2,reg,ind,year) ) )
         / 1000000 ;

EMIS_time(reg,"FCH","CO2_c",year)
        = sum(ener_CO2,
        ( coef_emis_c_t('%OEscen%',ener_CO2,reg,"FCH","CO2_c",year)
            * CONS_H_T_time(ener_CO2,reg,year) ) )
         / 1000000 ;

EMIS_time(reg,"FCG","CO2_c",year)
        = sum(ener_CO2,
        ( coef_emis_c_t('%OEscen%',ener_CO2,reg,"FCG","CO2_c",year)
            * CONS_G_T_time(ener_CO2,reg,year) ) )
         / 1000000 ;


