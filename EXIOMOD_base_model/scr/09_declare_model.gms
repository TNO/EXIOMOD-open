* File:   EXIOMOD_base_model/scr/09_declare_model.gms
* Author: Trond Husby
* Organization: TNO, Netherlands 
* Date:   22 April 2015
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
In this code the full base CGE and Input-Output models are defined. The models
are defined as collection of sub-models as described in different modules.

The two Input-Output models (product technology and industry technology) are
compiled from parts of production and trade modules.

The base CGE model in MCP formulation is compiled from the equations of demand,
production, trade and prices modules.
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ========================== Declare model equations ===========================
* The models here are combined from the models already defined within modules.

* If type of production function differs from 'KL' then don't create input-
* output model.
$if not '%prodfunc%' == 'KL' $goto end_io_models

Model IO_product_technology
/
production_IO_product_technology
trade_IO_product_technology
/
;

Model IO_industry_technology
/
production_IO_industry_technology
trade_IO_industry_technology
/
;

$label end_io_models

Model CGE_MCP
/
demand_CGE_MCP
production_CGE_MCP
trade_CGE_MCP
price_CGE_MCP
/
;
