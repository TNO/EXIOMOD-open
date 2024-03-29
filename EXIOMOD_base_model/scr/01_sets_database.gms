* File:   EXIOMOD_base_model/scr/01_sets_database.gms
* Author: Tatyana Bulavskaya
* Organization: TNO, Netherlands
* Date:   14 May 2014
* Adjusted: 17 Februari 2021 by Hettie Boonman

* gams-master-file: 00_base_model_prepare.gms

********************************************************************************
* THIS MODEL IS A CUSTOM-LICENSE MODEL.
* EXIOMOD 2.0 shall not be used for commercial purposes until an exploitation
* aggreement is signed, subject to similar conditions as for the underlying
* database (EXIOBASE). EXIOBASE limitations are based on open source license
* agreements to be found here:
* http://exiobase.eu/index.php/terms-of-use

* For information on a license, please contact: hettie.boonman@tno.nl
********************************************************************************

$ontext startdoc
This code is used for declaration and definition of sets which are used in the
database underlying the base model.

The current version of the code includes sets relevant for inter-regional social
accounting matrix. The code includes:

- Declaration of sets including lists of regions, products, industries, etc.
- Loading contents of the sets from external .txt files.
- Declaration of super-sets where needed for loading the database.
- Declaration of aliase.

The code is split into blocks according to the supersets needed for loading the
database:

- Full list of regions
- Full list of row/column elements (in the matrix version)
- Auxiliary identifiers.

In case the structure of the database is changed and a set should be updated,
all the corrections should be done in the corresponding external .txt file. If a
new element is introduced in a set, it should include both the element name and
the element description. If a completely new set is introduced, it should be
given a name, a description, a new external .txt file with the list and it
should be included into one of the super-sets.
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ==== Declaration of database and rest-of-the-world regions lists, and the ====
* ========================== corresponding super-set ===========================

Sets
   all_reg_data           full region list for reading-in the database
/
$include EXIOMOD_base_model/sets/regions_database.txt
$include EXIOMOD_base_model/sets/restoftheworld_database.txt
/

   reg_data(all_reg_data) list of regions in the database
/
$include EXIOMOD_base_model/sets/regions_database.txt
/

   row_data(all_reg_data) list of rest of the world regions in the database
/
$include EXIOMOD_base_model/sets/restoftheworld_database.txt
/
;


* = Declaration of elements in defining dimensions of social accounting matrix,
* ======================= and the corresponding super-set ======================

Sets
   full_cat_list           full rows list (products value-added etc) for
                           # reading-in the database
/
$include EXIOMOD_base_model/sets/products_database.txt
$include EXIOMOD_base_model/sets/industries_database.txt
$include EXIOMOD_base_model/sets/taxesandsubsidiesonproducts_database.txt
$include EXIOMOD_base_model/sets/valueadded_database.txt
$include EXIOMOD_base_model/sets/finaldemand_database.txt
$include EXIOMOD_base_model/sets/export_database.txt
/

   prd_data(full_cat_list) list of products in the database
/
$include EXIOMOD_base_model/sets/products_database.txt
/

   ind_data(full_cat_list) list of industries in the database
/
$include EXIOMOD_base_model/sets/industries_database.txt
/

   tsp_data(full_cat_list) list of taxes and subsidies on products in the
                           # database
/
$include EXIOMOD_base_model/sets/taxesandsubsidiesonproducts_database.txt
/

   va_data(full_cat_list)  list of value added categories in the database
/
$include EXIOMOD_base_model/sets/valueadded_database.txt
/

   fd_data(full_cat_list)  list of final demand categories in the database
/
$include EXIOMOD_base_model/sets/finaldemand_database.txt
/

   exp_data(full_cat_list) list of export categories in the database
/
$include EXIOMOD_base_model/sets/export_database.txt
/
;


* ============ Declaration of auxiliary sets describing the database ===========

Sets
   year_data               list of time periods in the database
/
$include EXIOMOD_base_model/sets/years_database.txt
/

   cur_data                list of currencies in the database
/
$include EXIOMOD_base_model/sets/currencies_database.txt
/
;


* ===== Declaration of alias needed for further calculations with the data =====
$ontext
Sometimes it is necessary to have more than one name for the same set. Aliases
are created by repeating the last character of the original set a number of
times.
$offtext

Alias
   (reg_data,regg_data,reggg_data)
   (all_reg_data,all_regg_data)
   (full_cat_list,full_catt_list)
   (fd_data,fdd_data)
;


* Check that base year and base currency as defined in configuration.gms are in
* ============== the year_data and cur_data lists correspondingly ==============

ABORT$(SUM(sameas(year_data,"%base_year%"), 1) ne 1)
   "Base year is not in the database"

ABORT$(SUM(sameas(cur_data,"%base_cur%"), 1) ne 1)
   "Base currency is not in the database"
