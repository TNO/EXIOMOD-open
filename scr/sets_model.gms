* File:   scr/set_model.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014

$ontext startdoc
This `.gms` file is one of the `.gms` files part of the `main.gms` file and includes the equations and model formulation. Please start from `main.gms`.

This `.gms` file consists of the following parts:

### Declaration of sets for the model

The following sets are defined:

Set name         | Explanation
---------------- | ----------
`reg`            | regions used for the model `regions_model.txt`
`row`            | rest of the world regions used in the model `restoftheworld_model.txt`
`prd`            | products `products_model.txt`
`va`             | value added `valueadded_model.txt`
`tsp`            | taxes and subsidies `taxesandsubsidiesonproducts_model.txt`
`uip`            | imports `useofimportedproducts_model.txt`
`inm`            | international margins `internationalmargins_model.txt`
`val`            | valuation categories `valuation_model.txt`
`use_col`        | use table (columns) consists of `ind`, `fd` and `exp` explaned on the next lines
`ind(use_col)`   | 19 industries `industries_model.txt`, a subset of `use_col`
`fd(use_col)`    | final demand `finaldemand_model.txt`, a subset of `use_col`
`exp(use_col)`   | exports `export_model.txt`, a subset of `use_col`



### Declaration of aggregation scheme

The aggregation scheme consists of mappings used for aggregations of the (above) sets from dimension1 to dimension2:

map name (dimension1, dimension2)       | Explanation
--------------------------------------- | -----------
`reg_aggr(reg_data,reg)`                | Aggregates scheme for regions `regions_database_to_model.txt `
`prd_aggr(prd_data,prd)`                | Aggregates scheme for products `products_database_to_model.txt`
`ind_aggr(ind_data,ind)`                | Aggregates scheme for industries `industries_database_to_model.txt`
`fd_aggr(fd_data,fd)`                   | Aggregates scheme for final demand `finaldemand_database_to_model.txt`
`va_aggr(va_data,va)`                   | Aggregates scheme for value added `valueadded_database_to_model.txt`
`exp_aggr(exp_data,exp)`                | Aggregates scheme for exports `export_database_to_model.txt`
`val_aggr(val_data,val)`                | Aggregates scheme for valuation categories `valuation_database_to_model.txt`
`row_aggr(full_reg_list,row)`           | Aggregates scheme for rest of the world `restoftheworld_database_to_model.txt`
`tsp_aggr(tsp_data,tsp)`                | Aggregates scheme for taxes and subsidies `taxesandsubsidiesonproducts_database_to_model.txt`
`uip_aggr(uip_data,uip)`                | Aggregates scheme for imports `useofimportedproducts_database_to_model.txt`
`prd_uip_aggr(prd_data,uip)`            | Aggregates scheme from products to imported products categories `products_to_uip_model.txt`
`inm_aggr(inm_data,inm)`                | Aggregates scheme for international margins categories `internationalmargins_database_to_model.txt`



### Declaration of aliases

Sometimes it is necessary to have more than one name for the same set. Aliases are created by repeating the last character of the original set a number of times. We define the following aliases:

Original set | Aliases (new names for the original set)
------------ | ----------------------------------------
`reg`        | `regg`, `reggg`
`prd`        | `prdd`, `prddd`
`ind`        | `indd`, `inddd`

More detailed information about the sets and mappings can be found in the corresponding `.txt` file. All sets and maps can be changed to any level of details.
For this the `.txt` files should be changed (sets and/or maps). This sets and maps in this file are mainly used in `aggregate_database.gms`, `model_parameters.gms` and `model_variables_equations.gms`
$offtext

* ===================== Declaration of sets for the model ======================

Sets
         full_reg_m      full list of regions in the model
/
$include sets/model/regions_model.txt
$include sets/model/restoftheworld_model.txt
/

         reg(full_reg_m)  list of regions in the model
/
$include sets/model/regions_model.txt
/

         row(full_reg_m)  list of rest of the world regions in the model
