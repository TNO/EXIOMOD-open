
$ontext

File:   read-cepii-data.gms
Author: Jinxue Hu
Date:   18-02-2015

This script processes the baseline data from CEPII (version 2.1).


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "PRODKL"        productivity for capital-labour

    2. Data source (should be the same as name of the library)
    "_CEPII"        Cepii database

    3. Unit of measurement
    "_level"        absolute value for year t
    "_change"       annual change in t/(t-1)-1

Example of resulting parameter: PRODKL_CEPII_change


INPUTS
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

OUTPUTS
    GDP_CEPII_change(reg,year)          annual change in GDP based on cepii data
    PRODKL_CEPII_change(reg,year)       annual change in capital-labour
                                        productivity based on cepii data
    PRODE_CEPII_change(reg,year)        annual change in energy productivity
                                        based on cepii data
    KS_CEPII_change(reg,year)           annual change in capital stock based on
                                        cepii data
    LS_CEPII_change(reg,year)           annual change in labour supply based on
                                        cepii data
    E_CEPII_change(reg,year)            annual change in energy consumption
                                        based on cepii data
    POP_CEPII_level(reg,year)           cepii population in thousands model
                                        classification

annual change is expressed in t/(t-1)-1
$offtext

$oneolcom
$eolcom #


* ==================== Declaration of aggregation schemes ======================
Sets

    reg_CP_aggr(reg_CP,reg)         aggregation scheme for cepii regions
/
$include %project%\CEPII_baseline\sets\aggregation\regions_cepii_to_model.txt
/

    year_CP_aggr(year_CP,year)      aggregation scheme for cepii years
/
$include %project%\CEPII_baseline\sets\aggregation\years_cepii_to_model.txt
/
;


Alias (reg_CP,regg_CP) ;

* ============================ Aggregation of years ============================


Parameters
    GDP_CP_yr(reg_CP,year)      cepii GDP in model years
    prodKL_CP_yr(reg_CP,year)   cepii capital-labour productivity in model
                                # years
    prodE_CP_yr(reg_CP,year)    cepii energy productivity in model years
    KS_CP_yr(reg_CP,year)       cepii capital stock in model years
    LS_CP_yr(reg_CP,year)       cepii labour supply in model years
    E_CP_yr(reg_CP,year)        cepii energy consumption in model years
    POP_CP_yr(reg_CP,year)      cepii population in model years
;

GDP_CP_yr(reg_CP,year)$
    sum(reg, reg_CP_aggr(reg_CP,reg) )
        = sum(year_CP$year_CP_aggr(year_CP,year), GDP_CEPII_orig(reg_CP,year_CP) ) ;

prodKL_CP_yr(reg_CP,year)$
    sum(reg, reg_CP_aggr(reg_CP,reg) )
        = sum(year_CP$year_CP_aggr(year_CP,year), prodKL_CEPII_orig(reg_CP,year_CP) ) ;

prodE_CP_yr(reg_CP,year)$
    sum(reg, reg_CP_aggr(reg_CP,reg) )
        = sum(year_CP$year_CP_aggr(year_CP,year), prodE_CEPII_orig(reg_CP,year_CP) ) ;

KS_CP_yr(reg_CP,year)$
    sum(reg, reg_CP_aggr(reg_CP,reg) )
        = sum(year_CP$year_CP_aggr(year_CP,year), KS_CEPII_orig(reg_CP,year_CP) ) ;

LS_CP_yr(reg_CP,year)$
    sum(reg, reg_CP_aggr(reg_CP,reg) )
        = sum(year_CP$year_CP_aggr(year_CP,year), LS_CEPII_orig(reg_CP,year_CP) ) ;

E_CP_yr(reg_CP,year)$
    sum(reg, reg_CP_aggr(reg_CP,reg) )
        = sum(year_CP$year_CP_aggr(year_CP,year), E_CEPII_orig(reg_CP,year_CP) ) ;

