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

sets
    prd_gas(prd_data)
/
p402a, p402b, p402c, p402d, p402e, p4021
/

    prd_elec(prd_data)
/
p4011a, p4011b, p4011c, p4011d, p4011e, p4011f, p4011g, p4011h, p4011i, p4011j
p4011k, p4011l
/

    prd_serv(prd_data)
/
p41, p50a, p50b, p51, p52, p55, p63, p64, p65, p66, p67, p70, p71, p72, p73, p74
p75, p80, p85, p901a, p901b, p901c, p901d, p901e, p901f, p901g, p903a, p903b,
p904a, p904b, p905a, p905b, p905c, p905d, p905e, p905f, p91, p92, p93, p95, p99
/

    prd_indu(prd_data)
/
p12, p131, p132011, p132012, p132013, p132014, p132015, p132016, p141, p142,
p143, p15a, p15b, p15c, p15d, p15e, p15f, p15g, p15h, p15i, p15j, p15k, p16, p17
p18, p19, p20, p20w, p211, p21w1, p212, p22, p233, p24a, p24aw, p24b, p24c, p24d
p24f, p25, p26a, p26w1, p26b, p26c, p26d, p26dw, p26e, p28, p29, p30, p31, p32
p33, p34, p35, p36, p37, p37w1, p45, p45w
/
;

Alias
    (prd_data, prdd_data)
    (va_data, vaa_data)
    (prd_gas, prdd_gas)
    (ind_data, indd_data)
;


************************** which sectors produce gas? **************************

* Find out which sectors produce gas.
* And for those sectors find out if there is at least one service, industrial,
* electricity, and gas product that is USED by that sector.

Parameters
    produce_gas(prd_data,reg_data,ind_data)
    uses_elec(prd_data,reg_data,ind_data)
    uses_serv(prd_data,reg_data,ind_data)
    uses_gas(prd_data,reg_data,ind_data)
    uses_indu(prd_data,reg_data,ind_data)
    uses_labor(reg_data,ind_data)
    uses_all(reg_data,ind_data)
    uses_all_value(reg_data,ind_data)
    max_uses_all_value(reg_data)
;

* Which industries produce gas. And which type of gas is used?
produce_gas(prd_gas,reg_data,ind_data)
    $(SAM_bp_data('y2011','MEUR',reg_data,ind_data,reg_data,prd_gas,"Value") gt 0.1)
    = SAM_bp_data('y2011','MEUR',reg_data,ind_data,reg_data,prd_gas,"Value") ;

* For all industries in a region that produce gas: find all service products
* that are used by that industry
uses_serv(prd_serv,reg_data,ind_data)$( sum(prd_gas,produce_gas(prd_gas,reg_data,ind_data))
    and SAM_bp_data('y2011','MEUR',reg_data,prd_serv,reg_data,ind_data,"Value") gt 0.005 )
    = SAM_bp_data('y2011','MEUR',reg_data,prd_serv,reg_data,ind_data,"Value") ;

* For all industries in a region that produce gas: find all industrial products
* that are used by that industry
uses_indu(prd_indu,reg_data,ind_data)$( sum(prd_gas,produce_gas(prd_gas,reg_data,ind_data))
    and SAM_bp_data('y2011','MEUR',reg_data,prd_indu,reg_data,ind_data,"Value") gt 0.010 )
    = SAM_bp_data('y2011','MEUR',reg_data,prd_indu,reg_data,ind_data,"Value") ;

* For all industries in a region that produce gas: find all electricity products
* that are used by that industry
uses_elec(prd_elec,reg_data,ind_data)$( sum(prd_gas,produce_gas(prd_gas,reg_data,ind_data))
    and SAM_bp_data('y2011','MEUR',reg_data,prd_elec,reg_data,ind_data,"Value") gt 0.044 )
    = SAM_bp_data('y2011','MEUR',reg_data,prd_elec,reg_data,ind_data,"Value") ;

* For all industries in a region that produce gas: find all gas products
* that are used by that industry
uses_gas(prd_gas,reg_data,ind_data)$( sum(prdd_gas,produce_gas(prdd_gas,reg_data,ind_data))
    and SAM_bp_data('y2011','MEUR',reg_data,prd_gas,reg_data,ind_data,"Value") gt 0.012 )
    = SAM_bp_data('y2011','MEUR',reg_data,prd_gas,reg_data,ind_data,"Value") ;

