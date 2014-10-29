* File:   library/scr/set_model.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted:   23 June 2014

* gams-master-file: main.gms

$ontext startdoc
This `.gms` file is one of the `.gms` files part of the `main.gms` file and
includes the equations and model formulation. Please start from `main.gms`.

This `.gms` file consists of the following parts:

### Declaration of sets for the model

The following sets are defined:

Set name         | Explanation
---------------- | ----------
`reg`            | regions used for the model `regions_model.txt`
`row`            | rest of the world regions used in the model `restoftheworld_model.txt`
`prd`            | products `products_model.txt`
`ind`            | industries `industries_model.txt`
`tsp`            | taxes and subsidies `taxesandsubsidiesonproducts_model.txt`
`va`             | value added `valueadded_model.txt`
`fd`             | final demand `finaldemand_model.txt`
`uip`            | imports `useofimportedproducts_model.txt`
`exp`            | exports `export_model.txt`


### Declaration of aggregation scheme

The aggregation scheme consists of mappings used for aggregations of the (above)
sets from dimension1 to dimension2:

map name (dimension1, dimension2)       | Explanation
--------------------------------------- | -----------
`all_reg_aggr(all_reg_data,all_reg)`    | Aggregates scheme for all regions `regions_all_database_to_model.txt `
`prd_aggr(prd_data,prd)`                | Aggregates scheme for products `products_database_to_model.txt`
`ind_aggr(ind_data,ind)`                | Aggregates scheme for industries `industries_database_to_model.txt`
`tsp_aggr(tsp_data,tsp)`                | Aggregates scheme for taxes and subsidies `taxesandsubsidiesonproducts_database_to_model.txt`
`va_aggr(va_data,va)`                   | Aggregates scheme for value added `valueadded_database_to_model.txt`
`fd_aggr(fd_data,fd)`                   | Aggregates scheme for final demand `finaldemand_database_to_model.txt`
`uip_aggr(uip_data,uip)`                | Aggregates scheme for imports `useofimportedproducts_database_to_model.txt`
`prd_uip_aggr(prd_data,uip)`            | Aggregates scheme from products to imported products categories `products_to_uip_model.txt`
`exp_aggr(exp_data,exp)`                | Aggregates scheme for exports `export_database_to_model.txt`


### Declaration of aliases

Sometimes it is necessary to have more than one name for the same set. Aliases
are created by repeating the last character of the original set a number of
times. We define the following aliases:

Original set | Aliases (new names for the original set)
------------ | ----------------------------------------
`reg`        | `regg`, `reggg`
`prd`        | `prdd`, `prddd`
`ind`        | `indd`, `inddd`
`fd`         | `fdd`, `fddd`


### Consistency checks of aggregation scheme

In case the configuration file requires check on consistency of aggregation
schemes, the check is performed in this code. For more details on types of
checks performed see the included file `scr/snippets/setaggregationcheck`.


More detailed information about the sets and mappings can be found in the
corresponding `.txt` file. All sets and maps can be changed to any level of
details. For this the `.txt` files should be changed (sets and/or maps). This
sets and maps in this file are mainly used in `aggregate_database.gms`,
`model_parameters.gms` and `model_variables_equations.gms`.
$offtext

* ===================== Declaration of sets for the model ======================

Sets
         all_reg      full list of regions in the model
/
$include %project%/sets/regions_model.txt
$include %project%/sets/restoftheworld_model.txt
/

         reg(all_reg)  list of regions in the model
/
$include %project%/sets/regions_model.txt
/

         row(all_reg)  list of rest of the world regions in the model
/
$include %project%/sets/restoftheworld_model.txt
/
;

Sets
         prd             list of products in the model
/
$include %project%/sets/products_model.txt
/

         ind             list of industries in the model
/
$include %project%/sets/industries_model.txt
/

         tsp             list of taxes and subsidies on products in the model
/
$include %project%/sets/taxesandsubsidiesonproducts_model.txt
/

         va              list of value added categories in the model
/
$include %project%/sets/valueadded_model.txt
/

         fd              list of final demand categories in the model
/
$include %project%/sets/finaldemand_model.txt
/

         exp             list of export categories in the model
/
$include %project%/sets/export_model.txt
/
;


* ===================== Declaration of aggregation scheme ======================
Sets
         all_reg_aggr(all_reg_data,all_reg)  aggregation scheme for full list of regions
/
$include %project%/sets/aggregation/regions_all_database_to_model.txt
/

         prd_aggr(prd_data,prd)          aggregation scheme for products
/
$include %project%/sets/aggregation/products_database_to_model.txt
/

         ind_aggr(ind_data,ind)          aggregation scheme for industries
/
$include %project%/sets/aggregation/industries_database_to_model.txt
/

         tsp_aggr(tsp_data,tsp)          aggregation scheme for taxes and subsidies on products
/
$include %project%/sets/aggregation/taxesandsubsidiesonproducts_database_to_model.txt
/

         va_aggr(va_data,va)             aggregation scheme for value added categories
/
$include %project%/sets/aggregation/valueadded_database_to_model.txt
/

         fd_aggr(fd_data,fd)             aggregation scheme for final demand categories
/
$include %project%/sets/aggregation/finaldemand_database_to_model.txt
/

         exp_aggr(exp_data,exp)          aggregation scheme for export categories
/
$include %project%/sets/aggregation/export_database_to_model.txt
/
;

* ===================== Declaration of aliases =================================
Alias
         (reg,regg,reggg)
         (prd,prdd,prddd)
         (ind,indd,inddd)
         (fd,fdd,fddd)
;


* Check that all aggregation schemes are correct

$if not '%agg_check%' == 'yes' $goto endofcode

$BATINCLUDE "library/scr/snippets/setaggregationcheck" all_reg_data    all_reg      all_reg_aggr
$BATINCLUDE "library/scr/snippets/setaggregationcheck" prd_data        prd          prd_aggr
$BATINCLUDE "library/scr/snippets/setaggregationcheck" ind_data        ind          ind_aggr
$BATINCLUDE "library/scr/snippets/setaggregationcheck" fd_data         fd           fd_aggr
$BATINCLUDE "library/scr/snippets/setaggregationcheck" va_data         va           va_aggr
$BATINCLUDE "library/scr/snippets/setaggregationcheck" exp_data        exp          exp_aggr
$BATINCLUDE "library/scr/snippets/setaggregationcheck" tsp_data        tsp          tsp_aggr

$label endofcode
