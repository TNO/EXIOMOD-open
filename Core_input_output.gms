
* ==================== Declaration of sets for the database ====================

Sets
         full_reg_list           full region list for reading-in the database
/
$include sets/database/regions_database.txt
$include sets/database/restoftheworld_database.txt
/

         reg_data(full_reg_list) list of regions in the database
/
$include sets/database/regions_database.txt
/

         row_data(full_reg_list) list of rest of the world regions in the database
/
$include sets/database/restoftheworld_database.txt
/


         full_row_list           full rows list (products value-added etc) for reading-in the database
/
$include sets/database/products_database.txt
$include sets/database/valueadded_database.txt
$include sets/database/taxesandsubsidiesonproducts_database.txt
$include sets/database/useofimportedproducts_database.txt
/

         prd_data(full_row_list) list of products in the database
/
$include sets/database/products_database.txt
/

         va_data(full_row_list)  list of value added categories in the database
/
$include sets/database/valueadded_database.txt
/

         tsp_data(full_row_list) list of taxes and subsidies on products in the database
/
$include sets/database/taxesandsubsidiesonproducts_database.txt
/

         uip_data(full_row_list) use of imported products categories in the database
/
$include sets/database/useofimportedproducts_database.txt
/


         full_col_list           full columns list (industries final-demand etc) for reading-in the database
/
$include sets/database/industries_database.txt
$include sets/database/finaldemand_database.txt
$include sets/database/export_database.txt
/

         ind_data(full_col_list) list of industries in the database
/
$include sets/database/industries_database.txt
/

         fd_data(full_col_list)  list of final demand categories in the database
/
$include sets/database/finaldemand_database.txt
/

         exp_data(full_col_list) list of export categories in the database
/
$include sets/database/export_database.txt
/


         year_data               list of time periods in the database
/
$include sets/database/years_database.txt
/

         cur_data                list of currencies in the databse
/
$include sets/database/currencies_database.txt
/
;

Alias
         (reg_data,regg_data)
         (full_reg_list,full_regg_list)
;


* ============================ Read in the database ============================
Parameters
         SUP_data(year_data,cur_data,full_reg_list,full_row_list,full_regg_list,full_col_list,*)      raw supply data
         USE_data(year_data,cur_data,full_reg_list,full_row_list,full_regg_list,full_col_list,*)      raw use data
;

$LIBInclude      xlimport        SUP_data        data/SUTdata_long_format.xlsx   Supply!a1..g65
$LIBInclude      xlimport        USE_data        data/SUTdata_long_format.xlsx   Use!a1..g170


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

         year_base(year_data)            base year for the model
/
$include sets/model/year_base.txt
/

         cur_base(cur_data)              base currency for the model
/
$include sets/model/currency_base.txt
/

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
;

Alias
         (reg,regg,reggg)
         (prd,prdd,prddd)
         (ind,indd,inddd)
;


* ========================= Declaration of parameters ==========================

Parameters
         Y(reg,ind)                  output vector by activity
         X(reg,prd)                  output vector by product
         coprodA(reg,prd,regg,ind)   coproduction coefficients with mix per industry - corresponds to product technology assumption
         coprodB(reg,prd,regg,ind)   coproduction coefficients with mix per product  - corresponds to industry technology assumption
         a(reg,prd,regg,ind)         technical input coefficients
         V(reg,va,ind)               value added vector
         TS(reg,tsp,use_col)         taxes and subsidies on products vector
         IM(reg,use_col,row,uip)     use of imported products vector
         C(reg,prd,regg,fd)          final demand vector
         EX(reg,prd,row,exp)         export vector

         Cshock(reg,prd,regg,fd)     final demand shock
;


* ========================== Definition of parameters ==========================

Y(reg,ind)       = sum((year_base,cur_base,regg_data,prd_data,reg_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and ind_aggr(ind_data,ind) ),
                       SUP_data(year_base,cur_base,regg_data,prd_data,reg_data,ind_data,"Value")) ;

X(reg,prd)       = sum((year_base,cur_base,reg_data,prd_data,regg_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) ),
                       SUP_data(year_base,cur_base,reg_data,prd_data,regg_data,ind_data,"Value")) ;

