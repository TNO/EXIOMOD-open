* File:   library/scr/aggregate_database.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 23 June 2014

* gams-master-file: main.gms

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
TRANSFERS_ROW_model   | transfers between the rest of the world regions and the final demand categories (positive - from row to fd, negative - from fd to row)


### Display commands for parameters
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ============ Aggregation of the database to the model dimensions =============

Parameters
    SUP_model(reg,prd,regg,ind)             supply table in model aggregation

    INTER_USE_bp_model(reg,prd,regg,ind)    intermediate use in model
                                            # aggregation in basic prices
    INTER_USE_ts_model(reg,prd,regg,ind)    tax paid domestically on
                                            # intermediate use in model
                                            # aggregation
    INTER_USE_et_model(reg,prd,regg,ind)    tax paid to exporing region on
                                            # intermediate use in model
                                            # aggregation
    INTER_USE_ROW_bp_model(row,prd,regg,ind)    use of imported products by
                                            # industries in model aggregation in
                                            # cif prices
    INTER_USE_ROW_ts_model(row,prd,regg,ind)    tax layer of use of imported
                                            # products by industries in model
                                            # aggregation

    FINAL_USE_bp_model(reg,prd,regg,fd)     final use in model aggregation in
                                            # basic prices
    FINAL_USE_ts_model(reg,prd,regg,fd)     tax paid domestically on final use
                                            # in model aggregation
    FINAL_USE_et_model(reg,prd,regg,fd)     tax paid to exporting region on
                                            # final use in model aggregation
    FINAL_USE_ROW_bp_model(row,prd,regg,fd) use of imported products by final
                                            # demand categories in model
                                            # aggregation in cif prices
    FINAL_USE_ROW_ts_model(row,prd,regg,fd) tax layers of use of imported
                                            # products by final demand
                                            # categories in model aggregation

    VALUE_ADDED_model(reg,va,regg,ind)      value added in model aggregation

    TAX_SUB_PRD_DISTR_model(reg,tsp,regg,fd)    distribution of taxes and
                                            # subsidies on products revenue to
                                            # final demand categories in model
                                            # aggregation
    VALUE_ADDED_DISTR_model(reg,va,regg,fd) distribution of value added revenues
                                            # to final demand categories in
                                            # model aggregation

    INCOME_DISTR_model(reg,fd,regg,fdd)     re-distribution of income between
                                            # final demand categories in model
                                            # aggregation

    EXPORT_bp_model(reg,prd,row,exp)        export to rest of the world regions
                                            # in model aggregation in fob prices
    EXPORT_et_model(reg,prd,row,exp)        tax paid on export to rest of the
                                            # world regions in model aggregation
    TRANSFERS_ROW_model(reg,fd,row,exp)     transfers between rest of the world
                                            # regions and final demand
                                            # categories in model aggregation
;

* The parameters as defined above are depending on given data.
* Overview of sets: reg = regions, prd = products, regg = regions (alias), ind = industry, fd = final demand, row = rest of world, exp = export, va = value added uip = use of imported products.
* "use_col" refers to calling specific columns from use table.
* See also sets_model.gms for an overview of abovementioned sets that define a parameter.

* for all model tables (SUP_model, INTER_USE_model etc.) below, these comments below are relevant

* they SUM over sets (expressed between brackets) to construct the table
* the "$" sign can be read as "such that", meaning that the summations below have to satisfy the aggregations and inputs regarding %base_year%, %base_cur% and Value
* the base year, base currency and Value are taken from initial input defined in
* the sets that include a "_data" extension relate to the files named $include library/sets/<namehere>_database.txt
* the sets that include a "_aggr" extension relate to the files named $include %proejct%/sets/aggregation/<namehere>.txt
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

