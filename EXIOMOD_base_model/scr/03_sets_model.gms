* File:   EXIOMOD_base_model/scr/03_sets_model.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted:   27 February 2015

* gams-master-file: 00_base_model_prepare.gms

$ontext startdoc
This code is used for declaration and definition of sets which are used in the
base model.

This file consists of the following parts:

- Declaration and assignment of sets for the model.
- Declaration and assignment of aggregation scheme.
- Declaration and assignment of types of value added elements.
- Declaration and assignment of final demand types.
- Declaration of aliases.
- Consistency checks of aggregation scheme.

More detailed information about the sets and mappings can be found in the
corresponding .txt files. All sets and maps can be changed to any level of
details. For this the .txt files should be changed (sets and/or maps). When
elements of a set are changed they should be give both element names and element
descriptions. The consistency check in the end of the file will assure that a
new aggregation is done correctly
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ====================== Declaration of sets for the model =====================

Sets
    all_reg      full list of regions in the model
/
$include %project%/00_base_model_setup/sets/regions_model.txt
$include %project%/00_base_model_setup/sets/restoftheworld_model.txt
/

    reg(all_reg)  list of regions in the model
/
$include %project%/00_base_model_setup/sets/regions_model.txt
/

    row(all_reg)  list of rest of the world regions in the model (one element)
/
$include %project%/00_base_model_setup/sets/restoftheworld_model.txt
/
;

* Check that only one rest of the world region is declared
ABORT$( card(row) gt 1 )
    "More than 1 rest of the region is declared" ;


Sets
    prd             list of products in the model
/
$include %project%/00_base_model_setup/sets/products_model.txt
/

    ind             list of industries in the model
/
$include %project%/00_base_model_setup/sets/industries_model.txt
/

    tsp             list of taxes and subsidies on products in the model
/
$include %project%/00_base_model_setup/sets/taxesandsubsidiesonproducts_model.txt
/

    va              list of value added categories in the model
/
$include %project%/00_base_model_setup/sets/valueadded_model.txt
/

    fd              list of final demand categories in the model
/
$include %project%/00_base_model_setup/sets/finaldemand_model.txt
/

    exp             list of export categories in the model
/
$include %project%/00_base_model_setup/sets/export_model.txt
/
;

* ====================== Declaration of aggregation scheme =====================

Sets
    all_reg_aggr(all_reg_data,all_reg)  aggregation scheme for full list of
                                        # regions
/
$include %project%/00_base_model_setup/sets/aggregation/regions_all_database_to_model.txt
/

    prd_aggr(prd_data,prd)              aggregation scheme for products
/
$include %project%/00_base_model_setup/sets/aggregation/products_database_to_model.txt
/

    ind_aggr(ind_data,ind)              aggregation scheme for industries
/
$include %project%/00_base_model_setup/sets/aggregation/industries_database_to_model.txt
/

    tsp_aggr(tsp_data,tsp)              aggregation scheme for taxes and
                                        # subsidies on products
/
$include %project%/00_base_model_setup/sets/aggregation/taxesandsubsidiesonproducts_database_to_model.txt
/

    va_aggr(va_data,va)                 aggregation scheme for value added
                                        # categories
/
$include %project%/00_base_model_setup/sets/aggregation/valueadded_database_to_model.txt
/

    fd_aggr(fd_data,fd)                 aggregation scheme for final demand
                                        # categories
/
$include %project%/00_base_model_setup/sets/aggregation/finaldemand_database_to_model.txt
/

    exp_aggr(exp_data,exp)              aggregation scheme for export categories
/
$include %project%/00_base_model_setup/sets/aggregation/export_database_to_model.txt
/
;

* ================ Declaration of types of value added elements ================
$ontext
The value added elements in the model aggregation should be assigned to one
of the three types of value added types. The different types (net tax on
production, factors of production, international margins and taxes) will have
different functions in the model, they will be included in different equations.
Each value added element should be assigned to 1 type; but not all the types
need to represented in the model.
$offtext

