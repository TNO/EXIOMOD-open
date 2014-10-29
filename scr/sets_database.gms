* File:   scr/sets_database.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted:   22 June 2014

* gams-master-file: main.gms

$ontext startdoc
This code is used for declaration and definition of sets which are used in the
database underlying the input-output/CGE model.

The current version of the code includes sets relevant for inter-regional social
accounting matrix. The code includes:

 - declaration of sets including lists of regions, products, industries, etc.
 - loading contents of the sets from external .txt files.
 - declaration of super-sets where needed for loading the database.
 - declaration of alias.

The code is split into blocks according to the supersets needed for loading the
database: full list of regions, full list of row/column elements (in the matrix
version), auxiliary identifiers.

In case the structure of the database is changed and a set should be updated,
all the corrections should be done in the corresponding external .txt file. If a
new element is introduced in a set, it should include both the element name and
the element description. If a completely new set is introduced, it should be
given a name, a description, a new external .txt file with the list and it
should be included into one of the super-sets.
$offtext


* Declaration of database and rest-of-the-world regions lists, and the
* corresponding super-set

Sets
         all_reg_data           full region list for reading-in the database
/
$include sets/database/regions_database.txt
$include sets/database/restoftheworld_database.txt
/

         reg_data(all_reg_data) list of regions in the database
/
$include sets/database/regions_database.txt
/

         row_data(all_reg_data) list of rest of the world regions in the database
/
$include sets/database/restoftheworld_database.txt
/
;


* Declaration of elements in defining dimensions of social accounting matrix,
* and the corresponding super-set

Sets
         full_cat_list           full rows list (products value-added etc) for reading-in the database
/
$include sets/database/products_database.txt
$include sets/database/industries_database.txt
$include sets/database/taxesandsubsidiesonproducts_database.txt
$include sets/database/valueadded_database.txt
$include sets/database/finaldemand_database.txt
$include sets/database/export_database.txt
/

         prd_data(full_cat_list) list of products in the database
/
$include sets/database/products_database.txt
/

         ind_data(full_cat_list) list of industries in the database
/
$include sets/database/industries_database.txt
/

         tsp_data(full_cat_list) list of taxes and subsidies on products in the database
/
$include sets/database/taxesandsubsidiesonproducts_database.txt
/

         va_data(full_cat_list)  list of value added categories in the database
/
$include sets/database/valueadded_database.txt
/

         fd_data(full_cat_list)  list of final demand categories in the database
/
$include sets/database/finaldemand_database.txt
/

         exp_data(full_cat_list) list of export categories in the database
/
$include sets/database/export_database.txt
/
;


* Declaration of auxiliary sets describing the database

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


* Declaration of alias needed for further calculations with the data

Alias
         (reg_data,regg_data)
         (all_reg_data,all_regg_data)
         (full_cat_list,full_catt_list)
         (fd_data,fdd_data)
;


* Check that base year and base currency defined in configuration.gms is in the
* year_data and cur_data lists correspondingly

ABORT$(SUM(sameas(year_data,"%base_year%"), 1) ne 1)
   "Base year is not in the database"

ABORT$(SUM(sameas(cur_data,"%base_cur%"), 1) ne 1)
   "Base currency is not in the database"
