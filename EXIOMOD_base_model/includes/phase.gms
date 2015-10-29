* File:   EXIOMOD_base_model/includes/phase.gms
* Author: Trond Husby
* Date:   30 May 2015
* Adjusted:

* gams-master-file: 00_base_model_prepare.gms

$ontext
This script allows to implement code modularity within GAMS. In this case
modularity means that the code of the model is split into thematic blocks, e.g.
producer, consumer, etc. In GAMS the order of compilation is important:
(1) Declaration of sets
(2) Assignment of sets
(3) Declaration of parameters
(4) Assignment of parameters
(5) Declaration of variables and equations
(6) Definition of equation
(7) Model statement
(8) Solve statement
Each of the thematic blocks goes through these step, as we call them PHASES. In
a CGE model the thematic blocks are interconnected, and calling one block after
another would results in compilation errors.

Input:
    * phase name (%1), which is passed from 00_base_model_prepare.gms

The script then goes through each of the included modules and compiles the
corresponding phase.

The script is inspired by (please refer for further explanations):
https://docs.google.com/document/d/1__9okBI8LsNnzDw_z4x80vfgUb5GUv3vKV_kptxXIbY/edit
$offtext

$setglobal phase %1
$include EXIOMOD_base_model/scr/05_module_demand_%demnfunc%.gms
$include EXIOMOD_base_model/scr/06_module_production_%prodfunc%.gms
$include EXIOMOD_base_model/scr/07_module_trade.gms
$include EXIOMOD_base_model/scr/08_module_closure.gms
