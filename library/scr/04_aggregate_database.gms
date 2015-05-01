* File:   library/scr/04_aggregate_database.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted: 23 June 2014

* gams-master-file: 00_simulation_prepare.gms

$ontext startdoc
With this code the database is aggregated to the dimensions of the model, as
identified in 03_sets_model.gms. The database in the form of MRSUT is aggregated
and at the same time split into the following blocks:

- Supply table.
- Intermediate use: domestic, imported and taxes on products.
- Final use: domestic, imported and taxes on products.
- Trade with modeled regions and with the rest of the world region.
- Value added.
- Taxes on export and international margins paid by final users.
- Taxes on export and international margins paid to and by the rest of the world
  region.
- Distribution of taxes and factor incomes to final user.
- Distribution of income between final users.
- Transfers to and from the rest of the world region.

In the end of the code the database version of the data is removed. This data is
not being used in any further codes, and in case of using save and restart files
this allows to use less memory.

Whenever a new type of database is being used, this code may need to be be
revised to include possible aggregations.
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ============ Aggregation of the database to the model dimensions =============

Parameters
    SUP(reg,prd,regg,ind)                   supply table in model aggregation

    INTER_USE_D(prd,regg,ind)               intermediate use of domestic
                                            # products in model aggregation in
                                            # basic prices
    INTER_USE_M(prd,regg,ind)               intermediate use of imported
                                            # products (from modeled and rest of
                                            # the world regions) in model
                                            # aggregation in basic (c.i.f.)
                                            # prices
    INTER_USE_dt(prd,regg,ind)              tax paid domestically on
                                            # intermediate use in model
                                            # aggregation

    FINAL_USE_D(prd,regg,fd)                final use of domestic products in
                                            # model aggregation in basic prices
    FINAL_USE_M(prd,regg,fd)                final use of imported products (from
                                            # modeled and rest of the world
                                            # regions) in model aggregation in
                                            # basic (c.i.f.)prices
    FINAL_USE_dt(prd,regg,fd)               tax paid domestically on final use
                                            # in model aggregation

    TRADE(reg,prd,regg)                     trade in products between modeled
                                            # regions in basic (c.i.f.) prices
    IMPORT_ROW(prd,regg)                    import from the rest of the world
                                            # region in model aggregation in
                                            # basic (c.i.f.) prices

    VALUE_ADDED(reg,va,regg,ind)            value added in model aggregation
    TAX_INTER_USE_ROW(va,regg,ind)          tax and international margins
                                            # paid on intermediate use of
                                            # products imported from the rest of
                                            # the world region

    TAX_FINAL_USE(reg,va,regg,fd)           tax and international margins paid
                                            # on final use of products imported
                                            # from modeled regions
    TAX_FINAL_USE_ROW(va,regg,fd)           tax and international margins paid
                                            # on final use of products imported
                                            # from the rest of the world region

    EXPORT_ROW(reg,prd)                     export to the rest of the world
                                            # region in model aggregation in
                                            # basic (f.o.b.) prices
    TAX_EXPORT_ROW(reg,va)                  tax and international margin
                                            # received due to export to the rest
                                            # of the world regions

    TAX_SUB_PRD_DISTR(reg,tsp,regg,fd)      distribution of revenues from taxes
                                            # and subsidies on products to final
                                            # demand categories in model
                                            # aggregation
    VALUE_ADDED_DISTR(reg,va,regg,fd)       distribution of value added revenues
                                            # to final demand categories in
                                            # model aggregation

    INCOME_DISTR(reg,fd,regg,fdd)           re-distribution of income between
                                            # final demand categories in model
                                            # aggregation

    TRANSFERS_ROW(reg,fd)                   transfers between the rest of the
                                            # world region and final demand
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
    ( not all_reg_aggr(reg_data,regg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") )
    +
    sum((row_data,prd_data,regg_data,ind_data)$
    ( prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,ind_data,"Value") ) ;

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
    ( not all_reg_aggr(reg_data,regg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") )
    +
    sum((row_data,prd_data,regg_data,fd_data)$
    ( prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,fd_data,"Value") ) ;

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

IMPORT_ROW(prd,regg)
    = sum((row_data,prd_data,regg_data,ind_data)$
    ( prd_aggr(prd_data,prd) and all_reg_aggr(regg_data,regg) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,ind_data,"Value") )
    +
    sum(row, sum((reg_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) )
    +
    sum((row_data,prd_data,regg_data,fd_data)$
    ( prd_aggr(prd_data,prd) and all_reg_aggr(regg_data,regg) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,prd_data,regg_data,fd_data,"Value") )
    +
    sum(row, sum((reg_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,row) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,regg) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ) ;


VALUE_ADDED(reg,va,regg,ind)
    = sum((reg_data,va_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,ind_data,"Value") ) ;

TAX_INTER_USE_ROW(va,regg,ind)
    = sum((row_data,va_data,regg_data,ind_data)$
    ( va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,va_data,regg_data,ind_data,"Value") )
    +
    sum(row, sum((reg_data,va_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,row) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,ind_data,"Value") ) ) ;


TAX_FINAL_USE(reg,va,regg,fd)
    = sum((reg_data,va_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,fd_data,"Value") ) ;

TAX_FINAL_USE_ROW(va,regg,fd)
    = sum((row_data,va_data,regg_data,fd_data)$
    ( va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",row_data,va_data,regg_data,fd_data,"Value") )
    +
    sum(row, sum((reg_data,va_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,row) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,fd_data,"Value") ) ) ;


EXPORT_ROW(reg,prd)
    = sum((reg_data,prd_data,row_data,exp_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,row_data,exp_data,"Value") )
    +
    sum(row, sum((reg_data,prd_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,row) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) )
    +
    sum(row, sum((reg_data,prd_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
    all_reg_aggr(regg_data,row) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ) ;

TAX_EXPORT_ROW(reg,va)
    = sum((reg_data,va_data,row_data,exp_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,row_data,exp_data,"Value") )
    +
    sum(row, sum((reg_data,va_data,regg_data,ind_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,row) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,ind_data,"Value") ) )
    +
    sum(row, sum((reg_data,va_data,regg_data,fd_data)$
    ( all_reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
    all_reg_aggr(regg_data,row) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,va_data,regg_data,fd_data,"Value") ) ) ;


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

* make net redistribution from government to investment agent in the same region
INCOME_DISTR(reg,fd,reg,fdd)$( fd_assign(fd,'Government') and
    fd_assign(fdd,'GrossFixCapForm') ) = INCOME_DISTR(reg,fd,reg,fdd) -
    INCOME_DISTR(reg,fdd,reg,fd) ;

INCOME_DISTR(reg,fd,reg,fdd)$( fd_assign(fd,'GrossFixCapForm') and
    fd_assign(fdd,'Government') ) = 0 ;


TRANSFERS_ROW(reg,fd)
    = sum((reg_data,fd_data,row_data,exp_data)$
    ( all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,fd_data,row_data,exp_data,"Value") )
    +
    sum(row, sum((reg_data,fd_data,regg_data,fdd_data)$
    ( all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) and
    all_reg_aggr(regg_data,row) ),
    SAM_bp_data("%base_year%","%base_cur%",reg_data,fd_data,regg_data,fdd_data,"Value") ) )
    -
    sum(row, sum((regg_data,fdd_data,reg_data,fd_data)$
    ( all_reg_aggr(regg_data,row) and
    all_reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
    SAM_bp_data("%base_year%","%base_cur%",regg_data,fdd_data,reg_data,fd_data,"Value") ) ) ;

Display
SUP
INTER_USE_D
INTER_USE_M
INTER_USE_dt
FINAL_USE_D
FINAL_USE_M
FINAL_USE_dt
TRADE
IMPORT_ROW
VALUE_ADDED
TAX_INTER_USE_ROW
TAX_FINAL_USE
TAX_FINAL_USE_ROW
EXPORT_ROW
TAX_EXPORT_ROW
TAX_SUB_PRD_DISTR
VALUE_ADDED_DISTR
INCOME_DISTR
TRANSFERS_ROW
;

* Deleting data that will not be used further to avoid memory issues
SAM_bp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,'Value') = 0 ;
SAM_dt_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,'Value') = 0 ;
SAM_pp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,'Value') = 0 ;
