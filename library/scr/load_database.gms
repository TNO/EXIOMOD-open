* File:   library/scr/load_database.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted:   22 June 2014

* gams-master-file: main.gms

* change
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
    SAM_et_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM taxes and subsidies on export of products (revenue goes to the governemnt of the producer)
    SAM_em_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM margins on export of products (revenue is redistributed between sectors)
    SAM_im_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM margins on international transportation (revenue goes to the government of the producer)
    SAM_dt_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM taxes and subsidies on consumption of domestic and imported products (revenue goes to the government of the consumer)
    SAM_pp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM expressed in purchasers prices

*$LIBInclude      xlimport        SAM_bp_data        library/data/SAMdata_open_economy_export_tax_long_format.xlsx   basic_price!a1..g1055
*$LIBInclude      xlimport        SAM_ts_data        library/data/SAMdata_open_economy_export_tax_long_format.xlsx   dom_cons_tax!a1..g1055
*$LIBInclude      xlimport        SAM_et_data        library/data/SAMdata_open_economy_export_tax_long_format.xlsx   export_tax!a1..g1055
*$LIBInclude      xlimport        SAM_pp_data        library/data/SAMdata_open_economy_export_tax_long_format.xlsx   producer_price!a1..g1055

$Gdxin 'library/data/MRSAM'
$loaddc SAM_bp_data = MRSAM_bp_database
*$loaddc SAM_et_data = MRSAM_exp_taxsub_database
*$loaddc SAM_em_data = MRSAM_exp_margin_database
*$loaddc SAM_im_data = MRSAM_int_margin_database
$loaddc SAM_dt_data = MRSAM_dom_taxsub_database
$loaddc SAM_pp_data = MRSAM_bp_database
$Gdxin

$if '%db_check%' == 'yes' $include library/scr/checks_database.gms