/
$include sets/model/restoftheworld_model.txt
/
;

Sets
         prd             list of products in the model
/
$include sets/model/products_model.txt
/

         va              list of value added categories in the model
/
$include sets/model/valueadded_model.txt
/

         tsp             list of taxes and subsidies on products in the model
/
$include sets/model/taxesandsubsidiesonproducts_model.txt
/

         uip             use of imported products categories in the model
/
$include sets/model/useofimportedproducts_model.txt
/
;

Sets
         use_col         columns is use table - declared for convenience
/
$include sets/model/industries_model.txt
$include sets/model/finaldemand_model.txt
$include sets/model/export_model.txt
/

         ind(use_col)    list of industries in the model
/
$include sets/model/industries_model.txt
/

         fd(use_col)     list of final demand categories in the model
/
$include sets/model/finaldemand_model.txt
/

         exp(use_col)    list of export categories in the model
/
$include sets/model/export_model.txt
/
;

* ===================== Declaration of aggregation scheme ======================
Sets
         reg_full_aggr(full_reg_list,full_reg_m)  aggregation scheme for full list of regions
/
$include sets/model/aggregation/regions_full_database_to_model.txt
/

         prd_aggr(prd_data,prd)          aggregation scheme for products
/
$include sets/model/aggregation/products_database_to_model.txt
/

         ind_aggr(ind_data,ind)          aggregation scheme for industries
/
$include sets/model/aggregation/industries_database_to_model.txt
/

         fd_aggr(fd_data,fd)             aggregation scheme for final demand categories
/
$include sets/model/aggregation/finaldemand_database_to_model.txt
/

         va_aggr(va_data,va)             aggregation scheme for value added categories
/
$include sets/model/aggregation/valueadded_database_to_model.txt
/

         exp_aggr(exp_data,exp)          aggregation scheme for export categories
/
$include sets/model/aggregation/export_database_to_model.txt
/

         tsp_aggr(tsp_data,tsp)          aggregation scheme for taxes and subsidies on products
/
$include sets/model/aggregation/taxesandsubsidiesonproducts_database_to_model.txt
/

         uip_aggr(uip_data,uip)          aggregation scheme for use of imported products categories
/
$include sets/model/aggregation/useofimportedproducts_database_to_model.txt
/

         prd_uip_aggr(prd_data,uip)      aggregation scheme from products to imported products categories
/
$include sets/model/aggregation/products_to_uip_model.txt
/
;

* ===================== Declaration of aliases =================================
Alias
         (reg,regg,reggg)
         (prd,prdd,prddd)
         (ind,indd,inddd)
;


* If product technology is used, check that number of products is equal to
* number of sectors

$if not '%io_type%' == 'product_technology' $goto aggregation_check

ABORT$(CARD(prd) ne CARD(ind)) "number of products and industries should be the same for Product technology assumption"


$label aggregation_check
* Check that all aggregation schemes are correct

$if not '%agg_check%' == 'yes' $goto endofcode

$BATINCLUDE "scr/snippets/setaggregationcheck" full_reg_list   full_reg_m   reg_full_aggr
$BATINCLUDE "scr/snippets/setaggregationcheck" prd_data        prd          prd_aggr
$BATINCLUDE "scr/snippets/setaggregationcheck" ind_data        ind          ind_aggr
$BATINCLUDE "scr/snippets/setaggregationcheck" fd_data         fd           fd_aggr
$BATINCLUDE "scr/snippets/setaggregationcheck" va_data         va           va_aggr
$BATINCLUDE "scr/snippets/setaggregationcheck" exp_data        exp          exp_aggr
$BATINCLUDE "scr/snippets/setaggregationcheck" tsp_data        tsp          tsp_aggr
$BATINCLUDE "scr/snippets/setaggregationcheck" uip_data        uip          uip_aggr
$BATINCLUDE "scr/snippets/setaggregationcheck" prd_data        uip          prd_uip_aggr


$label endofcode
