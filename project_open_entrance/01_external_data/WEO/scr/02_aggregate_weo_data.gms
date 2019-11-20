
$ontext

File:   02-aggregate-weo-data.gms
Author: Anke van den Beukel
Date:   11-11-2019

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


* ==================== Declaration of aggregation schemes ======================
Sets

    reg_WEO_aggr(reg_WEO,reg_data)        aggregation scheme for WEO regions
/
$include %project%\01_external_data\WEO\sets\aggregation\regions_weo_to_model.txt
/

    year_WEO_aggr(year_WEO,year)          aggregation scheme for WEO years
/
$include %project%\01_external_data\WEO\sets\aggregation\years_weo_to_model.txt
/

    source_WEO_aggr(source_WEO,ind_data)  aggregation scheme for WEO sources
/
$include %project%\01_external_data\WEO\sets\aggregation\sources_weo_to_model.txt
/
;

Alias (reg_WEO,regg_WEO) ;

Display reg_data ;
Display reg_WEO_aggr ;
Display year_WEO_aggr ;
Display source_WEO_aggr;

* ===================== Declaration of WEO industry set ========================
Sets

    ind_elec(ind)
/
$include %project%/00_base_model_setup/sets/industries_model_weo.txt
/
Display ind_elec ;

Alias (ind_elec, ind_elecc) ;


Parameters
Suppy_only_elec_ind(reg,prd,regg,ind)
;

Suppy_only_elec_ind(reg,prd,regg,ind_elec)=SUP(reg,prd,regg,ind_elec) ;

Display
   Suppy_only_elec_ind
;

* ============================ Aggregation of years ============================

Parameters
    elec_WEO_yr(reg_WEO,source_WEO_relevant,year)      WEO electricity in model years
;

elec_WEO_yr(reg_WEO,source_WEO_relevant,year)$
    sum(reg_data, reg_WEO_aggr(reg_WEO,reg_data) )
        = sum(year_WEO$year_WEO_aggr(year_WEO,year), elec_WEO_orig(reg_WEO,source_WEO_relevant,year_WEO) ) ;

Display elec_WEO_yr;

* ========================== Aggregation of industries =========================

Parameters
    elec_WEO_ind(reg_WEO,ind_elec,year)            WEO electricity in model industries
;

elec_WEO_ind(reg_WEO,ind_elec,year)
    = sum(ind_data$ind_aggr(ind_data,ind_elec),
        sum(source_WEO_relevant$source_WEO_aggr(source_WEO_relevant,ind_data),
            elec_WEO_yr(reg_WEO,source_WEO_relevant,year) ) ) ;

Display elec_WEO_ind
        ind_aggr;

* =========================== Aggregation of regions ===========================

* The spatial aggregation for productivity uses a different procedure because
* additional weights are needed and there are two options to weigh it. See below.

Parameters
    elec_WEO(reg,ind_elec,year)        WEO electricity in model regions
;

elec_WEO(reg,ind_elec,year)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_WEO$reg_WEO_aggr(reg_WEO,reg_data),
            elec_WEO_ind(reg_WEO,ind_elec,year) ) ) ;

Display elec_WEO
Display reg
;

* ====================== Conversion into annual change =========================

Parameters
    elec_WEO_change(reg,ind_elec,year)       annual change in electricity mix
;

elec_WEO_change(reg,ind_elec,year)$
    elec_WEO(reg,ind_elec,year-1)
        = elec_WEO(reg,ind_elec,year) / elec_WEO(reg,ind_elec,year-1) ;

Display elec_WEO_change
        ind_elec
        ind ;


* *********************** Baseyear should have value one ***********************

*elec_WEO_change(reg, ind, "2011")
*    = sum(ind_data$ind_aggr(ind_data,ind),
*      sum(source_WEO$source_WEO_aggr(source_WEO,ind_data),
*            1 ) ) ;
*Display elec_WEO_change ;

elec_WEO_change(reg,ind_elec,"2011")   =   1 ;
Display elec_WEO_change;


* ====================== Conversion into percentages ==========================

Parameters
    elec_WEO_perc(reg, ind_elec, year)     calculate technology shares for
                                           # every year and country
*    share_electricty_total(reg, year)     share of total electricty production
;

elec_WEO_perc(reg, ind_elec, year) = elec_WEO(reg, ind_elec, year) / sum(ind_elecc, elec_WEO(reg, ind_elecc, year))
*coprodB_subset(reg,prd,regg,ind)   = coprodB(reg,prd,regg,ind) ;
*share_electricty_total(reg, year)  = sum(

Display
elec_WEO_perc
*coprodB_subset ;

* ===================== Declaration of subset (trial) ========================

Sets
         coprodB_subset(reg,prd,regg,ind)       calculate a subset of coprodB