POP_CP_yr(reg_CP,year)$
    sum(reg, reg_CP_aggr(reg_CP,reg) )
        = sum(year_CP$year_CP_aggr(year_CP,year), POP_CEPII_orig(reg_CP,year_CP) ) ;
Display POP_CP_yr ;
* =========================== Aggregation of regions ===========================


Parameters
    GDP_CP(reg,year)        cepii GDP in model classification
    prodKL_CP(reg,year)     cepii capital-labour productivity in model
                            # classification
    prodE_CP(reg,year)      cepii energy productivity in model classification
    KS_CP(reg,year)         cepii capital stock in model classification
    LS_CP(reg,year)         cepii labour supply in model classification
    E_CP(reg,year)          cepii energy consumption in model classification
    POP_CEPII_level(reg,year)   cepii population in model classification
;

GDP_CP(reg,year)    = sum(reg_CP$reg_CP_aggr(reg_CP,reg), GDP_CP_yr(reg_CP,year) ) ;
KS_CP(reg,year)     = sum(reg_CP$reg_CP_aggr(reg_CP,reg), KS_CP_yr(reg_CP,year) ) ;
LS_CP(reg,year)     = sum(reg_CP$reg_CP_aggr(reg_CP,reg), LS_CP_yr(reg_CP,year) ) ;
E_CP(reg,year)      = sum(reg_CP$reg_CP_aggr(reg_CP,reg), E_CP_yr(reg_CP,year) ) ;
POP_CEPII_level(reg,year)
                    = sum(reg_CP$reg_CP_aggr(reg_CP,reg), POP_CP_yr(reg_CP,year) ) ;

* ====================== Conversion into annual change =========================


Parameters
    GDP_CEPII_change(reg,year)      annual change in GDP based on cepii data
    PRODKL_CEPII_change(reg,year)   annual change in capital-labour
                                    # productivity based on cepii data
    PRODE_CEPII_change(reg,year)    annual change in energy productivity
                                    # based on cepii data
    KS_CEPII_change(reg,year)       annual change in capital stock based on
                                    # cepii data
    LS_CEPII_change(reg,year)       annual change in labour supply based on
                                    #cepii data
    E_CEPII_change(reg,year)        annual change in energy consumption based
                                    # on cepii data
;

GDP_CEPII_change(reg,year)$
    GDP_CP(reg,year-1)
        = GDP_CP(reg,year) / GDP_CP(reg,year-1) ;

KS_CEPII_change(reg,year)$
    KS_CP(reg,year-1)
        = KS_CP(reg,year) / KS_CP(reg,year-1)  ;

LS_CEPII_change(reg,year)$
    LS_CP(reg,year-1)
        = LS_CP(reg,year) / LS_CP(reg,year-1)  ;

E_CEPII_change(reg,year)$
    LS_CP(reg,year-1)
        = E_CP(reg,year) / E_CP(reg,year-1)  ;


* ======================== Aggregation of productivity =========================

* Aggregated productivity would ideally be based on a re-estimation of the
* productivity, using the original underlying data. Unfortunately we dont have
* this and will therefore take a weighted average. Perhaps in a later stage we
* can implement a proper module.

* Option 1: Take weighted average of growth rates, using GDP weights.
* (option 1 is our preferred option for now)
* Option 2: Take weighted average of productivity, using labour supply or
* primary energy consumption as weights.

* Then derive growth rates.


* Option 1
Parameters
    prodKL_change_CP_yr(reg_CP,year)    annual change in capital-labour
                                        # productivity based on cepii data
    prodE_change_CP_yr(reg_CP,year)     annual change in energy productivity
                                        # based on cepii data
;

prodKL_change_CP_yr(reg_CP,year)$
    prodKL_CP_yr(reg_CP,year-1)
            = prodKL_CP_yr(reg_CP,year) / prodKL_CP_yr(reg_CP,year-1) ;

prodE_change_CP_yr(reg_CP,year)$
    prodE_CP_yr(reg_CP,year-1)
            = prodE_CP_yr(reg_CP,year)  / prodE_CP_yr(reg_CP,year-1)  ;

