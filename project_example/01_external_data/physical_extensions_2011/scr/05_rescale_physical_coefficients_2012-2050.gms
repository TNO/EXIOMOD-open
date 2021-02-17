$ontext
File:   project_polfree\library_physical_extensions\scr\
        05_rescale_physical_coefficients_2007-2050.gms
Author: Hettie Boonman (based on version Jinxue Hu)
Date:   2 November 2017

This script rescales physical coefficients from EXIOBASE 2011 physical
coefficients to the more up to date data from for instance EEA. Also we create
a trajectory in CO2 and resource efficieny until 2050.

Scaling CO2 emissions 2012-2015 by country
* Read in EDGAR emission data until 2015
* Read in GDP data until 2015.
* Calculate emissions per unit of GDP until 2015.
* Derive change in emissions per unit of GDP between 2011 and 2015.
* Apply this change on 2011 emission coefficients.
* Source: EDGARv4.3.2, European Commission, JRC/PBL
* Emission Database for Global Atmospheric Research (EDGAR), release version 4.3.2.
* http://edgar.jrc.ec.europe.eu, 2016 forthcoming

Scaling CO2 emissions 2016-2050 by sector
* Carbon intensity decreases with 0.49% annually between 2015-2050.
* Carbon intensity is also available by country and sector.
* Source: European Commission (2016), "EU Reference Scenario 2016 - EU energy,
* transport and GHG emissions - Trends to 2050", see page 185

Scaling DEU 2007-2050
* For materials we use Eurostat data on material productivity. The material
* productivity in 2013 was 24.2% higher than in 2007 (annual change of 3.68%).
* Also we assume an annual increase in material productivity of 0.85% or 2%
* (EC, 2014) after 2013.
* Source: European Commission (2014) "Study on modelling of the economic and
* environmental impacts of raw material consumption", by Cambridge Econometrics
* and BIO Intelligence Service, Final report, March 2014

INPUTS
  EMIS_model(reg,*,emis)        Emissions in kg for non ghg emissions and in
                                CO2-eq kt for ghg emissions
  CONS_H_T(prd,reg)             household consumption on product level (volume)
  Y(regg,ind)                   output vector by activity (volume)
  INTER_USE_T(prd,regg,ind)     intermediate use on product level (volume)

OUTPUTS
  EMIS_model(reg,*,emis)        Emissions in kg for non ghg emissions and in
                                CO2-eq kt for ghg emissions rescaled to EEA data
  coef_emis_c_year(reg,*,emis,year)   emission coefficient in kt CO2-eq kg or
                                      I-TEQ kt per mln euro
  coef_emis_nc_year(reg,*,emis,year)  non combustion emission coefficients

  coef_deu_year(reg,ind,deu,year)     material coefficients kt per mln euro
;
$offtext

$oneolcom
$eolcom #

* ******************** Trajectory 2012-2050 ************************************
* non-CO2 emissions also have trajectory from 2011-2050
* rescaling of CO2 emissions will be overwritten in the remaining code below

Parameter
    coef_emis_c_year(reg,*,emis,year)     emission coefficients for CO2 until 2050
    coef_emis_nc_year(reg,ind,emis,year)  emission coefficients for CO2 until 2050
;

coef_emis_c_year(reg,ind,emis_c,year)
    = coef_emis_c(reg,ind,emis_c) ;
coef_emis_nc_year(reg,ind,emis_nc,year)
    = coef_emis_nc(reg,ind,emis_nc) ;
coef_emis_c_year(reg,fd,emis_c,year)
    = coef_emis_c(reg,fd,emis_c) ;

* ******************* EDGAR CO2 emissions data 2012 - 2015 *********************

Parameter
    EMIS_EDGAR_data(*,*)            CO2 emissions in kt from EDGAR by country
                                    # for 2011-2015
    GDP_Worldbank_data(*,*)         GDP in 2010 USD by country for 2012-2015
    EMIS_EDGAR_level(reg,year)      CO2 emissions in kt
    GDP_Worldbank_level(reg,year)   GDP in 2010 mln USD
    coef_emis_EDGAR_level(reg,year) aggregate CO2 emission coefficient
    coef_emis_change(reg,*,year)    aggregate change in CO2 emission coefficient
;

*$libinclude xlimport EMIS_EDGAR_data        %project%/01_external_data/physical_extensions_2011/data/CO2_EDGAR.xls      data!b1:g45
$libinclude xlimport GDP_Worldbank_data     %project%\01_external_data\physical_extensions_2011\data\GDP_Worldbank.xlsx  data!e1:j44

* Annual reduction for EU countries

* Aggregate EEA emissions and GDP
EMIS_EDGAR_level(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_edgar$reg_edgar_aggr(reg_edgar,reg_data),
         EDGAR_emis_data(reg_edgar,year) ) ) ;

GDP_Worldbank_level(reg,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        GDP_Worldbank_data(reg_data,year) )
            / 1000000 ;

* Estimate CO2 emissions per unit of GDP
coef_emis_EDGAR_level(reg,year)$
    GDP_Worldbank_level(reg,year)
        = EMIS_EDGAR_level(reg,year)
            / GDP_Worldbank_level(reg,year) ;