* For all industries in a region that produce gas: check if there is labordemand
uses_labor(reg_data,ind_data)$( sum(prdd_gas,produce_gas(prdd_gas,reg_data,ind_data))
    and SAM_bp_data('y2011','MEUR',reg_data,"t205",reg_data,ind_data,"Value") gt 0.004 )
    = SAM_bp_data('y2011','MEUR',reg_data,"t205",reg_data,ind_data,"Value") ;


* Set to one if the industry in that region has a positive usevalue for all four
* type of products: serv, indu, elec, gas.
uses_all(reg_data,ind_data)
    $( sum(prd_serv,uses_serv(prd_serv,reg_data,ind_data) ) and
       sum(prd_indu,uses_indu(prd_indu,reg_data,ind_data) ) and
       sum(prd_elec,uses_elec(prd_elec,reg_data,ind_data) ) and
       sum(prd_gas,uses_gas(prd_gas,reg_data,ind_data   ) ) and
                   uses_labor(reg_data,ind_data         ) )
    = 1 ;

uses_all_value(reg_data,ind_data)$uses_all(reg_data,ind_data)
    = sum(prd_serv,uses_serv(prd_serv,reg_data,ind_data) )
    + sum(prd_indu,uses_indu(prd_indu,reg_data,ind_data) )
    + sum(prd_elec,uses_elec(prd_elec,reg_data,ind_data) )
    + sum(prd_gas,uses_gas(prd_gas,reg_data,ind_data) )
    + uses_labor(reg_data,ind_data ) ;

max_uses_all_value(reg_data)
    = smax(ind_data, uses_all_value(reg_data,ind_data) ) ;

Display
    produce_gas
    uses_serv
    uses_indu
    uses_elec
    uses_gas
    uses_all
    uses_all_value
    max_uses_all_value
;

*******************  Choose one gas-producing industry per region **************

* For each region, we now only select one industry that fills all criteria
* Note that there are only 39 industries that fill the criteria, of which 24
* European countries. The other countries/ regions are assumed not to be able
* to produce hydrogen in the future.

Parameters
    ind_that_produces_gas(ind_data,reg_data)
    gasprd_value(reg_data,ind_data)
    gasprd(prd_data,reg_data,ind_data)
    prd_pos_serv_value(reg_data,ind_data)
    prd_pos_serv(prd_data,reg_data,ind_data)
    prd_pos_indu_value(reg_data,ind_data)
    prd_pos_indu(prd_data,reg_data,ind_data)
    prd_pos_elec_value(reg_data,ind_data)
    prd_pos_elec(prd_data,reg_data,ind_data)
    prd_pos_gas_value(reg_data,ind_data)
    prd_pos_gas(prd_data,reg_data,ind_data)
    check_sum_products
;

* Which industry is choosen to produce gas in a region?
ind_that_produces_gas(ind_data,reg_data)
    $(uses_all(reg_data,ind_data) and uses_all_value(reg_data,ind_data) eq  max_uses_all_value(reg_data) )
     = 1 ;

******************* PRODUCING OF GAS
gasprd_value(reg_data,ind_data)$(ind_that_produces_gas(ind_data,reg_data) )
    = smax(prd_gas, produce_gas(prd_gas,reg_data,ind_data) ) ;

* Which gas-product is produced by this sector?
gasprd(prd_data,reg_data,ind_data)$(ind_that_produces_gas(ind_data,reg_data) and produce_gas(prd_data,reg_data,ind_data) eq gasprd_value(reg_data,ind_data))
    = 1 ;

******************* USE OF SERVICES
prd_pos_serv_value(reg_data,ind_data)$(ind_that_produces_gas(ind_data,reg_data) )
    = smax(prd_serv, uses_serv(prd_serv,reg_data,ind_data) ) ;

* Which service product is used by the gas producing sector?
prd_pos_serv(prd_data,reg_data,ind_data)$(ind_that_produces_gas(ind_data,reg_data) and uses_serv(prd_data,reg_data,ind_data) eq prd_pos_serv_value(reg_data,ind_data))
    = 1 ;

******************* USE OF INDUSTRIAL PRODUCTS
prd_pos_indu_value(reg_data,ind_data)$(ind_that_produces_gas(ind_data,reg_data) )
    = smax(prd_indu, uses_indu(prd_indu,reg_data,ind_data) ) ;

* Which industrial product is used by the gas producing sector?
prd_pos_indu(prd_data,reg_data,ind_data)$(ind_that_produces_gas(ind_data,reg_data) and uses_indu(prd_data,reg_data,ind_data) eq prd_pos_indu_value(reg_data,ind_data))
    = 1 ;

