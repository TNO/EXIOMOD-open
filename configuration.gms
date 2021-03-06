* File:   configuration.gms
* Author: Tatyana Bulavskaya
* Organization: TNO, Netherlands
* Date:   26 May 2014
* Adjusted: 17 Februari 2021 by Hettie Boonman

* gams-master-file: run_EXIOMOD.gms

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
This is the configuration file for the base CGE model. The file allows to
configure the following control variables:

Variable           | Explanation
------------------ | -----------
`project`          | gives name of the project folder.
`prodfunc`         | determines type of standard production function.
`demnfunc`         | determines type of standard demand function.
`db_check`         | determine whether the database needs checking.
`agg_check`        | determine whether aggregation schemes need checking.
`base_year`        | select one of the years available in the database.
`base_cur`         | select one of the currencies available in the database.
$offtext

* name of the project folder, please give meaningful name
$if not set project      $setglobal      project         'project_example'

* form of production functions: choose between 'KL' and 'KL-E'
* type 'KL': substitution possible between production factors, other inputs
*     have fixed Leontief coefficients
* type 'KL-E': substitution possible between production factors and energy,
*     other inputs have fixed Leontief coefficients
$if not set prodfunc     $setglobal      prodfunc        'KL-E'

* form of demand functions: choose between 'CES' and 'LES-CEShh'
* type 'CES': demand functions of all final consumers follows CES utility
*     function
* type 'LES-CEShh': demand function for households includes minimum subsitabnce
*     level (LES utility form), other demand functions are CES
$if not set demnfunc     $setglobal      demnfunc        'CES'


* database checking: set 'yes' to check the database on consistency
* set 'no' otherwise
$if not set db_check     $setglobal      db_check        'yes'

* aggregation checking: set 'yes' to check aggregation schemes between database
* and model set on consistency
* set 'no' otherwise
$if not set agg_check    $setglobal      agg_check       'yes'

* base year
$if not set base_year    $setglobal      base_year       'y2011'

* base currency
$if not set base_cur     $setglobal      base_cur        'MEUR'
