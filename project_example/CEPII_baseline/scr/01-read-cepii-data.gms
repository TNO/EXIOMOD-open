
$ontext

File:   01-read-cepii-data.gms
Author: Jinxue Hu
Date:   18-02-2015

This script reads in the baseline data from CEPII (version 2.2).


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "PRODKL"        productivity for capital-labour

    2. Data source (should be the same as name of the library)
    "_CEPII"        Cepii database

    3. Extension "_orig" is added to indicate that it is not processed

Example of resulting parameter: PRODKL_CEPII_orig


INPUTS
    %project%\library_CEPII\data\CEPII_baseline_database_v2.2.xls

OUTPUTS
    GDP_CEPII_orig(reg_CP,year_CP)      cepii GDP in original classification
    PRODKL_CEPII_orig(reg_CP,year_CP)   cepii capital-labour productivity in
                                        original classification
    PRODE_CEPII_orig(reg_CP,year_CP)    cepii energy productivity in original
                                        classification
    KS_CEPII_orig(reg_CP,year_CP)       cepii capital stock in original
                                        classification
    LS_CEPII_orig(reg_CP,year_CP)       cepii labour supply in original
                                        classification
    E_CEPII_orig(reg_CP,year_CP)        cepii primary energy consumption in
                                        original classification
    POP_CEPII_orig(reg_CP,year_CP)      cepii population in thousands in
                                        original classification

$offtext

$oneolcom
$eolcom #
* ============================ Declaration of sets =============================

sets

    reg_CP      list of regions in cepii data
/
$include %project%\CEPII_baseline\sets\regions_cepii.txt
$include %project%\CEPII_baseline\sets\regions_cepii_missing.txt
/

    year_CP     list of years in cepii data
/
$include %project%\CEPII_baseline\sets\years_cepii.txt
/

;
* ================================ Load data ===================================

Parameters
    GDP_CP_data(reg_CP,*,*,year_CP)         GDP data in mln constant 2005 USD
    productivity_CP_data(reg_CP,*,year_CP)  Total factor productivity
    factors_CP_data(reg_CP,*,*,year_CP)     KS in bln constant 2005 USD and LS
                                            # in thousands active population and
                                            # E in 1000 barrels of oil eq
    tot_productivity                        difference between total value in
                                            # excel and in gams
;

$libinclude xlimport GDP_CP_data            %project%\CEPII_baseline\data\CEPII_baseline_database_v2.2.xls    GDP!b1:bw442
$libinclude xlimport productivity_CP_data   %project%\CEPII_baseline\data\CEPII_baseline_database_v2.2.xls    productivity!b1:bv295
$libinclude xlimport factors_CP_data        %project%\CEPII_baseline\data\CEPII_baseline_database_v2.2.xls    factors!b1:bw1177

tot_productivity
            = sum((reg_CP,year_CP), productivity_CP_data(reg_CP,"Energy productivity",year_CP) )
            + sum((reg_CP,year_CP), productivity_CP_data(reg_CP,"Total Factor Productivity",year_CP) )
            - 18142988;
Display tot_productivity ;
* Total should be equal to 18,142,988

* ========================== Assign data to parameters =========================

Parameters
    GDP_CEPII_orig(reg_CP,year_CP)      cepii GDP in original classification
    PRODKL_CEPII_orig(reg_CP,year_CP)   cepii capital-labour productivity in
                                        # original classification
    PRODE_CEPII_orig(reg_CP,year_CP)    cepii energy productivity in original
                                        # classification
    KS_CEPII_orig(reg_CP,year_CP)       cepii capital stock in original
                                        # classification
    LS_CEPII_orig(reg_CP,year_CP)       cepii labour supply in original
                                        # classification
    E_CEPII_orig(reg_CP,year_CP)        cepii primary energy consumption in
                                        # original classification
    POP_CEPII_orig(reg_CP,year_CP)      cepii population in number of people in
                                        # original classification
;

GDP_CEPII_orig(reg_CP,year_CP)     = GDP_CP_data(reg_CP,"GDP","million constant 2005 USD",year_CP) ;
PRODKL_CEPII_orig(reg_CP,year_CP)  = productivity_CP_data(reg_CP,"Total Factor Productivity",year_CP) ;
PRODE_CEPII_orig(reg_CP,year_CP)   = productivity_CP_data(reg_CP,"Energy productivity",year_CP) ;
KS_CEPII_orig(reg_CP,year_CP)      = factors_CP_data(reg_CP,"Capital stocks","Billion constant 2005 USD",year_CP) ;
LS_CEPII_orig(reg_CP,year_CP)      = factors_CP_data(reg_CP,"Economically active population","Thousands",year_CP) ;
E_CEPII_orig(reg_CP,year_CP)       = factors_CP_data(reg_CP,"Primary energy consumption","Thousands barrels of oil equivalent",year_CP) ;
POP_CEPII_orig(reg_CP,year_CP)     = factors_CP_data(reg_CP,"Population","Thousands",year_CP) * 1000 ;
Display POP_CEPII_orig ;
