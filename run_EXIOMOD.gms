* File:   run_EXIOMOD.gms
* Author: Hettie Boonman
* Organization: TNO, Netherlands
* Date:   26 May 2014
* Adjusted:

* gams-master-file: run_EXIOMOD.gms

********************************************************************************
* THIS MODEL IS A CUSTOM-LICENSE MODEL.
* EXIOMOD 2.0 shall not be used for commercial purposes until an exploitation
* agreement is signed, subject to similar conditions as for the underlying
* database (EXIOBASE). EXIOBASE limitations are based on open source license
* agreements to be found here:
* http://exiobase.eu/index.php/terms-of-use

* For information on a license, please contact: hettie.boonman@tno.nl
********************************************************************************

$ontext startdoc
This file is the one to be used to run simulations from GAMS.
It is suggested to create a separate 'run_EXIOMOD' file for each simulation,
this will allow to exactly reproduce results from reports/presentations.

This run_exiomod file is run in four parts
1. Include base model file
2. Read exogenous data (for example input for a scenario)
3. Run simulation for a chosen scenario.
4. Merge all selected data to one excel file

Comment using * the $include code line and $exit after running each part.
Save (s=) and restart (r=) files are used to respectively save and restart data
of each of the four parts.
$offtext

$include configuration.gms

* (1) Include base model file
* (uncomment the two lines below, and type s=run_exiomod in the command line)
*$include EXIOMOD_base_model\scr\00_base_model_prepare.gms
*$exit

* (2) Include exogenous data for scenario
* (uncomment the two lines below, and type r=run_exiomod, s=read_extradata
* in the command line)
*$include %project%/00_base_model_setup/scr/read_extradata.gms
*$exit

********************************************************************************
$ontext
* Set for simulation (do not outcomment)

* Choose from:
* 01_BAU_loop_fprod         (This simulation finds the correct capital and labor
                             productivities such that when later baseline 01_BAU
                             is runned, it follows growth in GDP from chosen
                             scenario. Productivities are exported to file:
                             %project%\02_project_model_setup\data\prodKL.xlsx)
* 01_BAU                    (This simulation file runs the baseline, it includes
                             growth in GDP and growth in population.)
* 02_mat_reduction          (This simulation file decreases the use of product
                             group pINDU and pMANU in each industry, and
                             replaces this product by a service product pSERV.)
* 03_BAU_mat_reduction      (This simulation file combines the baseline with the
                             material reduction scenario)
* ...                       (add more simulation files)

$offtext

* Choose a scenario:
$if not set scenario      $setglobal      scenario   '03_BAU_mat_reduction'

********************************************************************************

* (3) Run simulation
* (uncomment the two lines below, and type r=read_extradata in the command line)
$include %project%/02_project_model_setup/scr/simulation_%scenario%.gms
$exit

* (4) Merge output off all simulations in one excel file
* (uncomment the two lines below, and type r=read_extradata in the command line)
*$include %project%/02_project_model_setup/scr/simulation_%scenario%.gms
*$exit
