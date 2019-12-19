
$ontext

File:   02-aggregate-ref-data.gms
Author: Anke van den Beukel
Date:   17-12-2019

This script processes the baseline data from CEPII (version 2.2).


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "elec"        ref electricity mix

    2. Data source (should be the same as name of the library)
    "_ref"        ref data

    3. Unit of measurement
    "_level"        absolute value for year t
    "_change"       annual change in t/(t-1)-1

Example of resulting parameter: elec_ref_change


INPUTS
    elec_ref_orig(reg_ref,source_ref,year_ref)      ref electricity data in
                                                    original classification

OUTPUTS
    elec_ref_change                                annual electricity mix change

annual change is expressed in t/(t-1)-1
$offtext

$oneolcom
$eolcom #


* ==================== Declaration of aggregation schemes ======================
Sets

    reg_ref_aggr(reg_ref,reg_data)        aggregation scheme for ref regions
/
$include %project%\01_external_data\EU_reference\sets\aggregation\regions_ref_to_model.txt
/

$ontext
    year_ref_first(year_ref_relevant,year)      aggregation scheme for ref years
/
$include %project%\01_external_data\EU_reference\sets\aggregation\years_ref_to_model_first.txt
/
$offtext

    year_ref_aggr(year_ref_relevant,year)      aggregation scheme for ref years
/
$include %project%\01_external_data\EU_reference\sets\aggregation\years_ref_to_model.txt
/

    year_ref_aggr2(year_ref_relevant,year)      aggregation scheme for ref years
/
$include %project%\01_external_data\EU_reference\sets\aggregation\years_ref_to_model2.txt
/

    source_ref_aggr(source_ref,ind_data)  aggregation scheme for ref sources
/
$include %project%\01_external_data\EU_reference\sets\aggregation\sources_ref_to_model.txt
/
;

Alias (reg_ref,regg_ref) ;

Display reg_data ;
Display reg_ref_aggr ;
Display year_ref_aggr ;
Display source_ref_aggr;

* =========================== Declaration of sets ==============================
Sets

    ind_ref(ind)
/
$include %project%/00_base_model_setup/sets/industries_model_ref.txt
/

    problem_ind(ind_ref)
/
iELCC, iELCG, iELCN, iELCH, iELCW, iELCE
/

Alias (ind_ref, ind_reff) ;



Display ind_ref
problem_ind;



Parameters
Suppy_only_elec_ind(reg,prd,regg,ind)
;

Suppy_only_elec_ind(reg,prd,regg,ind_ref)=SUP(reg,prd,regg,ind_ref) ;

Display
   Suppy_only_elec_ind
;

* ============================ Aggregation of years ============================
$ontext
Parameters
    elec_ref_yr(reg_ref,source_ref_relevant,year)      ref electricity in model years
;

elec_ref_yr(reg_ref,source_ref_relevant,year)$
    sum(reg_data, reg_ref_aggr(reg_ref,reg_data) )
        = sum(year_ref_relevant$year_ref_aggr(year_ref_relevant,year), elec_ref_orig(reg_ref,source_ref_relevant,year_ref_relevant) ) ;

Display elec_ref_yr;
$offtext

* ========================== Aggregation of industries =========================

Parameters
    elec_ref_ind(reg_ref,ind_ref,year_ref_relevant)            ref electricity in model industries
;

elec_ref_ind(reg_ref,ind_ref,year_ref_relevant)
    = sum(ind_data$ind_aggr(ind_data,ind_ref),
        sum(source_ref_relevant$source_ref_aggr(source_ref_relevant,ind_data),
            elec_ref_orig(reg_ref,source_ref_relevant,year_ref_relevant) ) ) ;

Display elec_ref_ind
        ind_aggr;


* =========================== Aggregation of regions ===========================

* The spatial aggregation for productivity uses a different procedure because
* additional weights are needed and there are two options to weigh it. See below.

Parameters
    elec_ref(reg,ind_ref,year_ref_relevant)        ref electricity in model regions
;

elec_ref(reg,ind_ref,year_ref_relevant)
    = sum(reg_data$all_reg_aggr(reg_data,reg),
        sum(reg_ref$reg_ref_aggr(reg_ref,reg_data),
            elec_ref_ind(reg_ref,ind_ref,year_ref_relevant) ) ) ;

Display elec_ref
Display reg
;

Display elec_ref ;


* ====================== Conversion into percentages ==========================

Parameters
    elec_ref_shares(reg,ind_ref,year_ref_relevant)     shares of electricty mix
    sum_elec(reg,year_ref_relevant)
;
sum_elec(reg,year_ref_relevant) = sum(ind_reff, elec_ref(reg,ind_reff,year_ref_relevant) ) ;
elec_ref_shares(reg,ind_ref,year_ref_relevant)$elec_ref(reg,ind_ref,year_ref_relevant) =
    elec_ref(reg,ind_ref,year_ref_relevant) / sum(ind_reff, elec_ref(reg,ind_reff,year_ref_relevant) ) ;


Display
sum_elec
elec_ref_shares ;

* ============================ Aggregation of years ============================
$ontext
Parameters
    elec_ref_shares_yr(reg,ind_ref,year)      ref electricity in model years
;

