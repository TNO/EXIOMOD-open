* File:   library/scr/aggregate_database.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 23 June 2014

* gams-master-file: main.gms

$ontext startdoc
This is the `main.gms` code for the input-output/CGE model. This is the part
where the database is aggregated to the dimensions of the model, identified in
`sets_model.gms`.

 The parameters as defined below are determined on given data.

Overview of sets: reg = regions, prd = products, regg = regions (alias), ind = industry, fd = final demand, row = rest of world, exp = export, va = value added uip = use of imported products.
 "use_col" refers to calling specific columns from use table.
 See also sets_model.gms for an overview of abovementioned sets that define a parameter.

 For all model tables (SUP, INTER_USE etc.) below, these comments below are relevant

 they SUM over sets (expressed between brackets) to construct the table
 the "$" sign can be read as "such that", meaning that the summations below have to satisfy the aggregations and inputs regarding %base_year%, %base_cur% and Value
 the base year, base currency and Value are taken from initial input defined in
 the sets that include a "_data" extension relate to the files named $include library/sets/<namehere>_database.txt
 the sets that include a "_aggr" extension relate to the files named $include %proejct%/sets/aggregation/<namehere>.txt
 See also sets_model.gms OR sets_data.gms for an overview of sets

$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ============ Aggregation of the database to the model dimensions =============

Parameters
    SUP(reg,prd,regg,ind)             supply table in model aggregation

    INTER_USE_D(prd,regg,ind)         intermediate use of domestic
                                            # products in model aggregation in
                                            # basic prices
    INTER_USE_M(prd,regg,ind)         intermediate use of products
                                            # imported from modeled regions
                                            # in model aggregation in
                                            # basic (c.i.f.) prices
    INTER_USE_ROW(row,prd,regg,ind)   intermediate use of products
                                            # imported from rest of the world
                                            # regions in model aggregation in
                                            # basic (c.i.f.) prices
    INTER_USE_dt(prd,regg,ind)        tax paid domestically on
                                            # intermediate use in model
                                            # aggregation

    FINAL_USE_D(prd,regg,fd)          final use of domestic products in
                                            # model aggregation in basic prices
    FINAL_USE_M(prd,regg,fd)          final use of products imported from
                                            # modeled regions in model
                                            # aggregation in basic (c.i.f.)
                                            # prices
    FINAL_USE_ROW(row,prd,regg,fd)    final use of products imported from
                                            # rest of the world regions in model
                                            # aggregation in basic (c.i.f.)
                                            # prices
    FINAL_USE_dt(prd,regg,fd)         tax paid domestically on final use
                                            # in model aggregation

    TRADE(reg,prd,regg)               trade in products between modeled
                                            # regions in basic (c.i.f.) prices

    VALUE_ADDED(reg,va,regg,ind)      value added in model aggregation
    TAX_INTER_USE_ROW(row,va,regg,ind)    tax and international margins
                                            # paid on intermediate use of
                                            # products imported from rest of the
                                            # world regions

    TAX_FINAL_USE(reg,va,regg,fd)     tax and international margins paid
                                            # on final use of products imported
                                            # from modeled regions
    TAX_FINAL_USE_ROW(row,va,regg,fd) tax and international margins paid
                                            # on final use of products imported
                                            # from rest of the world regions

    EXPORT(reg,prd,row)               export to rest of the world regions
                                            # in model aggregation in basic
                                            # (f.o.b.) prices
    TAX_EXPORT(reg,va,row)            tax and international margin
                                            # received due to export to rest of
                                            # the world regions

    TAX_SUB_PRD_DISTR(reg,tsp,regg,fd)    distribution of taxes and
                                            # subsidies on products revenue to
                                            # final demand categories in model
                                            # aggregation
    VALUE_ADDED_DISTR(reg,va,regg,fd) distribution of value added revenues
                                            # to final demand categories in
                                            # model aggregation

    INCOME_DISTR(reg,fd,regg,fdd)     re-distribution of income between
                                            # final demand categories in model
                                            # aggregation

    TRANSFERS_ROW(reg,fd,row)         transfers between rest of the world
                                            # regions and final demand
                                            # categories in model aggregation
;


SUP(reg,prd,regg,ind)
    = sum((reg_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,ind_data,regg_data,prd_data,"Value") ) ;

