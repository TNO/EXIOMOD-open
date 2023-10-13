$ontext
File:   project_carboncap\library_physical_extensions\scr\
        04-rescale-physical-coefficients_2011.gms
Author: Hettie Boonman (based on version Trond Husby)
Date:   2 November 2017

This script rescales physical coefficients from EXIOBASE 2007 physical
coefficients to the EDGAR data.

$offtext

$oneolcom
$eolcom #


* ================================ Sets edgar ==================================

sets
reg_edgar                           regions in edgar database
/
$include %project%/01_external_data/physical_extensions_2011/sets/edgar_regions.txt
/

reg_edgar_aggr(reg_edgar,reg_data)  regions in edgar database
/
$include %project%/01_external_data/physical_extensions_2011/sets/aggregation/edgar_regions_to_data.txt
/

;
* ====================== EEA CO2 emissions data 2011 ===========================

Parameter
    EDGAR_emis_data(reg_edgar,*)  CO2 emissions from EDGAR database in kton
    Eurostat_emis_data(reg_EUS,*,year_EUS)
                                  # CO2 emissions from Eurostat database
                                  # in tonne
    Eurostat_emis(reg,*,year)     CO2 emissions from Eurostat database
                                  # in tonne
    Edgar_eurostat_emis(reg)      CO2 emissions from Eurostat and edgar database
                                  # in kton in 2011 (combined)
    EDGAR_emis(reg)               CO2 emissions 2007 from EDGAR database
    coef_emis_EDGAR_scaling(reg)  aggregate CO2 emission coefficient
    EMIS_EEA_level(reg,year)      CO2 emissions in kt from EEA
    coef_emis_EEA_level(reg,year) aggregate CO2 emission coefficient

    CO2_hh_EXIOBASE(reg)
    CO2_hh_eurostat(reg)
    CO2_EXIOBASE_total(reg)
*    coef_emis_change(sce_sce,reg,*,year)  aggregate change in CO2 emission coefficient
;

$libinclude xlimport edgar_emis_data  %project%/01_external_data/physical_extensions_2011/data/CO2_edgar_tm2018.xlsx  TOTALSBYCOUNTRY!e10:bb227
$libinclude xlimport Eurostat_emis_data  %project%/01_external_data/physical_extensions_2011/data/Emissions_eurostat_2008_2020.xlsx  Data!a10:o91

EDGAR_emis(reg)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_edgar$reg_edgar_aggr(reg_edgar,reg_data),
         EDGAR_emis_data(reg_edgar,'2011') ) ) ;

eurostat_emis(reg,"All NACE activities plus households",year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_EUS$reg_EUS_aggr(reg_EUS,reg_data),
        sum(year_EUS$year_EUS_aggr(year_EUS,year),
         Eurostat_emis_data(reg_EUS,"All NACE activities plus households",year_EUS) ) ) ) ;

eurostat_emis(reg,"Total activities by households",year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_EUS$reg_EUS_aggr(reg_EUS,reg_data),
        sum(year_EUS$year_EUS_aggr(year_EUS,year),
         Eurostat_emis_data(reg_EUS,"Total activities by households",year_EUS) ) ) ) ;

Edgar_eurostat_emis(reg)
    = EDGAR_emis(reg) ;
Edgar_eurostat_emis(reg)$eurostat_emis(reg,"All NACE activities plus households","2011")
    = eurostat_emis(reg,"All NACE activities plus households","2011") / 1000 ;


coef_emis_EDGAR_scaling(reg)
    = Edgar_eurostat_emis(reg)
* Convert from kton to kg
    * 1000000
        / ( sum(ind, Emissions_model(reg,ind,"CO2_c","kg CO2-eq")
          + Emissions_model(reg,ind,"CO2_nc","kg CO2-eq") )
          + sum( fd, Emissions_model(reg,fd,"CO2_c","kg CO2-eq") ) ) ;


* Check sum totals
CO2_EXIOBASE_total(reg)
    = (sum((prd,fd,unit),Emissions_c_model(prd,reg,fd,"CO2_c",unit))
            + sum((prd,ind,unit),Emissions_c_model(prd,reg,ind,"CO2_c",unit))
            + sum((ind,unit),Emissions_model(reg,ind,"CO2_nc",unit)) );

