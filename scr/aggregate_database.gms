* File:   scr/aggregate_database.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 23 June 2014

* gams-master-file: load_database.gms

$ontext startdoc
This is the `main.gms` code for the input-output/CGE model. This is the part
where the database is aggregated to the dimensions of the model, identified in
`sets_model.gms`.

The code consists of the following parts:

### Parameters declaration

The data i.e. sets they consists of

Parameter             | Explanation
--------------------- | -----------
SUP_model             | the supply table
INTER_USE_bp_model    | the intermediate use table in basic prices (prd is input into ind)
INTER_USE_ts_model    | the tax layer of the intermediate use table
FINAL_USE_bp_model    | the final use table in basic, discerning final consumption by households and government and fixed asset formation in defined regions (not rest of the world)
FINAL_USE_ts_model    | the tax layer of  the final use table, discerning final consumption by households and government and fixed asset formation in defined regions (not rest of the world)
EXPORT_model          | the export to the rest of the world table
VALUE_ADDED_model     | the value added table (va created by ind in reg can also end up in regg)
IMPORT_USE_IND_model  | imports from  the rest of the world, for use by the industries
TAX_SUB_PRD_DISTR_model  | income of taxes and subsidies on products becomes income of the final demand categories
VALUE_ADDED_DISTR_model  | income of value added categories becomes income of the final demand categories
INCOME_DISTR_model    | income re-distribution flows between the final demand categories (flows from reg-fd to regg-fdd)
IMPORT_USE_FD_model   | imports from the rest of the world, for use by the final demand categories
TRANSFERS_ROW_molel   | transfers between the rest of the world regions and the final demand categories (positive - from row to fd, negative - from fd to row)


### Display commands for parameters
$offtext

* ============ Aggregation of the database to the model dimensions =============

Parameters
         SUP_model(reg,prd,regg,ind)             supply table in model aggregation

         INTER_USE_bp_model(reg,prd,regg,ind)    intermediate use in model aggregation in basic prices
         INTER_USE_ts_model(reg,prd,regg,ind)    tax layer of intermediate use in model aggregation

         FINAL_USE_bp_model(reg,prd,regg,fd)     final use in model aggregation in basic prices
         FINAL_USE_ts_model(reg,prd,regg,fd)     tax layer of final use in model aggregation

         EXPORT_model(reg,prd,row,exp)           export to rest of the world regions in model aggregation
         VALUE_ADDED_model(reg,va,regg,ind)      value added in model aggregation
         IMPORT_USE_IND_model(reg,ind,row,uip)   use of imported products by industries in model aggregation

         TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd) distribution of taxes and subsidies on products revenue to final demand categories in model aggregation
         VALUE_ADDED_DISTR_model(reg,va,regg,fd) distribution of value added revenues to final demand categories in model aggregation

         INCOME_DISTR_model(reg,fd,regg,fdd)     re-distribution of income between final damand categories in model aggregation
         IMPORT_USE_FD_model(reg,fd,row,uip)     use of imported products by final demand categories in model aggregation
         TRANSFERS_ROW_molel(reg,fd,row,exp)     transfers between rest of the world regions and final demand categories in model aggregation
;

* The parameters as defined above are depending on given data.
* Overview of sets: reg = regions, prd = products, regg = regions (alias), ind = industry, fd = final demand, row = rest of world, exp = export, va = value added uip = use of imported products.
* "use_col" refers to calling specific columns from use table.
* See also sets_model.gms for an overview of abovementioned sets that define a parameter.

* for all model tables (SUP_model, INTER_USE_model etc.) below, these comments below are relevant

* they SUM over sets (expressed between brackets) to construct the table
* the "$" sign can be read as "such that", meaning that the summations below have to satisfy the aggregations and inputs regarding %base_year%, %base_cur% and Value
* the base year, base currency and Value are taken from initial input defined in
* the sets that include a "_data" extension relate to the files named $include sets/database/<namehere>_database.txt
* the sets that include a "_aggr" extension relate to the files named $include sets/model/aggregation/<namehere>.txt
* See also sets_model.gms OR sets_data.gms for an overview of sets

SUP_model(reg,prd,regg,ind)
                 = sum((reg_data,prd_data,regg_data,ind_data)$
                       ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       SAM_bp_data("%base_year%","%base_cur%",reg_data,ind_data,regg_data,prd_data,"Value") ) ;


