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

mkdir project_%ftitle%\extradata
mkdir project_%ftitle%\extradata\sets
mkdir project_%ftitle%\extradata\sets\aggregation
mkdir project_%ftitle%\extradata\data
mkdir project_%ftitle%\extradata\scr

:End
