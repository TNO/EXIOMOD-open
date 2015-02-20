* File:   library/scr/user_data.gms
* Author: Trond Husby
* Date:   19 February 2015
* Adjusted: 19 February 2015

* gams-master-file: main.gms


$ontext
This is a file where additional project-specific data can be read in. Data should be placed in %project%/data/.

Reading in data on elasticities

  1. elasFU_data - data on elasticities (final demand)
  2. elasTRADE_data - data on elasticities of import/domestic supply (Armington)
  3. elasPROD_data - data on substitution elasticities in production nests

$offtext

Parameters
elasFU_data(fd,*)
elasTRADE_data(prd,*)
elasPROD_data(ind,*)
    ;
    
$libinclude xlimport elasFU_data ././%project%/data/Eldata.xlsx elasFU!a1..b3 ;
$libinclude xlimport elasTRADE_data ././%project%/data/Eldata.xlsx elasTRADE!a1..d36 ;
$libinclude xlimport elasPROD_data ././%project%/data/Eldata.xlsx elasPROD!a1..b36 ;
