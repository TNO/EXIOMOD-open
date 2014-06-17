
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
