$ontext

File:   04_replace_coprodB_data.gms
Author: Anke van den Beukel
Date:   2-12-2019

This script processes the baseline data from CEPII (version 2.2).


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "elec"        WEO electricity mix

    2. Data source (should be the same as name of the library)
    "_WEO"        WEO data

    3. Unit of measurement
    "_level"        absolute value for year t
    "_change"       annual change in t/(t-1)-1

Example of resulting parameter: elec_WEO_change


INPUTS
    elec_WEO_orig(reg_WEO,source_WEO,year_WEO)      WEO electricity data in
                                                    original classification

OUTPUTS
    elec_WEO_change                                annual electricity mix change

annual change is expressed in t/(t-1)-1
$offtext

$oneolcom
$eolcom #

Parameters
elec_WEO_shares(reg,ind_elec,year)            shares of electricty mix
;

elec_WEO_shares(reg,ind_elec,year) =
    elec_WEO(reg,ind_elec,year) / sum(ind_elecc, elec_WEO(reg,ind_elecc,year) ) ;

Display
elec_WEO_shares
;
