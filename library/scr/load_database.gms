* File:   library/scr/load_database.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted:   19 February 2014

* gams-master-file: main.gms

* change
$ontext startdoc
This gms file is one of the gms files called from the `main.gms` file.

Parameters are read in by loading the social accounting matrix database
from a gdx file.

It defines the following parameters:

$offtext
* ============================= Load the database ==============================
Parameters
    SAM_bp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM expressed in basic prices
    SAM_et_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM taxes and subsidies on export of products (revenue goes to the governemnt of the producer)
    SAM_em_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM margins on export of products (revenue is redistributed between sectors)
    SAM_im_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM margins on international transportation (revenue goes to the government of the producer)
    SAM_dt_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM taxes and subsidies on consumption of domestic and imported products (revenue goes to the government of the consumer)
    SAM_pp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)      raw SAM expressed in purchasers prices
 ;

$Gdxin '\\tsn.tno.nl\Data\SV\sv-016648\Databank Economen\European data\EXIOBASE_MRSUT\20141031_version_60sec\MRSUT_to_MRSAM\MRSAM'
$loaddc SAM_bp_data = MRSAM_bp_database
*$loaddc SAM_et_data = MRSAM_exp_taxsub_database
*$loaddc SAM_em_data = MRSAM_exp_margin_database
*$loaddc SAM_im_data = MRSAM_int_margin_database
$loaddc SAM_dt_data = MRSAM_dom_taxsub_database
$loaddc SAM_pp_data = MRSAM_bp_database
$Gdxin

$if '%db_check%' == 'yes' $include library/scr/checks_database.gms
