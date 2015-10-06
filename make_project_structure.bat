@ECHO off

set /P ftitle=Please enter title of project folder:

IF "%ftitle%"=="" GOTO End

mkdir project_%ftitle%
mkdir project_%ftitle%\00_base_model_setup
mkdir project_%ftitle%\00_base_model_setup\sets
mkdir project_%ftitle%\00_base_model_setup\sets\aggregation
mkdir project_%ftitle%\00_base_model_setup\data
xcopy documentation\templates\Eldata.xlsx project_%ftitle%\00_base_model_setup\data
mkdir project_%ftitle%\00_base_model_setup\scr
xcopy documentation\templates\run_simulation.gms project_%ftitle%\00_base_model_setup\scr

mkdir project_%ftitle%\01_external_data\databaseX
mkdir project_%ftitle%\01_external_data\databaseX\sets
mkdir project_%ftitle%\01_external_data\databaseX\sets\aggregation
mkdir project_%ftitle%\01_external_data\databaseX\data
mkdir project_%ftitle%\01_external_data\databaseX\scr

mkdir project_%ftitle%\02_project_model_setup
mkdir project_%ftitle%\02_project_model_setup\sets
mkdir project_%ftitle%\02_project_model_setup\sets\aggregation
mkdir project_%ftitle%\02_project_model_setup\data
mkdir project_%ftitle%\02_project_model_setup\scr

mkdir project_%ftitle%\03_simulation_results
mkdir project_%ftitle%\03_simulation_results\sets
mkdir project_%ftitle%\03_simulation_results\sets\aggregation
mkdir project_%ftitle%\03_simulation_results\data
mkdir project_%ftitle%\03_simulation_results\scr

xcopy documentation\templates\readme.txt project_%ftitle%

:End
