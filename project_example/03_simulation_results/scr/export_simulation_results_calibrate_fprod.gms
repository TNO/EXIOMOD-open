$ontext

File:   export-simulation-results_calibrate_prodK_prodL.gms
Author: Jinxue Hu
Date:   18-02-2015

This file exports factor productivity to file prodKL.xlsx. This ensures that
GDP is equal to SSP GDP.
$offtext

* ==================================== Sets ====================================


* ========================== Create aggregated results =========================
Parameter
      prodK_change(regg,ind,year)          prodK in level compared
                                           # to last year

      prodL_change(regg,ind,year)          prodL in level compared
                                           # to last year
;


prodK_change(regg,ind,year)$(ord(year) gt 1 and prodK_year(regg,ind,year-1))
         = prodK_year(regg,ind,year)
                 / prodK_year(regg,ind,year-1) ;

prodL_change(regg,ind,year)$(ord(year) gt 1 and prodK_year(regg,ind,year-1))
         = prodL_year(regg,ind,year)
                 / prodL_year(regg,ind,year-1) ;

prodK_change(regg,ind,year)$(ord(year) eq 1)
         = 1 ;

prodL_change(regg,ind,year)$(ord(year) eq 1)
         = 1 ;

* ========================= Export results to xlsx-file ========================
$libinclude xldump prodK_change %project%\02_project_model_setup\data\prodKL.xlsx prodK!
$libinclude xldump prodL_change %project%\02_project_model_setup\data\prodKL.xlsx prodL!
