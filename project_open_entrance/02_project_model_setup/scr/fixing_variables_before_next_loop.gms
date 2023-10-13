* Fix some variables after the last loop set some values to zero.


PIU_V.FX(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) eq 0)           = 1 ;
INTER_USE_T_V.FX(prd,regg,ind)$(INTER_USE_T_V.L(prd,regg,ind) eq 0)   = 0 ;
ENER_V.FX(prd,regg,ind)$(ENER_V.L(prd,regg,ind) eq 0)                 = 0 ;

PnKL_V.FX(regg,ind)$(nKL_V.L(regg,ind) eq 0)     = 1 ;
nKL_V.FX(regg,ind)$(nKL_V.L(regg,ind) eq 0)      = 0 ;

PnENER_V.FX(regg,ind)$(nENER_V.L(regg,ind) eq 0) = 1 ;
nENER_V.FX(regg,ind)$(nENER_V.L(regg,ind) eq 0)  = 0 ;

PnKLE_V.FX(regg,ind)$(nKLE_V.L(regg,ind) eq 0)   = 1 ;
nKLE_V.FX(regg,ind)$(nKLE_V.L(regg,ind) eq 0)    = 0 ;

PY_V.FX(regg,ind)$(Y_V.L(regg,ind) eq 0)         = 1 ;
Y_V.FX(regg,ind)$(Y_V.L(regg,ind) eq 0)          = 0 ;

PC_H_V.FX(prd,regg)$(CONS_H_T_V.L(prd,regg) eq 0)       = 1 ;
CONS_H_T_V.FX(prd,regg)$(CONS_H_T_V.L(prd,regg) eq 0)   = 0 ;

PC_G_V.FX(prd,regg)$(CONS_G_T_V.L(prd,regg) eq 0)       = 1 ;
CONS_G_T_V.FX(prd,regg)$(CONS_G_T_V.L(prd,regg) eq 0)   = 0 ;

* When a price is negative (but quantity is small but still slightly positive):
* Also fix price and quantity.

PIU_V.FX(prd,regg,ind)$(PIU_V.L(prd,regg,ind) lt 0)           = 1 ;
INTER_USE_T_V.FX(prd,regg,ind)$(PIU_V.L(prd,regg,ind) lt 0)   = 0 ;
ENER_V.FX(prd,regg,ind)$(PIU_V.L(prd,regg,ind) lt 0)          = 0 ;

PnKL_V.FX(regg,ind)$(PnKL_V.L(regg,ind) lt 0)     = 1 ;
nKL_V.FX(regg,ind)$(PnKL_V.L(regg,ind) lt 0)      = 0 ;

PnENER_V.FX(regg,ind)$(PnENER_V.L(regg,ind) lt 0) = 1 ;
nENER_V.FX(regg,ind)$(PnENER_V.L(regg,ind) lt 0)  = 0 ;

PnKLE_V.FX(regg,ind)$(PnKLE_V.L(regg,ind) lt 0)   = 1 ;
nKLE_V.FX(regg,ind)$(PnKLE_V.L(regg,ind) lt 0)    = 0 ;

PY_V.FX(regg,ind)$(PY_V.L(regg,ind) lt 0)         = 1 ;
Y_V.FX(regg,ind)$(PY_V.L(regg,ind) lt 0)          = 0 ;

PC_H_V.FX(prd,regg)$(PC_H_V.L(prd,regg) lt 0)       = 1 ;
CONS_H_T_V.FX(prd,regg)$(PC_H_V.L(prd,regg) lt 0)   = 0 ;

PC_G_V.FX(prd,regg)$(PC_G_V.L(prd,regg) lt 0)       = 1 ;
CONS_G_T_V.FX(prd,regg)$(PC_G_V.L(prd,regg) lt 0)   = 0 ;

PnKLE_V.FX(regg,ind)$(nKL_V.L(regg,ind) eq 0 and nENER_V.L(regg,ind) eq 0) = 1 ;
nKLE_V.FX(regg,ind)$(nKL_V.L(regg,ind) eq 0 and nENER_V.L(regg,ind) eq 0)  = 0 ;


* We need this for the CO2cap
if(ord(year) gt 1 ,


* Only fix when two years ago it was still above a threshold, and now it is below
* the threshold
*PIU_V.FX(ener_CO2,regg,ind)$(ENER_V.L(ener_CO2,regg,ind) lt   0.00000000001)        = 1 ;
*ENER_V.FX(ener_CO2,regg,ind)$(ENER_V.L(ener_CO2,regg,ind) lt  0.00000000001)        = 0 ;


);

* We need this for the CO2cap
if(ord(year) gt 3 ,

* Only fix when two years ago it was still above a threshold, and now it is below
* the threshold
PIU_V.FX(ener_CO2,regg,ind)$(ENER_time(ener_CO2,regg,ind,year-2) gt   0.000000001 and ENER_time(ener_CO2,regg,ind,year-1) lt 0.000000001) = 1 ;
ENER_V.FX(ener_CO2,regg,ind)$(ENER_time(ener_CO2,regg,ind,year-2) gt  0.000000001 and ENER_time(ener_CO2,regg,ind,year-1) lt 0.000000001) = 0 ;


);