INTER_USE_D(prd,regg,ind)
    = sum((reg_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,regg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;

INTER_USE_M(prd,regg,ind)
    = sum((reg_data,prd_data,regg_data,ind_data)$
    ( not all_reg_aggr(reg_data,regg) and
    sum(row$all_reg_aggr(reg_data,row), 1 ) eq 0 and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;

INTER_USE_ROW(row,prd,regg,ind)
    = sum((row_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(row_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,ind_data,"Value") )
    +
    sum((reg_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;

INTER_USE_dt(prd,regg,ind)
    = sum((reg_data,prd_data,regg_data,ind_data)$
    ( prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_dt_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") )
    +
    sum((row_data,prd_data,regg_data,ind_data)$
    ( prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_dt_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,ind_data,"Value") ) ;

FINAL_USE_D(prd,regg,fd)
    = sum((reg_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,regg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

FINAL_USE_M(prd,regg,fd)
    = sum((reg_data,prd_data,regg_data,fd_data)$
    ( not all_reg_aggr(reg_data,regg) and
    sum(row$all_reg_aggr(reg_data,row), 1 ) eq 0 and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

FINAL_USE_ROW(row,prd,regg,fd)
    = sum((row_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(row_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,fd_data,"Value") )
    +
    sum((reg_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

FINAL_USE_dt(prd,regg,fd)
    = sum((reg_data,prd_data,regg_data,fd_data)$
    ( prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_dt_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") )
    +
    sum((row_data,prd_data,regg_data,fd_data)$
    ( prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_dt_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,fd_data,"Value") ) ;

TRADE(reg,prd,regg)
    = sum((reg_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") )
    +
    sum((reg_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

* exclude trade between the same regions
TRADE(reg,prd,reg) = 0 ;


VALUE_ADDED(reg,va,regg,ind)
    = sum((reg_data,va_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,ind_data,"Value") ) ;

TAX_INTER_USE_ROW(row,va,regg,ind)
    = sum((row_data,va_data,regg_data,ind_data)$
    ( all_reg_aggr(row_data,row) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,va_data,regg_data,ind_data,"Value") )
    +
    sum((reg_data,va_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,row) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,ind_data,"Value") ) ;


TAX_FINAL_USE(reg,va,regg,fd)
    = sum((reg_data,va_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,fd_data,"Value") ) ;

TAX_FINAL_USE_ROW(row,va,regg,fd)
    = sum((row_data,va_data,regg_data,fd_data)$
    ( all_reg_aggr(row_data,row) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,va_data,regg_data,fd_data,"Value") )
    +
    sum((reg_data,va_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,row) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,fd_data,"Value") ) ;


EXPORT(reg,prd,row)
    = sum((reg_data,prd_data,row_data,exp_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(row_data,row) ),
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

TAX_EXPORT(reg,va,row)
    = sum((reg_data,va_data,row_data,exp_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(row_data,row) ),
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


TAX_SUB_PRD_DISTR(reg,tsp,regg,fd)
    = sum((regg_data,fd_data,reg_data,tsp_data)$
    ( all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) and
    all_reg_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) ),
    SAM_bp_data("%base_year%","%base_cur%",regg_data,fd_data,reg_data,tsp_data,"Value") ) ;

VALUE_ADDED_DISTR(reg,va,regg,fd)
    = sum((regg_data,fd_data,reg_data,va_data)$
    ( all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) and
    all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) ),
    SAM_bp_data("%base_year%","%base_cur%",regg_data,fd_data,reg_data,va_data,"Value") ) ;

INCOME_DISTR(reg,fd,regg,fdd)
    = sum((regg_data,fdd_data,reg_data,fd_data)$
    ( all_reg_aggr(regg_data,regg) and fd_aggr(fdd_data,fdd) and
    all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",regg_data,fdd_data,reg_data,fd_data,"Value") ) ;

* exclude income redistribution from the same agent
INCOME_DISTR(reg,fd,reg,fd) = 0 ;


TRANSFERS_ROW(reg,fd,row)
    = sum((reg_data,fd_data,row_data,exp_data)$
    ( all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) and
    all_reg_aggr(row_data,row) ),
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
SUP
INTER_USE_D
INTER_USE_M
INTER_USE_ROW
INTER_USE_dt
FINAL_USE_D
FINAL_USE_M
FINAL_USE_ROW
FINAL_USE_dt
TRADE
VALUE_ADDED
TAX_INTER_USE_ROW
TAX_FINAL_USE
TAX_FINAL_USE_ROW
EXPORT
TAX_EXPORT
TAX_SUB_PRD_DISTR
VALUE_ADDED_DISTR
INCOME_DISTR
TRANSFERS_ROW ;

* Deleting data to avoid memory issues
SAM_bp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,'Value') = 0 ;
SAM_dt_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,'Value') = 0 ;
SAM_pp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,'Value') = 0 ;




