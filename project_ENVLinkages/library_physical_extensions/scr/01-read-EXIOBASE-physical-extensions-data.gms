* File:   01-read-EXIOBASE-physical_extensions-data.gms
* Author: Jinxue Hu
* Date:   16 March 2015

* This script reads in the data from the EXIOBASE physical extensions database
* version 2.2.0.

Sets


deu_ext     domestic extraction used
/
$include    %project%\library_physical_extensions\sets\physical_deu_database.txt
/
ude_ext     unused domestic extraction
/
$include    %project%\library_physical_extensions\sets\physical_ude_database.txt
/
emis_ext    emissions
/
$include    %project%\library_physical_extensions\sets\physical_emissions_database.txt
/
land_ext    land use
/
$include    %project%\library_physical_extensions\sets\physical_land_database.txt
/
water_ext   water consumption and withdrawal
/
$include    %project%\library_physical_extensions\sets\physical_water_database.txt
/

unit
/
$include    %project%\library_physical_extensions\sets\physical_units_database.txt
/

col_ext     industries
/
$include    %project%\library_physical_extensions\sets\physical_industries_database.txt
/
reg_ext     regions
/
$include    %project%\library_physical_extensions\sets\physical_regions_database.txt
/
;


* Load database from physical extensions
Parameters
DOMESTIC_EXTRACTION_USED_data(reg_ext,deu_ext,col_ext)    domestic extraction used in kt
UNUSED_DOMESTIC_EXTRACTION_data(reg_ext,ude_ext,col_ext)  unused domestic extraction in kt
EMISSIONS_data(reg_ext,emis_ext,col_ext)                  emissions in kg CO2-eq kg or I-TEQ kg
LAND_USE_data(reg_ext,land_ext,col_ext)                   land use in km2
WATER_USE_data(reg_ext,water_ext,col_ext)                 water use in Mm3
;

* With "loaddc" the sets are checked, as opposed to "load".
* For emissions we only load CO2 and therefore do not use "loaddc" there.
*$GDXin   %project%\library_physical_extensions\data\EXIOBASE_2_2_0_physical_extensions.gdx
$Gdxin '\\tsn.tno.nl\data\SV\SV-016648\Databank Economen\European data\EXIOBASE\EXIOBASE_v2.2.0_incl_physical_extensions\EXIOBASE_2_2_0_physical_extensions'
$loaddc  DOMESTIC_EXTRACTION_USED_data = DOMESTIC_EXTRACTION_USED
$loaddc  UNUSED_DOMESTIC_EXTRACTION_data = UNUSED_DOMESTIC_EXTRACTION
$load    EMISSIONS_data = emissions
$loaddc  LAND_USE_data = land_use
$loaddc  WATER_USE_data = water
$GDXin

Display DOMESTIC_EXTRACTION_USED_data, EMISSIONS_data, LAND_USE_data, WATER_USE_data  ;
