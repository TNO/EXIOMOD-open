* File:   EXIOMOD_base_model/scr/02_load_database.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted:   19 February 2014

* gams-master-file: 00_simulation_prepare.gms

$ontext startdoc
Parameters are read in by loading the social accounting matrix database
from a .gdx file.

The code loads the following parameters:

- Multi-regional social accounting matrix in basic prices.
- Multi-regional social accounting matrix of taxes products.
- Multi-regional social accounting matrix in purchasers prices.

$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ============================= Load the database ==============================
Parameters
    SAM_bp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)
                            # raw SAM expressed in basic prices
    SAM_dt_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)
                            # raw SAM taxes and subsidies on consumption of
                            # domestic and imported products (revenue goes to
                            # the government of the consumer)
    SAM_pp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,*)
                            # raw SAM expressed in purchasers prices
 ;

$Gdxin '\\tsn.tno.nl\Data\SV\sv-016648\Databank Economen\European data\EXIOBASE_MRSUT\20150611_version_90sec\MRSUT_to_MRSAM\MRSAM'

$loaddc SAM_bp_data = MRSAM_bp_database
$loaddc SAM_dt_data = MRSAM_dom_taxsub_database
$loaddc SAM_pp_data = MRSAM_bp_database
$Gdxin

$if '%db_check%' == 'yes' $include EXIOMOD_base_model/scr/02A_checks_database.gms
