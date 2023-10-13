$ontext
File:   03-calculate-physical-coefficients.gms
Author: Hettie Boonman (based on version of Jinxue Hu)
Date:   2 November 2017

This script calculates physical coefficients based on the physical extensions
data and the monetary data from EXIOBASE version 3.3.0.

INPUTS
  Materials_model(reg,*,mat,unit)  Materials (domestic extraction used, unused
                                     # domestic extraction, water use, nature in
                                     # kt, TJ and Mm3
  Resources_model(reg,*,res,unit)  Resources (land use) in km2;
  Emissions_model(reg,*,emis,unit) Emissions in kg CO2-equivalent

  CONS_H_T(prd,reg)             household consumption on product level (volume)
  Y(regg,ind)                   output vector by activity (volume)
  INTER_USE_T(prd,regg,ind)     intermediate use on product level (volume)

OUTPUTS
  coef_deu(reg,ind,deu)         domestic extraction used coefficient in kt per
                                mln euro
  coef_ude(reg,ind,ude)         unused domestic extraction coefficient in kt per
                                mln euro
  coef_water(reg,*,water)       water use coefficient in Mm3 per mln euro
  coef_land(reg,ind,land)       land use coefficient in km2 per mln euro
  coef_emis(reg,*,emis)         emission coefficient in kt CO2-eq kg or I-TEQ kg
                                per mln euro
$offtext

$oneolcom
$eolcom #

* ===================== Sets combustion vs non combustion ======================

sets
emis_c(emis)                    combustion emission types
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_emissions_model_combustion.txt
/

emis_nc(emis)                   non-combustion emission types
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_emissions_model_noncombustion.txt
/

ener_CO2(prd)                   energy nest for calculation emissions
/
$include %project%\00_base_model_setup\sets\products_model_energy_CO2.txt
/

;

* =============== Correct emissions for sectors without output ================

* Some sectors have emissions but no output. These emissions are proportionately
* distributed over the sectors that do have output.

Parameter
    emis_no_energy(reg,ind,emis)  sectors with emissions but without energy use
    emis_no_output(reg,ind,emis)  sectors with emissions but without output
    emis_scaling(reg,emis)        scale emissions of other sectors to compensate
;

emis_no_energy(reg,ind,emis)$
    (sum(ener_CO2, INTER_USE_T(ener_CO2,reg,ind) ) eq 0 )
        = Emissions_model(reg,ind,emis,'kg CO2-eq')  ;

emis_no_output(reg,ind,emis)$
    (Y(reg,ind) eq 0 )
        = Emissions_model(reg,ind,emis,'kg CO2-eq')  ;

emis_scaling(reg,emis_c)$
    sum(ind, emis_no_energy(reg,ind,emis_c) )
        = sum(ind, Emissions_model(reg,ind,emis_c,'kg CO2-eq') )
        / ( sum(ind, Emissions_model(reg,ind,emis_c,'kg CO2-eq') )
          - sum(ind, emis_no_energy(reg,ind,emis_c) ) ) ;

emis_scaling(reg,emis_nc)$
    sum(ind, emis_no_output(reg,ind,emis_nc) )
        = sum(ind,Emissions_model(reg,ind,emis_nc,'kg CO2-eq') )
        / ( sum(ind, Emissions_model(reg,ind,emis_nc,'kg CO2-eq') )
          - sum(ind, emis_no_output(reg,ind,emis_nc) ) ) ;

*Display emis_no_energy, emis_no_output, emis_scaling ;

* Put combustion related CO2 emissions in sectors with energy use
Emissions_model(reg,ind,emis_c,'kg CO2-eq')$
    emis_no_energy(reg,ind,emis_c)
        = 0 ;

Emissions_model(reg,ind,emis_c,'kg CO2-eq')$
    sum(indd, emis_no_energy(reg,indd,emis_c))
        = Emissions_model(reg,ind,emis_c,'kg CO2-eq')
          * emis_scaling(reg,emis_c) ;

* Put non combustion related CO2 emissions in sectors with output
Emissions_model(reg,ind,emis_nc,'kg CO2-eq')$
    emis_no_output(reg,ind,emis_nc)
        = 0 ;

Emissions_model(reg,ind,emis_nc,'kg CO2-eq')$
    sum(indd, emis_no_output(reg,indd,emis_nc))
        = Emissions_model(reg,ind,emis_nc,'kg CO2-eq')
          * emis_scaling(reg,emis_nc) ;

* Check if the sum is still the same
sum_emissions(emis) = 0;
sum_emissions(emis)
         = sum((reg,fd,unit),
                Emissions_model(reg,fd,emis,unit))
         + sum((reg,ind,unit),
                Emissions_model(reg,ind,emis,unit)) ;

Display sum_emissions;

* ==================== Estimate coefficients  ======================

Parameter
    coef_deu(reg,ind,deu)       domestic extraction used in kt per mln euro
    coef_ude(reg,ind,ude)       unused domestic extraction in kt per mln euro
    coef_water(reg,*,water)     water use in Mm3 per mln euro
    coef_land(reg,ind,res)      land use coefficient in km2 per mln euro
    coef_emis_c(reg,*,emis)     combustion related emissions in kt CO2-eq kg or
                                # I-TEQ kt per mln euro
    coef_emis_nc(reg,ind,emis)  non combustion related emission coefficient
;

coef_deu(reg,ind,deu)$
    Y(reg,ind)
        = Materials_model(reg,ind,deu,'kt') / Y(reg,ind) ;

coef_ude(reg,ind,ude)$
    Y(reg,ind)
        = Materials_model(reg,ind,ude,'kt') / Y(reg,ind) ;

coef_emis_c(reg,ind,emis_c)$
    sum(ener_CO2, INTER_USE_T(ener_CO2,reg,ind) )
        = Emissions_model(reg,ind,emis_c,'kg CO2-eq') / sum(ener_CO2, INTER_USE_T(ener_CO2,reg,ind) ) ;

coef_emis_c(reg,"FCH",emis_c)$
    sum(ener_CO2, CONS_H_T(ener_CO2,reg) )
        = Emissions_model(reg,"FCH",emis_c,'kg CO2-eq')
          / sum(ener_CO2, CONS_H_T(ener_CO2,reg) ) ;

coef_emis_c(reg,"FCG",emis_c)$
    sum(ener_CO2, CONS_G_T(ener_CO2,reg) )
        = Emissions_model(reg,"FCG",emis_c,'kg CO2-eq')
          / sum(ener_CO2, CONS_G_T(ener_CO2,reg) ) ;

coef_water(reg,ind,water)$
    Y(reg,ind)
        = Materials_model(reg,ind,water,'Mm3') / Y(reg,ind) ;

coef_water(reg,fd,water)$
    sum(prd,CONS_H_T(prd,reg))
        = Materials_model(reg,fd,water,'Mm3') / sum(prd,CONS_H_T(prd,reg)) ;

coef_land(reg,ind,res)$
    Y(reg,ind)
        = Resources_model(reg,ind,res,'Km2') / Y(reg,ind) ;

coef_emis_nc(reg,ind,emis_nc)$
    Y(reg,ind)
        = Emissions_model(reg,ind,emis_nc,'kg CO2-eq') / Y(reg,ind) ;

Display
    coef_deu
    coef_water
    coef_land
    coef_emis_c
    coef_emis_nc
;
