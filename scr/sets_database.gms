
*' sets_database.gms
*' author: Tatyana Bulavskaya
*' date: 14 May 2014

* gams-master-file: main.gms

$ontext
This code is used for declaration and definition of sets which are used in the
database underlying the input-output/CGE model.

The current version of the code includes sets relevant for inter-regional supply
and use tables. The code includes:

 - declaration of sets including lists of regions, products, industries, etc.
 - loading contents of the sets from external .txt files.
 - declaration of super-sets where needed for loading the database.
 - declaration of alias.

The code is split into blocks according to the supersets needed for loading the
database: full list of regions, full list of row elements (in the matrix
version), full list of column elements (in the matrix version), auxiliary
identifiers.

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


* Declaration of product, value added elements lists and other elements in the
* rows of a use table, and the corresponding super-set

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


* Declaration of industry, final demand elements list and other elements in the
* columns of a use table, and the corresponding super-set

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
         (full_reg_list,full_regg_list)
;
