* File:   library/scr/load_database.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted:   22 June 2014

* gams-master-file: main.gms

$ontext startdoc
This gms file is one of the gms files called from the `main.gms` file.

It defines three types of parameters:

  1. SAM_bp_data - social accounting matrix (SAM) expressed in basic prices.
  2. SAM_tx_data - tax layer showing next taxes on produces associated with
     transactions in the social accounting matrix.
  3. SAM_pp_data - social accounting matrix expressed in producers prices, it is
     equal to sum of the SAM in basic prices and the tax layer.

It calibrates these parameters by loading the social accounting matrix database
from an xlsx file.

$offtext
* ============================= Load the database ==============================
Parameters
         SAM_bp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM expressed in basic prices
         SAM_ts_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM taxes and subsidies on products layer
         SAM_pp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM expressed in producer prices
;

$LIBInclude      xlimport        SAM_bp_data        library/data/SAMdata_open_economy_long_format.xlsx   basic_price!a1..g1055
$LIBInclude      xlimport        SAM_ts_data        library/data/SAMdata_open_economy_long_format.xlsx   tax_layer!a1..g1055
$LIBInclude      xlimport        SAM_pp_data        library/data/SAMdata_open_economy_long_format.xlsx   producer_price!a1..g1055

$if '%db_check%' == 'yes' $include library/scr/checks_database.gms
