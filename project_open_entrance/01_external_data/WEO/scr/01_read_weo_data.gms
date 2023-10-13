
$ontext

File:   01-read-weo-data.gms
Author: Anke van den Beukel
Date:   11-11-2019

This script reads in template data from WEO (World Energy Outlook).


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "elec"        electricity (TWh)

    2. Data source (should be the same as name of the library)
    "_WEO"        WEO database

    3. Extension "_orig" is added to indicate that it is not processed

Example of resulting parameter: elec_WEO_orig


INPUTS
    %project%\library_WEO\data\data_template.xlsx

OUTPUTS
    elec_WEO_orig(reg_WEO, source_WEO, year_WEO)     WEO electricity mix in
                                                     original classification
    elec_WEO_perc(reg_WEO,source_WEO,year_WEO)       percentage change in
                                                     electricity mix

$offtext

$oneolcom
$eolcom #
* ============================ Declaration of sets =============================

sets

    reg_WEO      list of regions in WEO data
/
$include %project%\01_external_data\WEO\sets\regions_weo.txt
/

    source_WEO   list of electricity sources in WEO data
/
$include %project%\01_external_data\WEO\sets\sources_weo.txt
/

    source_WEO_relevant(source_WEO)    list of relevant electricity sources in
                                       # WEO data (ie minus "Total")
/
$include %project%\01_external_data\WEO\sets\sources_weo_relevant.txt
/

    year_WEO     list of years in WEO data
/
$include %project%\01_external_data\WEO\sets\years_weo.txt
/


;
Display
         reg_WEO
         source_WEO
         year_WEO
         source_WEO_relevant
;


* ================================ Load data ===================================

Parameters
    elec_WEO_data(reg_WEO,source_WEO,year_WEO)     electricity mix data in TWh
    tot_source_check                               difference between total value
*                                                  # in excel and in gams
;

$libinclude xlimport elec_WEO_data            %project%\01_external_data\WEO\data\data_template.xlsx    Electricity!A2:AP362

tot_source_check
    = sum((reg_WEO,source_WEO,year_WEO), elec_WEO_data(reg_WEO,source_WEO,year_WEO) )
        - 7727790;
* Total should be equal to 7,727,790

Display tot_source_check ;
Display elec_WEO_data ;


* ========================== Assign data to parameters =========================

Parameters
    elec_WEO_orig(reg_WEO,source_WEO_relevant,year_WEO)      WEO electricity data in
                                                    #original classification
*    elec_WEO_perc(reg_WEO,source_WEO,year_WEO)      Source percentages per
*                                                    #country per year
;

elec_WEO_orig(reg_WEO, source_WEO_relevant, year_WEO) = elec_WEO_data(reg_WEO, source_WEO_relevant, year_WEO) ;
*elec_WEO_perc(reg_WEO,source_WEO_relevant ,year_WEO) = elec_WEO_data(reg_WEO,source_WEO_relevant,year_WEO) / sum(reg_WEO, year_WEO, elec_WEO_data(reg_WEO,source_WEO_relevant, year_WEO)) * 100;

Display elec_WEO_orig ;
*Display elec_WEO_perc ;
$exit
