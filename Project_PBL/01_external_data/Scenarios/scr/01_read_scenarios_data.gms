
$ontext

File:   01-read-scenarios-data.gms
Author: Hettie Boonman
Date:   20-09-2019

This script reads in the baseline data from Statline.


PARAMETER NAME
Resulting parameters are named according to:

    1. Indicator
    "ioc"        ioc tabel from EXIOMOD

    2. Data source (should be the same as name of the library)
    "_food"        For food wast scenario

    3. Extension "_data" is added to indicate that it is not processed

Example of resulting parameter: ioc_food_data


INPUTS


OUTPUTS


$offtext

$oneolcom
$eolcom #
* ============================ Declaration of sets =============================



* ================================ Load data ===================================

Parameters
    ioc_food_data(prd,reg,ind,year)         Adjusted ioc for food scenario
    theta_h_les_food_data(prd,year)         Adjusted theta_h_les for food
                                            # scenario
    ioc_matt_data(prd,reg,ind,year)         Adjusted ioc for mattrass scenario
    theta_h_les_matt_data(prd,year)         Adjusted theta_h_les for mattrass
                                            # scenario
*    ioc_plastic_change(prd,reg,year)        Adjusted ioc for plastic scenario 1
    theta_g_20_data(prd,year)               Adjusted theta_g for plastic
                                            # scenario 20% less plastic
*    ioc_plastic_change_3(reg,ind,year)      Adjusted ioc for plastic scenario 3
;

$libinclude xlimport ioc_food_data               %project%\01_external_data\Scenarios\data\Berekening_scenario.xlsx   Industries!a162:aq182
$libinclude xlimport theta_h_les_food_data       %project%\01_external_data\Scenarios\data\Berekening_scenario.xlsx   Households!a147:ao151
$libinclude xlimport theta_h_les_matt_data       %project%\01_external_data\Scenarios\data\Prijzen_matrassen.xlsx    Matrassen!b148:q151
$libinclude xlimport ioc_matt_data               %project%\01_external_data\Scenarios\data\Prijzen_matrassen.xlsx    Matrassen!a141:r145
*$libinclude xlimport ioc_plastic_change          %project%\01_external_data\Scenarios\data\Berekening_scenarios_plastic.xlsx    Plastic!a55:q56
$libinclude xlimport theta_g_20_data             %project%\01_external_data\Scenarios\data\Berekening_scenarios_plastic.xlsx   Plastic_new!a27:p28
*$libinclude xlimport ioc_plastic_change_3        %project%\01_external_data\Scenarios\data\Berekening_scenarios_plastic.xlsx    Plastic!a300:q301

Display
    ioc_food_data
    theta_h_les_food_data
    ioc_matt_data
    theta_h_les_matt_data
*    ioc_plastic_change
    theta_g_20_data
*    ioc_plastic_change_3
;

* ========================== Assign data to parameters =========================

* NOte that the 'change' parameter does not work in the simulation, because, it
* can

Parameters
    ioc_food_change(prd,reg,ind,year)         Adjusted ioc for food scenario
    theta_h_les_food_change(prd,year)         Adjusted theta_h_les for food
                                              # scenario
    ioc_matt_change(prd,reg,ind,year)         Adjusted ioc for mattrass scenario
    theta_h_les_matt_change(prd,year)         Adjusted theta_h_les for mattrass
                                              # scenario
    theta_g_20_change(prd,year)               Adjusted theta_g for 20% less
                                              # plastic scenario
;

ioc_food_change(prd,reg,ind,year)$ioc_food_data(prd,reg,ind,year-1)
    = ioc_food_data(prd,reg,ind,year) / ioc_food_data(prd,reg,ind,year-1) ;

theta_h_les_food_change(prd,year)$theta_h_les_food_data(prd,year-1)
    = theta_h_les_food_data(prd,year) / theta_h_les_food_data(prd,year-1) ;


ioc_matt_change(prd,reg,ind,year)$ioc_matt_data(prd,reg,ind,year-1)
    = ioc_matt_data(prd,reg,ind,year) / ioc_matt_data(prd,reg,ind,year-1) ;

theta_h_les_matt_change(prd,year)$theta_h_les_matt_data(prd,year-1)
    = theta_h_les_matt_data(prd,year) / theta_h_les_matt_data(prd,year-1) ;


theta_g_20_change(prd,year)$theta_g_20_data(prd,year-1)
    = theta_g_20_data(prd,year) / theta_g_20_data(prd,year-1);


ioc_food_change(prd,reg,ind,'2011')$ioc_food_change(prd,reg,ind,'2012') = 1 ;
theta_h_les_food_change(prd,'2011')$theta_h_les_food_change(prd,'2012') = 1 ;
ioc_matt_change(prd,reg,ind,'2011')$ioc_matt_change(prd,reg,ind,'2012') = 1 ;
theta_h_les_matt_change(prd,'2011')$theta_h_les_matt_change(prd,'2012') = 1 ;
theta_g_20_change(prd,'2011')$theta_g_20_change(prd,'2012') = 1 ;

Display
    ioc_food_change
    theta_h_les_food_change
    ioc_matt_change
    theta_h_les_matt_change
    theta_g_20_change
;

* ========================= Parameters that do not need read-in data ===========

* Plastic pact measure 2: Alle eenmalig te gebruiken producten en verpakkingen,
* voor de Nederlandse markt, moeten minstens 35% gerecyclede plastics bevatten.

