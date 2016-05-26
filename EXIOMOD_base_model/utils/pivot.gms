$title  Produce a Pivot Report Keyed to Input Assumptions

$onUNDF

*   -------------------------------------------------------------------
*   Model-specific code:

$if not set item     $set item CONS_H_T_time
$if not set ws       $set ws PivotData
$if not set output   $set output %item%

$if not set inputs   $set inputs INPUT1,INPUT2
$if not set indices  $set indices prd,regg,year

*   -------------------------------------------------------------------

alias (%inputs%,*);
alias (%indices%,*);

set header /%indices%, %inputs%,  value/;

$gdxin 'ssa.gdx'

set     scn(*)  Scenarios indices;
$load scn
set     inputs(scn,%inputs%) Input associations;
$load inputs

parameter       %item%(scn,%indices%)      Model results;

$call 'gdxmerge gdx\*.gdx id=%item%'
$gdxin merged.gdx
$load %item%

parameter       pivotdata   Pivot table data;
loop(inputs(scn,%inputs%),
        pivotdata(%indices%,%inputs%) = %item%(scn,%indices%);
);
execute_unload 'pivotdata.gdx',header,pivotdata;
$onecho >gdxxrw.rsp
set=header    rng=%ws%!a1 cdim=1
par=pivotdata rng=%ws%!a2 cdim=0
$offecho

execute 'gdxxrw i=pivotdata.gdx o=%output%.xlsx @gdxxrw.rsp'
