* File:   scr/aggregate_database.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014

$ontext startdoc
This is the `main.gms` code for the core input-output model. This is the part where the database is aggregated to the
dimensions of the model, identified in `sets_model.gms`.

The code consists of the following parts:

### Parameters declaration

The data i.e. sets they consists of

Parameter             | Explanation
--------------------- | -----------
SUP_model             | the supply and use table
INTER_USE_model       | the intermediate use table
FINAL_USE_model       | the final use table, discerning final consumption, fixed asset formation and export to defined regions (not rest of the world)
EXPORT_model          | the export to the rest of the world table
VALUE_ADDED_model     | the value added table i.e. vector
TAX_SUB_model (for industries, exports and final demands)              | taxes table, for industries (specific taxes), final demands and exports (as data here is not "free on board")
IMPORT_USE_model (both for industries, exports and final demands       | imports from rest of the world use table, for industries, final demands and exports (i.e. re-exports)

display commands for parameters
$offtext

* ============ Aggregation of the database to the model dimensions =============

Parameters
         SUP_model(reg,prd,regg,ind)             supply table in model aggregation

         INTER_USE_model(reg,prd,regg,ind)       intermediate use in model aggregation
         FINAL_USE_model(reg,prd,regg,fd)        final use in model aggregation
         EXPORT_model(reg,prd,row,exp)           export to rest of the world regions in model aggregation
         VALUE_ADDED_model(reg,va,ind)           value added in model aggregation
         TAX_SUB_model(reg,tsp,use_col)          taxes and subsidies on products in model aggregation
         IMPORT_USE_model(reg,uip,row,use_col)   use of imported products in model aggregation

* The parameters as defined above are depending on given data.
* Overview of sets: reg = regions, prd = products, regg = regions (alias), ind = industry, fd = final demand, row = rest of world, exp = export, va = value added uip = use of imported products.
* "use_col" refers to calling specific columns from use table.
* See also sets_model.gms for an overview of abovementioned sets that define a parameter.

;
* for all model tables (SUP_model, INTER_USE_model etc.) below, these comments below are relevant

* they SUM over sets (expressed between brackets) to construct the table
* the "$" sign can be read as "such that", meaning that the summations below have to satisfy the aggregations and inputs regarding %base_year%, %base_cur% and Value
* the base year, base currency and Value are taken from initial input defined in
* the sets that include a "_data" extension relate to the files named $include sets/database/<namehere>_database.txt
* the sets that include a "_aggr" extension relate to the files named $include sets/model/aggregation/<namehere>.txt
* See also sets_model.gms OR sets_data.gms for an overview of sets

SUP_model(reg,prd,regg,ind)
                 = sum((reg_data,prd_data,regg_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       SUP_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;


INTER_USE_model(reg,prd,regg,ind)
                 = sum((reg_data,prd_data,regg_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       USE_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;

FINAL_USE_model(reg,prd,regg,fd)
                 = sum((reg_data,prd_data,regg_data,fd_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
                       USE_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

EXPORT_model(reg,prd,row,exp)
                 = sum((reg_data,prd_data,row_data,exp_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         row_aggr(row_data,row) and exp_aggr(exp_data,exp) ),
                       USE_data("%base_year%","%base_cur%",reg_data,prd_data,row_data,exp_data,"Value") )
                   +
                   sum((reg_data,prd_data,regg_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         row_aggr(regg_data,row) ),
                       USE_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") )
                   +
                   sum((reg_data,prd_data,regg_data,fd_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         row_aggr(regg_data,row) ),
                       USE_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

VALUE_ADDED_model(reg,va,ind)
                 = sum((reg_data,va_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
                         ind_aggr(ind_data,ind) ),
                       USE_data("%base_year%","%base_cur%",reg_data,va_data,reg_data,ind_data,"Value") ) ;

TAX_SUB_model(reg,tsp,ind)
                 = sum((reg_data,tsp_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) and
                         ind_aggr(ind_data,ind) ),
                       USE_data("%base_year%","%base_cur%",reg_data,tsp_data,reg_data,ind_data,"Value") ) ;

TAX_SUB_model(reg,tsp,fd)
                 = sum((reg_data,tsp_data,fd_data)$
                       ( reg_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) and
                         fd_aggr(fd_data,fd) ),
                       USE_data("%base_year%","%base_cur%",reg_data,tsp_data,reg_data,fd_data,"Value") ) ;

TAX_SUB_model(reg,tsp,exp)
                 = sum((reg_data,tsp_data,exp_data)$
                       ( reg_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) and
                         exp_aggr(exp_data,exp) ),
                       USE_data("%base_year%","%base_cur%",reg_data,tsp_data,reg_data,exp_data,"Value") ) ;

IMPORT_USE_model(reg,uip,row,ind)
                 = sum((row_data,uip_data,reg_data,ind_data)$
                       ( row_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         reg_aggr(reg_data,reg) and ind_aggr(ind_data,ind) ),
                       USE_data("%base_year%","%base_cur%",row_data,uip_data,reg_data,ind_data,"Value") )
                   +
                   sum((regg_data,prd_data,reg_data,ind_data)$
                       ( row_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         reg_aggr(reg_data,reg) and ind_aggr(ind_data,ind) ),
                       USE_data("%base_year%","%base_cur%",regg_data,prd_data,reg_data,ind_data,"Value") ) ;

IMPORT_USE_model(reg,uip,row,fd)
                 = sum((row_data,uip_data,reg_data,fd_data)$
                       ( row_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
                       USE_data("%base_year%","%base_cur%",row_data,uip_data,reg_data,fd_data,"Value") )
                   +
                   sum((regg_data,prd_data,reg_data,fd_data)$
                       ( row_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
                       USE_data("%base_year%","%base_cur%",regg_data,prd_data,reg_data,fd_data,"Value") ) ;

IMPORT_USE_model(reg,uip,row,exp)
                 = sum((row_data,uip_data,reg_data,exp_data)$
                       ( row_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         reg_aggr(reg_data,reg) and exp_aggr(exp_data,exp) ),
                       USE_data("%base_year%","%base_cur%",row_data,uip_data,reg_data,exp_data,"Value") )
                   +
                   sum((regg_data,prd_data,reg_data,exp_data)$
                       ( row_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         reg_aggr(reg_data,reg) and exp_aggr(exp_data,exp) ),
                       USE_data("%base_year%","%base_cur%",regg_data,prd_data,reg_data,exp_data,"Value") ) ;

Display
SUP_model
INTER_USE_model
FINAL_USE_model
EXPORT_model
VALUE_ADDED_model
TAX_SUB_model
IMPORT_USE_model
;