INTER_USE_et_model(reg,prd,regg,ind)
    = sum((reg_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_et_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;

INTER_USE_ROW_bp_model(row,prd,regg,ind)
    = sum((row_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(row_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,ind_data,"Value") )
    +
    sum((reg_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;

INTER_USE_ROW_ts_model(row,prd,regg,ind)
    = sum((row_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(row_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_ts_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,ind_data,"Value") )
    +
    sum((reg_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,row) and prd_aggr(prd_data,prd) and
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

FINAL_USE_et_model(reg,prd,regg,fd)
    = sum((reg_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_et_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

FINAL_USE_ROW_bp_model(row,prd,regg,fd)
    = sum((row_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(row_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,fd_data,"Value") )
    +
    sum((reg_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

FINAL_USE_ROW_ts_model(row,prd,regg,fd)
    = sum((row_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(row_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_ts_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,fd_data,"Value") )
    +
    sum((reg_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_ts_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

VALUE_ADDED_model(reg,va,regg,ind)
    = sum((reg_data,va_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,ind_data,"Value") ) ;

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

* exclude income redistribution from the same agent
INCOME_DISTR_model(reg,fd,reg,fd) = 0 ;

EXPORT_bp_model(reg,prd,row,exp)
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

EXPORT_et_model(reg,prd,row,exp)
    = sum((reg_data,prd_data,row_data,exp_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(row_data,row) and exp_aggr(exp_data,exp) ),
    SAM_et_data("%base_year%","%base_cur%",reg_data,prd_data,row_data,exp_data,"Value") )
    +
    sum((reg_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,row) ),
    SAM_et_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") )
    +
    sum((reg_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,row) ),
    SAM_et_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

TRANSFERS_ROW_model(reg,fd,row,exp)
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
    ( all_reg_aggr(regg_data,row) and
    all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",regg_data,fdd_data,reg_data,fd_data,"Value") ) ;

Display
SUP_model
INTER_USE_bp_model
INTER_USE_ts_model
INTER_USE_et_model
INTER_USE_ROW_bp_model
INTER_USE_ROW_ts_model
FINAL_USE_bp_model
FINAL_USE_ts_model
FINAL_USE_et_model
FINAL_USE_ROW_bp_model
FINAL_USE_ROW_ts_model
VALUE_ADDED_model
TAX_SUB_PRD_DISTR_model
VALUE_ADDED_DISTR_model
INCOME_DISTR_model
EXPORT_bp_model
EXPORT_et_model
TRANSFERS_ROW_model
;


* Extra parameters while database is not fixed
Parameters
    VALUE_ADDED_FU_model(reg,va,regg,fd)  value added (tax) on final use
    VALUE_ADDED_ROW_model(reg,va,row,exp) value added (tax) on export to RoW
    TAX_INTER_USE_ROW_model(row,regg,ind) tax paid on products from RoW
    TAX_FINAL_USE_ROW_model(row,regg,fd)  tax paid on products from RoW
;

VALUE_ADDED_FU_model(reg,va,regg,fd)
    = sum((reg_data,va_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,fd_data,"Value") ) ;

VALUE_ADDED_ROW_model(reg,va,row,exp)
    = sum((reg_data,va_data,row_data,exp_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(row_data,row) and exp_aggr(exp_data,exp) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,row_data,exp_data,"Value") )
    +
    sum((reg_data,va_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,row) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,ind_data,"Value") )
    +
    sum((reg_data,va_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,row) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,fd_data,"Value") ) ;

TAX_INTER_USE_ROW_model(row,regg,ind)
    = sum((row_data,va_data,regg_data,ind_data)$
    ( all_reg_aggr(row_data,row) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,va_data,regg_data,ind_data,"Value") )
    +
    sum((reg_data,va_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,row) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,ind_data,"Value") ) ;

TAX_FINAL_USE_ROW_model(row,regg,fd)
    = sum((row_data,va_data,regg_data,fd_data)$
    ( all_reg_aggr(row_data,row) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,va_data,regg_data,fd_data,"Value") )
    +
    sum((reg_data,va_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,row) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,fd_data,"Value") ) ;


Display
VALUE_ADDED_FU_model
VALUE_ADDED_ROW_model
TAX_INTER_USE_ROW_model
TAX_FINAL_USE_ROW_model
;
