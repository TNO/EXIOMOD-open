*This gms file is one of the gms files part of the “main.gms” file and includes the equations and model formulation. Please start from “main.gms”.
*
*This gms file consists of the following parts:
*
*        Declaration of sets for the model,
*        where the following sets are defined:
*                set name        expanation
*                reg             regions used for the model 'regions_model.txt'
*                row             rest of the world regions used in the model 'restoftheworld_model.txt'
*                prd             products 'products_model.txt'
*                va              value added 'valueadded_model.txt'
*                tsp             taxes and subsidies 'taxesandsubsidiesonproducts_model.txt'
*                uip             imports 'useofimportedproducts_model.txt '
*                inm             international margins 'internationalmargins_model.txt'
*                val             valuation categories 'valuation_model.txt'
*                use_col         use table (columns) consitst of ind, fd and exp explaned on the next lines
*                ind(use_col)    19 industries 'industries_model.txt', a subset of use_col
*                fd(use_col)     final demand 'finaldemand_model.txt', a subset of use_col
*                exp(use_col)    exports 'export_model.txt', a subset of use_col
*                reg_sim(reg)    list of regions used in simulation setup, a subset of reg
*                prd_sim(prd)    list of products used in simulation setup, a subset of prd
*
*        Declaration of aggregation scheme,
*        consisting of mappings used for aggregations of the (above) sets from dimension1 to dimension2:
*                map name (dimension1, dimension2)       explanation
*                reg_aggr(reg_data,reg)                  aggregates scheme for regions 'regions_database_to_model.txt '
*                prd_aggr(prd_data,prd)                  aggregates scheme for products 'products_database_to_model.txt'
*                ind_aggr(ind_data,ind)                  aggregates scheme for industries 'industries_database_to_model.txt'
*                fd_aggr(fd_data,fd)                     aggregates scheme for final demand 'finaldemand_database_to_model.txt'
*                va_aggr(va_data,va)                     aggregates scheme for value added 'valueadded_database_to_model.txt'
*                exp_aggr(exp_data,exp)                  aggregates scheme for exports 'export_database_to_model.txt'
*                val_aggr(val_data,val)                  aggregates scheme for valuation categories 'valuation_database_to_model.txt'
*                row_aggr(full_reg_list,row)             aggregates scheme for rest of the world 'restoftheworld_database_to_model.txt'
*                tsp_aggr(tsp_data,tsp)                  aggregates scheme for taxes and subsidies 'taxesandsubsidiesonproducts_database_to_model.txt'
*                uip_aggr(uip_data,uip)                  aggregates scheme for imports 'useofimportedproducts_database_to_model.txt'
*                prd_uip_aggr(prd_data,uip)              aggregates scheme from products to imported products categories 'products_to_uip_model.txt'
*                inm_aggr(inm_data,inm)                  aggregates scheme for international margins categories 'internationalmargins_database_to_model.txt '
*
*
*        Declaration of aliases,
*        sometimes it is necessary to have more than one name for the same set
*                (reg,regg,reggg)   where the new sets regg and reggg are all new names for the original set reg.
*                (prd,prdd,prddd)   where the new sets prdd and predd are all new names for the original set prd.
*                (ind,indd,inddd)   where the new sets indd and inddd are all new names for the original set ind.
*
*
*More detailed information about the sets and mappings can be found in the corresponding .txt file. All sets and maps can be changed to any level of details.
*For this the .txt files should be changed (sets and/or maps). This sets and maps in this file are mainly used in 'aggregate_database.gms', 'model_parameters.gms' and 'model_variables_equations.gms'

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
         reg_sim(reg)                    list of regions used in simulation setup

         prd_sim(prd)                    list of products used in simulation setup
;

* ===================== Declaration of aggregation scheme ======================
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

* ===================== Declaration of aliases =================================

Alias
         (reg,regg,reggg)
         (prd,prdd,prddd)
         (ind,indd,inddd)
;
