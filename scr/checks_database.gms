
* File:   checks_database.gms
* Author: Tatyana Bulavskaya
* Date: 3 June 2014
* Adjusted:   22 June 2014

* gams-master-file: load_database.gms

$ontext
This code is used for checking consistency of the social accounting matrix (SAM)
database.

The current version includes the following checks:
 - supply table, as part of SAM: sign and off-diagonal (meaning, by other
   regions) production
 - use table, as part of SAM: sign of intermediate uses
 - balance: balance of SAM, for regions of rest of the world

The code performs all the checks, displaying results of the checks. If at least
one checks fails, the execution is aborted in the end of the code.

Whenever a new type of database is being used, this code should be revised to
include possible additional data checks.
$offtext

Parameters
    SUP_sign(reg_data,ind_data,regg_data,prd_data)  indicator for negative values in the supply table
    SUP_offd(reg_data,ind_data,regg_data,prd_data)  indicator for off-diagonal values in the supply table

    USE_bp_sign(reg_data,prd_data,regg_data,ind_data)  indicator for negative values in the intermediate use table in basic prices
    USE_pp_sign(reg_data,prd_data,regg_data,ind_data)  indicator for negative values in the intermediate use table in producer prices

    BAL_bp_reg(reg_data,full_cat_list)  indicator for disbalanced SAM accounts for the regions in basic prices
    BAL_pp_reg(reg_data,full_cat_list)  indicator for disbalanced SAM accounts for the regions in producer prices
    BAL_bp_row(row_data)  indicator for disbalanced rest of the world accounts in basic prices
    BAL_pp_row(row_data)  indicator for disbalanced rest of the world accounts in producer prices
;

Scalar
    nerrors     total number of errors
;


* Check for negative values in the supply table

SUP_sign(reg_data,ind_data,regg_data,prd_data)$(SAM_bp_data("%base_year%",
    "%base_cur%",reg_data,ind_data,regg_data,prd_data,"Value") lt 0) = 1 ;

Display SUP_sign
;


* Check for positive production by 'other' regions

SUP_offd(reg_data,ind_data,regg_data,prd_data)$(not sameas(reg_data,regg_data)
    and SAM_bp_data("%base_year%","%base_cur%",reg_data,ind_data,regg_data,
    prd_data,"Value") ne 0) = 1 ;

Display SUP_offd
;


* Check for negative values in the intermediate use table

USE_bp_sign(reg_data,prd_data,regg_data,ind_data)$(SAM_bp_data("%base_year%",
    "%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") lt 0) = 1 ;

USE_pp_sign(reg_data,prd_data,regg_data,ind_data)$(SAM_pp_data("%base_year%",
    "%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") lt 0) = 1 ;

Display
USE_bp_sign
USE_pp_sign
;


* Check for SAMs account balance for the regions
* Due to possible rounding, allowed level of discrepancy is 1e-8

BAL_bp_reg(reg_data,full_cat_list) = SUM((all_reg_data,full_catt_list),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,full_cat_list,all_reg_data,
    full_catt_list,"Value") ) - SUM((all_reg_data,full_catt_list),
    SAM_bp_data("%base_year%","%base_cur%",all_reg_data,full_catt_list,reg_data,
    full_cat_list,"Value") ) ;

BAL_bp_reg(reg_data,full_cat_list)$
    (abs(BAL_bp_reg(reg_data,full_cat_list)) lt 1e-8 ) = 0 ;

BAL_bp_reg(reg_data,full_cat_list)$BAL_bp_reg(reg_data,full_cat_list) = 1 ;


BAL_pp_reg(reg_data,full_cat_list) = SUM((all_reg_data,full_catt_list),
    SAM_pp_data("%base_year%","%base_cur%",reg_data,full_cat_list,all_reg_data,
    full_catt_list,"Value") ) - SUM((all_reg_data,full_catt_list),
    SAM_pp_data("%base_year%","%base_cur%",all_reg_data,full_catt_list,reg_data,
    full_cat_list,"Value") ) ;

BAL_pp_reg(reg_data,full_cat_list)$
    (abs(BAL_pp_reg(reg_data,full_cat_list)) lt 1e-8 ) = 0 ;

BAL_pp_reg(reg_data,full_cat_list)$BAL_pp_reg(reg_data,full_cat_list) = 1 ;


Display
BAL_bp_reg
BAL_pp_reg
;


* Check for rest of the world accounts balance
* Due to possible rounding, allowed level of discrepancy is 1e-8

BAL_bp_row(row_data) = SUM((full_cat_list,all_reg_data,full_catt_list),
    SAM_bp_data("%base_year%", "%base_cur%",row_data,full_cat_list,all_reg_data,
    full_catt_list,"Value") ) - SUM((all_reg_data,full_cat_list,full_catt_list),
    SAM_bp_data("%base_year%","%base_cur%",all_reg_data,full_cat_list,row_data,
    full_catt_list,"Value") ) ;

BAL_bp_row(row_data)$(abs(BAL_bp_row(row_data)) lt 1e-8 ) = 0 ;

BAL_bp_row(row_data)$BAL_bp_row(row_data) = 1 ;


BAL_pp_row(row_data) = SUM((full_cat_list,all_reg_data,full_catt_list),
    SAM_pp_data("%base_year%", "%base_cur%",row_data,full_cat_list,all_reg_data,
    full_catt_list,"Value") ) - SUM((all_reg_data,full_cat_list,full_catt_list),
    SAM_pp_data("%base_year%","%base_cur%",all_reg_data,full_cat_list,row_data,
    full_catt_list,"Value") ) ;

BAL_pp_row(row_data)$(abs(BAL_pp_row(row_data)) lt 1e-8 ) = 0 ;

BAL_pp_row(row_data)$BAL_pp_row(row_data) = 1 ;


Display
BAL_bp_row
BAL_pp_row
;

nerrors = SUM((reg_data,ind_data,regg_data,prd_data), SUP_sign(reg_data,
    ind_data,regg_data,prd_data) ) +
    SUM((reg_data,ind_data,regg_data,prd_data), SUP_offd(reg_data,ind_data,
    regg_data,prd_data) ) +
    SUM((reg_data,prd_data,regg_data,ind_data), USE_bp_sign(reg_data,
    prd_data,regg_data,ind_data) ) +
    SUM((reg_data,prd_data,regg_data,ind_data), USE_pp_sign(reg_data,
    prd_data,regg_data,ind_data) ) +
    SUM((reg_data,full_cat_list), BAL_bp_reg(reg_data,full_cat_list) ) +
    SUM((reg_data,full_cat_list), BAL_pp_reg(reg_data,full_cat_list) ) +
    SUM(row_data, BAL_bp_row(row_data) ) +
    SUM(row_data, BAL_pp_row(row_data) );

ABORT$nerrors
    "Errors found in the database, see details in displayed parameters. Total number of errors: ", nerrors ;
