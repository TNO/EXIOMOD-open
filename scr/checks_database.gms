
*' checks_database.gms
*' author: Tatyana Bulavskaya
*' date: 3 June 2014

* gams-master-file: load_database.gms

$ontext
This code is used for checking consistency of the supply-use database.

The current version includes the following checks:
 - supply table: sign and off-diagonal (meaning, by other regions) production
 - use table: sign of intermediate uses
 - balance: product and industry balance between supply and use

The code performs all the checks, displaying results of the checks. If at least
one checks fails, the execution is aborted in the end of the code.

Whenever a new type of database is being used, this code should be revised to
include possible additional data checks.
$offtext

Parameters
    SUP_sign(reg_data,prd_data,regg_data,ind_data)  indicator for negative values in the supply table
    SUP_offd(reg_data,prd_data,regg_data,ind_data)  indicator for off-diagonal values in the supply table

    USE_sign(reg_data,prd_data,regg_data,ind_data)  indicator for negative values in the intermediate use table

    BAL_prd(reg_data,prd_data)  indicator for disbalanced product account
    BAL_ind(reg_data,ind_data)  indicator for disbalanced industry account
;

Scalar
    nerrors     total number of errors
;


* Check for negative values in the supply table

SUP_sign(reg_data,prd_data,regg_data,ind_data)$(SUP_data("%base_year%",
    "%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") lt 0) = 1 ;

Display SUP_sign
;


* Check for positive production by 'other' regions

SUP_offd(reg_data,prd_data,regg_data,ind_data)$(not sameas(reg_data,regg_data)
    and SUP_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,
    ind_data,"Value") ne 0) = 1 ;

Display SUP_offd
;


* Check for negative values in the intermediate use table

USE_sign(reg_data,prd_data,regg_data,ind_data)$(USE_data("%base_year%",
    "%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") lt 0) = 1 ;

Display USE_sign
;


* Check for product account balance
* Due to possible rounding, allowed level of discrepancy is 1e-8

BAL_prd(reg_data,prd_data) = SUM((regg_data,ind_data), SUP_data("%base_year%",
    "%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) -
    SUM((full_reg_list,full_col_list), USE_data("%base_year%",
    "%base_cur%",reg_data,prd_data,full_reg_list,full_col_list,"Value") ) ;

BAL_prd(reg_data,prd_data)$(abs(BAL_prd(reg_data,prd_data)) lt 1e-8 ) = 0 ;

BAL_prd(reg_data,prd_data)$BAL_prd(reg_data,prd_data) = 1 ;

Display BAL_prd
;


* Check for industry account balance
* Due to possible rounding, allowed level of discrepancy is 1e-8

BAL_ind(reg_data,ind_data) = SUM((regg_data,prd_data), SUP_data("%base_year%",
    "%base_cur%",regg_data,prd_data,reg_data,ind_data,"Value") ) -
    SUM((full_reg_list,full_row_list), USE_data("%base_year%",
    "%base_cur%",full_reg_list,full_row_list,reg_data,ind_data,"Value") ) ;

BAL_ind(reg_data,ind_data)$(abs(BAL_ind(reg_data,ind_data)) lt 1e-8 ) = 0 ;

BAL_ind(reg_data,ind_data)$BAL_ind(reg_data,ind_data) = 1 ;

Display BAL_ind
;

nerrors = SUM((reg_data,prd_data,regg_data,ind_data), SUP_sign(reg_data,
    prd_data,regg_data,ind_data) ) +
    SUM((reg_data,prd_data,regg_data,ind_data), SUP_offd(reg_data,prd_data,
    regg_data,ind_data) ) +
    SUM((reg_data,prd_data,regg_data,ind_data), USE_sign(reg_data,
    prd_data,regg_data,ind_data) ) +
    SUM((reg_data,prd_data), BAL_prd(reg_data,prd_data) ) +
    SUM((reg_data,ind_data), BAL_ind(reg_data,ind_data) ) ;

ABORT$nerrors
    "Errors found in the database, see details in displayed parameters. Total number of errors: ", nerrors ;
