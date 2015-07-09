$ontext
File:   02-aggregate-EXIOBASE-physical_extensions-data.gms
Author: Jinxue Hu
Date:   16 March 2015

This script reads aggregates the data from the EXIOBASE physical extensions 
database version 2.2.0.

INPUTS
  DOMESTIC_EXTRACTION_USED_data(reg_ext,deu_ext,col_ext)    domestic extraction used in kt
  UNUSED_DOMESTIC_EXTRACTION_data(reg_ext,ude_ext,col_ext)  unused domestic extraction in kt
  EMISSIONS_data(reg_ext,emis_ext,col_ext)                  emissions in kg CO2-eq kg or I-TEQ kg
  LAND_USE_data(reg_ext,land_ext,col_ext)                   land use in km2
  WATER_USE_data(reg_ext,water_ext,col_ext)                 water use in Mm3

OUTPUTS
  LAND_model(reg,ind,land)            Land use
  DEU_model(reg,ind,deu)              Domestic extraction used
  UDE_model(reg,ind,ude)              Unused domestic extraction
  EMIS_model(reg,*,emis)              Emissions in kg for non ghg emissions and in 
                                      CO2-eq kg for ghg emissions
  WATER_model(reg,*,water)            Water use
  WATER_C_model(reg,*,water)          Water use (consumption)
  WATER_WD_model(reg,*,water)         Water use (withdrawal)

$offtext

$oneolcom
$eolcom #

* Sets model

Sets

deu                           domestic extraction types
/
$include %project%/library_physical_extensions/sets/model/physical_deu_model.txt
/

ude                           unused domestic extraction types
/
$include %project%/library_physical_extensions/sets/model/physical_ude_model.txt
/

emis                          emission types
/
$include %project%/library_physical_extensions/sets/model/physical_emissions_model.txt
/

land                          land use types
/
$include %project%/library_physical_extensions/sets/model/physical_land_model.txt
/

water                         type of water use
/
$include %project%/library_physical_extensions/sets/model/physical_water_cons_model.txt
$include %project%/library_physical_extensions/sets/model/physical_water_wd_model.txt
/

water_c(water)                type of water use (consumption)
/
$include %project%/library_physical_extensions/sets/model/physical_water_cons_model.txt
/

water_wd(water)               type of water use (withdrawal)
/
$include %project%/library_physical_extensions/sets/model/physical_water_wd_model.txt
/

col_agg
/
$include %project%/library_physical_extensions/sets/model/physical_industries_aggregated.txt
/



* Aggregation to database sets.

deu_aggr(deu_ext,deu)         aggregation scheme for domestic extraction types
/
$include %project%/library_physical_extensions/sets/aggregation/physical_deu_extensions_to_model.txt
/

ude_aggr(ude_ext,ude)         aggregation scheme for unused domestic extraction 
                              # types
/
$include %project%/library_physical_extensions/sets/aggregation/physical_ude_extensions_to_model.txt
/
;

Parameter
emis_aggr(emis_ext,emis)      aggregation scheme for  emission types
;
$libinclude xlimport emis_aggr  %project%/library_physical_extensions/sets/aggregation/physical_extensions_to_model.xlsx EMIS!b1:f171 ;

Sets
land_aggr(land_ext,land)      aggregation scheme for  land use types
/
$include %project%/library_physical_extensions/sets/aggregation/physical_land_extensions_to_model.txt
/

water_aggr(water_ext,water)   aggregation scheme for type of water use
/
$include %project%/library_physical_extensions/sets/aggregation/physical_water_extensions_to_model.txt
/
;

Parameter
col_ext_aggr(col_ext,col_agg) aggregation scheme for industries and final demand 
                              # categories in physical extensions
;
$libinclude xlimport col_ext_aggr  %project%\library_physical_extensions\sets\aggregation\industries_extensions_to_database.xlsx GROUPSc_use!d2:bs172 ;

Sets
col_ext_model(col_agg,*)      aggregation scheme for industries and final demand
                              # categories in physical extensions
/
$include %project%/library_physical_extensions/sets/aggregation/physical_industries_aggregated_to_model.txt
/

reg_ext_aggr(reg_ext,reg)     aggregation scheme for regions in physical 
                              # extensions
/
$include %project%/library_physical_extensions/sets/aggregation/physical_regions_extensions_to_model.txt
/
;

Display  col_ext_aggr
         col_ext_model
         land_aggr
         deu_aggr
         ude_aggr
         water_aggr
;

