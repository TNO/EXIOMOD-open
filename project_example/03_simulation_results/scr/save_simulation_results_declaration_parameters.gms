
* File:   project_COMPLEX/03_simulation_results/scr/save_simulation_results_declaration_parameters.gms
* Author: Jinxue Hu
* Date:   19 October 2015
* Adjusted: 14 April 2016

* Declaration of parameters for storing simulation results
*$oneolcom
*$eolcom #

Parameters
* Consumption
CONS_H_T_time(prd,regg,year)    household consumption on aggregated product
                                # level
CONS_G_T_time(prd,regg,year)    government consumption on aggregated product
                                # level
GFCF_T_time(prd,regg,year)      gross fixed capital formation on aggregated
                                # product level

CAPREV_time(reg,year)           revenue from capital
LABREV_time(reg,year)           revenue from labour
TSPREV_time(reg,year)           revenue from net tax on products
NTPREV_time(reg,year)           revenue from net tax on production
INMREV_time(reg,year)           revenue from international margins
TSEREV_time(reg,year)           revenue from tax on export

GRINC_H_time(regg,year)         gross income of households
GRINC_G_time(regg,year)         gross income of government
GRINC_I_time(regg,year)         gross income of investment agent
CBUD_H_time(regg,year)          budget available for household consumption
CBUD_G_time(regg,year)          budget available for government consumption
CBUD_I_time(regg,year)          budget available for gross fixed capital
                                # formation

SCLFD_H_time(regg,year)         scale parameter for household consumption
SCLFD_G_time(regg,year)         scale parameter for government consumption
SCLFD_I_time(regg,year)         scale parameter for gross fixed capital

INCTRANSFER_time(reg,fd,regg,fdd,year)  income transfers
TRANSFERS_ROW_time(reg,fd,year) income trasnfers from rest of the world regions

$if %demnfunc% == "CES" $goto demnfunc_CES
CONS_H_T_MIN_time(prd,regg,year)    subsistence level of household consumption
                                    # for each product (volume)
$label demnfunc_CES

* Production
Y_time(regg,ind,year)           output vector on industry level
X_time(reg,prd,year)            output vector on product level

INTER_USE_T_time(prd,regg,ind,year) use of intermediate inputs on aggregated
                                    # product level

K_time(reg,regg,ind,year)       use of capital
L_time(reg,regg,ind,year)       use of labour

PnKL_time(regg,ind,year)        aggregate production factors price


$if %prodfunc% == "KL" $goto prod_func_KL
nKLE_time(regg,ind,year)        use of aggregated capital-labour-energy nest
nENER_time(regg,ind,year)       use of aggregated energy nest
nKL_time(regg,ind,year)         use of aggregated production factors
ENER_time(prd,regg,ind,year)    use of energy types

PnENER_time(regg,ind,year)      aggregate energy price
PnKLE_time(regg,ind,year)       aggregate capital-labour-energy price
$label prod_func_KL

* Trade
INTER_USE_D_time(prd,regg,ind,year) use of domestically produced intermediate
                                    # inputs
INTER_USE_M_time(prd,regg,ind,year) use of aggregated imported intermediate
                                    # inputs

CONS_H_D_time(prd,regg,year)    household consumption of domestically produced
                                # products
CONS_H_M_time(prd,regg,year)    household consumption of aggregated imported
                                # products
CONS_G_D_time(prd,regg,year)    government consumption of domestically produced
                                # products
CONS_G_M_time(prd,regg,year)    government consumption of aggregated imported
                                # products
GFCF_D_time(prd,regg,year)      gross fixed capital formation of domestically
                                # produced products
GFCF_M_time(prd,regg,year)      gross fixed capital formation of aggregated
                                # imported products
SV_time(reg,prd,regg,year)      stock changes of products on the most
                                # detailed level from modeled regions

IMPORT_T_time(prd,regg,year)    total use of aggregated imported products
IMPORT_MOD_time(prd,regg,year)  aggregated import from modeled regions
IMPORT_ROW_time(prd,regg,year)  import from the rest of the world region
TRADE_time(reg,prd,regg,year)   bi-lateral trade flows
EXPORT_ROW_time(reg,prd,year)   export to the rest of the world region

PIMP_T_time(prd,regg,year)      aggregate total imported product price
PIMP_MOD_time(prd,regg,year)    aggregate imported product price for the
                                # aggregate imported from modeled regions

*Closure
PY_time(regg,ind,year)          industry output price
P_time(reg,prd,year)            basic product price
PK_time(reg,year)               capital price
PL_time(reg,year)               labour price

PIU_time(prd,regg,ind,year)     aggregate product price for intermediate use
PC_H_time(prd,regg,year)        aggregate product price for household
                                # consumption
PC_G_time(prd,regg,year)        aggregate product price for government
                                # consumption
PC_I_time(prd,regg,year)        aggregate product price for gross fixed
                                # capital formation
PROW_time                       price of imports from the rest of the world
                                # region (similar to exchange rate)
PAASCHE_time(regg,year)         Paasche price index for household consumption
LASPEYRES_time(regg,year)       Laspeyres price index for household consumption
GDPCUR_time(regg,year)          GDP in current prices (value)
GDPCONST_time(regg,year)        GDP in constant prices (volume)
GDPDEF_time                     GDP deflator used as numéraire

*Exogenous variables
tc_h_time(prd,regg,year)        tax and subsidies on products rates for
                                # household consumption (relation in value)
tc_g_time(prd,regg,year)        tax and subsidies on products rates for
                                # government consumption (relation in value)
tc_gfcf_time(prd,regg,year)     tax and subsidies on products rates for gross
                                # fixed capital formation (relation in value)
txd_ind_time(reg,regg,ind,year) net taxes on production rates (relation in
                                # value)

tc_ind_time(prd,regg,ind,year)  tax and subsidies on products rates for
                                # industries net taxes on production rates
                                # (relation in value)

ty_time(reg,year)               household income tax rate


*Complex specific parameters
prodK_time(regg,ind,year)       level of capital productivity
prodL_time(regg,ind,year)       level of labour productivity
;