* Derive annual change in CO2 emisions per unit of GDP
Loop((reg,year)$(ord(year) and coef_emis_EDGAR_level(reg,year-1)),
    coef_emis_change(reg,ind,year)
        = coef_emis_EDGAR_level(reg,year)
            / coef_emis_EDGAR_level(reg,year-1) ;
    coef_emis_change(reg,fd,year)
        = coef_emis_EDGAR_level(reg,year)
            / coef_emis_EDGAR_level(reg,year-1) ;
) ;

* Annual reduction for missing countries
coef_emis_change(reg,ind,year)$(not coef_emis_change(reg,ind,year) and ord(year) ge 1 and ord(year) le 5 ) = 1 ;
coef_emis_change(reg,fd,year)$( not coef_emis_change(reg,fd,year) and ord(year) ge 1 and ord(year) le 5 ) = 1 ;
*Display coef_emis_change ;

* ********************* EC CO2 emissions data 2016 - 2050 **********************

Parameter
    coef_emis_EU_data(*,*)    annual reduction in CO2 coefficients EU 2016-2050
;

$libinclude xlimport coef_emis_EU_data    %project%\01_external_data\physical_extensions_2011\data\CO2_EU_reference_scenario.xlsx  data!b1:c7
display coef_emis_EU_data ;

$ontext
* Scale using an average value for EU

* Annual reduction for EU countries
coef_emis_change(reg,ind,year)$
    (ord(year) ge 6 and ord(year) le 55 )
        = 1 + coef_emis_EU_data("Total_final_energy_demand","Annual_reduction") ;

$offtext

* Scale using an average value for EU by sector

Sets
    ind_trans(*)    transport industries    /iTRAN/
    ind_serv(*)     service industries      /iREBA, iPUBO, iWAST/
    ind_energy_supply(*) electricity and steam sectors /iELCF,iTRDI/
;

* Energy supply sectors
coef_emis_change(reg,ind,year)$
    (ord(year) ge 6 and ord(year) le 39 and ind_energy_supply(ind) )
        = 1 + coef_emis_EU_data("Energy_supply_sector","Annual_reduction") ;

* Industrial sectors, excluding energy
coef_emis_change(reg,ind,year)$
    (ord(year) ge 6 and ord(year) le 39 and not ind_trans(ind) and not ind_serv(ind) and not ind_energy_supply(ind) )
        = 1 + coef_emis_EU_data("Industrial_sectors","Annual_reduction") ;

* Tertiary sectors, excluding transport
coef_emis_change(reg,ind,year)$
    (ord(year) ge 6 and ord(year) le 39 and not ind_trans(ind) and ind_serv(ind) )
        = 1 + coef_emis_EU_data("Tertiary_sectors","Annual_reduction") ;

* Transport sectors
coef_emis_change(reg,ind,year)$
    (ord(year) ge 6 and ord(year) le 39 and ind_trans(ind) )
        = 1 + coef_emis_EU_data("Transport_sectors","Annual_reduction") ;

* Residential sectors
coef_emis_change(reg,fd,year)$
    (ord(year) ge 6 and ord(year) le 39 )
        = 1 + coef_emis_EU_data("Residential_sector","Annual_reduction") ;

Display
  coef_emis_change
;

* ************* Apply changes in emission coefficients until 2050 **************

coef_emis_c_year(reg,ind,"CO2_c","2011")    = coef_emis_c(reg,ind,"CO2_c") ;
coef_emis_nc_year(reg,ind,"CO2_nc","2011")  = coef_emis_nc(reg,ind,"CO2_nc") ;
coef_emis_c_year(reg,fd,"CO2_c","2011")     = coef_emis_c(reg,fd,"CO2_c") ;
Display coef_emis_c_year, year ;

Loop(year$(ord(year) gt 1 ),
    coef_emis_c_year(reg,ind,"CO2_c",year)
        = coef_emis_c_year(reg,ind,"CO2_c",year-1) * coef_emis_change(reg,ind,year) ;
    coef_emis_nc_year(reg,ind,"CO2_nc",year)
        = coef_emis_nc_year(reg,ind,"CO2_nc",year-1) * coef_emis_change(reg,ind,year) ;
    coef_emis_c_year(reg,fd,"CO2_c",year)
        = coef_emis_c_year(reg,fd,"CO2_c",year-1) * coef_emis_change(reg,fd,year) ;
) ;
Display coef_emis_c_year, coef_emis_nc_year ;
$exit

* ***** Scale material coefficients to EC (2014) study on RMC until 2050 *******
* JH: Calibration and trajectory for resources should still be updated
* Assume these improvements in both EU and non EU countries
Parameter
    coef_deu_year(reg,ind,deu,year)   material coefficient until 2050
;

coef_deu_year(reg,ind,deu,"2007") = coef_deu(reg,ind,deu) ;

* Apply change in resource productivity from actual data
Loop(year$(ord(year) gt 1 and ord(year) le 7),
    coef_deu_year(reg,ind,deu,year)
        = coef_deu_year(reg,ind,deu,year-1) / 1.0368 ;
) ;

* Apply change in resource productivity from an EU scenario
Loop(year$(ord(year) gt 7 ),
    coef_deu_year(reg,ind,deu,year)
        = coef_deu_year(reg,ind,deu,year-1) / (1.02) ;
) ;

Display coef_deu_year ;
