
* File:   project_ENVLinkages/00-principal/scr/save_simulation_results_declaration_parameters.gms
* Author: Jinxue Hu
* Date:   19 February 2015

* Declaration of parameters for storing simulation results
*$oneolcom
*$eolcom #

Parameters

    GDP_%scenario%(reg,year)                     GDP
    GDP_old_%scenario%(reg,year)                 alternative way of calculating GDP
    Y_%scenario%(regg,ind,year)                  output vector on industry level
    X_%scenario%(reg,prd,year)                   output vector on product level

    INTER_USE_T_%scenario%(prd,regg,ind,year)    use of intermediate inputs on
                                                 # aggregated product level
    INTER_USE_D_%scenario%(prd,regg,ind,year)    use of domestically produced
                                                 # intermediate inputs
    INTER_USE_M_%scenario%(prd,regg,ind,year)    use of aggregated imported
                                                 # intermediate inputs
    INTER_USE_%scenario%(reg,prd,regg,ind,year)  use of intermediate inputs on
                                                 # the most detailed level
    INTER_USE_ROW_%scenario%(prd,regg,ind,year)  intermediate use of products
                                                 # imported from the rest of the
                                                 # world regions

    VA_%scenario%(regg,ind,year)             use of aggregated production factors
    KL_%scenario%(reg,va,regg,ind,year)      use of specific production factors


    CONS_H_T_%scenario%(prd,regg,year)      household consumption on aggregated
                                            # product level
    CONS_H_D_%scenario%(prd,regg,year)      household consumption of
                                            # domestically produced products
    CONS_H_M_%scenario%(prd,regg,year)      household consumption of aggregated
                                            # products imported from modeled
                                            # regions

    CONS_G_T_%scenario%(prd,regg,year)      government consumption on aggregated
                                            # product level
    CONS_G_D_%scenario%(prd,regg,year)      government consumption of domestically
                                            # produced products
    CONS_G_M_%scenario%(prd,regg,year)      government consumption of aggregated
                                            # product imported from modeled
                                            # regions

    GFCF_T_%scenario%(prd,regg,year)        gross fixed capital formation on
                                            # aggregated product level
    GFCF_D_%scenario%(prd,regg,year)        gross fixed capital formation of
                                            # domestically produced products
    GFCF_M_%scenario%(prd,regg,year)        gross fixed capital formation of
                                            # aggregated product imported from
                                            # modeled regions

    SV_%scenario%(reg,prd,regg,year)        stock changes of products on the
                                            # most detailed level

    IMPORT_T_%scenario%(prd,regg,year)      total use of aggregated imported
                                            # products
    IMPORT_MOD_%scenario%(prd,regg,year)    aggregated import from modeled
                                            # regions
    IMPORT_ROW_%scenario%(prd,regg,year)    import from rest of the world region
    TRADE_%scenario%(reg,prd,regg,year)     bi-lateral trade flows
    EXPORT_ROW_%scenario%(reg,prd,year)     export to the rest of the world
                                            # regions

    FACREV_%scenario%(reg,va,year)          revenue from factors of production
    TSPREV_%scenario%(reg,year)             revenue from net tax on products
    NTPREV_%scenario%(reg,year)             revenue from net tax on production
    TIMREV_%scenario%(reg,year)             revenue from tax on export and
                                            # international margins

    GRINC_H_%scenario%(regg,year)           gross income of households
    GRINC_G_%scenario%(regg,year)           gross income of government
    GRINC_I_%scenario%(regg,year)           gross income of investment agent
    CBUD_H_%scenario%(regg,year)            budget available for household
                                            #consumption
    CBUD_G_%scenario%(regg,year)            budget available for government
                                            # consumption
    CBUD_I_%scenario%(regg,year)            budget available for gross fixed
                                            # capital formation

    PY_%scenario%(regg,ind,year)            industry output price
    P_%scenario%(reg,prd,year)              basic product price
    PKL_%scenario%(reg,va,year)             production factor price
    PVA_%scenario%(regg,ind,year)           aggregate production factors price
    PIU_%scenario%(prd,regg,ind,year)       aggregate product price for
                                            # intermediate use
    PC_H_%scenario%(prd,regg,year)          aggregate product price for
                                            # household consumption
    PC_G_%scenario%(prd,regg,year)          aggregate product price for
                                            # government consumption
    PC_I_%scenario%(prd,regg,year)          aggregate product price for gross
                                            # fixed capital formation
    PIMP_T_%scenario%(prd,regg,year)        aggregate total imported product
                                            #price
    PIMP_MOD_%scenario%(prd,regg,year)      aggregate imported product price for
                                            # the aggregate imported from
                                            # modeled regions
    SCLFD_H_%scenario%(regg,year)           scale parameter for household
                                            #consumption
    SCLFD_G_%scenario%(regg,year)           scale parameter for government
                                            #consumption
    SCLFD_I_%scenario%(regg,year)           scale parameter for gross fixed
                                            # capital formation
    PROW_%scenario%(year)                   price of imports from the rest of
                                            # the world (similar to exchange rate)
    PAASCHE_%scenario%(regg,year)           Paasche price index for final users
    LASPEYRES_%scenario%(regg,year)         Laspeyres price index for final
                                            # users

    GDPCUR_%scenario%(regg,year)            GDP in current prices (value)
    GDPCONST_%scenario%(regg,year)          GDP in constant prices (volume)
    GDPDEF_%scenario%(year)                 GDP deflator used as numéraire
;

* Exogenous variables
Parameters
    KLS_%scenario%(reg,va,year)              supply of production factors
    INCTRANSFER_%scenario%(reg,fd,regg,fdd,year) income transfers
    SV_ROW_%scenario%(prd,regg,year)         stock changes of rest of the world
                                             # products
    TRANSFERS_ROW_%scenario%(reg,fd,year)    income trasnfers from rest of the
                                             # world regions
;

* New variables declared in simulation setup
Parameters
    LAND_%scenario%(reg,ind,year)           land use in km2
    LANDS_%scenario%(reg,year)              land supply in km2
    PLAND_%scenario%(reg,year)              land price

    WATER_%scenario%(reg,*,year)            water use in Mm3
    WATERS_%scenario%(reg,year)             water supply in Mm3
    PWATER_%scenario%(reg,year)             water price

    WATERW_%scenario%(regg,ind,year)        water demand by industry

    tc_ind_%scenario%(prd,regg,ind,year)    new tax rates
    tc_h_%scenario%(prd,regg,year)          new tax rates
;
