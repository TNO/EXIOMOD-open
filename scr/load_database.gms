
* ============================= Load the database ==============================
Parameters
         SUP_data(year_data,cur_data,full_reg_list,full_row_list,full_regg_list,full_col_list,*)      raw supply data
         USE_data(year_data,cur_data,full_reg_list,full_row_list,full_regg_list,full_col_list,*)      raw use data
;

$LIBInclude      xlimport        SUP_data        data/SUTdata_long_format.xlsx   Supply!a1..g65
$LIBInclude      xlimport        USE_data        data/SUTdata_long_format.xlsx   Use!a1..g170

$include scr/checks_database.gms
