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
    "_EU"           Aging report

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

    reg_EU      list of regions in cepii data
/
$include %project%\01_external_data\eureference\sets\regions_euref.txt
/

    year_EU     list of years in cepii data
/
$include %project%\01_external_data\eureference\sets\years_euref.txt
/

;

* ================================ Load data ===================================

Parameters
    EU_data(reg_EU,*,year_EU)      Worldbank data on labor force
                                        # population GDP (constant LCA and
                                        # 2010$ )
;


$libinclude xlimport EU_data            %project%\01_external_data\eureference\data\EU-reference.xlsx    data!A1:M100000

Display EU_data;


* ========================== Assign data to parameters =========================

Parameters
    GDP_EU_orig(reg_EU,year_EU)         GDP in 2010 US dollars
    POP_EU_orig(reg_EU,year_EU)         Total population

;

GDP_EU_orig(reg_EU,year_EU)
    = EU_data(reg_EU,'GDP (in 000 Meuro13)',year_EU) ;

POP_EU_orig(reg_EU,year_EU)
    = EU_data(reg_EU,'Population (in million)',year_EU) ;

Display
    GDP_EU_orig
    POP_EU_orig
;