Display Y,X ;

coprodA(reg,prd,regg,ind)$Y(regg,ind)
                 = sum((year_base,cur_base,reg_data,prd_data,regg_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       SUP_data(year_base,cur_base,reg_data,prd_data,regg_data,ind_data,"Value") ) / Y(regg,ind) ;

coprodB(reg,prd,regg,ind)$X(reg,prd)
                 = sum((year_base,cur_base,reg_data,prd_data,regg_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       SUP_data(year_base,cur_base,reg_data,prd_data,regg_data,ind_data,"Value") ) / X(reg,prd) ;

Display coprodA, coprodB ;

a(reg,prd,regg,ind)$Y(regg,ind)
                 = sum((year_base,cur_base,reg_data,prd_data,regg_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_aggr(regg_data,regg) and ind_aggr(ind_data,ind) ),
                       USE_data(year_base,cur_base,reg_data,prd_data,regg_data,ind_data,"Value") ) / Y(regg,ind) ;

V(reg,va,ind)$Y(reg,ind)
                 = sum((year_base,cur_base,reg_data,va_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and va_aggr(va_data,va) and
                         ind_aggr(ind_data,ind) ),
                       USE_data(year_base,cur_base,reg_data,va_data,reg_data,ind_data,"Value") ) ;

TS(reg,tsp,ind)  = sum((year_base,cur_base,reg_data,tsp_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) and
                         ind_aggr(ind_data,ind) ),
                       USE_data(year_base,cur_base,reg_data,tsp_data,reg_data,ind_data,"Value") ) ;

TS(reg,tsp,fd)   = sum((year_base,cur_base,reg_data,tsp_data,fd_data)$
                       ( reg_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) and
                         fd_aggr(fd_data,fd) ),
                       USE_data(year_base,cur_base,reg_data,tsp_data,reg_data,fd_data,"Value") ) ;

TS(reg,tsp,exp)  = sum((year_base,cur_base,reg_data,tsp_data,exp_data)$
                       ( reg_aggr(reg_data,reg) and tsp_aggr(tsp_data,tsp) and
                         exp_aggr(exp_data,exp) ),
                       USE_data(year_base,cur_base,reg_data,tsp_data,reg_data,exp_data,"Value") ) ;

IM(reg,ind,row,uip)
                 = sum((year_base,cur_base,row_data,uip_data,reg_data,ind_data)$
                       ( row_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         reg_aggr(reg_data,reg) and ind_aggr(ind_data,ind) ),
                       USE_data(year_base,cur_base,row_data,uip_data,reg_data,ind_data,"Value") )
                   +
                   sum((year_base,cur_base,regg_data,prd_data,reg_data,ind_data)$
                       ( row_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         reg_aggr(reg_data,reg) and ind_aggr(ind_data,ind) ),
                       USE_data(year_base,cur_base,regg_data,prd_data,reg_data,ind_data,"Value") ) ;

