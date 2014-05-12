
* ==================== Declaration of sets for the database ====================

Sets
         reg_data        list of regions in the database
/
$include sets/database/regions_database.txt
/

         prd_data       list of products in the database
/
$include sets/database/products_database.txt
/

         ind_data        list of industries in the database
/
$include sets/database/industries_database.txt
/

         fd_data         list of final demand categories in the database
/
$include sets/database/finaldemand_database.txt
/

         va_data         list of value added categories in the database
/
$include sets/database/valueadded_database.txt
/

         exp_data        list of export categories in the database
/
$include sets/database/export_database.txt
/

         row_data        list of rest of the world regions in the database
/
$include sets/database/restoftheworld_database.txt
/

         year_data       list of time periods in the database
/
$include sets/database/years_database.txt
/

         cur_data        list of currencies in the databse
/
$include sets/database/currencies_database.txt
/

         uim_data        use of imported products categories in the database
/
$include sets/database/useofimportedproducts_database.txt
/

         full_reg_list   full region list for reading-in the database
/
$include sets/database/regions_database.txt
$include sets/database/restoftheworld_database.txt
/

         full_row_list   full rows list (products value-added etc) for reading-in the database
/
$include sets/database/products_database.txt
$include sets/database/valueadded_database.txt
$include sets/database/useofimportedproducts_database.txt
/

         full_col_list   full columns list (industries final-demand etc) for reading-in the database
/
$include sets/database/industries_database.txt
$include sets/database/finaldemand_database.txt
$include sets/database/export_database.txt
/

;

Alias
         (full_reg_list,full_reg_list2)
;


* ============================ Read in the database ============================
Parameters
         SUP_data(year_data,cur_data,full_reg_list,full_row_list,full_reg_list2,full_col_list,*)      raw supply data
         USE_data(year_data,cur_data,full_reg_list,full_row_list,full_reg_list2,full_col_list,*)      raw use data
;

$LIBInclude      xlimport        SUP_data        data/SUTdata_long_format.xlsx   Supply!a1..g65
$LIBInclude      xlimport        USE_data        data/SUTdata_long_format.xlsx   Use!a1..g170


* ===================== Declaration of sets for the model ======================

Sets
         reg        list of regions in the model
/
$include sets/model/regions_model.txt
/

         prd       list of products in the model
/
$include sets/model/products_model.txt
/

         ind        list of industries in the model
/
$include sets/model/industries_model.txt
/

         fd         list of final demand categories in the model
/
$include sets/model/finaldemand_model.txt
/

         va         list of value added categories in the model
/
$include sets/model/valueadded_model.txt
/

         exp        list of export categories in the model
/
$include sets/model/export_model.txt
/

         row        list of rest of the world regions in the model
/
$include sets/model/restoftheworld_model.txt
/

         uim        use of imported products categories in the model
/
$include sets/model/useofimportedproducts_model.txt
/

         year_base(year_data)    base year for the model
/
$include sets/model/year_base.txt
/

         cur_base(cur_data)      base currency for the model
/
$include sets/model/currency_base.txt
/

         reg_aggr(reg_data,reg)  aggregation scheme for regions
/
$include sets/model/aggregation/regions_database_to_model.txt
/

         prd_aggr(prd_data,prd)  aggregation scheme for products
/
$include sets/model/aggregation/products_database_to_model.txt
/

         ind_aggr(ind_data,ind)  aggregation scheme for industries
/
$include sets/model/aggregation/industries_database_to_model.txt
/

         fd_aggr(fd_data,fd)     aggregation scheme for final demand categories
/
$include sets/model/aggregation/finaldemand_database_to_model.txt
/

         va_aggr(va_data,va)     aggregation scheme for value added categories
/
$include sets/model/aggregation/valueadded_database_to_model.txt
/

         exp_aggr(exp_data,exp)  aggregation scheme for export categories
/
$include sets/model/aggregation/export_database_to_model.txt
/

         row_aggr(row_data,row)  aggregation scheme for rest of the world regions
/
$include sets/model/aggregation/restoftheworld_database_to_model.txt
/

         uim_aggr(uim_data,uim)  aggregation scheme for use of imported products categories
/
$include sets/model/aggregation/useofimportedproducts_database_to_model.txt
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
         alpha(reg,va,ind)           value added coefficients
         C(reg,prd,regg,fd)          final demand vector
         EX(reg,prd,row,exp)         export vector

         Cshock(reg,prd,regg,fd)     final demand shock
;


* ========================== Definition of parameters ==========================

Y(reg,ind)       = sum((regg,prd), SUP_data("2007","MEUR",regg,prd,reg,ind,"Value")) ;
X(reg,prd)       = sum((regg,ind), SUP_data("2007","MEUR",reg,prd,regg,ind,"Value")) ;

Display Y,X ;

coprodA(reg,prd,regg,ind)$Y(regg,ind)
                 = SUP_data("2007","MEUR",reg,prd,regg,ind,"Value") / Y(regg,ind) ;
coprodB(reg,prd,regg,ind)$X(reg,prd)
                 = SUP_data("2007","MEUR",reg,prd,regg,ind,"Value") / X(reg,prd) ;

Display coprodA, coprodB ;

a(reg,prd,regg,ind)$Y(regg,ind)
                 = USE_data("2007","MEUR",reg,prd,regg,ind,"Value") / Y(regg,ind) ;

alpha(reg,va,ind)$Y(reg,ind)
                 = USE_data("2007","MEUR","N/A",va,reg,ind,"Value") / Y(reg,ind) ;

Display a, alpha ;

C(reg,prd,regg,fd)
                 = USE_data("2007","MEUR",reg,prd,regg,fd,"Value") ;

EX(reg,prd,row,exp)
                 = USE_data("2007","MEUR",reg,prd,row,exp,"Value") ;

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
