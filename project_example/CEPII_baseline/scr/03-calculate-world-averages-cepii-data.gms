$ontext

File:   03-calculate-world-averages-cepii-data.gms
Author: Jinxue Hu
Date:   06-07-2015

This script calculates world averages from the baseline data from CEPII.
$offtext

$oneolcom
$eolcom #

* *************************** World averages values ****************************

Parameter
    tot_POP_CEPII_change(*)         world average population growth
    tot_PRODKL_CEPII_change(*)      world average capital-labour productivity
                                    # growth
    tot_PRODE_CEPII_change(*)       world average energy productivity growth
;

tot_POP_CEPII_change(year)$(ord(year) gt 7)
    =  sum(regg, POP_CEPII_level(regg,year) ) / sum(regg, POP_CEPII_level(regg,year-1) ) ;

tot_POP_CEPII_change("total")
    =  ( sum(regg, POP_CEPII_level(regg,"2050") ) / sum(regg, POP_CEPII_level(regg,"2007") ) ) ** ( 1 / 43 ) ;


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


tot_PRODE_CEPII_change(year)$
    sum(reg,sum(regg_CP$reg_CP_aggr(regg_CP,reg),
    GDP_CP_yr(regg_CP,year) ) )
                = sum(reg,
                    sum(reg_CP$reg_CP_aggr(reg_CP,reg),
                    prodE_change_CP_yr(reg_CP,year) * GDP_CP_yr(reg_CP,year) ) )
                / sum(reg,
                    sum(regg_CP$reg_CP_aggr(regg_CP,reg),
                    GDP_CP_yr(regg_CP,year) ) ) ;

tot_PRODE_CEPII_change("total")
                = sum(reg,
                    sum(reg_CP$reg_CP_aggr(reg_CP,reg),
                    prodE_change_CP_yr(reg_CP,"2050") * GDP_CP_yr(reg_CP,"2050") ) )
                / sum(reg,
                    sum(regg_CP$reg_CP_aggr(regg_CP,reg),
                    GDP_CP_yr(regg_CP,"2050") ) ) ;

Display tot_POP_CEPII_change, tot_PRODKL_CEPII_change, tot_PRODE_CEPII_change ;
