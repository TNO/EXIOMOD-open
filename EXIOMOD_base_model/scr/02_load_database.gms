* File:   EXIOMOD_base_model/scr/02_load_database.gms
* Author: Tatyana Bulavskaya
* Organization: TNO, Netherlands
* Date:   14 May 2014
* Adjusted: 17 Februari 2021 by Hettie Boonman

* gams-master-file: 00_base_model_prepare.gms

********************************************************************************
* THIS MODEL IS A CUSTOM-LICENSE MODEL.
* EXIOMOD 2.0 shall not be used for commercial purposes until an exploitation
* aggreement is signed, subject to similar conditions as for the underlying
* database (EXIOBASE). EXIOBASE limitations are based on open source license
* agreements to be found here:
* http://exiobase.eu/index.php/terms-of-use

* For information on a license, please contact: hettie.boonman@tno.nl
********************************************************************************

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

$Gdxin 'EXIOMOD_base_model\data\EXIOBASE_aggr.gdx'

$loaddc SAM_bp_data = MRSAM_bp_database_aggr0
$loaddc SAM_dt_data = MRSAM_dom_taxsub_database_aggr0
$loaddc SAM_pp_data = MRSAM_pp_database_aggr0
$Gdxin

$if '%db_check%' == 'yes' $include EXIOMOD_base_model/scr/02A_checks_database.gms
