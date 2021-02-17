
$ontext

File:   01-read-ref-data.gms
Author: Anke van den Beukel
Date:   17-12-2019

This script reads in template data from the EU reference scenario.


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "elec"        electricity (TWh)

    2. Data source (should be the same as name of the library)
    "_ref"        EU reference database database

    3. Extension "_orig" is added to indicate that it is not processed

Example of resulting parameter: elec_ref_orig


INPUTS
    %project%\library_ref\data\data_template.xlsx

OUTPUTS
    elec_ref_orig(reg_ref, source_ref, year_ref)     ref electricity mix in
                                                     original classification
    elec_ref_perc(reg_ref,source_ref,year_ref)       percentage change in
                                                     electricity mix

$offtext

$oneolcom
$eolcom #
* ============================ Declaration of sets =============================

sets

    reg_ref      list of regions in ref data
/
$include %project%\01_external_data\EU_reference\sets\regions_ref.txt
/

    source_ref   list of electricity sources in WEO data
/
$include %project%\01_external_data\EU_reference\sets\sources_ref.txt
/

    source_ref_relevant(source_ref) list of relevant technologies (ie minus Total)
/
$include %project%\01_external_data\EU_reference\sets\sources_ref_relevant.txt
/

    year_ref     list of years in ref data
/
$include %project%\01_external_data\EU_reference\sets\years_ref.txt
/

    year_ref_relevant(year_ref)    list of relevant years (ie minus 2000 and 2005)
/
$include %project%\01_external_data\EU_reference\sets\years_ref_relevant.txt
/
;

Display
         reg_ref
         source_ref
         year_ref
         year_ref_relevant
;

* ================================ Load data ===================================

Parameters
    elec_ref_data(reg_ref,source_ref,year_ref)     electricity mix data in GWh
*    tot_source_check                               difference between total value
*                                                  # in excel and in gams
;

$libinclude xlimport elec_ref_data            %project%\01_external_data\EU_reference\data\EU_ref.xls    Aggregate!A1:M309

Display elec_ref_data ;


* ========================== Assign data to parameters =========================

Parameters
    elec_ref_orig(reg_ref,source_ref_relevant,year_ref_relevant)      ref electricity data in
                                                    #original classification
;

elec_ref_orig(reg_ref, source_ref_relevant, year_ref_relevant) = elec_ref_data(reg_ref, source_ref_relevant, year_ref_relevant) ;

Display elec_ref_orig ;

* ======================== Add zeros for very small numbers ====================
* elec_ref_orig has some very small entries (eg -4.5475E-13) which are 0 in the
* excel file.
loop( (reg_ref,source_ref_relevant,year_ref_relevant) $
    (elec_ref_orig(reg_ref, source_ref_relevant, year_ref_relevant) < 1E-10),
    elec_ref_orig(reg_ref, source_ref_relevant, year_ref_relevant) = 0 );

Display
elec_ref_orig
;

