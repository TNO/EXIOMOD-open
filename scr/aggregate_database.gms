
* ============ Aggregation of the database to the model dimensions =============

Parameters
         SUP_model(reg,prd,regg,ind)             supply table in model aggregation

         INTER_USE_model(reg,prd,regg,ind)       intermediate use in model aggregation
         FINAL_USE_model(reg,prd,regg,fd)        final use in model aggregation
         EXPORT_model(reg,prd,row,exp)           export to rest of the world regions in model aggregation
         VALUE_ADDED_model(reg,va,ind)           value added in model aggregation
         TAX_SUB_model(reg,tsp,use_col)          taxes and subsidies on products in model aggregation
         IMPORT_USE_model(reg,uip,row,use_col)   use of imported products in model aggregation
;

SUP_model(reg,prd,regg,ind)
                 = sum((reg_data,prd_data,regg_data,ind_data)$
                       ( reg_full_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_full_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       SUP_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;

INTER_USE_model(reg,prd,regg,ind)
                 = sum((reg_data,prd_data,regg_data,ind_data)$
                       ( reg_full_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_full_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       USE_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") ) ;

FINAL_USE_model(reg,prd,regg,fd)
                 = sum((reg_data,prd_data,regg_data,fd_data)$
                       ( reg_full_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_full_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
                       USE_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

EXPORT_model(reg,prd,row,exp)
                 = sum((reg_data,prd_data,row_data,exp_data)$
                       ( reg_full_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_full_aggr(row_data,row) and exp_aggr(exp_data,exp) ),
                       USE_data("%base_year%","%base_cur%",reg_data,prd_data,row_data,exp_data,"Value") )
                   +
                   sum((reg_data,prd_data,regg_data,ind_data)$
                       ( reg_full_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_full_aggr(regg_data,row) ),
                       USE_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,ind_data,"Value") )
                   +
                   sum((reg_data,prd_data,regg_data,fd_data)$
                       ( reg_full_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_full_aggr(regg_data,row) ),
                       USE_data("%base_year%","%base_cur%",reg_data,prd_data,regg_data,fd_data,"Value") ) ;

VALUE_ADDED_model(reg,va,ind)
                 = sum((reg_data,va_data,ind_data)$
                       ( reg_full_aggr(reg_data,reg) and va_aggr(va_data,va) and
                         ind_aggr(ind_data,ind) ),
                       USE_data("%base_year%","%base_cur%",reg_data,va_data,reg_data,ind_data,"Value") ) ;

TAX_SUB_model(reg,tsp,ind)
                 = sum((reg_data,tsp_data,ind_data)$
                       ( reg_full_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) and
                         ind_aggr(ind_data,ind) ),
                       USE_data("%base_year%","%base_cur%",reg_data,tsp_data,reg_data,ind_data,"Value") ) ;

TAX_SUB_model(reg,tsp,fd)
                 = sum((reg_data,tsp_data,fd_data)$
                       ( reg_full_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) and
                         fd_aggr(fd_data,fd) ),
                       USE_data("%base_year%","%base_cur%",reg_data,tsp_data,reg_data,fd_data,"Value") ) ;

TAX_SUB_model(reg,tsp,exp)
                 = sum((reg_data,tsp_data,exp_data)$
                       ( reg_full_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) and
                         exp_aggr(exp_data,exp) ),
                       USE_data("%base_year%","%base_cur%",reg_data,tsp_data,reg_data,exp_data,"Value") ) ;

IMPORT_USE_model(reg,uip,row,ind)
                 = sum((row_data,uip_data,reg_data,ind_data)$
                       ( reg_full_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         reg_full_aggr(reg_data,reg) and ind_aggr(ind_data,ind) ),
                       USE_data("%base_year%","%base_cur%",row_data,uip_data,reg_data,ind_data,"Value") )
                   +
                   sum((regg_data,prd_data,reg_data,ind_data)$
                       ( reg_full_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         reg_full_aggr(reg_data,reg) and ind_aggr(ind_data,ind) ),
                       USE_data("%base_year%","%base_cur%",regg_data,prd_data,reg_data,ind_data,"Value") ) ;

IMPORT_USE_model(reg,uip,row,fd)
                 = sum((row_data,uip_data,reg_data,fd_data)$
                       ( reg_full_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         reg_full_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
                       USE_data("%base_year%","%base_cur%",row_data,uip_data,reg_data,fd_data,"Value") )
                   +
                   sum((regg_data,prd_data,reg_data,fd_data)$
                       ( reg_full_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         reg_full_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
                       USE_data("%base_year%","%base_cur%",regg_data,prd_data,reg_data,fd_data,"Value") ) ;

IMPORT_USE_model(reg,uip,row,exp)
                 = sum((row_data,uip_data,reg_data,exp_data)$
                       ( reg_full_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         reg_full_aggr(reg_data,reg) and exp_aggr(exp_data,exp) ),
                       USE_data("%base_year%","%base_cur%",row_data,uip_data,reg_data,exp_data,"Value") )
                   +
                   sum((regg_data,prd_data,reg_data,exp_data)$
                       ( reg_full_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         reg_full_aggr(reg_data,reg) and exp_aggr(exp_data,exp) ),
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
