@ECHO off

set /P ftitle=Please enter title of project folder:

IF "%ftitle%"=="" GOTO End

mkdir project_%ftitle%
mkdir project_%ftitle%\00-principal
mkdir project_%ftitle%\00-principal\sets
mkdir project_%ftitle%\00-principal\sets\aggregation
mkdir project_%ftitle%\00-principal\data
xcopy documentation\templates\Eldata.xlsx project_%ftitle%\00-principal\data
mkdir project_%ftitle%\00-principal\scr
xcopy documentation\templates\run_simulation.gms project_%ftitle%\00-principal\scr

mkdir project_%ftitle%\##-scenario#
mkdir project_%ftitle%\##-scenario#\sets
mkdir project_%ftitle%\##-scenario#\sets\aggregation
mkdir project_%ftitle%\##-scenario#\data
mkdir project_%ftitle%\##-scenario#\scr

:End
