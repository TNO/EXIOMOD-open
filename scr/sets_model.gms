
* ===================== Declaration of sets for the model ======================

Sets
         reg             list of regions in the model
/
$include sets/model/regions_model.txt
/

         row             list of rest of the world regions in the model
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
         cur_base(cur_data)              base currency for the model
/
$include sets/model/currency_base.txt
/
;

Sets
         reg_aggr(reg_data,reg)          aggregation scheme for regions
/
$include sets/model/aggregation/regions_database_to_model.txt
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

         row_aggr(full_reg_list,row)     aggregation scheme for rest of the world regions
/
$include sets/model/aggregation/restoftheworld_database_to_model.txt
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

Sets
         reg_sim(reg)                    list of regions used in simulation setup

         prd_sim(prd)                    list of products used in simulation setup
;

Alias
         (reg,regg,reggg)
         (prd,prdd,prddd)
         (ind,indd,inddd)
;
