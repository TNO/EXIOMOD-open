# Documentation of main.gms

## File loading structure

* [`main.gms`](#main.gms-index)
    * [`configuration.gms`](#configuration.gms-index)
    * [`scr/sets_database.gms`](#scrsets_database.gms-index)
    * [`scr/load_database.gms`](#scrload_database.gms-index)
    * [`scr/sets_model.gms`](#scrsets_model.gms-index)
    * [`scr/aggregate_database.gms`](#scraggregate_database.gms-index)
    * [`scr/model_parameters.gms`](#scrmodel_parameters.gms-index)
    * [`scr/model_variables_equations.gms`](#scrmodel_variables_equations.gms-index)
    * [`scr/simulation/final_demand_shock.gms`](#scrsimulationfinal_demand_shock.gms-index)

## Values of global variables

Global        | Value         | Defined in file
------------- |:------------- |:---------------
`base_year` | `2011` | [`configuration.gms`](#configuration.gms-index)
`base_cur` | `MEUR` | [`configuration.gms`](#configuration.gms-index)
`io_type` | `industry_technology` | [`configuration.gms`](#configuration.gms-index)
`simulation_setup` | `final_demand_shock` | [`configuration.gms`](#configuration.gms-index)


## main.gms ([index](#file-loading-structure))

* `main.gms`

This is the `main.gms` code for the core input-output model. The code consists
of the following parts:

 * Include `configuration.gms`, where some key parameters relevant for data,
   model and simulation choices are set.
 * Include `sets_database.gms`, where sets used in the database are declared.
 * Include `load_database.gms`, where external input-output/supply-use database
   is loaded.
 * Include `sets_model.gms`, where sets used in the model are declared and their
   relations for the sets in the database are defined.
 * Include `aggregate_database.gms`, where the database is aggregated to the
   dimensions of the model, identified in `sets_model.gms`.
 * Include `model_parameters.gms`, where key parameters of input-output model
   are defined.
 * Include `model_variables_equations.gms`, where variables, equations and the
   model itself are defined.
 * Include `%simulation_setup%.gms`, where simulation setup, solve statement and
   post-processing of the results are defined. `%simulation%` is set within
   `configuration.gms`
 * Clear up possible temporary files produced by GAMS.

More specific explanation of each of the included part of the script can be
found in the corresponding `.gms` file. These explanation blocks include which
inputs are necessary for the scripts to run and which changes are possible.

## configuration.gms ([index](#file-loading-structure))

* `main.gms`
    * `configuration.gms`

This is the configuration file for the core input-output model. The file allows
to configure the following control variables:

Variable           | Explanation
------------------ | -----------
`base_year`        | select one of the years available in the database.
`base_cur`         | select one of the currencies available in the database.
`io_type`          | select one of input-output model types.
`simulation_setup` | select out of one of the preprogrammed simulation setup available in `scr/simulation/`.

## scr/sets_database.gms ([index](#file-loading-structure))

* `main.gms`
    * `scr/sets_database.gms`

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

## scr/load_database.gms ([index](#file-loading-structure))

* `main.gms`
    * `scr/load_database.gms`

This gms file is one of the gms files called from the `main.gms` file. 

It defines two types of parameters:

  1. SUP_data
  2. USE_data

It calibrates these parameters by loading the input-output/supply-use database from an xlsx file.


## scr/sets_model.gms ([index](#file-loading-structure))

* `main.gms`
    * `scr/sets_model.gms`

This `.gms` file is one of the `.gms` files part of the `main.gms` file and includes the equations and model formulation. Please start from `main.gms`.

This `.gms` file consists of the following parts:

### Declaration of sets for the model

The following sets are defined:

Set name         | Explanation
---------------- | ----------
`reg`            | regions used for the model `regions_model.txt`
`row`            | rest of the world regions used in the model `restoftheworld_model.txt`
`prd`            | products `products_model.txt`
`va`             | value added `valueadded_model.txt`
`tsp`            | taxes and subsidies `taxesandsubsidiesonproducts_model.txt`
`uip`            | imports `useofimportedproducts_model.txt`
`inm`            | international margins `internationalmargins_model.txt`
`val`            | valuation categories `valuation_model.txt`
`use_col`        | use table (columns) consists of `ind`, `fd` and `exp` explaned on the next lines
`ind(use_col)`   | 19 industries `industries_model.txt`, a subset of `use_col`
`fd(use_col)`    | final demand `finaldemand_model.txt`, a subset of `use_col`
`exp(use_col)`   | exports `export_model.txt`, a subset of `use_col`
`reg_sim(reg)`   | list of regions used in simulation setup, a subset of `reg`
`prd_sim(prd)`   | list of products used in simulation setup, a subset of `prd`



### Declaration of aggregation scheme

The aggregation scheme consists of mappings used for aggregations of the (above) sets from dimension1 to dimension2:

map name (dimension1, dimension2)       | Explanation
--------------------------------------- | -----------
`reg_aggr(reg_data,reg)`                | Aggregates scheme for regions `regions_database_to_model.txt `
`prd_aggr(prd_data,prd)`                | Aggregates scheme for products `products_database_to_model.txt`
`ind_aggr(ind_data,ind)`                | Aggregates scheme for industries `industries_database_to_model.txt`
`fd_aggr(fd_data,fd)`                   | Aggregates scheme for final demand `finaldemand_database_to_model.txt`
`va_aggr(va_data,va)`                   | Aggregates scheme for value added `valueadded_database_to_model.txt`
`exp_aggr(exp_data,exp)`                | Aggregates scheme for exports `export_database_to_model.txt`
`val_aggr(val_data,val)`                | Aggregates scheme for valuation categories `valuation_database_to_model.txt`
`row_aggr(full_reg_list,row)`           | Aggregates scheme for rest of the world `restoftheworld_database_to_model.txt`
`tsp_aggr(tsp_data,tsp)`                | Aggregates scheme for taxes and subsidies `taxesandsubsidiesonproducts_database_to_model.txt`
`uip_aggr(uip_data,uip)`                | Aggregates scheme for imports `useofimportedproducts_database_to_model.txt`
`prd_uip_aggr(prd_data,uip)`            | Aggregates scheme from products to imported products categories `products_to_uip_model.txt`
`inm_aggr(inm_data,inm)`                | Aggregates scheme for international margins categories `internationalmargins_database_to_model.txt`



### Declaration of aliases

Sometimes it is necessary to have more than one name for the same set. Aliases are created by repeating the last character of the original set a number of times. We define the following aliases:

Original set | Aliases (new names for the original set)
------------ | ----------------------------------------
`reg`        | `regg`, `reggg`
`prd`        | `prdd`, `prddd`
`ind`        | `indd`, `inddd`

More detailed information about the sets and mappings can be found in the corresponding `.txt` file. All sets and maps can be changed to any level of details.
For this the `.txt` files should be changed (sets and/or maps). This sets and maps in this file are mainly used in `aggregate_database.gms`, `model_parameters.gms` and `model_variables_equations.gms`

## scr/aggregate_database.gms ([index](#file-loading-structure))

* `main.gms`
    * `scr/aggregate_database.gms`

This is the `main.gms` code for the core input-output model. This is the part where the database is aggregated to the
dimensions of the model, identified in `sets_model.gms`.

The code consists of the following parts:

### Parameters declaration

The data i.e. sets they consists of

Parameter             | Explanation
--------------------- | -----------
SUP_model             | the supply and use table
INTER_USE_model       | the intermediate use table
FINAL_USE_model       | the final use table, discerning final consumption, fixed asset formation and export to defined regions (not rest of the world)
EXPORT_model          | the export to the rest of the world table
VALUE_ADDED_model     | the value added table i.e. vector
TAX_SUB_model (for industries, exports and final demands)              | taxes table, for industries (specific taxes), final demands and exports (as data here is not "free on board")
IMPORT_USE_model (both for industries, exports and final demands       | imports from rest of the world use table, for industries, final demands and exports (i.e. re-exports)

display commands for parameters

## scr/model_parameters.gms ([index](#file-loading-structure))

* `main.gms`
    * `scr/model_parameters.gms`

This GAMS file defines the parameters that are used in the model. Please start from `main.gms`.

Parameters are fixed and are declared (in a first block) and defined (in the second block) in this file. The following parameters are defined:

Variable                    | Explanation     
--------------------------- |:----------------
`Y(reg,ind)`                | This is the output vector by activity. It is defined from the supply table in model format, by summing `SUP_model(regg,prd,reg,ind)` over `regg` and `prd`.
`X(reg,ind)`                | This is the output vector by product. It is defined from the supply table in model format, by summing `SUP_model(reg,prd,regg,ind)` over `regg` and `ind`.
`coprodA(reg,prd,regg,ind)` | These are the co-production coefficients with mix per industry. Using these coefficients in the analysis corresponds to the product technology assumption. The coefficients are defined as `SUP_model(reg,prd,regg,ind) / Y(regg,ind)`. if `Y(regg,ind)` is nonzero.
`coprodA(reg,prd,regg,ind)` | These are the co-production coefficients with mix per product. Using these coefficients in the analysis corresponds to the industry technology assumption. The coefficients are defined as `SUP_model(reg,prd,regg,ind) / X(reg,prd)`. if `X(reg,prd)` is nonzero.
`a(reg,prd,regg,ind)`       | These are the technical input coefficients. They are defined as `INTER_USE_model(reg,prd,regg,ind) / Y(regg,ind)`.

No changes should be made in this file, as the parameters declared here are all defined using their standard definitions.

## scr/model_variables_equations.gms ([index](#file-loading-structure))

* `main.gms`
    * `scr/model_variables_equations.gms`

This `.gms` file is one of the `.gms` files part of the `main.gms` file and includes the equations and model formulation. Please start from `main.gms`.

This `.gms` file consists of the following parts:

1. *Declaration of variables*

    Output by activity and product are here the variables which can be adjusted in the model. The variable `Cshock` is defined later in the `%simulation%` gms file.

2. *Declaration of equations*

    One of the equations is an artificial objective function. This is because GAMS only understands a model run with an objective function. If you would like to run it without one, you can use such an artificial objective function which is basically put to any value such as 1.

3. *Definition of equations*

4. *Definition of levels and lower and upper bounds and fixed variables*

    Upper and lower bounds can be adjusted when needed.

5. *Declaration of equations in the model*

    This states which equations are included in which model. The models are based on either product technology or activity technology. The `main.gms` file includes the option to choose one of the two types of technologies.


## scr/simulation/final_demand_shock.gms ([index](#file-loading-structure))

* `main.gms`
    * `scr/simulation/final_demand_shock.gms` (included from GAMS as `scr/simulation/%simulation_setup%.gms`)

Documentation for this file is missing.