IM(reg,fd,row,uip)
                 = sum((year_base,cur_base,row_data,uip_data,reg_data,fd_data)$
                       ( row_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
                       USE_data(year_base,cur_base,row_data,uip_data,reg_data,fd_data,"Value") )
                   +
                   sum((year_base,cur_base,regg_data,prd_data,reg_data,fd_data)$
                       ( row_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         reg_aggr(reg_data,reg) and fd_aggr(fd_data,fd) ),
                       USE_data(year_base,cur_base,regg_data,prd_data,reg_data,fd_data,"Value") ) ;

IM(reg,exp,row,uip)
                 = sum((year_base,cur_base,row_data,uip_data,reg_data,exp_data)$
                       ( row_aggr(row_data,row) and uip_aggr(uip_data,uip) and
                         reg_aggr(reg_data,reg) and exp_aggr(exp_data,exp) ),
                       USE_data(year_base,cur_base,row_data,uip_data,reg_data,exp_data,"Value") )
                   +
                   sum((year_base,cur_base,regg_data,prd_data,reg_data,exp_data)$
                       ( row_aggr(regg_data,row) and prd_uip_aggr(prd_data,uip) and
                         reg_aggr(reg_data,reg) and exp_aggr(exp_data,exp) ),
                       USE_data(year_base,cur_base,regg_data,prd_data,reg_data,exp_data,"Value") ) ;

Display a, V, TS, IM ;

C(reg,prd,regg,fd)
                 = sum((year_base,cur_base,reg_data,prd_data,regg_data,fd_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         reg_aggr(regg_data,regg) and fd_aggr(fd_data,fd) ),
                       USE_data(year_base,cur_base,reg_data,prd_data,regg_data,fd_data,"Value") ) ;

EX(reg,prd,row,exp)
                 = sum((year_base,cur_base,reg_data,prd_data,row_data,exp_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         row_aggr(row_data,row) and exp_aggr(exp_data,exp) ),
                       USE_data(year_base,cur_base,reg_data,prd_data,row_data,exp_data,"Value") )
                   +
                   sum((year_base,cur_base,reg_data,prd_data,regg_data,ind_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         row_aggr(regg_data,row) ),
                       USE_data(year_base,cur_base,reg_data,prd_data,regg_data,ind_data,"Value") )
                   +
                   sum((year_base,cur_base,reg_data,prd_data,regg_data,fd_data)$
                       ( reg_aggr(reg_data,reg) and prd_aggr(prd_data,prd) and
                         row_aggr(regg_data,row) ),
                       USE_data(year_base,cur_base,reg_data,prd_data,regg_data,fd_data,"Value") ) ;

Display C, EX ;


* ========================== Declaration of variables ==========================

Positive variables
         Y_V(reg,ind)   output vector activities
         X_V(reg,prd)   output vector products
;

Variables
         obj            artificial objective value
;


* ========================== Declaration of equations ==========================

Equations
         EQBAL(reg,prd)    product market balance
         EQX(reg,prd)      output level of products
         EQY(reg,ind)      output level of activities
         EQOBJ             artificial objective function
;


* ========================== Definition of equations ===========================

EQBAL(reg,prd)..       sum((regg,fd), C(reg,prd,regg,fd)) +
                       sum((regg,fd), Cshock(reg,prd,regg,fd)) +
                       sum((row,exp), EX(reg,prd,row,exp)) +
                       sum((regg,ind), a(reg,prd,regg,ind) * Y_V(regg,ind))
                       =E=
                       X_V(reg,prd) ;

EQX(reg,prd)..         X_V(reg,prd)
                       =E=
                       sum((regg,ind), coprodA(reg,prd,regg,ind) * Y_V(regg,ind)) ;

EQY(reg,ind)..         Y_V(reg,ind)
                       =E=
                       sum((regg,prd), coprodB(regg,prd,reg,ind) * X_V(regg,prd)) ;

EQOBJ..                obj
                       =E=
                       1 ;


* ======== Define levels and lower and upper bounds and fixed variables ========

Y_V.L(reg,ind)     = Y(reg,ind) ;
Y_V.UP(reg,ind)    = 100 * Y(reg,ind) ;

X_V.L(reg,prd)     = X(reg,prd) ;
X_V.UP(reg,prd)    = 100 * X(reg,prd) ;


* ========================== Declare model equations ===========================

Model product_technology
/
EQBAL
EQX
EQOBJ
/ ;

Model industry_technology
/
EQBAL
EQY
EQOBJ
/ ;


* ============================== Simulation setup ==============================

Cshock(reg,prd,regg,"FC")$sameas(reg,regg)   = 1 ;

Display Cshock;


* =============================== Solve statement ==============================

Solve product_technology using lp maximizing obj ;
*Solve industry_technology using lp maximizing obj ;


* ========================= Post-processing of results =========================

Parameters
         deltaY(reg,ind)       change in activity output
         deltaX(reg,prd)       change in product output
;

deltaY(reg,ind) = Y_V.L(reg,ind) - Y(reg,ind) ;
deltaX(reg,prd) = X_V.L(reg,prd) - X(reg,prd) ;

Display deltaY, deltaX ;
