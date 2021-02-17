* File:   01-read-EXIOBASE-physical_extensions-data.gms
* Author: Hettie Boonman (based on version of Jinue Hu)
* Date:   2 November 2017

* This script reads in the data from the EXIOBASE physical extensions database
* version 3.3.0.

$oneolcom
$eolcom #

Sets


res_ext     Resources
/
$include    %project%\01_external_data\physical_extensions_2011\sets\physical_resource_database.txt
/
mat_ext     Materials
/
$include    %project%\01_external_data\physical_extensions_2011\sets\physical_material_database.txt
/
emis_ext    Emissions
/
$include    %project%\01_external_data\physical_extensions_2011\sets\physical_emission_database.txt
/


air_water   air water nature
/
$include    %project%\01_external_data\physical_extensions_2011\sets\physical_air_water_database.txt
/
unit_ext    units
/
$include    %project%\01_external_data\physical_extensions_2011\sets\physical_unit_database.txt
/
col_ext     industries
/
$include    %project%\01_external_data\physical_extensions_2011\sets\physical_industry_database.txt
/
reg_ext     regions
/
$include    %project%\01_external_data\physical_extensions_2011\sets\physical_region_database.txt
/
;


* Load database from physical extensions
Parameters
Emission_data(reg_ext,col_ext,emis_ext,air_water,unit_ext)   Emission data
                                                             # (mostly in kg)
Resource_data(reg_ext,col_ext,res_ext,air_water,unit_ext)    Resource data (km2)
Material_data(reg_ext,col_ext,mat_ext,unit_ext)              Material data (kt
                                                             # TJ and MM3)
;

* With "loaddc" the sets are checked, as opposed to "load".
* For emissions we only load CO2 and therefore do not use "loaddc" there.
$Gdxin '\\tsn.tno.nl\Data\sv\sv-016648\Databank Economen\European data\EXIOBASE\EXIOBASE_v3_3_PUBLIC_VERSION\GAMS\Physical_extensions_3_3_2011.gdx'
$loaddc Emission_data
$loaddc Resource_data
$loaddc Material_data
$GDXin

*Display
*Emission_data
*Resource_data
*Material_data
*;