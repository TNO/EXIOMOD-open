* File:   %project%/00_base_model_setup/scr/Adjust_MRSAM.gms
* Author: Hettie Boonman
* Date:   03 Januari 2018
* Adjusted:

* gams-master-file: run_EXIOMOD.gms

$ontext startdoc
This code is used to make changes in the base database of MRSAM.
$offtext

$oneolcom
$eolcom #

* ================ Declaration of sets and scalars =============================

Scalar
    tolerance /1E-8/
;


Alias
    (prd_data, prdd_data)
    (va_data, vaa_data)
;


* ======================== Divide the database in groups of regions ============

Parameters
    group1(reg_data)
    group2(reg_data)
    group3(reg_data)
    group4(reg_data)
    group5(reg_data)    subset of group4

    max_gas_per_region(reg_data)
    reg_ind_combination(reg_data,full_cat_list)
;


Sets
    ind_other(full_cat_list)
;

*Regions for which p402a is produced by i402
group1(reg_data)
    $((SAM_bp_data('y2011','MEUR',reg_data,"i402",reg_data,"p402a","Value") ge 0.0100) )
    =
    1 ;

*Regions for which p402e is produced by i402
group2(reg_data)
    $((not SAM_bp_data('y2011','MEUR',reg_data,"i402",reg_data,"p402a","Value") ge 0.0100) and
        (SAM_bp_data('y2011','MEUR',reg_data,"i402",reg_data,"p402e","Value") ge 0.0100))
    =
    1 ;

*Regions for which p402b is produced by i402
group3(reg_data)
    $((not SAM_bp_data('y2011','MEUR',reg_data,"i402",reg_data,"p402a","Value") ge 0.0100)  and
        (not SAM_bp_data('y2011','MEUR',reg_data,"i402",reg_data,"p402e","Value") ge 0.0100) and
        (SAM_bp_data('y2011','MEUR',reg_data,"i402",reg_data,"p402b","Value") ge 0.0100) )
    =
    1 ;

* When i402 does not produce gas at all:
group4(reg_data)$(not group1(reg_data) and not group2(reg_data) and not group3(reg_data) )
    = 1;


* Maximum gas p402a produced by any of the sectors.
max_gas_per_region(reg_data)$group4(reg_data)
    = smax(full_cat_list,SAM_bp_data('y2011','MEUR',reg_data,full_cat_list,reg_data,"p402a","Value")) ;

* Which sector produces the most gas in a certain region?
reg_ind_combination(reg_data,full_cat_list)
    $((SAM_bp_data('y2011','MEUR',reg_data,full_cat_list,reg_data,"p402a","Value")
        eq max_gas_per_region(reg_data))
        and SAM_bp_data('y2011','MEUR',reg_data,full_cat_list,reg_data,"p402a","Value")
        and group4(reg_data) )
    = 1 ;

group5(reg_data)$sum(full_cat_list,reg_ind_combination(reg_data,full_cat_list))
    = 1;


Display
    group1
    group2
    group3
    group4
    max_gas_per_region
    reg_ind_combination
;


* ==============Add extra values to the supply and use table ===================

* Add extra industry (H2) to the table. This industry will also produce gas.
* We need information on the production structure of this industry

$ontext
* SUP
SAM_bp_data(year_data,cur_data,reg_data,"iH2",reg_data,"p402a","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"iH2","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"iH2","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"iH2","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"iH2","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  0.012 ;

SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"iH2","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  0.025 ;

SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"iH2","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  0.004 ;

*********************
* Adjust the gas sector to compensate for changes in the new H2 sector.

* SUP
SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") - 0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") - 0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") - 0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") - 0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") - 0.012 ;


SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") - 0.025 ;


SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value")
    $((SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") ge 0.100) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"i402","Value") ge 0.005) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"i402","Value") ge 0.010) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"i402","Value") ge 0.044) and
       (SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"i402","Value") ge 0.012) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") ge 0.025) and
       (SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") ge 0.004) )
    =  SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"i402","Value") - 0.004 ;
$offtext




**************************** GROUP 1 *******************************************
* SUP
SAM_bp_data(year_data,cur_data,reg_data,"iH2",reg_data,"p402a","Value")$group1(reg_data)
    =  0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"iH2","Value")$group1(reg_data)
    =  0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"iH2","Value")$group1(reg_data)
    =  0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"iH2","Value")$group1(reg_data)
    =  0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"iH2","Value")$group1(reg_data)
    =  0.012 ;

SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"iH2","Value")$group1(reg_data)
    =  0.029 ;

* Adjust the gas sector to compensate for changes in the new H2 sector.

