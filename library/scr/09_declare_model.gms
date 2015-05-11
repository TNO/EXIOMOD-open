* File:   library/scr/09_declare_model.gms
* Author: Trond Husby
* Date:   22 April 2015
* Adjusted: 8 May 2015

* gams-master-file: 00_simulation_prepare.gms

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

Model CGE_MCP
/
demand_CGE_MCP
production_CGE_MCP
trade_CGE_MCP
price_CGE_MCP
/
;