Display  CO2_EXIOBASE_total ;

* Reestimate emission coefficients
coef_emis_c(prd,reg,ind,"CO2_c")
    = coef_emis_c(prd,reg,ind,"CO2_c") * coef_emis_EDGAR_scaling(reg) ;

coef_emis_nc(reg,ind,"CO2_nc")
    = coef_emis_nc(reg,ind,"CO2_nc") * coef_emis_EDGAR_scaling(reg) ;

coef_emis_c(prd,reg,fd,"CO2_c")
    = coef_emis_c(prd,reg,fd,"CO2_c") * coef_emis_EDGAR_scaling(reg) ;

Display coef_emis_EDGAR_scaling, coef_emis_c, coef_emis_nc ;


* Reestimate total emissions based on edgar database

Emissions_c_model(prd,reg,ind,"CO2_c",unit)
    = Emissions_c_model(prd,reg,ind,"CO2_c",unit) *
        coef_emis_EDGAR_scaling(reg) ;

Emissions_model(reg,ind,"CO2_nc",unit)
    = Emissions_model(reg,ind,"CO2_nc",unit) *
        coef_emis_EDGAR_scaling(reg) ;

Emissions_c_model(prd,reg,fd,"CO2_c",unit)
    = Emissions_c_model(prd,reg,fd,"CO2_c",unit) *
        coef_emis_EDGAR_scaling(reg) ;


* CO2 household percentages compared. Differences are quite big.
CO2_hh_EXIOBASE(reg)
    = sum((prd,fd,unit),Emissions_c_model(prd,reg,fd,"CO2_c",unit))
        / (sum((prd,fd,unit),Emissions_c_model(prd,reg,fd,"CO2_c",unit))
            + sum((prd,ind,unit),Emissions_c_model(prd,reg,ind,"CO2_c",unit))
            + sum((ind,unit),Emissions_model(reg,ind,"CO2_nc",unit)) );

CO2_hh_eurostat(reg)$eurostat_emis(reg,"All NACE activities plus households",'2011')
    = eurostat_emis(reg,"Total activities by households",'2011')
        / eurostat_emis(reg,"All NACE activities plus households",'2011');

* Check sum totals (should be equal to sum of Eurostat per region)
CO2_EXIOBASE_total(reg)
    = (sum((prd,fd,unit),Emissions_c_model(prd,reg,fd,"CO2_c",unit))
            + sum((prd,ind,unit),Emissions_c_model(prd,reg,ind,"CO2_c",unit))
            + sum((ind,unit),Emissions_model(reg,ind,"CO2_nc",unit)) );


Display CO2_hh_EXIOBASE, CO2_hh_eurostat, CO2_EXIOBASE_total;
$exit
* ====================== calculate total ghg emissions =========================
* This is only possible for a very specific set with emissions
EMIS_model(reg,ind,"ghg_c")
        = EMIS_model(reg,ind,"CO2_c")+EMIS_model(reg,ind,"ghg_other_c") ;
EMIS_model(reg,ind,"ghg_nc")
        = EMIS_model(reg,ind,"CO2_nc")+EMIS_model(reg,ind,"ghg_other_nc") ;
EMIS_model(reg,fd,"ghg_c")
        = EMIS_model(reg,fd,"CO2_c")+EMIS_model(reg,fd,"ghg_other_c") ;

* Reestimate emission coefficients
coef_emis_c(reg,ind,"ghg_c")$
  (  sum(ener_CO2, INTER_USE_T(ener_CO2,reg,ind) ) )
    = EMIS_model(reg,ind,"ghg_c") / sum(ener_CO2, INTER_USE_T(ener_CO2,reg,ind) ) ;

coef_emis_nc(reg,ind,"ghg_nc")$
  (  Y(reg,ind) )
    = EMIS_model(reg,ind,"ghg_nc") / Y(reg,ind) ;

coef_emis_c(reg,fd,"ghg_c")$
  ( sum(ener_CO2, CONS_H_T(ener_CO2,reg) ) )
    = EMIS_model(reg,fd,"ghg_c") / sum(ener_CO2, CONS_H_T(ener_CO2,reg) ) ;