* SUP
SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value")$group1(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402a","Value") - 0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"t167","Value")$group1(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"t167","Value") - 0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"t167","Value")$group1(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"t167","Value") - 0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"t167","Value")$group1(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"t167","Value") - 0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"t167","Value")$group1(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"t167","Value") - 0.012 ;

SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value")$group1(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") - 0.100 ;

**************************** GROUP 2 *******************************************
* SUP
SAM_bp_data(year_data,cur_data,reg_data,"iH2",reg_data,"p402e","Value")$group2(reg_data)
    =  0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"iH2","Value")$group2(reg_data)
    =  0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"iH2","Value")$group2(reg_data)
    =  0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"iH2","Value")$group2(reg_data)
    =  0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,"p402e",reg_data,"iH2","Value")$group2(reg_data)
    =  0.012 ;

SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"iH2","Value")$group2(reg_data)
    =  0.029 ;

* Adjust the gas sector to compensate for changes in the new H2 sector.

* SUP
SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402e","Value")$group2(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402e","Value") - 0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"t167","Value")$group2(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"t167","Value") - 0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"t167","Value")$group2(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"t167","Value") - 0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"t167","Value")$group2(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"t167","Value") - 0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,"p402e",reg_data,"t167","Value")$group2(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p402e",reg_data,"t167","Value") - 0.012 ;

SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value")$group2(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") - 0.100 ;

**************************** GROUP 3 *******************************************
* SUP
SAM_bp_data(year_data,cur_data,reg_data,"iH2",reg_data,"p402c","Value")$group3(reg_data)
    =  0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"iH2","Value")$group3(reg_data)
    =  0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"iH2","Value")$group3(reg_data)
    =  0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"iH2","Value")$group3(reg_data)
    =  0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,"p402c",reg_data,"iH2","Value")$group3(reg_data)
    =  0.012 ;

SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"iH2","Value")$group3(reg_data)
    =  0.029 ;

* Adjust the gas sector to compensate for changes in the new H2 sector.

* SUP
SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402c","Value")$group3(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"i402",reg_data,"p402c","Value") - 0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"t167","Value")$group3(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"t167","Value") - 0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"t167","Value")$group3(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"t167","Value") - 0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"t167","Value")$group3(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"t167","Value") - 0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,"p402c",reg_data,"t167","Value")$group3(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p402c",reg_data,"t167","Value") - 0.012 ;

SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value")$group3(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"i402","Value") - 0.100 ;


**************************** GROUP 5 *******************************************

* SUP
SAM_bp_data(year_data,cur_data,reg_data,"iH2",reg_data,"p402a","Value")$group5(reg_data)
    =  0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"iH2","Value")$group5(reg_data)
    =  0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"iH2","Value")$group5(reg_data)
    =  0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"iH2","Value")$group5(reg_data)
    =  0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"iH2","Value")$group5(reg_data)
    =  0.012 ;

SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"iH2","Value")$group5(reg_data)
    =  0.029 ;

* Adjust the gas sector to compensate for changes in the new H2 sector.

* SUP
SAM_bp_data(year_data,cur_data,reg_data,ind_data,reg_data,"p402a","Value")$(group5(reg_data)  and reg_ind_combination(reg_data,ind_data))
    =  SAM_bp_data(year_data,cur_data,reg_data,ind_data,reg_data,"p402a","Value") - 0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"t167","Value")$group5(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p41",reg_data,"t167","Value") - 0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"t167","Value")$group5(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p45",reg_data,"t167","Value") - 0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"t167","Value")$group5(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p4011a",reg_data,"t167","Value") - 0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"t167","Value")$group5(reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"p402a",reg_data,"t167","Value") - 0.012 ;


SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,ind_data,"Value")$(group5(reg_data)  and reg_ind_combination(reg_data,ind_data))
    =  SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,ind_data,"Value") - 0.100 ;

* ================================= Check balance ==============================

Parameter
    balance(year_data,cur_data,all_reg_data,full_cat_list)     Check balance MRSAM
;

* check balance: revenues minus expenditures
balance(year_data,cur_data,all_reg_data,full_cat_list)
    = sum((all_regg_data,full_catt_list),
       SAM_bp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,"Value") ) -
      sum((all_regg_data,full_catt_list),
       SAM_bp_data(year_data,cur_data,all_regg_data,full_catt_list,all_reg_data,full_cat_list,"Value") ) ;

balance(year_data,cur_data,all_reg_data,full_cat_list)
    $(abs(balance(year_data,cur_data,all_reg_data,full_cat_list)) lt tolerance )
         = 0 ;

Display balance;

* ================================== Adjust SAM_pp =============================
SAM_pp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,"Value") = 0 ;

SAM_pp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,"Value") =
    SAM_bp_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,"Value")
     + SAM_dt_data(year_data,cur_data,all_reg_data,full_cat_list,all_regg_data,full_catt_list,"Value") ;
