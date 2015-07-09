$ontext
File:   project_polfree\library_physical_extensions\scr\
        03-calculate-physical-coefficients.gms
Author: Jinxue Hu
Date:   6 May 2015

This script calculates physical coefficients based on the physical extensions
data and the monetary data from EXIOBASE version 2.2.0.

INPUTS
  LAND_model(reg,ind,land)      Land use
  DEU_model(reg,ind,deu)        Domestic extraction used
  UDE_model(reg,ind,ude)        Unused domestic extraction
  EMIS_model(reg,*,emis)        Emissions in kg for non ghg emissions and in
                                CO2-eq kg for ghg emissions
  WATER_model(reg,*,water)      Water use
  WATER_C_model(reg,*,water)    Water use (consumption)
  WATER_WD_model(reg,*,water)

  CONS_H_T(prd,reg)             household consumption on product level (volume)
  Y(regg,ind)                   output vector by activity (volume)
  INTER_USE_T(prd,regg,ind)     intermediate use on product level (volume)

OUTPUTS
  coef_land(reg,ind,land)       land use coefficient in km2 per mln euro
  coef_deu(reg,ind,deu)         domestic extraction used coefficient in kt per
                                mln euro
  coef_ude(reg,ind,ude)         unused domestic extraction coefficient in kt per
                                mln euro
  coef_emis(reg,*,emis)         emission coefficient in kg CO2-eq kg or I-TEQ kg
                                per mln euro
  coef_water(reg,*,water)       water use coefficient in Mm3 per mln euro
  coef_water_c(reg,*,water)     water (consumption) use coefficient in Mm3 per
                                mln euro
  coef_water_wd(reg,*,water)    water (withdrawal)  use coefficient in Mm3 per
                                mln euro

$offtext

$oneolcom
$eolcom #

* ****************** Correct emissions for sectors without output **************

Parameter
  emis_no_energy(reg,ind,emis)  sectors with emissions but without energy use
  emis_no_output(reg,ind,emis)  sectors with emissions but without output
  emis_scaling(reg,emis)        scale emissions of other sectors to compensate
;

emis_no_energy(reg,ind,emis)$
  (sum(energy, INTER_USE_T(energy,reg,ind) ) eq 0 )
    = EMIS_model(reg,ind,emis)  ;

emis_no_output(reg,ind,emis)$
  (Y(reg,ind) eq 0 )
    = EMIS_model(reg,ind,emis)  ;

emis_scaling(reg,"CO2_c")$
  sum(ind, emis_no_energy(reg,ind,"CO2_c") )
    = sum(ind, EMIS_model(reg,ind,"CO2_c") )
    / ( sum(ind, EMIS_model(reg,ind,"CO2_c") )
      - sum(ind, emis_no_energy(reg,ind,"CO2_c") ) ) ;

emis_scaling(reg,"CO2_nc")$
  sum(ind, emis_no_output(reg,ind,"CO2_nc") )
    = sum(ind, EMIS_model(reg,ind,"CO2_nc") )
    / ( sum(ind, EMIS_model(reg,ind,"CO2_nc") )
      - sum(ind, emis_no_output(reg,ind,"CO2_nc") ) ) ;

Display emis_no_energy, emis_no_output, emis_scaling ;

* Put combustion related CO2 emissions in sectors with energy use
EMIS_model(reg,ind,"CO2_c")$
  emis_no_energy(reg,ind,"CO2_c")
    = 0 ;

EMIS_model(reg,ind,"CO2_c")$
  sum(indd, emis_no_energy(reg,indd,"CO2_c"))
    = EMIS_model(reg,ind,"CO2_c") * emis_scaling(reg,"CO2_c") ;

* Put non combustion related CO2 emissions in sectors with output
EMIS_model(reg,ind,"CO2_nc")$
  emis_no_output(reg,ind,"CO2_nc")
    = 0 ;

EMIS_model(reg,ind,"CO2_nc")$
  sum(indd, emis_no_output(reg,indd,"CO2_nc"))
    = EMIS_model(reg,ind,"CO2_nc") * emis_scaling(reg,"CO2_nc") ;


* *************************** Estimate coefficients ****************************

Parameter
  coef_land(reg,ind,land)      land use coefficient in km2 per mln euro
  coef_deu(reg,ind,deu)        domestic extraction used in kt per mln euro
  coef_ude(reg,ind,ude)        unused domestic extraction in kt per mln euro
  coef_emis_c(reg,*,emis)      combustion related emissions in kg CO2-eq kg or
                               # I-TEQ kg per mln euro
  coef_emis_nc(reg,ind,emis)   non combustion related emission coefficient
  coef_water(reg,*,water)      water use in m3 per mln euro
  coef_water_c(reg,*,water)    water (consumption) use in m3 per mln euro
  coef_water_wd(reg,*,water)   water (withdrawal)  use in m3 per mln euro
;

coef_land(reg,ind,land)$
  Y(reg,ind)
    = LAND_model(reg,ind,land) / Y(reg,ind) ;

coef_deu(reg,ind,deu)$
  Y(reg,ind)
    = DEU_model(reg,ind,deu) / Y(reg,ind) ;

coef_ude(reg,ind,ude)$
  Y(reg,ind)
    = UDE_model(reg,ind,ude) / Y(reg,ind) ;

coef_emis_c(reg,ind,"CO2_c")$
  sum(energy, INTER_USE_T(energy,reg,ind) )
    = EMIS_model(reg,ind,"CO2_c") / sum(energy, INTER_USE_T(energy,reg,ind) ) ;

coef_emis_nc(reg,ind,"CO2_nc")$
  Y(reg,ind)
    = EMIS_model(reg,ind,"CO2_nc") / Y(reg,ind) ;

coef_emis_c(reg,fd,"CO2_c")$
  sum(energy, CONS_H_T(energy,reg) )
    = EMIS_model(reg,fd,"CO2_c") / sum(energy, CONS_H_T(energy,reg) ) ;

coef_water(reg,ind,water)$
  Y(reg,ind)
    = WATER_model(reg,ind,water) / Y(reg,ind) ;

coef_water(reg,fd,water)$
  sum(prd,CONS_H_T(prd,reg))
    = WATER_model(reg,fd,water) / sum(prd,CONS_H_T(prd,reg)) ;

coef_water_c(reg,ind,water)$
  Y(reg,ind)
    = WATER_C_model(reg,ind,water) / Y(reg,ind) ;

coef_water_c(reg,fd,water)$
  sum(prd,CONS_H_T(prd,reg))
    = WATER_C_model(reg,fd,water) / sum(prd,CONS_H_T(prd,reg)) ;

coef_water_wd(reg,ind,water)$
  Y(reg,ind)
    = WATER_WD_model(reg,ind,water) / Y(reg,ind) ;

coef_water_wd(reg,fd,water)$
  sum(prd,CONS_H_T(prd,reg))
    = WATER_WD_model(reg,fd,water) / sum(prd,CONS_H_T(prd,reg)) ;


Display coef_land, coef_deu, coef_emis_c, coef_emis_nc, coef_water, coef_water_c, coef_water_wd;

