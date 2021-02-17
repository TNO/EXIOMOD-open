$ontext
File:   02-aggregate-EXIOBASE-physical_extensions-data.gms
Author: Hettie Boonman (based on version of Jinue Hu)
Date:   2 November 2017

This script aggregates the data from the EXIOBASE physical extensions
database version 3.3 year 2011.

INPUTS
Emission_data(reg_ext,col_ext,emis_ext,air_water,unit)   Emission data (in kg of kg-eq)
Resource_data(reg_ext,col_ext,res_ext,air_water,unit)    Resource data (land in km2)
Material_data(reg_ext,col_ext,mat_ext,unit)              Material data (kt TJ and MM3)

OUTPUTS

  Materials_model(reg,*,mat,unit)  Materials (domestic extraction used, unused
                                   # domestic extraction, water use, nature in
                                   # kt, TJ and Mm3
  Resources_model(reg,*,res,unit)  Resources (land use) in km2;
  Emissions_model(reg,*,emis,unit) Emissions in kg CO2-equivalent

$offtext

$oneolcom
$eolcom #

* Sets model

Sets

mat                           Material types
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_deu_model.txt
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_ude_model.txt
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_nature_model.txt
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_water_cons_model.txt
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_water_wd_model.txt
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_emissions_model.txt
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_land_model.txt
/

deu(mat)                           domestic extraction types
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_deu_model.txt
/

ude(mat)                           unused domestic extraction types
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_ude_model.txt
/

nature(mat)                        Nature inputs and energy carriers
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_nature_model.txt
/

water(mat)                         type of water use
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_water_cons_model.txt
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_water_wd_model.txt
/

water_c(mat)                type of water use (consumption)
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_water_cons_model.txt
/

water_wd(mat)               type of water use (withdrawal)
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_water_wd_model.txt
/

emis                          emission types
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_emissions_model.txt
/

res                           land use types
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_land_model.txt
/

unit                          unit types
/
$include %project%/01_external_data/physical_extensions_2011/sets/model/physical_unit_model.txt
/

sets
reg_ext_aggr(reg_ext,reg_data)           aggregation scheme for regions in
                                         # physical extensions
/
$include %project%/01_external_data/physical_extensions_2011/sets/aggregation/physical_regions_extensions_to_data.txt
/

col_ext_aggr(col_ext,full_cat_list)      aggregation scheme for industries and
                                         # final demand categories in physical
                                         # extensions
/
$include %project%/01_external_data/physical_extensions_2011/sets/aggregation/physical_industries_extensions_to_data.txt
/

unit_ext_aggr(unit_ext,unit)             aggregation scheme for units (mostly kg
                                         #to kg CO2-eq)
/
$include %project%/01_external_data/physical_extensions_2011/sets/aggregation/physical_unit_extensions_to_model.txt
/

;

* Aggregation to database sets.
Parameters
res_aggr(res_ext,res)
mat_aggr(mat_ext,mat)
emis_aggr(emis_ext,emis)
;

$libinclude xlimport res_aggr   %project%/01_external_data/physical_extensions_2011/sets/aggregation/physical_extensions_to_model_2011.xlsx   Resources!c4..f18 ;
$libinclude xlimport mat_aggr   %project%/01_external_data/physical_extensions_2011/sets/aggregation/physical_extensions_to_model_2011.xlsx   Materials!c4..aa871 ;
$libinclude xlimport emis_aggr  %project%/01_external_data/physical_extensions_2011/sets/aggregation/physical_extensions_to_model_2011.xlsx   Emissions!d4..o421 ;
Display emis_aggr;


Parameter
    map_emissec_check(emis_ext)      Check whether each emission is mapped
    Materials_model(reg,*,mat,unit)  Materials (domestic extraction used, unused
                                     # domestic extraction, water use, nature in
                                     # kt, TJ and Mm3
    Resources_model(reg,*,res,unit)  Resources (land use) in km2
    Emissions_model(reg,*,emis,unit) Emissions in kg CO2-equivalent
;


map_emissec_check(emis_ext)$
    (sum(emis,emis_aggr(emis_ext,emis)) eq 0
    and sum((reg_ext,col_ext,air_water,unit_ext),Emission_data(reg_ext,col_ext,emis_ext,air_water,unit_ext)) )
        = 1 ;
Display map_emissec_check ;

Loop(emis_ext, if(map_emissec_check(emis_ext), abort "correct missing GWP values" ) ; ) ;


Materials_model(reg,ind,mat,unit)
= sum(mat_ext$mat_aggr(mat_ext,mat),
      sum(ind_data$ind_aggr(ind_data,ind),
          sum(col_ext$col_ext_aggr(col_ext,ind_data),
              sum(reg_data$all_reg_aggr(reg_data,reg),
                  sum(reg_ext$reg_ext_aggr(reg_ext,reg_data),
                      sum(unit_ext$unit_ext_aggr(unit_ext,unit),
                    Material_data(reg_ext,col_ext,mat_ext,unit_ext)
      ) ) ) ) ) ) ;

Materials_model(reg,fd,mat,unit)
= sum(mat_ext$mat_aggr(mat_ext,mat),
      sum(fd_data$fd_aggr(fd_data,fd),
          sum(col_ext$col_ext_aggr(col_ext,fd_data),
              sum(reg_data$all_reg_aggr(reg_data,reg),
                  sum(reg_ext$reg_ext_aggr(reg_ext,reg_data),
                      sum(unit_ext$unit_ext_aggr(unit_ext,unit),
                    Material_data(reg_ext,col_ext,mat_ext,unit_ext)
      ) ) ) ) ) ) ;

Resources_model(reg,ind,res,unit)
= sum(res_ext$res_aggr(res_ext,res),
      sum(ind_data$ind_aggr(ind_data,ind),
          sum(col_ext$col_ext_aggr(col_ext,ind_data),
              sum(reg_data$all_reg_aggr(reg_data,reg),
                  sum(reg_ext$reg_ext_aggr(reg_ext,reg_data),
                      sum(unit_ext$unit_ext_aggr(unit_ext,unit),
                          sum(air_water,
                    Resource_data(reg_ext,col_ext,res_ext,air_water,unit_ext)
      ) ) ) ) ) ) ) ;

Resources_model(reg,fd,res,unit)
= sum(res_ext$res_aggr(res_ext,res),
      sum(fd_data$fd_aggr(fd_data,fd),
          sum(col_ext$col_ext_aggr(col_ext,fd_data),
              sum(reg_data$all_reg_aggr(reg_data,reg),
                  sum(reg_ext$reg_ext_aggr(reg_ext,reg_data),
                      sum(unit_ext$unit_ext_aggr(unit_ext,unit),
                          sum(air_water,
                    Resource_data(reg_ext,col_ext,res_ext,air_water,unit_ext)
      ) ) ) ) ) ) ) ;


Emissions_model(reg,ind,emis,unit)
= sum(emis_ext$emis_aggr(emis_ext,emis),
      sum(ind_data$ind_aggr(ind_data,ind),
          sum(col_ext$col_ext_aggr(col_ext,ind_data),
              sum(reg_data$all_reg_aggr(reg_data,reg),
                  sum(reg_ext$reg_ext_aggr(reg_ext,reg_data),
                      sum(unit_ext$unit_ext_aggr(unit_ext,unit),
                          sum(air_water,
                    Emission_data(reg_ext,col_ext,emis_ext,air_water,unit_ext)
                    * emis_aggr(emis_ext,emis)
      ) ) ) ) ) ) ) ;

Emissions_model(reg,fd,emis,unit)
= sum(emis_ext$emis_aggr(emis_ext,emis),
      sum(fd_data$fd_aggr(fd_data,fd),
          sum(col_ext$col_ext_aggr(col_ext,fd_data),
              sum(reg_data$all_reg_aggr(reg_data,reg),
                  sum(reg_ext$reg_ext_aggr(reg_ext,reg_data),
                      sum(unit_ext$unit_ext_aggr(unit_ext,unit),
                          sum(air_water,
                    Emission_data(reg_ext,col_ext,emis_ext,air_water,unit_ext)
                    * emis_aggr(emis_ext,emis)
      ) ) ) ) ) ) ) ;


Display Materials_model, Resources_model, Emissions_model;

* Check that total emissions before and after aggregation are equal
* Notice that before units were in kg, now in CO2 equivalents. This impacts for
* example CH4.
Parameter
sum_emissions_ext(emis_ext)
sum_emissions(emis)
;

sum_emissions_ext(emis_ext)
         = sum((reg_ext,col_ext,air_water,unit_ext),
                 Emission_data(reg_ext,col_ext,emis_ext,air_water,unit_ext)) ;

sum_emissions(emis)
         = sum((reg,fd,unit),
                Emissions_model(reg,fd,emis,unit))
         + sum((reg,ind,unit),
                Emissions_model(reg,ind,emis,unit)) ;

Display sum_emissions_ext, sum_emissions;