Parameter
  map_emissec_check(emis_ext)   Check whether each emission is mapped
  LAND_model(reg,ind,land)      Land use
  DEU_model(reg,ind,deu)        Domestic extraction used
  UDE_model(reg,ind,ude)        Unused domestic extraction
  EMIS_model(reg,*,emis)        Emissions in kg for non ghg emissions and in 
                                # CO2-eq kg for ghg emissions
  WATER_model(reg,*,water)      Water use
  WATER_C_model(reg,*,water)    Water use (consumption)
  WATER_WD_model(reg,*,water)   Water use (withdrawal)
  checktotal(*)
;


map_emissec_check(emis_ext)$
  (sum(emis,emis_aggr(emis_ext,emis)) eq 0
  and sum((reg_ext,col_ext),Emissions_data(reg_ext,emis_ext,col_ext)) ) 
    = 1 ;

Display map_emissec_check ;
Loop(emis_ext, if(map_emissec_check(emis_ext), abort "correct missing GWP values" ) ; ) ;



LAND_model(reg,ind,land)
= sum( land_ext$land_aggr(land_ext,land),
      sum(col_agg$col_ext_model(col_agg,ind),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Land_use_data(reg_ext,land_ext,col_ext)
      ) ) ) ) ;


DEU_model(reg,ind,deu)
= sum( deu_ext$deu_aggr(deu_ext,deu),
      sum(col_agg$col_ext_model(col_agg,ind),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Domestic_extraction_used_data(reg_ext,deu_ext,col_ext)
      ) ) ) ) ;

UDE_model(reg,ind,ude)
= sum( ude_ext$ude_aggr(ude_ext,ude),
      sum(col_agg$col_ext_model(col_agg,ind),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Unused_domestic_extraction_data(reg_ext,ude_ext,col_ext)
      ) ) ) ) ;

EMIS_model(reg,ind,emis)
= sum( emis_ext, emis_aggr(emis_ext,emis) *
      sum(col_agg$col_ext_model(col_agg,ind),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Emissions_data(reg_ext,emis_ext,col_ext)
      ) ) ) ) ;

EMIS_model(reg,fd,emis)
= sum( emis_ext, emis_aggr(emis_ext,emis) *
      sum(col_agg$col_ext_model(col_agg,fd),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Emissions_data(reg_ext,emis_ext,col_ext)
      ) ) ) ) ;

WATER_model(reg,ind,water)
= sum( water_ext$water_aggr(water_ext,water),
      sum(col_agg$col_ext_model(col_agg,ind),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Water_use_data(reg_ext,water_ext,col_ext)
      ) ) ) ) ;

WATER_model(reg,fd,water)
= sum( water_ext$water_aggr(water_ext,water),
      sum(col_agg$col_ext_model(col_agg,fd),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Water_use_data(reg_ext,water_ext,col_ext)
      ) ) ) ) ;

WATER_C_model(reg,ind,water)$water_c(water)
= sum( water_ext$water_aggr(water_ext,water),
      sum(col_agg$col_ext_model(col_agg,ind),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Water_use_data(reg_ext,water_ext,col_ext)
      ) ) ) ) ;

WATER_C_model(reg,fd,water)$water_c(water)
= sum( water_ext$water_aggr(water_ext,water),
      sum(col_agg$col_ext_model(col_agg,fd),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Water_use_data(reg_ext,water_ext,col_ext)
      ) ) ) ) ;

WATER_WD_model(reg,ind,water)$water_wd(water)
= sum( water_ext$water_aggr(water_ext,water),
      sum(col_agg$col_ext_model(col_agg,ind),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Water_use_data(reg_ext,water_ext,col_ext)
      ) ) ) ) ;

WATER_WD_model(reg,fd,water)$water_wd(water)
= sum( water_ext$water_aggr(water_ext,water),
      sum(col_agg$col_ext_model(col_agg,fd),
          sum(col_ext$col_ext_aggr(col_ext,col_agg),
              sum(reg_ext$reg_ext_aggr(reg_ext,reg),
                 Water_use_data(reg_ext,water_ext,col_ext)
      ) ) ) ) ;



Display col_agg, EMIS_model, WATER_model, WATER_WD_model, WATER_C_model, LAND_model;
*$libinclude xldump EMIS_model emissions.xlsx ;

* Check that total emissions before and after aggregation are equal
checktotal(emis_ext) = sum((reg_ext,col_ext), Emissions_data(reg_ext,emis_ext,col_ext) ) ;
Display  checktotal;

checktotal(emis_ext) = 0;
checktotal(emis) = sum((reg,ind), EMIS_model(reg,ind,emis) ) 
                 + sum((reg,fd), EMIS_model(reg,fd,emis) ) ;
Display  checktotal;