PRODKL_CEPII_change(reg,year)$
            sum(regg_CP$reg_CP_aggr(regg_CP,reg), GDP_CP_yr(regg_CP,year) )
                = sum(reg_CP$reg_CP_aggr(reg_CP,reg),
                    prodKL_change_CP_yr(reg_CP,year) * GDP_CP_yr(reg_CP,year) )
                / sum(regg_CP$reg_CP_aggr(regg_CP,reg),
                    GDP_CP_yr(regg_CP,year) ) ;

PRODE_CEPII_change(reg,year)$
            sum(regg_CP$reg_CP_aggr(regg_CP,reg), GDP_CP_yr(regg_CP,year) )
                = sum(reg_CP$reg_CP_aggr(reg_CP,reg),
                    prodE_change_CP_yr(reg_CP,year) * GDP_CP_yr(reg_CP,year) )
                / sum(regg_CP$reg_CP_aggr(regg_CP,reg),
                    GDP_CP_yr(regg_CP,year) ) ;



* Option 2
$ontext
prodKL_CP(reg,year)$
             sum(regg_CP$reg_CP_aggr(regg_CP,reg), LS_CP_yr(regg_CP,year) )
                    =
                    sum(reg_CP$reg_CP_aggr(reg_CP,reg),
                         prodKL_CP_yr(reg_CP,year) * LS_CP_yr(reg_CP,year) )
                    / sum(regg_CP$reg_CP_aggr(regg_CP,reg),
                         LS_CP_yr(regg_CP,year) ) ;

prodE_CP(reg,year)$
             sum(regg_CP$reg_CP_aggr(regg_CP,reg), E_CP_yr(regg_CP,year) )
                    =
                    sum(reg_CP$reg_CP_aggr(reg_CP,reg),
                         prodE_CP_yr(reg_CP,year) * E_CP_yr(reg_CP,year) )
                    / sum(regg_CP$reg_CP_aggr(regg_CP,reg),
                         E_CP_yr(regg_CP,year) ) ;

PRODKL_CEPII_change(reg,year)$
    prodKL_CP(reg,year-1)
        = prodKL_CP(reg,year) / prodKL_CP(reg,year-1) ;

PRODE_CEPII_change(reg,year)$
    prodE_CP(reg,year-1)
        = prodE_CP(reg,year)  / prodE_CP(reg,year-1)  ;
$offtext


$ontext
$libinclude xldump GDP_CEPII_change    cepii_baseline_data.xlsx GDP_CEPII_change
$libinclude xldump PRODKL_CEPII_change cepii_baseline_data.xlsx PRODKL_CEPII_change
$libinclude xldump PRODE_CEPII_change  cepii_baseline_data.xlsx PRODE_CEPII_change
$libinclude xldump KS_CEPII_change     cepii_baseline_data.xlsx KS_CEPII_change
$libinclude xldump LS_CEPII_change     cepii_baseline_data.xlsx LS_CEPII_change
$libinclude xldump E_CEPII_change      cepii_baseline_data.xlsx E_CEPII_change
$offtext


* ************************* Gap filling missing countries **********************

* Three EXIOBASE countries are missing in the CEPII dataset (reg_CP_miss).
* These are SI TW CY, assign the value of a comparable country (reg_CP_comp).
* This is only done when model regions include any of these three countries.

Sets
    reg_CP_miss       regions missing in Cepii regions
    / SI, TW, CY /

    reg_CP_comp(*,*)  comparable regions of missing regions
    / SI.SK, TW.CN, CY.MT /
;


Loop(reg$reg_CP_miss(reg),
        KS_CEPII_change(reg,year)      = sum(regg$reg_CP_comp(reg,regg), KS_CEPII_change(regg,year) ) ;
        LS_CEPII_change(reg,year)      = sum(regg$reg_CP_comp(reg,regg), LS_CEPII_change(regg,year) ) ;
        PRODKL_CEPII_change(reg,year)  = sum(regg$reg_CP_comp(reg,regg), PRODKL_CEPII_change(regg,year) ) ;
        PRODE_CEPII_change(reg,year)   = sum(regg$reg_CP_comp(reg,regg), PRODE_CEPII_change(regg,year) ) ;
        E_CEPII_change(reg,year)       = sum(regg$reg_CP_comp(reg,regg), E_CEPII_change(regg,year) ) ;
        GDP_CEPII_change(reg,year)     = sum(regg$reg_CP_comp(reg,regg), GDP_CEPII_change(regg,year) ) ;
) ;

