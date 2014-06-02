$ontext
This gms file is one of the gms files called from the 'main.gms' file. 

It defines two types of parameters:
  1. SUP_data
  2. USE_data

It calibrates these parameters by loading the input-output/supply-use database from an xlsx file.

$offtext
* ============================= Load the database ==============================
Parameters
         SUP_data(year_data,cur_data,full_reg_list,full_row_list,full_regg_list,full_col_list,*)      raw supply data
         USE_data(year_data,cur_data,full_reg_list,full_row_list,full_regg_list,full_col_list,*)      raw use data
;

$LIBInclude      xlimport        SUP_data        data/SUTdata_long_format.xlsx   Supply!a1..g65
$LIBInclude      xlimport        USE_data        data/SUTdata_long_format.xlsx   Use!a1..g170