elec_ref_shares_yr(reg,ind_ref,year)
        = sum(year_ref_relevant$year_ref_first(year_ref_relevant,year), elec_ref_shares(reg,ind_ref,year_ref_relevant) ) ;

Display elec_ref_shares_yr;

$offtext


* ======================= Aggregation of years =======================

Parameters
    all_elec_shares(reg,ind_ref,year)     shares of electricty mix for all years
    year_par                              year parameter
    start_year_interval
    end_year_interval(year)
    elec_ref_shares_yr(reg,ind_ref,year)      ref electricity in model years
;

*Interpolation of years 2016-2019,2021-2024,etc.
elec_ref_shares_yr(reg,ind_ref,year)=
    sum(year_ref_relevant$year_ref_aggr2(year_ref_relevant,year),elec_ref_shares(reg,ind_ref,year_ref_relevant)) +
        ( ord(year)/5 - floor(ord(year)/5 ) ) *
            ( sum(year_ref_relevant$year_ref_aggr(year_ref_relevant,year),elec_ref_shares(reg,ind_ref,year_ref_relevant)) -
                sum(year_ref_relevant$year_ref_aggr2(year_ref_relevant,year),elec_ref_shares(reg,ind_ref,year_ref_relevant) ) ) ;

*Shares for 2020, 2025, etc.
elec_ref_shares_yr(reg,ind_ref,year)$( ord(year)/5 eq floor(ord(year)/5 ) )
     = sum(year_ref_relevant$year_ref_aggr(year_ref_relevant,year),elec_ref_shares(reg,ind_ref,year_ref_relevant)) ;

*Share for 2011
elec_ref_shares_yr(reg,ind_ref,"2011") = coprodB(reg,"pELCC",reg,ind_ref) /
    sum((ind_reff,reggg), coprodB(reg,"pELCC",reggg,ind_reff) )  ;

*Change values for Malta
*** Dit moet ik nog verbeteren ***
$ontext
elec_ref_shares_yr("MLT","iELCC","2011") = 0.000 ;    # Currently 2.76951E-11
elec_ref_shares_yr("MLT","iELCG","2011") = 0.000 ;    # Currently 1.36329E-11
elec_ref_shares_yr("MLT","iELCN","2011") = 0.000 ;    # Currently 8.91004E-11
elec_ref_shares_yr("MLT","iELCH","2011") = 0.000 ;    # Currently 1.34924E-10
elec_ref_shares_yr("MLT","iELCW","2011") = 0.000 ;    # Currently 3.18987E-12
elec_ref_shares_yr("MLT","iELCE","2011") = 0.000 ;    # Currently 9.68170E-13
$offtext

*Share for 2015
elec_ref_shares_yr(reg,ind_ref,"2015") = elec_ref_shares(reg,ind_ref,"y2015") ;
*Interpolation of years 2012-2014
loop(year$( ord(year) > 1 and ord(year) < 5),
    elec_ref_shares_yr(reg,ind_ref,year) =
    elec_ref_shares_yr(reg,ind_ref,"2011") +
    ( elec_ref_shares_yr(reg,ind_ref,"2015") - elec_ref_shares_yr(reg,ind_ref,"2011") )
    * ( (ord(year)-1)/4 )
);

Display
elec_ref_shares_yr
;


loop((problem_ind,year)$(elec_ref_shares_yr("MLT",problem_ind,year) = 0.000),
     elec_ref_shares_yr("MLT",problem_ind,year)
     = elec_ref_shares_yr("MLT",problem_ind,year-1)
);





Display
elec_ref_shares_yr
;

* ====================== Conversion into annual change =========================

Parameters
    elec_ref_change(reg,ind_ref,year)       annual change in electricity mix
;

elec_ref_change(reg,ind_ref,year)$
    elec_ref_shares_yr(reg,ind_ref,year-1)
        = elec_ref_shares_yr(reg,ind_ref,year) / elec_ref_shares_yr(reg,ind_ref,year-1) ;

Display elec_ref_change ;


* *********************** Baseyear should have value one ***********************

*elec_ref_change(reg, ind, "2011")
*    = sum(ind_data$ind_aggr(ind_data,ind),
*      sum(source_ref$source_ref_aggr(source_ref,ind_data),
*            1 ) ) ;
*Display elec_ref_change ;

elec_ref_change(reg,ind_ref,"2011")   =   1 ;
Display
elec_ref_change
coprodB
;



******************* Trial sum ********************
Parameters
trial_sum(reg)                   Calculate how much of pELCC comes from electricity industries (ie ind_ref)
trial_share(reg,ind_ref)         Calculate the share of pELCC out of total supply of ind_ref
relevant_supply(reg,prd,ind_ref)
;

trial_sum(reg) = sum((ind_reff,reggg), coprodB(reg,"pELCC",reggg,ind_reff) );
trial_share(reg,ind_ref)$sum(prd, SUP(reg,prd,reg,ind_ref)) =  SUP(reg,"pELCC",reg,ind_ref) / sum(prd, SUP(reg,prd,reg,ind_ref));
relevant_supply(reg,prd,ind_ref) = SUP(reg,prd,reg,ind_ref) ;

Display
trial_sum
trial_share
relevant_supply
;