Parameter pop_data_miss(*,year)
/   SI .2007 =  2010377
    TW .2007 = 22918000
    CY .2007 =   757916 / ;


POP_CEPII_level(reg,year)$reg_CP_miss(reg)
    = pop_data_miss(reg,year)
    * sum(regg$(reg_CP_comp(reg,regg) and POP_CEPII_level(regg,year-1)),
            POP_CEPII_level(regg,year) / POP_CEPII_level(regg,year-1) ) ;

Parameter pop_eurostat(*,year) ;




* *********************** Baseyear should have value one ***********************

KS_CEPII_change(reg,"2007")      = 1 ;
LS_CEPII_change(reg,"2007")      = 1 ;
PRODKL_CEPII_change(reg,"2007")  = 1 ;
PRODE_CEPII_change(reg,"2007")   = 1 ;
E_CEPII_change(reg,"2007")       = 1 ;
GDP_CEPII_change(reg,"2007")     = 1 ;

Display KS_CEPII_change
        LS_CEPII_change
        PRODKL_CEPII_change
        PRODE_CEPII_change
        POP_CEPII_level
;

* *************************** World averages values ****************************

Parameter
    tot_POP_CEPII_change(*)         world average population growth
    tot_PRODKL_CEPII_change(*)
;

tot_POP_CEPII_change(year)$(ord(year) gt 7)
    =  sum(regg, POP_CEPII_level(regg,year) ) / sum(regg, POP_CEPII_level(regg,year-1) ) ;

tot_POP_CEPII_change("total")
    =  ( sum(regg, POP_CEPII_level(regg,"2050") ) / sum(regg, POP_CEPII_level(regg,"2007") ) ) ** ( 1 / 43 ) ;

*tot_POP_CEPII_change("EU")
*    =  ( sum(EU, POP_CEPII_level(EU,"2050") ) / sum(EU, POP_CEPII_level(EU,"2007") ) ) ** ( 1 / 43 ) ;


tot_PRODKL_CEPII_change(year)$
    sum(reg,sum(regg_CP$reg_CP_aggr(regg_CP,reg),
    GDP_CP_yr(regg_CP,year) ) )
                = sum(reg,
                    sum(reg_CP$reg_CP_aggr(reg_CP,reg),
                    prodKL_change_CP_yr(reg_CP,year) * GDP_CP_yr(reg_CP,year) ) )
                / sum(reg,
                    sum(regg_CP$reg_CP_aggr(regg_CP,reg),
                    GDP_CP_yr(regg_CP,year) ) ) ;

tot_PRODKL_CEPII_change("total")
                = sum(reg,
                    sum(reg_CP$reg_CP_aggr(reg_CP,reg),
                    prodKL_change_CP_yr(reg_CP,"2050") * GDP_CP_yr(reg_CP,"2050") ) )
                / sum(reg,
                    sum(regg_CP$reg_CP_aggr(regg_CP,reg),
                    GDP_CP_yr(regg_CP,"2050") ) ) ;

*tot_PRODKL_CEPII_change("EU")
*                = sum(EU,
*                    sum(reg_CP$reg_CP_aggr(reg_CP,EU),
*                    prodKL_change_CP_yr(reg_CP,"2050") * GDP_CP_yr(reg_CP,"2050") ) )
*                / sum(EU,
*                    sum(regg_CP$reg_CP_aggr(regg_CP,EU),
*                    GDP_CP_yr(regg_CP,"2050") ) ) ;

Display tot_POP_CEPII_change, tot_PRODKL_CEPII_change ;
