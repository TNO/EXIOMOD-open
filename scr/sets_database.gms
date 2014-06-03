
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
;

Sets
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
;

Sets
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
;

Sets
         year_data               list of time periods in the database
/
$include sets/database/years_database.txt
/

         cur_data                list of currencies in the database
/
$include sets/database/currencies_database.txt
/
;

Alias
         (reg_data,regg_data)
         (full_reg_list,full_regg_list)
;


* Check that base year and base currency defined in configuration.gms is in the
* year_data and cur_data lists correspondingly

ABORT$(SUM(sameas(year_data,"%base_year%"), 1) ne 1)
   "Base year is not in the database"

ABORT$(SUM(sameas(cur_data,"%base_cur%"), 1) ne 1)
   "Base currency is not in the database"