* Packaging is 40% of total produced plastic in Netherlands (see excel file).

$ontext
Parameters
    ioc_plastic(prd,reg,ind,year)                    ioc for plastic packaging
    year_par(year)                                   Parameter for year
    ioc_plastic_change2(prd,reg,ind,year)            Change ioc for plastic
                                                     # packaging
;

* ioc for 2011:
ioc_plastic("pPLAW","NLD","iRUBP","2011") =  ioc("pPLAW","NLD","iRUBP") ;
ioc_plastic("pPLAS","NLD","iRUBP","2011") =  ioc("pPLAS","NLD","iRUBP") ;


* ioc for 2025:
ioc_plastic("pPLAW","NLD","iRUBP","2025") =
    0.4 * 0.35
    * (ioc("pPLAW","NLD","iRUBP") + ioc("pPLAS","NLD","iRUBP")) ;

ioc_plastic("pPLAS","NLD","iRUBP","2025") =
    ioc("pPLAW","NLD","iRUBP") + ioc("pPLAS","NLD","iRUBP") -
    ioc_plastic("pPLAW","NLD","iRUBP","2025") ;

* Create parameters for the years
loop(year$( ord(year) ge 1 and ord(year) le 15 ),
     year_par(year) = 2010 + ord(year) ;
);

* Interpolation of intermediate years
loop(year$( ord(year) ge 2 and ord(year) le 14 ),

ioc_plastic("pPLAW","NLD","iRUBP",year)
    = ioc("pPLAW","NLD","iRUBP") +
      (ioc_plastic("pPLAW","NLD","iRUBP","2025") - ioc_plastic("pPLAW","NLD","iRUBP","2011")) /
      (year_par("2025") - year_par("2011")) *
      (year_par(year) - year_par("2011")) ;

ioc_plastic("pPLAS","NLD","iRUBP",year)
    = ioc("pPLAW","NLD","iRUBP") + ioc("pPLAS","NLD","iRUBP") -
      ioc_plastic("pPLAW","NLD","iRUBP",year) ;

);


* Calculate change parameter
ioc_plastic_change2(prd,reg,ind,year)
    $ioc_plastic(prd,reg,ind,year-1)
    = ioc_plastic(prd,reg,ind,year) /
        ioc_plastic(prd,reg,ind,year-1) ;


Display
ioc_plastic
ioc_plastic_change2
;


$offtext

*Plastic past measure 1: Afname van het gebruik van plastic met 20%.
Parameters
    ioc_plastic_20(prd,reg,ind,year)                   ioc for plastic use
    ioc_plastic_change_20(prd,reg,ind,year)            Change ioc for plastic use
    year_par_20(year)                                  Parameter for year
;

Sets
no_plas(prd)    set of every product that isn't pPLAS
/ pPLAW,    pPLNT,    pANIM,    pFORE,    pFISH,    pFOSM,    pOTHM
pFBTO,    pTXWO,    pCOKE,    pREFN,    pCHEM,    pRUBP,    pNMMP,    pMETP
pELEC,    pMACH,    pMATT,    pELCF,    pELCG,    pTRDI,    pHWAT,    pWATR
pCONS,    pTRAD,    pHORE,    pTRAN,    pREBA,    pPUBO,    pWAST,    pRECY
pREPR  /
;

* ioc for 2011 for every product:
ioc_plastic_20("pPLAS","NLD",ind,"2011") =  ioc("pPLAS","NLD",ind) ;
*ioc_plastic_20(no_plas,"NLD","iRUBP","2011") =  ioc(no_plas,"NLD","iRUBP") ;

* ioc for 2025 for pPLAS:
ioc_plastic_20("pPLAS","NLD",ind,"2025") =
    0.8 * (ioc("pPLAS","NLD",ind) ) ;

$ontext
* ioc for 2025 for no_plas:
ioc_plastic_20(no_plas,"NLD","iRUBP","2025") =
    ioc_plastic_20(no_plas,"NLD","iRUBP","2011")
    + ( ioc_plastic_20("pPLAS","NLD","iRUBP","2011")
    -  ioc_plastic_20("pPLAS","NLD","iRUBP","2025") )
    * ioc_plastic_20(no_plas,"NLD","iRUBP","2011")
    / ( sum(prd, ioc_plastic_20(prd,"NLD", "iRUBP", "2011") )
    -  ioc_plastic_20("pPLAS","NLD","iRUBP","2011") )
;
$offtext

* Create parameters for the years
loop(year$( ord(year) ge 1 and ord(year) le 15 ),
     year_par_20(year) = 2010 + ord(year) ;
);

* Interpolation of intermediate years
loop(year$( ord(year) ge 2 and ord(year) le 14 ),

ioc_plastic_20(prd,"NLD",ind,year)
    = ioc(prd,"NLD",ind) +
      (ioc_plastic_20(prd,"NLD",ind,"2025") - ioc_plastic_20(prd,"NLD",ind,"2011")) /
      (year_par_20("2025") - year_par_20("2011")) *
      (year_par_20(year) - year_par_20("2011")) ;
);

ioc_plastic_change_20(prd,reg,ind,year)
    $ioc_plastic_20(prd,reg,ind,year-1)
    = ioc_plastic_20(prd,reg,ind,year) /
        ioc_plastic_20(prd,reg,ind,year-1) ;

Display
ioc_plastic_20
ioc_plastic_change_20
;











