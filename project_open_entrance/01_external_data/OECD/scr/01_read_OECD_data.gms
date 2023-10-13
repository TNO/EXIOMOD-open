$ontext

File:   01-read-baseline-data.gms
Author: Hettie Boonman
Date:   05-12-2017

This script reads in the baseline data from 2012 aging report. This report is
also used as baseline for "Study on modeling of the economic and environmental
impacts of raw material consumption".
This study is used as reference in the "business as usual" scenario.
The above paper mentions:
"GDP and population assumptions are taken from the DG ECFIN 2012 Ageing Report
and Eurostat, respectively. The GDP projection for the period 2012–2030
indicates a quite stable trend for GDP with an annual growth between 1.6% and
1.9% resulting in a 33.2% increase of GDP between 2012 and 2030. The Croatian
population has been added based on projections performed by Cambridge
Econometrics using the EU12 average. The resulting trend shows an increase in
the EU28 population of 3.7% during this period."


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "GDP_gr"        Annual growth GDP

    2. Data source (should be the same as name of the library)
    "_OECD"           Aging report

    3. Extension "_orig" is added to indicate that it is not processed

Example of resulting parameter: PRODKL_CEPII_orig


INPUTS
    %project%\01_external_data\aging_report_2012\data\ar2012-main-outputs-dat-fwk_en.xlsx

OUTPUTS
    GDP_AG_data(reg_AG,year_AG)         GDP in 2010 prices (million euro)
                                        # (15-64)
    EMPL_AG_data(reg_AG,year_AG)        Employment (15-64) (millions)
    WORK_POP_AG_data(reg_AG,year_AG)    Working age population (15-64)
                                        # (thousands)
    LAB_FORCE_AG_data(reg_AG,year_AG)   Labour force (15-64) (thousands)
    POP_AG_data(reg_AG,year_AG)         Population (15-64) (thousands)

$offtext

$oneolcom
$eolcom #
* ============================ Declaration of sets =============================

sets

    reg_OECD      list of regions in cepii data
/
$include %project%\01_external_data\OECD\sets\regions_OECD.txt
/

    year_OECD     list of years in cepii data
/
$include %project%\01_external_data\OECD\sets\years_OECD.txt
/

;

* ================================ Load data ===================================

Parameters
    OECD_GDP_data(reg_OECD,*,*,*,*,year_OECD,*)     OECD data on real GDP (long term
                                                    # forecast) (mil dollars)
    OECD_POP_data(reg_OECD,year_OECD)               OECD data on population
;


$libinclude xlimport OECD_GDP_data       %project%\01_external_data\OECD\data\OECD.xlsx             OECD!A1:G100000
$libinclude xlimport OECD_POP_data       %project%\01_external_data\OECD\data\OECD_population.xlsx  OECD_population!B1:AS57

Display OECD_GDP_data, OECD_POP_data;


* ========================== Assign data to parameters =========================

Parameters
    GDP_OECD_orig(reg_OECD,year_OECD)         real GDP (long term, mln dollar)
    POP_OECD_orig(reg_OECD,year_OECD)         Total population


;

GDP_OECD_orig(reg_OECD,year_OECD)
    =  OECD_GDP_data(reg_OECD,'GDPLTFORECAST','TOT','MLN_USD','A',year_OECD,'Value') ;

POP_OECD_orig(reg_OECD,year_OECD)
    =  OECD_POP_data(reg_OECD,year_OECD) ;

Display
    GDP_OECD_orig
    POP_OECD_orig

;