INTER_USE_bp_model(reg,prd,regg,ind)
                 = sum((reg_data,prd_data,regg_data,ind_data)$
                       ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;

INTER_USE_ts_model(reg,prd,regg,ind)
                 = sum((reg_data,prd_data,regg_data,ind_data)$
                       ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       SAM_ts_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;

FINAL_USE_bp_model(reg,prd,regg,fd)
                 = sum((reg_data,prd_data,regg_data,fd_data)$
                       ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
                       SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

FINAL_USE_ts_model(reg,prd,regg,fd)
                 = sum((reg_data,prd_data,regg_data,fd_data)$
                       ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
                       SAM_ts_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

EXPORT_model(reg,prd,row,exp)
                 = sum((reg_data,prd_data,row_data,exp_data)$
                       ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         all_reg_aggr(row_data,row) and exp_aggr(exp_data,exp) ),
                       SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,row_data,exp_data,"Value") )
                   +
                   sum((reg_data,prd_data,regg_data,ind_data)$
                       ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         all_reg_aggr(regg_data,row) ),
                       SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") )
                   +
                   sum((reg_data,prd_data,regg_data,fd_data)$
                       ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         all_reg_aggr(regg_data,row) ),
                       SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

VALUE_ADDED_model(reg,va,regg,ind)
                 = sum((reg_data,va_data,regg_data,ind_data)$
                       ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
                         all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,ind_data,"Value") ) ;

IMPORT_USE_IND_model(reg,ind,row,uip)
                 = sum((row_data,uip_data,reg_data,ind_data)$
                       ( all_reg_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         all_reg_aggr(reg_data,reg) and ind_aggr(ind_data,ind) ),
                       SAM_bp_data("%base_year%","%base_cur%",row_data,uip_data,reg_data,ind_data,"Value") )
                   +
                   sum((regg_data,prd_data,reg_data,ind_data)$
                       ( all_reg_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         all_reg_aggr(reg_data,reg) and ind_aggr(ind_data,ind) ),
                       SAM_bp_data("%base_year%","%base_cur%",regg_data,prd_data,reg_data,ind_data,"Value") ) ;

TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd)
                 = sum((regg_data,fd_data,reg_data,tsp_data)$
                       ( all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) and
                         all_reg_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) ),
                       SAM_bp_data("%base_year%","%base_cur%",regg_data,fd_data,reg_data,tsp_data,"Value") ) ;

VALUE_ADDED_DISTR_model(reg,va,regg,fd)
                 = sum((regg_data,fd_data,reg_data,va_data)$
                       ( all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) and
                         all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) ),
                       SAM_bp_data("%base_year%","%base_cur%",regg_data,fd_data,reg_data,va_data,"Value") ) ;

INCOME_DISTR_model(reg,fd,regg,fdd)
                 = sum((regg_data,fdd_data,reg_data,fd_data)$
                       ( all_reg_aggr(regg_data,regg) and fd_aggr(fdd_data,fdd) and
                         all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
                       SAM_bp_data("%base_year%","%base_cur%",regg_data,fdd_data,reg_data,fd_data,"Value") ) ;

IMPORT_USE_FD_model(reg,fd,row,uip)
                 = sum((row_data,uip_data,reg_data,fd_data)$
                       ( all_reg_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
                       SAM_bp_data("%base_year%","%base_cur%",row_data,uip_data,reg_data,fd_data,"Value") )
                   +
                   sum((regg_data,prd_data,reg_data,fd_data)$
                       ( all_reg_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
                       SAM_bp_data("%base_year%","%base_cur%",regg_data,prd_data,reg_data,fd_data,"Value") ) ;

TRANSFERS_ROW_molel(reg,fd,row,exp)
                 = sum((reg_data,fd_data,row_data,exp_data)$
                       ( all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) and
                         all_reg_aggr(row_data,row) and exp_aggr(exp_data,exp) ),
                       SAM_bp_data("%base_year%","%base_cur%",reg_data,fd_data,row_data,exp_data,"Value") )
                   +
                   sum((reg_data,fd_data,regg_data,fdd_data)$
                       ( all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) and
                         all_reg_aggr(regg_data,row) ),
                       SAM_bp_data("%base_year%","%base_cur%",reg_data,fd_data,regg_data,fdd_data,"Value") )
                   -
                   sum((regg_data,fdd_data,reg_data,fd_data)$
                       ( all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) and
                         all_reg_aggr(regg_data,row) ),
                       SAM_bp_data("%base_year%","%base_cur%",regg_data,fdd_data,reg_data,fd_data,"Value") ) ;

Display
SUP_model
INTER_USE_bp_model
INTER_USE_ts_model
FINAL_USE_bp_model
FINAL_USE_ts_model
EXPORT_model
VALUE_ADDED_model
IMPORT_USE_IND_model
TAX_SUB_PRD_DISTR_model
VALUE_ADDED_DISTR_model
INCOME_DISTR_model
IMPORT_USE_FD_model
TRANSFERS_ROW_molel
;