******************* USE OF ELECTRICITY PRODUCTS
prd_pos_elec_value(reg_data,ind_data)$(ind_that_produces_gas(ind_data,reg_data) )
    = smax(prd_elec, uses_elec(prd_elec,reg_data,ind_data) ) ;

* Which electricity product is used by the gas producing sector?
prd_pos_elec(prd_data,reg_data,ind_data)$(ind_that_produces_gas(ind_data,reg_data) and uses_elec(prd_data,reg_data,ind_data) eq prd_pos_elec_value(reg_data,ind_data))
    = 1 ;

******************* USE OF GAS PRODUCTS
prd_pos_gas_value(reg_data,ind_data)$(ind_that_produces_gas(ind_data,reg_data) )
    = smax(prd_gas, uses_gas(prd_gas,reg_data,ind_data) ) ;

* Which gas product is used by the gas producing sector?
prd_pos_gas(prd_data,reg_data,ind_data)$(ind_that_produces_gas(ind_data,reg_data) and uses_gas(prd_data,reg_data,ind_data) eq prd_pos_gas_value(reg_data,ind_data))
    = 1 ;

*******************

Display
    ind_that_produces_gas
    gasprd
    prd_pos_serv
    prd_pos_indu
    prd_pos_elec
    prd_pos_gas
;


* This should add up to 39 regions for which there is an industry that fills
* all the conditions.

check_sum_products
    =sum((prd_data,reg_data,ind_data),prd_pos_serv(prd_data,reg_data,ind_data));
Display check_sum_products;

check_sum_products = 0;
check_sum_products
    =sum((prd_data,reg_data,ind_data),prd_pos_indu(prd_data,reg_data,ind_data));
Display check_sum_products;

check_sum_products = 0;
check_sum_products
    =sum((prd_data,reg_data,ind_data),prd_pos_elec(prd_data,reg_data,ind_data));
Display check_sum_products;

check_sum_products = 0;
check_sum_products
    =sum((prd_data,reg_data,ind_data),prd_pos_gas(prd_data,reg_data,ind_data));
Display check_sum_products;


* ========================  Change supply and use tables =======================


* SUP
SAM_bp_data(year_data,cur_data,reg_data,"iH2",reg_data,prd_data,"Value")$sum(ind_data,gasprd(prd_data,reg_data,ind_data))
    =  0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,"iH2","Value")$sum(ind_data,prd_pos_serv(prd_data,reg_data,ind_data))
    =  0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,"iH2","Value")$sum(ind_data,prd_pos_indu(prd_data,reg_data,ind_data))
    =  0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,"iH2","Value")$sum(ind_data,prd_pos_elec(prd_data,reg_data,ind_data))
    =  0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,"iH2","Value")$sum(ind_data,prd_pos_gas(prd_data,reg_data,ind_data))
    =  0.012 ;

SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,"iH2","Value")$sum(ind_data,ind_that_produces_gas(ind_data,reg_data))
    =  0.025 ;

SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,"iH2","Value")$sum(ind_data,ind_that_produces_gas(ind_data,reg_data))
    =  0.004 ;

* Adjust the gas sector to compensate for changes in the new H2 sector.

* SUP
SAM_bp_data(year_data,cur_data,reg_data,ind_data,reg_data,prd_data,"Value")$gasprd(prd_data,reg_data,ind_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,ind_data,reg_data,prd_data,"Value") - 0.100 ;

* USE
SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,ind_data,"Value")$prd_pos_serv(prd_data,reg_data,ind_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,ind_data,"Value") - 0.005 ;

SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,ind_data,"Value")$prd_pos_indu(prd_data,reg_data,ind_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,ind_data,"Value") - 0.010 ;

SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,ind_data,"Value")$prd_pos_elec(prd_data,reg_data,ind_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,ind_data,"Value") - 0.044 ;

SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,ind_data,"Value")$prd_pos_gas(prd_data,reg_data,ind_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,prd_data,reg_data,ind_data,"Value") - 0.012 ;

SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,ind_data,"Value")$ind_that_produces_gas(ind_data,reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"t212",reg_data,ind_data,"Value") - 0.025 ;

SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,ind_data,"Value")$ind_that_produces_gas(ind_data,reg_data)
    =  SAM_bp_data(year_data,cur_data,reg_data,"t205",reg_data,ind_data,"Value") - 0.004 ;


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




* ============================ What to do for all other regions? ===============

