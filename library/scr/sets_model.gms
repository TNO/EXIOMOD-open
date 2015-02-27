* File:   library/scr/sets_model.gms
* Author: Tatyana Bulavskaya
* Date:   14 May 2014
* Adjusted:   27 February 2015

* gams-master-file: main.gms

$ontext startdoc
This `.gms` file is one of the `.gms` files part of the `main.gms` file and
includes the equations and model formulation. Please start from `main.gms`.

This `.gms` file consists of the following parts:

1. Declaration of sets for the model

2. Declaration of aggregation scheme

3. Declaration of final demand types

4. Declaration of aliases

5. Consistency checks of aggregation scheme

More detailed information about the sets and mappings can be found in the
corresponding `.txt` file. All sets and maps can be changed to any level of
details. For this the `.txt` files should be changed (sets and/or maps). This
sets and maps in this file are mainly used in `aggregate_database.gms`,
`model_parameters.gms` and `model_variables_equations.gms`.
$offtext

* ===================== 1. Declaration of sets for the model ===================
$ontext
The following sets are defined:

Set name         | Explanation
---------------- | ----------
$offtext


Sets
    all_reg      full list of regions in the model
/
$include %project%/sets/regions_model.txt
$include %project%/sets/restoftheworld_model.txt
/

    reg(all_reg)  list of regions in the model
/
$include %project%/sets/regions_model.txt
/

    row(all_reg)  list of rest of the world regions in the model
/
$include %project%/sets/restoftheworld_model.txt
/
;

Sets
    prd             list of products in the model
/
$include %project%/sets/products_model.txt
/

    ind             list of industries in the model
/
$include %project%/sets/industries_model.txt
/

    tsp             list of taxes and subsidies on products in the model
/
$include %project%/sets/taxesandsubsidiesonproducts_model.txt
/

    va              list of value added categories in the model
/
$include %project%/sets/valueadded_model.txt
/

    fd              list of final demand categories in the model
/
$include %project%/sets/finaldemand_model.txt
/

    exp             list of export categories in the model
/
$include %project%/sets/export_model.txt
/
;

* ===================== 2. Declaration of aggregation scheme ===================
$ontext
The aggregation scheme consists of mappings used for aggregations of the (above)
sets from dimension1 to dimension2:

map name (dimension1, dimension2)       | Explanation
--------------------------------------- | -----------
$offtext

Sets
    all_reg_aggr(all_reg_data,all_reg)  aggregation scheme for full list of regions
/
$include %project%/sets/aggregation/regions_all_database_to_model.txt
/

    prd_aggr(prd_data,prd)          aggregation scheme for products
/
$include %project%/sets/aggregation/products_database_to_model.txt
/

    ind_aggr(ind_data,ind)          aggregation scheme for industries
/
$include %project%/sets/aggregation/industries_database_to_model.txt
/

    tsp_aggr(tsp_data,tsp)          aggregation scheme for taxes and subsidies on products
/
$include %project%/sets/aggregation/taxesandsubsidiesonproducts_database_to_model.txt
/

    va_aggr(va_data,va)             aggregation scheme for value added categories
/
$include %project%/sets/aggregation/valueadded_database_to_model.txt
/

    fd_aggr(fd_data,fd)             aggregation scheme for final demand categories
/
$include %project%/sets/aggregation/finaldemand_database_to_model.txt
/

    exp_aggr(exp_data,exp)          aggregation scheme for export categories
/
$include %project%/sets/aggregation/export_database_to_model.txt
/
;

* ================ 3. Declaration of types of final demands ====================
$ontext
The final demand categories in the model aggregation should be assigned to one
of the four types of final demands. The different types (household, government,
gross fixed capital formation, stock change) and their interactions will have
different functions in the model. Each final demand category should be assigned
to 1 type; but not all the types need to represented in the types.
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
    fd_assign(fd,fd_types)      indicator for types of final demand in the model aggregation
$include %project%/sets/finaldemand_categories_model.txt
;

* Check the assignment structure of final demand types
* Check that all fd elements are assigned to fd_types elements
loop(fd,
    ABORT$( sum(fd_types, fd_assign(fd,fd_types) ) ne 1 )
        "Some of the final demand categories in the model aggregation are not assigned to types" ;
) ;

* Check that fd_types element are not assigned more than 1 of fd
loop(fd_types,
    ABORT$( sum(fd, fd_assign(fd,fd_types) ) gt 1 )
        "Some of the final demand types are assigned more than 1 final demand categories" ;
) ;

* ===================== 4. Declaration of aliases ==============================
$ontext
Sometimes it is necessary to have more than one name for the same set. Aliases
are created by repeating the last character of the original set a number of
times. We define the following aliases (Original set, Aliases (new names for the original set)):
$offtext


Alias
    (reg,regg,reggg)
    (prd,prdd,prddd)
    (ind,indd,inddd)
    (fd,fdd,fddd)
;


* ================== 5. Check of aggregation schemes ===========================
$ontext
In case the configuration file requires check on consistency of aggregation
schemes, the check is performed in this code. For more details on types of
checks performed see the included file `scr/snippets/setaggregationcheck`.
$offtext

$if not '%agg_check%' == 'yes' $goto endofcode

$BATINCLUDE "library/includes/setaggregationcheck" all_reg_data    all_reg      all_reg_aggr
$BATINCLUDE "library/includes/setaggregationcheck" prd_data        prd          prd_aggr
$BATINCLUDE "library/includes/setaggregationcheck" ind_data        ind          ind_aggr
$BATINCLUDE "library/includes/setaggregationcheck" fd_data         fd           fd_aggr
$BATINCLUDE "library/includes/setaggregationcheck" va_data         va           va_aggr
$BATINCLUDE "library/includes/setaggregationcheck" exp_data        exp          exp_aggr
$BATINCLUDE "library/includes/setaggregationcheck" tsp_data        tsp          tsp_aggr

$label endofcode