Set
    va_types
/
'NetTaxProduction'
'Capital'
'Labour'
'IntMargins'
'ExportTax'
/

Table
    va_assign(va,va_types)      indicator for types of value added elements in
                                # the model aggregation
$include %project%/00_base_model_setup/sets/valueadded_categories_model.txt
;

* Check the assignment structure of value added elements types
* Check that all va elements are assigned to va_types elements
loop(va,
    ABORT$( sum(va_types, va_assign(va,va_types) ) ne 1 )
        "Some of the value added elements in the model aggregation are not assigned to types or assigned to multiple types" ;
) ;

Sets
    ntp(va)         net taxes on production categories
    k(va)           capital categories
    l(va)           labour categories
    inm(va)         international margins categories
    tse(va)         tax on export categories
;


ntp(va)$va_assign(va,'NetTaxProduction') = yes ;
k(va)$va_assign(va,'Capital')            = yes ;
l(va)$va_assign(va,'Labour')             = yes ;
inm(va)$va_assign(va,'IntMargins')       = yes ;
tse(va)$va_assign(va,'ExportTax')        = yes ;

* ==================== Declaration of types of final demands ===================
$ontext
The final demand categories in the model aggregation should be assigned to one
of the four types of final demands. The different types (household, government,
gross fixed capital formation, stock change) and their interactions will have
different functions in the model. Each final demand category should be assigned
to 1 type; but not all the types need to represented in the model.
$offtext

Set
    fd_types
/
'Households'
'Government'
'GrossFixCapForm'
'StockChange'
/

Table
    fd_assign(fd,fd_types)      indicator for types of final demand in
                                # the model aggregation
$include %project%/00_base_model_setup/sets/finaldemand_categories_model.txt
;

* Check the assignment structure of final demand types
* Check that all fd elements are assigned to fd_types elements
loop(fd,
    ABORT$( sum(fd_types, fd_assign(fd,fd_types) ) ne 1 )
        "Some of the final demand categories in the model aggregation are not assigned to types or assigned to multiple types" ;
) ;

* Check that fd_types element are not assigned more than 1 of fd
loop(fd_types,
    ABORT$( sum(fd, fd_assign(fd,fd_types) ) gt 1 )
        "Some of the final demand types are assigned more than 1 final demand categories" ;
) ;

* =========================== Declaration of aliases ===========================
$ontext
Sometimes it is necessary to have more than one name for the same set. Aliases
are created by repeating the last character of the original set a number of
times.
$offtext

Alias
    (reg,regg,reggg)
    (prd,prdd,prddd)
    (ind,indd,inddd)
    (fd,fdd,fddd)
;


* ======================== Check of aggregation schemes ========================
$ontext
In case the configuration file requires check on consistency of aggregation
schemes, the check is performed in this code. For more details on types of
checks performed see the included file
EXIOMOD_base_model/includes/setaggregationcheck.
$offtext

$if not '%agg_check%' == 'yes' $goto endofcode

$BATINCLUDE "EXIOMOD_base_model/includes/setaggregationcheck" all_reg_data  all_reg  all_reg_aggr
$BATINCLUDE "EXIOMOD_base_model/includes/setaggregationcheck" prd_data      prd      prd_aggr
$BATINCLUDE "EXIOMOD_base_model/includes/setaggregationcheck" ind_data      ind      ind_aggr
$BATINCLUDE "EXIOMOD_base_model/includes/setaggregationcheck" fd_data       fd       fd_aggr
$BATINCLUDE "EXIOMOD_base_model/includes/setaggregationcheck" va_data       va       va_aggr
$BATINCLUDE "EXIOMOD_base_model/includes/setaggregationcheck" exp_data      exp      exp_aggr
$BATINCLUDE "EXIOMOD_base_model/includes/setaggregationcheck" tsp_data      tsp      tsp_aggr

$label endofcode
