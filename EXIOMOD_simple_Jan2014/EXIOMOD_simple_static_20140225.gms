
$TITLE: Static EXIOMOD model for the world  - simple version


$onUNDF
$ontext

         == = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
         =                       Simple EXIOMOD model                 =
         =                                                            =
         =                             by                             =
         =                      Dr. Olga Ivanova                      =
         =                                                            =
         =                            TNO                             =
         =                                                            =
         =                                                            =
         =                     olga.ivanova@tno.nl                    =
         =                        www.tno.nl                          =
         == = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =



Purpose:
     Model calibrates parameters of a national economy with the following
     characteristics:
        - model database is based on the data from CREEA project
        - one household with Cobb-Douglas utility function
        - three types of labor by education levels
        -  commodities, used in production and consumption
        - production factors: capital, labor and commodities
        -  sectors with CES tehnology  for capital and labor
        - labor is mobile among sectors
        - capital is sector-specific
        - endogenous saving and investment
        - government sector is included:
           - Cobb-Douglas utility function
           - colects taxes and pays subsidies
        - international trade with Armington CES functions
          for exports and imports
        - commodities are tradeable
        - endogenously determined exchange rate/terms of trade


Notational conventions:

        -scalars, parameters and data are in lower case
        -VARIABLES (and their initial levels) and EQUATION names are in
         CAPITAL letters
        -EQUATION names always begin with EQ
        -initial values of variables and parameters are indicated with Z
         added to their names

$offtext

* Identify the sets necessary to read in the datasets
Sets
     b          rows in CREEA     /1*225/
     ss(b)      sectors           /1*163/
     cc(b)      commodities       /1*200/

     cnt         all countries and RoW regions
     /AU, AT, BE, BR, BG, CA, CN, CY, CZ, DK, EE, FI, FR, DE, GR, HR, HU, IN, ID, IE,
     IT, JP, LV, LT, LU, MT, MX, NL, NO, PL, PT, RO, RU, SK, SI, ZA, KR, ES, SE,
     CH, TW, TR, GB, US/

     EU(cnt)    EU countries
     /AT, BE, BG, CY, CZ, DK, EE, FI, FR, DE, GR, HR, HU, IE,
     IT, LV, LT, LU, MT, NL, PL, PT, RO, SK, SI, ES, SE, GB /
;


Alias
      (cc,ccc)
      (cc,cccc)
      (cc,ccccc)
      (cnt,cntt)
      (cnt,cnttt)
      (cnt,cntttt)
      (b,bb)
      (b,bbb)
      (b,bbbb)
      (ss,sss)
      (ss,ssss)
      (ss,sssss)

;



* ============== READING IN THE DATABASE =======================================

Parameters
USE(*,*,*)           use table in purchaser prices
SUP(*,*,*)           supply table in producer prices
;

* Read in the data from EXIOBASE  database
Execute_load 'EXIOBASE_clean', USE, SUP ;

Scalar
SAMpre SAM precision             /1e-6/
GLOBpre global balance precision /1e-5/;

* Check the balances and data problems

Parameter
check_consumption_pp(cnt,cc)  check that consumption minus taxes is non-negative ;

check_consumption_pp(cnt,cc) = ( sum(ss,USE(cnt,cc,ss))
                     + USE(cnt,cc,"164") + USE(cnt,cc,"165")
                     + USE(cnt,cc,"166") + USE(cnt,cc,"167")
*                     + USE(cnt,cc,"168") + USE(cnt,cc,"169")
*                     + USE(cnt,cc,"170")
                     )
                     - SUP(cnt,cc,"165")
                     - (SUP(cnt,cc,"177"))$(SUP(cnt,cc,"177") gt 0)  ;

check_consumption_pp(cnt,cc)$(check_consumption_pp(cnt,cc) gt 0) = 0 ;
Display check_consumption_pp ;

Parameter
check_balance(cnt,cc)  check balance of the SUTs
check_balance_indicator(cnt,cc) balance indicator
;

check_balance(cnt,cc) = sum(ss,SUP(cnt,cc,ss)) +  SUP(cnt,cc,"164")
                       + SUP(cnt,cc,"165") + SUP(cnt,cc,"177")

                       -   ( sum(ss,USE(cnt,cc,ss))
                       + USE(cnt,cc,"164") + USE(cnt,cc,"165")
                       + USE(cnt,cc,"166") + USE(cnt,cc,"167")
                       + USE(cnt,cc,"168") + USE(cnt,cc,"169")
                       + USE(cnt,cc,"170") ) ;

check_balance_indicator(cnt,cc)$(abs(check_balance(cnt,cc)) gt SAMpre) = check_balance(cnt,cc) ;
Display  check_balance, check_balance_indicator ;

loop((cnt,cc),
  if( abs(check_balance(cnt,cc)) gt SAMpre,
     abort "SUTs are not balanced"
  ) ;
);

Parameter tmargins_balance(cnt);
tmargins_balance(cnt) =  sum(cc,SUP(cnt,cc,"165") ) ;
Display tmargins_balance ;

Parameter sector_balance(cnt,ss);
sector_balance(cnt,ss) = sum(cc,SUP(cnt,cc,ss))
          -  ( sum(cc,USE(cnt,cc,ss))
          + USE(cnt,"204",ss) + USE(cnt,"205",ss)
          + USE(cnt,"209",ss) + USE(cnt,"212",ss) ) ;

sector_balance(cnt,ss)$(abs(sector_balance(cnt,ss)) lt SAMpre) =  0 ;
Display sector_balance ;

loop((cnt,ss),
  if( abs(sector_balance(cnt,ss)) gt SAMpre,
     abort "SUTs are not balanced 1"
  ) ;
);

* Check the global balance that means that SAMs can be balanced
Parameter balance_global(cnt) ;
balance_global(cnt) =
* Exports minus imports
                      ( sum(cc,USE(cnt,cc,"170"))
                          - sum(cc,SUP(cnt,cc,"164")) )
* Households consumption minus earnings
                      + ( sum(cc,USE(cnt,cc,"164"))
                          - sum(ss,USE(cnt,"205",ss))
                          - sum(ss,USE(cnt,"209",ss))
                          - sum(ss,USE(cnt,"212",ss))
                              )
* Government consumption minus earnings
                      + ( sum(cc,USE(cnt,cc,"166") + USE(cnt,cc,"165"))
                          - sum(cc,SUP(cnt,cc,"177"))
                          - sum(ss,USE(cnt,"204",ss) + USE(cnt,"201",ss))
                             )
* Investment balance
                      + ( sum(cc,USE(cnt,cc,"167"))
                          + sum(cc,USE(cnt,cc,"168")
                          + USE(cnt,cc,"169") )
                          - sum(ss, USE(cnt,"223",ss))
                             ) ;
Display balance_global ;

loop(cnt,
  if(abs(balance_global(cnt)) gt GLOBpre, abort "balance_global";);
) ;

* Read in national accounts data for constructing of SAMs
Parameter
NatAccounts(*,*) data from national accounts
Government(*,*)  data for governmental accounts
DataTaxes(*,*)   data for the taxes
;

$libinclude xlimport NatAccounts  Data/NationalAccounts.xls     NationalAccounts!b6..z53 ;
$libinclude xlimport Government   Data/NationalAccounts.xls     Government!b6..bm53 ;
$libinclude xlimport DataTaxes    Data/NationalAccounts.xls     Taxes!b6..cd53 ;


* =========== Definition of sets used in the model =============================
Sets
     sec       sectors
/
A_AGRI        Agriculture fishery forestry
A_FUEL        Fuels
A_MIN         Mining
A_FOOD        Food
A_MANUF       Manufacture
A_MACH        Machinery and equipment
A_ELEC        Electricity
A_SERV        Services
A_TRANSP      Transport

/

     com       commodities
/
C_AGRI        Agriculture fishery forestry
C_FUEL        Fuels such as gas peat lignit etc.
C_MIN         Metals stone  sand etc.
C_FOOD        Processed food products
C_MANUF       Manufactured goods
C_MACH        Machinery and equipment
C_ELEC        Electricity
C_SERV        Services
C_TRANSP      Transportation

/

     map(cc,com)
     map1(ss,sec)

;


* Prepare mapping between data and simplified EXIOMOD classification
Parameter
data_map(cc,com,*)
data_map1(ss,sec,*)
;

$libinclude xlimport data_map Sets/Simplified_dimentions.xlsx MappingCom!e1..g201 ;
$libinclude xlimport data_map1 Sets/Simplified_dimentions.xlsx MappingSec!e1..g164 ;

map(cc,com)$(data_map(cc,com,'Value') eq 1)  = yes ;
map1(ss,sec)$(data_map1(ss,sec,'Value') eq 1) = yes ;

Display map, map1 ;
*$exit

Alias
         (sec,secc)
         (com,comm)
         (cnt,cntt)
         (cnt,cnttt)
;

* ====== Calculate the balancing items of the last quadrant of the SAM =========

Parameters
* Households
Income_tax(cnt)     income taxes of the households
Hous_savings(cnt)   housholds savings
Hous_transfers(cnt) governmental transfers to the households
Hous_abroad(cnt)    households net transfers from abroad

*Government
Govt_savings(cnt)   savings of the government
Govt_abroad(cnt)    net government transfers from abroad

*Abroad
Inv_abroad(cnt)      investments from abroad
Balance_abroad(cnt)  net trade deficit or suprlus
;

Income_tax(cnt)     =  Government(cnt,"d5rec") ;
Hous_savings(cnt)   =  (NatAccounts(cnt,"b8g") - Government(cnt,"b8g")) ;
Govt_savings(cnt)   =  Government(cnt,"b8g")  ;
Hous_transfers(cnt) =  Government(cnt,"d7pay")  ;

Parameter
trade_balance(cnt)
household_balance(cnt)
governmental_balance(cnt)
taxes_balance(cnt)
income_balance(cnt)
investment_balance(cnt)
balance_global(cnt);

balance_global(cnt) =
* Exports minus imports
                      ( sum(cc,USE(cnt,cc,"170"))
                          - sum(cc,SUP(cnt,cc,"164")) )
* Households consumption minus earnings
                      + ( sum(cc,USE(cnt,cc,"164"))
                          - sum(ss,USE(cnt,"205",ss))
                          - sum(ss,USE(cnt,"212",ss))
                              )
* Government consumption minus earnings
                      + ( sum(cc,USE(cnt,cc,"166")
                          + USE(cnt,cc,"165"))
                          - sum(cc,SUP(cnt,cc,"177"))
                          - sum(ss,USE(cnt,"204",ss)
                          + USE(cnt,"201",ss))
                             )
* Investment balance
                      + ( sum(cc,USE(cnt,cc,"167"))
                          + sum(cc,USE(cnt,cc,"168")
                          + USE(cnt,cc,"169") )
                          - sum(ss, USE(cnt,"209",ss))
                             ) ;

trade_balance(cnt)        = ( sum(cc,USE(cnt,cc,"170"))
                            - sum(cc,SUP(cnt,cc,"164")) ) ;

household_balance(cnt)    = - ( sum(cc,USE(cnt,cc,"164"))
                           + Hous_savings(cnt) + Income_tax(cnt)
                            - sum(ss,USE(cnt,"205",ss))
                            - sum(ss,USE(cnt,"212",ss))
                             - Hous_transfers(cnt)
                             ) ;

governmental_balance(cnt) = - ( sum(cc,USE(cnt,cc,"165")
                            + USE(cnt,cc,"166"))
                            + Govt_savings(cnt) + Hous_transfers(cnt)
                            - sum(cc,SUP(cnt,cc,"177"))
                            - sum(ss,USE(cnt,ss,"201"))
                            - sum(ss,USE(cnt,"204",ss))
                            - Income_tax(cnt)
                            ) ;

investment_balance(cnt)   = - ( sum(cc,USE(cnt,cc,"167"))
                            + sum(cc,USE(cnt,cc,"168") + USE(cnt,cc,"169"))
                            - sum(ss, USE(cnt,"209",ss))
                            -  Govt_savings(cnt) - Hous_savings(cnt)
                            ) ;

taxes_balance(cnt)        =  sum(cc,SUP(cnt,cc,"177")) + sum(ss,USE(cnt,"201",ss)
                             + USE(cnt,"204",ss)) + Income_tax(cnt) ;

income_balance(cnt)       =  household_balance(cnt) + governmental_balance(cnt) ;


balance_global(cnt) =   0 ;

balance_global(cnt) =
* Exports minus imports
                        trade_balance(cnt)
* Households consumption minus earnings
                      -  household_balance(cnt)
* Government consumption minus earnings
                      -  governmental_balance(cnt)
* Investment balance
                      -  investment_balance(cnt) ;

Display
trade_balance
household_balance
governmental_balance
taxes_balance
income_balance
investment_balance
balance_global ;

loop((cnt),
  if( abs(balance_global(cnt)) gt GLOBpre, abort "balancing SAM not possible" ) ;
);

Inv_abroad(cnt)     =  - investment_balance(cnt)   ;

Hous_abroad(cnt)    =  - household_balance(cnt)    ;

Govt_abroad(cnt)    =  - governmental_balance(cnt) ;

Display
* Households
Income_tax
Hous_savings
Hous_transfers
Hous_abroad

*Government
Govt_savings
Govt_abroad

*Abroad
Inv_abroad
;

*$exit
* === DECLARATON OF PARAMETERS USED IN THE CODE ================================

* Declaration of scalars and assignment of values

Parameters
   growthz(cnt)   initial steady-state growth rate
   ERZ            initial exchange rate

   YZ(cnt)        initial  income level
   UZ(cnt)        initial utility level for the household

   INDEXZ(cnt)    initial consumer price index (commodities)
   INDEXEZ(cnt)   initial exports index (commodities)
   INDEXMZ(cnt)   initial imports index (commodities)

   frisch(cnt)    initial value of Frisch parameter in nested-ELES utility function

   STZ(cnt)       initial total savings
   SHZ(cnt)       initial household savings
   SGZ(cnt)       initial government savings
   SFZ(cnt)       initial foreign savings

   CBUDZ(cnt)     initial household expenditure (commodities)

   TRYZ(cnt)      initial income tax revenues
   TAXRZ(cnt)     initial total tax revenues
   SUBSZ(cnt)     initial total subsidies

   ETZ(cnt)       initial total exports
   MTZ(cnt)       initial total imports
   ITZ(cnt)       initial total investments
   PIZ(cnt)       initial price of investments
   RGDZ(cnt)      initial nominal rate of return

   ty(cnt)        tax rate on income
   mps(cnt)       marginal propensity to save of households
   elasLS(cnt)    real wage elasticity of labor supply

   TRFZ(cnt)      initial total transfers of government to households
   TRROWZ(cnt)    initial total transfers to government from or to ROW

   HTRROWZ(cnt)   initial total transfers to households from or to ROW

   SROWZ(cnt)     initial savings of or from RoW

   GDPZ(cnt)      initial value of GDP
   GDPZ1(cnt)
   GDPDEFZ        initial values of GDP deflator

   RGDZ(cnt)      nominal rate of return

   KSZ (cnt)      total capital endowment

   PTMZ(cnt)          initial price of transport and trade margin

   PLZ(cnt)           initial wage rate
   PZ(cnt,com)        initial price level of domestic composite good
   PDZ(cnt,sec)       initial marginal production costs
   PDDEZ(cnt,com)     initial price of goods produced domestically
   PXDDEZ(cnt,com)    initial price of goods produced domestically and purchased domestically
   PDDZ(cnt,sec,com)  initial price of domestic variety

* Production function nests

   PKLZ(cnt,sec)      initial price of capital-labour
   PEDUZ(cnt,sec)     initial price of labour nest

   PWEZ(cnt,com)      initial world price of exports
   PWEROWZ(cnt,com)   initial world price of exports to ROW
   PEZ(cnt,com)       initial price of total exports in national currency
   PEROWZ(cnt,com)    initial price of exports to ROW in national currency

   PMZ(cnt,com)       initial import price of total imports EX tariffs in local currency
   PMROWZ(cnt,com)    initial import price of imports from ROW EX tariffs in local currency
   PWMZ(cnt,com)      initial world price of imports
   PWMROWZ(cnt,com)   initial world price of imports from ROW

   LSZ(cnt)           initial supply of labor
   LSZZ(cnt)          initial supply of labor

   XZ(cnt,com)        initial domestic sales
   SVZ(cnt,com)       initial changes in inventories
   XDZ(cnt,sec)       initial domestic gross production  level
   XDDZ(cnt,sec,com)  initial domestic production

   KYZ(cnt,sec)       Capital income

   NEGVKYZ(cnt,sec)   negative values of capital income

   KZ(cnt,sec)        Capital stock
   RKZ(cnt,sec)       initial return to capital
   LZ(cnt,sec)        initial labor demand by education type

* Production function nests
   KLZ(cnt,sec)      capital-labour

   LSZ(cnt)          total labor endowment

   CZ(cnt,com)       initial consumer demand for goods
   IZ(cnt,com)       initial investment demand private
   EZ(cnt,com)       total exports
   TMXZ(cnt,com)     consumption of services for prod of transport and trade margins

   EROWZ(cnt,com)    Exports to RoW
   MZ(cnt,com)       Total imports
   MROWZ(cnt,com)    Imports from RoW

   TRADEZ(com,cnt,cntt)   International trade flows in FOB
   TmarginZ(com,cnt,cntt) International trade margins
   XDDEZ(cnt,com)    Use of domestic production within the country

   XXDZ(cnt,com)     Total demand for commodity produced within the country

   IOZ(cnt,com,sec)  initial intermediate demand for goods
   CGZ(cnt,com)      initial government demand for goods
   DEPRZ(cnt,sec)    Profits of sectors invested into production
   INVZ(cnt,sec)     Initial sectoral investment

   TAXPZ(cnt,sec)    net taxes on production
   TAXCZ(cnt,com)    net taxes on products

   TMCZ(cnt,com)     transp and trade margins

* ===== MODEL PARAMETERS TO BE DERIVED ON THE BASIS OF DATASET =================

*Tax rates to be derived from initial database

   tc(cnt,com)       nettax rate on products
   tcz(cnt,com)      initial net tax rate on products(to be used in the index)

   txd(cnt,sec)      net tax rate on production
   txdz(cnt,sec)     initial net tax rate on production

   trm(cnt,com)      trade and transport margins by type

* Parameters related to production functions
   ioc(cnt,com,sec)   technical coefficients intermediate inputs
   iop(cnt,sec,com)  technical coefficients for outputs

* Capital-labor nest
   gammaL(cnt,sec)   share parameter for L
   gammaK(cnt,sec)   share parameter for K
   aKL(cnt,sec)      scaling parameter of KL nest
   sigmaKL(cnt,sec)  elasticity of substitution

* depreciation
   delta(cnt,sec)    depreciation rate

* Parameters related to household's utility function (Cobb-Douglas)
   alphaH(cnt,com)   power parameters of household's utility

* Parameters related to modellig of international trade
   sigmaA(cnt,com)   Armington elasticity of sunstitution
   gammaA1(cnt,com)  CES share parameter of ARMINGTON function for imports from ROW
   gammaA2(cnt,com)  CES share parameter of ARMINGTON function for XDDE
   aA(cnt,com)       scale parameter of ARMINGTON function of sector

* CET production function
   sigmaT(cnt,com)   CET elasticity of substitution
   gammaT1(cnt,com)  share parameter of CET function for imports from ROW
   gammaT2(cnt,com)  share parameter of CET function for XDDE
   aT(cnt,com)       scale parameter of CET function of sector

* Choice of same good produced by different sectors (variety choice)
   sigmaB(cnt,com)  Elasticiticity of substitution between varieties
   gammaB(cnt,sec,com) share of commodity bought from a particular sector
   aB(cnt,com)      scale parameter

* Modelling of bi-lateral trade CES
   sigmaAA(cnt,com)   Armington elasticity of substitution
   gammaAA1(cnt,com)  CES share parameter of ARMINGTON function for imports from RoW
   gammaAA2(cntt,cnt,com)  CES share parameter of ARMINGTON function for imports from different countries
   aAA(cnt,com)       scale parameter of ARMINGTON function of sector

* Modelling of bi-lateral trade CET
   sigmaAAT(cnt,com)   Armington elasticity of sunstitution
   gammaAAT1(cnt,com)  CES share parameter of ARMINGTON function for exports from RoW
   gammaAAT2(cntt,cnt,com)  CES share parameter of ARMINGTON function for exports from different countries
   aAAT(cnt,com)       scale parameter of ARMINGTON function of sector

* Other parameters
   alphaI(cnt,com)    Cobb-Douglas power in investment production function

   alphaG(cnt,com)    Cobb-Douglas power in government utility function

   svs(cnt,com)       inventory shares
   atm(cnt,com)       share of commodity for prod of transp and trade margins
;

* ================= INITIAL DATA FOR MODEL VARIABLES ===========================

*Assigning data from the SUTs to the parameters representing
*initial values of model variables

*Column parameters

IOZ(cnt,com,sec)  = sum((cc,ss)$((map(cc,com) and map1(ss,sec))),USE(cnt,cc,ss)) ;
XDDZ(cnt,sec,com) = sum((ss,cc)$((map(cc,com) and map1(ss,sec))),SUP(cnt,cc,ss)) ;

CZ(cnt,com)$sum(map(cc,com),USE(cnt,cc,"164")) = sum(map(cc,com),USE(cnt,cc,"164"))  ;

CGZ(cnt,com)      = sum(map(cc,com),USE(cnt,cc,"165") + USE(cnt,cc,"166")) ;
IZ(cnt,com)       = sum(map(cc,com),USE(cnt,cc,"167")) ;
SVZ(cnt,com)      = sum(map(cc,com),USE(cnt,cc,"168") + USE(cnt,cc,"169")) ;

EZ(cnt,com)       =  sum(map(cc,com),USE(cnt,cc,"170")) ;

Display IOZ,XDDZ,CZ,CGZ,IZ,SVZ,EZ ;

*Row parameters
LZ(cnt,sec)$sum(map1(ss,sec),USE(cnt,"205",ss))
                    = sum(map1(ss,sec),USE(cnt,"205",ss))     ;

KYZ(cnt,sec)      = sum(map1(ss,sec),USE(cnt,"212",ss))  ;

TAXPZ(cnt,sec)    = sum(map1(ss,sec),USE(cnt,"201",ss) + USE(cnt,"204",ss))  ;

DEPRZ(cnt,sec)    = sum(map1(ss,sec),USE(cnt,"209",ss))  ;

TAXCZ(cnt,com)    = sum(map(cc,com),SUP(cnt,cc,"177")) ;

TMCZ(cnt,com)$(sum(map(cc,com),SUP(cnt,cc,"165")) gt 0)
                  = sum(map(cc,com),SUP(cnt,cc,"165")) ;

TMXZ(cnt,com)$(sum(map(cc,com),SUP(cnt,cc,"165")) lt 0)
                  = - sum(map(cc,com),SUP(cnt,cc,"165")) ;

MZ(cnt,com)       =  sum(map(cc,com),SUP(cnt,cc,"164")) ;

Display LZ,KYZ,TAXPZ,DEPRZ,TAXCZ,TMCZ,MZ,TMXZ ;

* ===============  Derive consistent trade flows ===============================

Parameters
TRADEZ(com,cnt,cntt)   trade flows in producer prices
TmarginZ(com,cnt,cntt) trade and transport margins
EROWZ(cnt,com) export to RoW
MROWZ(cnt,com) import to RoW
;

Sets services(com) /C_SERV, C_TRANSP/ ;

EROWZ(cnt,com)                =  EZ(cnt,com)*0.25 ;
EROWZ(cnt,'C_TRANSP')         =  EZ(cnt,'C_TRANSP')*0.45 ;

TRADEZ(com,cnt,cntt)$(EZ(cnt,com) and MZ(cntt,com))
 =  (EZ(cnt,com) - EROWZ(cnt,com))*MZ(cntt,com)/sum(cnttt, MZ(cnttt,com)) ;

MROWZ(cnt,com)         = MZ(cnt,com) -  sum(cntt,TRADEZ(com,cntt,cnt)*(1 + (0.05)$(not services(com))) ) ;
TmarginZ(com,cnt,cntt)$(not services(com)) = 0.05 ;


Display XDDZ, EZ, MZ, EROWZ, TRADEZ, MROWZ ;


* ======== Assign the data values for the last quadrant of SAM =================

SHZ(cnt)           = Hous_savings(cnt)  ;

SGZ(cnt)           = Govt_savings(cnt)  ;

TRYZ(cnt)          = Income_tax(cnt)  ;

SROWZ(cnt)         = Inv_abroad(cnt)  ;

HTRROWZ(cnt)       = Hous_abroad(cnt)  ;
TRROWZ(cnt)        = Govt_abroad(cnt)  ;

Display SHZ,SGZ,SROWZ,HTRROWZ,TRROWZ ;

* ===== Assign initial values (usually unity) to initial prices in the model ====

PZ(cnt,com)        = 1 ;
PDZ(cnt,sec)       = 1 ;
PDDEZ(cnt,com)     = 1 ;
PXDDEZ(cnt,com)    = 1 ;
PDDZ(cnt,sec,com)  = 1 ;

PWEZ(cnt,com)      = 1 ;
PWEROWZ(cnt,com)   = 1 ;
PEZ(cnt,com)       = 1 ;
PEROWZ(cnt,com)    = 1 ;

PMZ(cnt,com)       = 1 ;
PMROWZ(cnt,com)    = 1 ;
PWMZ(cnt,com)      = 1 ;
PWMROWZ(cnt,com)   = 1 ;

ERZ                = 1 ;

INDEXZ(cnt)        = 1 ;
INDEXEZ(cnt)       = 1 ;
INDEXMZ(cnt)       = 1 ;

PIZ(cnt)           = 1 ;
RGDZ(cnt)          = 1 ;

PTMZ(cnt)          = 1 ;
PLZ(cnt)           = 1 ;

PKLZ(cnt,sec)      = 1 ;
PEDUZ(cnt,sec)     = 1 ;

* ===== Assign initial values to other initial variables in the model  ========

KSZ(cnt)           =  sum(sec,KYZ(cnt,sec))  ;

LSZ(cnt)           =  sum(sec,LZ(cnt,sec))   ;
LSZZ(cnt)          =  LSZ(cnt)  ;
STZ(cnt)           =  SHZ(cnt) + SGZ(cnt) + sum(sec,DEPRZ(cnt,sec)) ;

YZ(cnt)            =  KSZ(cnt) + LSZ(cnt)  ;

CBUDZ(cnt)         =  sum(com,CZ(cnt,com))  ;

TAXRZ(cnt)         =  TRYZ(cnt) + sum(sec,TAXPZ(cnt,sec))+ sum(com,TAXCZ(cnt,com)) ;

ETZ(cnt)           = sum(com,EZ(cnt,com)) ;
MTZ(cnt)           = sum(com,MZ(cnt,com)) ;
ITZ(cnt)           = sum(com,IZ(cnt,com)) ;

XZ(cnt,com)        = sum(sec,XDDZ(cnt,sec,com)) + MZ(cnt,com) - EZ(cnt,com) ;

XDZ(cnt,sec)       = sum(com,XDDZ(cnt,sec,com)) ;

Display KSZ,LSZ,STZ,YZ,CBUDZ,TAXRZ,EZ,MZ,ETZ,MTZ,ITZ,XZ,XDZ ;


* =============== Assign values to the model parameters ========================

growthz(cnt)           = 0.025 ;
frisch(cnt)            =  -1.10  ;
elasLS(cnt)            = 0.15 ;

* Capital-labor nest
sigmaKL(cnt,sec)       = 1.2     ;

* International trade
sigmaA(cnt,com)        = 5    ;
sigmaT(cnt,com)        = -5   ;

* Choice of variety
sigmaB(cnt,com)        = 10    ;

* Bi-lateral trade flows
sigmaAA(cnt,com)       = 4     ;

* Bi-lateral trade flows
sigmaAAT(cnt,com)      = -4     ;

* ==============================================================================

*Calculate initial values of other variables

TAXRZ(cnt)    =  sum(sec,TAXPZ(cnt,sec)) + sum(com,TAXCZ(cnt,com)) + TRYZ(cnt) ;

Display TAXRZ;

* ===== CHECK THE CONSISTENCY OF GDP CALCULATIONS ==============================

GDPZ(cnt)     = sum((sec,com),XDDZ(cnt,sec,com)) - sum((com,sec),IOZ(cnt,com,sec))
                + sum(com,TAXCZ(cnt,com)) ;
Display GDPZ ;

*$exit

GDPZ1(cnt)    = sum(com,CZ(cnt,com) + IZ(cnt,com)+ CGZ(cnt,com) + SVZ(cnt,com))
                + ETZ(cnt) - sum(ss,SUP(cnt,ss,"133"))  ;

Display GDPZ1 ;



Parameter difference(cnt) ;
difference(cnt) = GDPZ(cnt) - GDPZ1(cnt) ;

loop((cnt),
  if (difference(cnt) gt 0.01,
            abort "GDP is inconsistent"
  );
);

* ==============================================================================
*$exit

*Redefinition of consumption,investments and intermediate consumption
*(as net of taxes, subsidies and trade and transport margins)
Parameter
CZ_old(cnt,com)
IZ_old(cnt,com)
CGZ_old(cnt,com)
IOZ_old(cnt,com,sec)
TMXZ_old(cnt,com)
TAX_total(cnt,com)
DEM_total(cnt,com)
;

CZ_old(cnt,com)       = CZ(cnt,com)  ;
IZ_old(cnt,com)       = IZ(cnt,com)  ;
CGZ_old(cnt,com)      = CGZ(cnt,com) ;
IOZ_old(cnt,com,sec)  = IOZ(cnt,com,sec) ;
TMXZ_old(cnt,com)     = TMXZ(cnt,com) ;
TAX_total(cnt,com)    = TAXCZ(cnt,com) + TMCZ(cnt,com) ;

DEM_total(cnt,com)    = CZ(cnt,com) + IZ(cnt,com)
              + CGZ(cnt,com) + TMXZ(cnt,com) + sum(sec,IOZ(cnt,com,sec))  ;

* check the data on consumption from SAM has only positive values
loop ((cnt,com),
   if ((CZ(cnt,com) lt 0) and (abs(CZ(cnt,com)) gt SAMpre) ,
          abort "check CZ(cnt,com) "
   );
   if ((IZ(cnt,com) lt 0) and (abs(IZ(cnt,com)) gt SAMpre) ,
          abort "check IZ(cnt,com) "
   );
   if ((CGZ(cnt,com) lt 0) and (abs(CGZ(cnt,com)) gt SAMpre) ,
          abort "CGZ(cnt,com) "
   );
   if ((TMXZ(cnt,com) lt 0) and (abs(TMXZ(cnt,com)) gt SAMpre) ,
          abort "TMXZ(cnt,com) "
   );
loop (sec,
   if ((IOZ(cnt,com,sec) lt 0) and (abs(IOZ(cnt,com,sec)) gt SAMpre) ,
          abort "check IOZ(cnt,com,sec)"
   );
);
);


CZ(cnt,com)$DEM_total(cnt,com)      = CZ(cnt,com)  - TAX_total(cnt,com)*CZ_old(cnt,com)/DEM_total(cnt,com) ;
IZ(cnt,com)$DEM_total(cnt,com)      = IZ(cnt,com)  - TAX_total(cnt,com)*IZ_old(cnt,com)/DEM_total(cnt,com) ;
CGZ(cnt,com)$DEM_total(cnt,com)     = CGZ(cnt,com) - TAX_total(cnt,com)*CGZ_old(cnt,com)/DEM_total(cnt,com) ;
TMXZ(cnt,com)$DEM_total(cnt,com)    = TMXZ(cnt,com) - TAX_total(cnt,com)*TMXZ_old(cnt,com)/DEM_total(cnt,com) ;
IOZ(cnt,com,sec)$DEM_total(cnt,com) = IOZ(cnt,com,sec) - TAX_total(cnt,com)*IOZ_old(cnt,com,sec)/DEM_total(cnt,com) ;

Display CZ, IZ, CGZ, TMXZ, IOZ ;


* check the data on consumption after tax deduction has only positive values
loop ((cnt,com),

   if ((CZ(cnt,com) lt 0) and (abs(CZ(cnt,com)) gt SAMpre) ,
          abort "check CZ(cnt,com) "
   );

   if ((IZ(cnt,com) lt 0) and (abs(IZ(cnt,com)) gt SAMpre) ,
          abort "check IZ(cnt,com) "
   );
   if ((CGZ(cnt,com) lt 0) and (abs(CGZ(cnt,com)) gt SAMpre) ,
          abort "CGZ(cnt,com) "
   );
   if ((TMXZ(cnt,com) lt 0) and (abs(TMXZ(cnt,com)) gt SAMpre) ,
          abort "TMXZ(cnt,com) "
   );
loop (sec,
   if ((IOZ(cnt,com,sec) lt 0) and (abs(IOZ(cnt,com,sec)) gt SAMpre) ,
          abort "check IOZ(cnt,com,sec)"
   );
);
);

*Calculation of trade and transport margins
trm(cnt,com)$TMCZ(cnt,com) =  TMCZ(cnt,com)/(PTMZ(cnt)
               *(CZ(cnt,com) + IZ(cnt,com)+ CGZ(cnt,com)+ sum(sec,IOZ(cnt,com,sec)))) ;

Display trm ;

loop ((cnt,com),
   if ((trm(cnt,com) lt 0),
          abort "check trm"
   );
);


display   TRYZ ;

*Calculate initial tax rates from the database
ty(cnt)               = TRYZ(cnt)/YZ(cnt)   ;

tc(cnt,com)$TAXCZ(cnt,com)    = TAXCZ(cnt,com)/((CZ(cnt,com) + IZ(cnt,com)
                       + CGZ(cnt,com) + TMXZ(cnt,com)
                       + sum(sec,IOZ(cnt,com,sec)))
                       *(PZ(cnt,com)+ trm(cnt,com)*PTMZ(cnt)) ) ;
tcz(cnt,com)          = tc(cnt,com) ;
txd(cnt,sec)$TAXPZ(cnt,sec)   = TAXPZ(cnt,sec)/XDZ(cnt,sec) ;
txdz(cnt,sec)         = txd(cnt,sec) ;


*Calibration of functional model parameters from the initial dataset and
*calculation of additional initial values

* (parameters of Cobb-Douglas investment utility function and mps)

alphaI(cnt,com)$IZ(cnt,com)  = IZ(cnt,com)*(PZ(cnt,com)+ trm(cnt,com)*PTMZ(cnt))*(1 + tc(cnt,com))
               /sum(comm,IZ(cnt,comm)*(PZ(cnt,comm)+ trm(cnt,comm)*PTMZ(cnt))*(1 + tc(cnt,comm)))  ;

Display alphaI ;

ITZ(cnt)     = sum(com,IZ(cnt,com)*(PZ(cnt,com)+ trm(cnt,com)*PTMZ(cnt))*(1+ tc(cnt,com)) ) ;

PIZ(cnt)     = prod(com$alphaI(cnt,com),((PZ(cnt,com)+ trm(cnt,com)*PTMZ(cnt))
               *(1+tc(cnt,com))/alphaI(cnt,com))**alphaI(cnt,com)) ;


CBUDZ(cnt)   = sum(com, CZ(cnt,com)*(PZ(cnt,com)+trm(cnt,com)*PTMZ(cnt))*(1+ tc(cnt,com)) ) ;


*Capital stock calculations
DEPRZ(cnt,sec)     = DEPRZ(cnt,sec)/PIZ(cnt) ;

KSZ(cnt)           = ( sum(com,IZ(cnt,com)) - sum(sec,DEPRZ(cnt,sec)) )/growthz(cnt) ;

* first assign capital stock in case of positive operative surplus
KZ(cnt,sec)$(KYZ(cnt,sec) gt 0)
                   = (KYZ(cnt,sec) + DEPRZ(cnt,sec))
                     /sum(secc$(KYZ(cnt,secc) gt 0),KYZ(cnt,secc) + DEPRZ(cnt,secc))*KSZ(cnt) ;

RKZ(cnt,sec)$(KYZ(cnt,sec) gt 0)   = KYZ(cnt,sec)/KZ(cnt,sec);

* choose the minimum return to capital
Parameter RK_min(cnt),KYZ_old(cnt,sec) ;
KYZ_old(cnt,sec) = KYZ(cnt,sec) ;

loop((cnt),
  RK_min(cnt) = 1000000 ;
    loop(sec$(KYZ(cnt,sec) gt 0),
      if(RK_min(cnt) gt RKZ(cnt,sec),
          RK_min(cnt) =  RKZ(cnt,sec) ;
      ) ;
    );
);


RK_min(cnt)$(RK_min(cnt) lt 0) = sum(cntt$(RK_min(cntt) gt 0),RK_min(cntt))
     /sum(cntt$(RK_min(cntt) gt 0),1) ;
Display RK_min ;

Parameter KYZ_old(cnt,sec);
KYZ_old(cnt,sec) = KYZ(cnt,sec);

KYZ(cnt,sec)$(KYZ(cnt,sec) le 0) = RK_min(cnt)*LZ(cnt,sec)*
              sum((cntt,secc)$(KYZ(cntt,secc) gt 0),KZ(cntt,secc))
              /sum((cntt,secc)$(KYZ(cntt,secc) gt 0),LZ(cntt,secc)) ;

* second assign capital stock to sectors with negative return to capital

KZ(cnt,sec)$(KYZ(cnt,sec) gt 0)
                   = (KYZ(cnt,sec) + DEPRZ(cnt,sec))
                     /sum(secc,KYZ(cnt,secc) + DEPRZ(cnt,secc))*KSZ(cnt) ;


RKZ(cnt,sec)$KYZ(cnt,sec)   = KYZ(cnt,sec)/KZ(cnt,sec);


NEGVKYZ(cnt,sec)$(KYZ_old(cnt,sec) le 0)  =  KYZ_old(cnt,sec) - KYZ(cnt,sec) ;

delta(cnt,sec)$KZ(cnt,sec) = DEPRZ(cnt,sec)/KZ(cnt,sec);
INVZ(cnt,sec)$KZ(cnt,sec)  = (growthz(cnt)+delta(cnt,sec))*KZ(cnt,sec) ;

Display  KZ, RKZ, delta, INVZ ;

*Nominal interest rate

RGDZ(cnt) = sum(sec,RKZ(cnt,sec)*KZ(cnt,sec))/sum(sec,KZ(cnt,sec)) ;

Display RGDZ ;

* ============= CALIBRATION OF MODEL PARAMETERS ================================

* =============     (technical coefficients) ===================================

* output coefficients
iop(cnt,sec,com)$XDZ(cnt,sec) =  XDDZ(cnt,sec,com)/XDZ(cnt,sec) ;


* changes in stocks
svs(cnt,com)$SVZ(cnt,com)  =  SVZ(cnt,com)/( sum(sec,XDDZ(cnt,sec,com)) + EZ(cnt,com)
                   + MZ(cnt,com) ) ;

* transport and trade margins
atm(cnt,com)$TMXZ(cnt,com) =  TMXZ(cnt,com)*(1+tc(cnt,com))/sum(comm,TMXZ(cnt,comm)*(1+tc(cnt,comm))) ;

Display iop,svs,atm ;

RKZ(cnt,sec)$(KZ(cnt,sec) eq 0) = 1 ;

* ---------------------  Production functions ----------------------------------

ioc(cnt,com,sec)$XDZ(cnt,sec)   =  IOZ(cnt,com,sec)/XDZ(cnt,sec) ;

KLZ(cnt,sec)        = LZ(cnt,sec)*PLZ(cnt) + (RKZ(cnt,sec)
                      + delta(cnt,sec)*PIZ(cnt))*KZ(cnt,sec) ;

* Capital-labour nest

gammaK(cnt,sec)$KZ(cnt,sec)= (RKZ(cnt,sec)
                      + delta(cnt,sec)*PIZ(cnt))*KZ(cnt,sec)**(1/sigmaKL(cnt,sec))
                      /( ( (RKZ(cnt,sec) + delta(cnt,sec)*PIZ(cnt))
                      *KZ(cnt,sec)**(1/sigmaKL(cnt,sec)) )$KZ(cnt,sec)
                      + ( PLZ(cnt)*LZ(cnt,sec)**(1/sigmaKL(cnt,sec)) )$LZ(cnt,sec) ) ;

gammaL(cnt,sec)$LZ(cnt,sec) = PLZ(cnt)*LZ(cnt,sec)**(1/sigmaKL(cnt,sec))
                      /( ( (RKZ(cnt,sec) + delta(cnt,sec)*PIZ(cnt))
                     *KZ(cnt,sec)**(1/sigmaKL(cnt,sec)) )$KZ(cnt,sec)
                      + ( PLZ(cnt)*LZ(cnt,sec)**(1/sigmaKL(cnt,sec)) )$LZ(cnt,sec) ) ;

aKL(cnt,sec)$KLZ(cnt,sec) =  KLZ(cnt,sec)
                      /( ( gammaK(cnt,sec)*KZ(cnt,sec)
                      **((sigmaKL(cnt,sec)-1)/sigmaKL(cnt,sec)) )$gammaK(cnt,sec)
                      + ( gammaL(cnt,sec)*LZ(cnt,sec)
                      **((sigmaKL(cnt,sec)-1)/sigmaKL(cnt,sec)) )$gammaL(cnt,sec) )
                      **(sigmaKL(cnt,sec)/(sigmaKL(cnt,sec)-1)) ;
* ------------------------------------------------------------------------------

* households utility function
alphaH(cnt,com) = CZ(cnt,com)*(PZ(cnt,com)+trm(cnt,com)*PTMZ(cnt))*(1+ tc(cnt,com))
                  /sum(comm, CZ(cnt,comm)*(PZ(cnt,comm)+trm(cnt,comm)*PTMZ(cnt))*(1+ tc(cnt,comm)) ) ;

* international trade
* (parameters of ARMINGTON function)

PMROWZ(cnt,com)                   =  PWMROWZ(cnt,com)*ERZ   ;
PEROWZ(cnt,com)                   =  PWEROWZ(cnt,com)*ERZ  ;

XDDEZ(cnt,com)                    =  sum(sec,XDDZ(cnt,sec,com)) - EZ(cnt,com) ;
* ------------------------------------------------------------------------------

gammaA1(cnt,com)$MZ(cnt,com)     =  PMZ(cnt,com)*MZ(cnt,com)**(1/sigmaA(cnt,com))
                                  /( PMZ(cnt,com)*MZ(cnt,com)**(1/sigmaA(cnt,com))
                                  + PXDDEZ(cnt,com)*XDDEZ(cnt,com)**(1/sigmaA(cnt,com))  ) ;

gammaA2(cnt,com)$XDDEZ(cnt,com)  =  PXDDEZ(cnt,com)*XDDEZ(cnt,com)**(1/sigmaA(cnt,com))
                                  /( PMZ(cnt,com)*MZ(cnt,com)**(1/sigmaA(cnt,com))
                                  + PXDDEZ(cnt,com)*XDDEZ(cnt,com)**(1/sigmaA(cnt,com)) ) ;

aA(cnt,com)$XZ(cnt,com)          =  XZ(cnt,com)/( gammaA1(cnt,com)
                                *MZ(cnt,com)**((sigmaA(cnt,com) -1)/sigmaA(cnt,com) )  +
                                gammaA2(cnt,com)*XDDEZ(cnt,com)**((sigmaA(cnt,com)- 1)/sigmaA(cnt,com))
                                )**(sigmaA(cnt,com)/(sigmaA(cnt,com) - 1) ) ;

Display gammaA1, gammaA2, aA;

* (parameters of variety choice function - from  which sector to buy)

XXDZ(cnt,com) =  sum(secc,XDDZ(cnt,secc,com)) ;

gammaB(cnt,sec,com)$XDDZ(cnt,sec,com) = PDDZ(cnt,sec,com)*XDDZ(cnt,sec,com)**(1/sigmaB(cnt,com))
                /sum(secc$XDDZ(cnt,secc,com),PDDZ(cnt,secc,com)*XDDZ(cnt,secc,com)**(1/sigmaB(cnt,com)) ) ;

aB(cnt,com)$XXDZ(cnt,com) = XXDZ(cnt,com)/sum(sec,gammaB(cnt,sec,com)*XDDZ(cnt,sec,com)
                **((sigmaB(cnt,com) -1)/sigmaB(cnt,com) ) )**(sigmaB(cnt,com)/(sigmaB(cnt,com) - 1) ) ;

Display gammaB, aB ;

* (parameters of CET function)

gammaT1(cnt,com)$EZ(cnt,com)   =  PEZ(cnt,com)*EZ(cnt,com)**(1/sigmaT(cnt,com))
                                  /( (PEZ(cnt,com)*EZ(cnt,com)**(1/sigmaT(cnt,com)))$EZ(cnt,com)
                                  + (PXDDEZ(cnt,com)*XDDEZ(cnt,com)**(1/sigmaT(cnt,com)))$XDDEZ(cnt,com)  ) ;

gammaT2(cnt,com)$XDDEZ(cnt,com)  =  PXDDEZ(cnt,com)*XDDEZ(cnt,com)**(1/sigmaT(cnt,com))
                                  /( (PEZ(cnt,com)*EZ(cnt,com)**(1/sigmaT(cnt,com)))$EZ(cnt,com)
                                  + (PXDDEZ(cnt,com)*XDDEZ(cnt,com)**(1/sigmaT(cnt,com)))$XDDEZ(cnt,com)  ) ;

aT(cnt,com)$XXDZ(cnt,com)        =  XXDZ(cnt,com)/( ( gammaT1(cnt,com)
                                  *EZ(cnt,com)**((sigmaT(cnt,com) -1)/sigmaT(cnt,com) ) )$EZ(cnt,com) +
                                  (gammaT2(cnt,com)*XDDEZ(cnt,com)**((sigmaT(cnt,com)- 1)/sigmaT(cnt,com)))$XDDEZ(cnt,com)
                                  )**(sigmaT(cnt,com)/(sigmaT(cnt,com) - 1) ) ;


* (parameters of bi-lateral trade modelling CES)
gammaAA1(cnt,com)$MROWZ(cnt,com)  =  PMROWZ(cnt,com)*MROWZ(cnt,com)**(1/sigmaAA(cnt,com))
                                  /( PMROWZ(cnt,com)*MROWZ(cnt,com)**(1/sigmaAA(cnt,com))
                                  + sum(cntt, (PEZ(cntt,com) + PTMZ(cnt)*TmarginZ(com,cntt,cnt))
                                  *TRADEZ(com,cntt,cnt)**(1/sigmaAA(cnt,com)) ) ) ;

gammaAA2(cntt,cnt,com)$TRADEZ(com,cntt,cnt) = (PEZ(cntt,com) + PTMZ(cnt)*TmarginZ(com,cntt,cnt))
                                  *TRADEZ(com,cntt,cnt)**(1/sigmaAA(cnt,com))
                                  /( PMROWZ(cnt,com)*MROWZ(cnt,com)**(1/sigmaAA(cnt,com))
                                  + sum(cnttt, (PEZ(cnttt,com)+ PTMZ(cnt)*TmarginZ(com,cnttt,cnt))
                                  *TRADEZ(com,cnttt,cnt)**(1/sigmaAA(cnt,com)) ) ) ;

aAA(cnt,com)$MZ(cnt,com)        = MZ(cnt,com)/( gammaAA1(cnt,com)
                                *MROWZ(cnt,com)**((sigmaAA(cnt,com) -1)/sigmaAA(cnt,com) )
                                + sum(cntt,gammaAA2(cntt,cnt,com)*TRADEZ(com,cntt,cnt)
                                **((sigmaAA(cnt,com)- 1)/sigmaAA(cnt,com)))
                                )**(sigmaAA(cnt,com)/(sigmaAA(cnt,com) - 1) ) ;

* (parameters of bi-lateral trade modelling CET)

gammaAAT1(cnt,com)$EROWZ(cnt,com)  =  PEROWZ(cnt,com)*EROWZ(cnt,com)**(1/sigmaAAT(cnt,com))
                                  /( (PEROWZ(cnt,com)*EROWZ(cnt,com)**(1/sigmaAAT(cnt,com)))$EROWZ(cnt,com)
                                  + sum(cntt$TRADEZ(com,cnt,cntt), PEZ(cnt,com)*TRADEZ(com,cnt,cntt)**(1/sigmaAAT(cnt,com)) ) ) ;

gammaAAT2(cnt,cntt,com)$TRADEZ(com,cnt,cntt) = PEZ(cnt,com)*TRADEZ(com,cnt,cntt)**(1/sigmaAAT(cnt,com))
                                  /( (PEROWZ(cnt,com)*EROWZ(cnt,com)**(1/sigmaAAT(cnt,com)))$EROWZ(cnt,com)
                                  + sum(cnttt$TRADEZ(com,cnt,cnttt), PEZ(cnt,com)*TRADEZ(com,cnt,cnttt)**(1/sigmaAAT(cnt,com)) ) ) ;

aAAT(cnt,com)$EZ(cnt,com)        = EZ(cnt,com)/( gammaAAT1(cnt,com)
                                *EROWZ(cnt,com)**((sigmaAAT(cnt,com) -1)/sigmaAAT(cnt,com) )
                                + sum(cntt,gammaAAT2(cnt,cntt,com)*TRADEZ(com,cnt,cntt)
                                **((sigmaAAT(cnt,com)- 1)/sigmaAAT(cnt,com)))
                                )**(sigmaAAT(cnt,com)/(sigmaAAT(cnt,com) - 1) ) ;


TRFZ(cnt)    =  CBUDZ(cnt) - YZ(cnt)*(1- ty(cnt)) - HTRROWZ(cnt) + SHZ(cnt) ;

* Marginal propensity to save
mps(cnt)     = SHZ(cnt) /(YZ(cnt)  - TRYZ(cnt) + TRFZ(cnt) + HTRROWZ(cnt) )  ;

* Cobb-Douglas utility function of the government
alphaG(cnt,com) =  CGZ(cnt,com)*(PZ(cnt,com)+trm(cnt,com)
               *PTMZ(cnt))*(1 + tc(cnt,com))
               /(TAXRZ(cnt) - TRFZ(cnt) + TRROWZ(cnt) - SGZ(cnt)) ;



*=============== DEFINITION OF THE EXIOMOD MODEL ===============================

* ===================== Declaration of model variables =========================
Positive variables
    P(cnt,com)          domestic sales prices of commodities and price of leisure
    PD(cnt,sec)         domestic producer prices of commodities
    PDDE(cnt,com)       price of goods produced domestically
    PXDDE(cnt,com)      price of goods produced domestically and purchased domestically
    PDD(cnt,sec,com)    price of domestic variety
    ER                  exchange rate
    INDEX(cnt)          consumer price index
    PI(cnt)             price of investments private

    PEROW(cnt,com)      price of exports to ROW in national currency
    PMROW(cnt,com)      import price of imports from ROW in local currency

    PE(cnt,com)         price of exports
    PM(cnt,com)         import price of imports

    PL(cnt)             domestic price of labor
    RKC(cnt)            return to capital country level

    RGD(cnt)            nominal interest rate

* Production function nests
    PKL(cnt,sec)        price of capital-labour
    LS(cnt)             labor supply (exogenous)

    X(cnt,com)          domestic sales (domestic+foreign origin)
    XD(cnt,sec)         gross domestic output
    XDD(cnt,sec,com)    domestic output

    XDDE(cnt,com)       domestic production delivered to domestic market
    XXD(cnt,com)        total demand for commodity produced within the country

    TMX(cnt,com)        commodity consumed for prod of transp and trade marins

    EROW(cnt,com)       exports to RoW
    MROW(cnt,com)       imports from RoW

    E(cnt,com)          exports
    ETRADE(cnt,com)     exports in trade module
    PETRADE(cnt,cntt,com) exports in trade module
    M(cnt,com)          imports

    TRADE(com,cnt,cntt) international trade in FOB prices

    IT(cnt)             total investments private

    K(cnt,sec)          capital input (exogenous)

    L(cnt,sec)          labor input

* Production function nests
    KL(cnt,sec)       capital-labour

    C(cnt,com)         demand for consumer goods and leisure
    CBUD(cnt)          consumer expenditure commodities

    Y(cnt)             household income
    SH(cnt)            household savings
    SG(cnt)            government savings
    SROW(cnt)          savings of or from RoW (exogenous)
    ST(cnt)            national savings
    I(cnt,com)         demand for investment goods private

    CG(cnt,com)        intermediate public demand for goods
    TAXR(cnt)          tax revenues

    TRF(cnt)           total transfers of government to households (exogenous)

    TRROW(cnt)          total transfers to government from or to ROW

    HTRROW(cnt)         total transfers to households from or to ROW

    GDP(cnt)            gross domestic product (real)
    GDPC(cnt)           gross domestic product (nominal)
    GDPDEF              GDP deflator (exogenous-numeraire)

    PTM(cnt)            composite price of trade and transport margin

    SV(cnt,com)         changes in stocks
    IO(cnt,com,sec)     intermediate use of commodities

    Tmargin(com,cntt,cnt) international trade and transport margins
;

* ========================= Declaration of model equations =====================
* Each equation corresponds/defines an endogenous variable

Equations
    EQP(cnt,com)          domestic sales prices of commodities and price of leisure
    EQPD(cnt,sec)         domestic producer prices of commodities
    EQPDDE(cnt,com)       price of goods delivered to dom market
    EQPXDDE(cnt,com)      price of goods produced domestically and purchased domestically
    EQPDD(cnt,sec,com)    price of domestic variety
    EQER                  exchange rate
    EQINDEX(cnt)          consumer price index
    EQPI(cnt)             price of investments private

    EQPEROW(cnt,com)      initial price of exports to ROW in national currency
    EQPMROW(cnt,com)      initial import price of imports form ROW in local currency

    EQPE(cnt,com)         initial price of exports
    EQPM(cnt,com)         initial import price of imports

    EQPL(cnt)            domestic price of labor

    EQRKC(cnt)            return to capital country level

    EQRGD(cnt)            nominal interest rate

* Production function nests
    EQPKL(cnt,sec)        price of capital-labour
    EQPEDU(cnt,sec)       price of labour nest

    EQLS(cnt)             labor supply (exogenous)

    EQX(cnt,com)          domestic sales (domestic+foreign origin)
    EQXD(cnt,sec)         gross domestic output
    EQXDD(cnt,sec,com)    domestic output

    EQXDDE(cnt,com)       domestic production delivered to domestic market
    EQXXD(cnt,com)        total demand for commodity produced within the country

    EQTMX(cnt,com)        commodity consumed for prod of transp and trade marins

    EQEROW(cnt,com)       exports to RoW
    EQMROW(cnt,com)       imports from RoW

    EQE(cnt,com)          exports
    EQPETRADE(cnt,cntt,com)    exports in trade module
    EQM(cnt,com)          imports

    EQTRADE(com,cnt,cntt) international trade in FOB prices

    EQIT(cnt)             total investments private

    EQL(cnt,sec)          labor input
    EQK(cnt,sec)          capital input

* Production function nests
    EQKL(cnt,sec)       capital-labour

    EQC(cnt,com)        demand for consumer goods and leisure
    EQCBUD(cnt)         consumer expenditure commodities

    EQY(cnt)            household income
    EQSH(cnt)           household savings
    EQST(cnt)           national savings
    EQI(cnt,com)        demand for investment goods private

    EQCG(cnt,com)       intermediate public demand for goods
    EQTAXR(cnt)         tax revenues

    EQGDP(cnt)          gross domestic product (real)
    EQGDPC(cnt)         gross domestic product (nominal)
    EQGDPDEF            GDP deflator (exogenous-numeraire)

    EQPTM(cnt)          composite price of trade and transport margin

    EQSV(cnt,com)       changes in stocks
    EQIO(cnt,com,sec)   intermediate use of commodities

;


* ==================== Specification of model equations ========================

* =========== PART I: HOUSEHOLDS ===============================================

* Formation of the households incomes
EQY(cnt)..    Y(cnt) =E=
                   LS(cnt)*LSZ(cnt)/YZ(cnt)*PL(cnt)
                   + ( sum(sec,KZ(cnt,sec)/YZ(cnt)*K(cnt,sec)*RKC(cnt)*RKZ(cnt,sec))
                   + sum(sec,NEGVKYZ(cnt,sec)*GDPDEF/YZ(cnt)) ) ;

* Households consumption budget
EQCBUD(cnt)..      CBUD(cnt) =E=
                   Y(cnt)*YZ(cnt)/CBUDZ(cnt)*(1- ty(cnt))
                   + TRF(cnt)*TRFZ(cnt)/CBUDZ(cnt)*GDPDEF
                   - SH(cnt)*SHZ(cnt)/CBUDZ(cnt)
                   + HTRROW(cnt)*HTRROWZ(cnt)/CBUDZ(cnt)*ER    ;

* Households consumption according to Cobb-Gouglas demand
EQC(cnt,com)$(CZ(cnt,com)).. C(cnt,com) =E=
                   CBUD(cnt)*CBUDZ(cnt)/CZ(cnt,com)
                   *alphaH(cnt,com)/((P(cnt,com)+ trm(cnt,com)
                   *PTM(cnt))*(1 + tc(cnt,com)))  ;

* Households savings
EQSH(cnt)..     SH(cnt) =E= mps(cnt)*(Y(cnt)*YZ(cnt)/SHZ(cnt)*(1- ty(cnt))
                   + TRF(cnt)*TRFZ(cnt)/SHZ(cnt)*GDPDEF
                   + HTRROW(cnt)*HTRROWZ(cnt)/SHZ(cnt)*ER) ;


* ====================PART II: GOVERNMENT ======================================

* Governmental tax revenues
EQTAXR(cnt)..      TAXR(cnt) =E=
                   sum(sec,txd(cnt,sec)*XD(cnt,sec)*XDZ(cnt,sec)/TAXRZ(cnt)*PD(cnt,sec))

                   + sum(com,tc(cnt,com)*(P(cnt,com)+ trm(cnt,com)
                   *PTM(cnt))*( C(cnt,com)*CZ(cnt,com)/TAXRZ(cnt)
                   + I(cnt,com)*IZ(cnt,com)/TAXRZ(cnt)+ TMX(cnt,com)*TMXZ(cnt,com)/TAXRZ(cnt)
                   + CG(cnt,com)*CGZ(cnt,com)/TAXRZ(cnt)
                   + sum(sec,IO(cnt,com,sec)*IOZ(cnt,com,sec)/TAXRZ(cnt))))

                   + ty(cnt)*Y(cnt)*YZ(cnt)/TAXRZ(cnt)  ;

* Demand of government for goods and services
EQCG(cnt,com)$(CGZ(cnt,com)).. CG(cnt,com)*(P(cnt,com)+ trm(cnt,com)
                   *PTM(cnt))*(1 + tc(cnt,com)) =E= alphaG(cnt,com)
                   *( TAXR(cnt)*TAXRZ(cnt)/CGZ(cnt,com)
                   - TRF(cnt)*TRFZ(cnt)/CGZ(cnt,com)*GDPDEF
                   - SG(cnt)*SGZ(cnt)/CGZ(cnt,com)*GDPDEF
                   + TRROW(cnt)*TRROWZ(cnt)/CGZ(cnt,com)*ER )  ;

* ================= PART III : PRODUCERS =======================================

* Zero profit condition/average costs rule
EQPD(cnt,sec)$(XDZ(cnt,sec)).. PD(cnt,sec)*XD(cnt,sec)
                   *(1 - txd(cnt,sec))
                    =E=
                   K(cnt,sec)*KZ(cnt,sec)/XDZ(cnt,sec)*(RKC(cnt)*RKZ(cnt,sec)+delta(cnt,sec)*PI(cnt))
                   + PL(cnt)*L(cnt,sec)*LZ(cnt,sec)/XDZ(cnt,sec)
                   + sum(com,IO(cnt,com,sec)*IOZ(cnt,com,sec)/XDZ(cnt,sec)*(P(cnt,com)+ trm(cnt,com)
                   *PTM(cnt))*(1 + tc(cnt,com))) + NEGVKYZ(cnt,sec)*GDPDEF/XDZ(cnt,sec)
                     ;

* Zero profit for output function
EQXD(cnt,sec)$(XDZ(cnt,sec)).. XD(cnt,sec)*PD(cnt,sec) =E=
                    sum(com$XDDZ(cnt,sec,com),PDD(cnt,sec,com)
                    *XDD(cnt,sec,com)*XDDZ(cnt,sec,com)/XDZ(cnt,sec) ) ;

* Sectoral demand for capital
EQK(cnt,sec)$(KZ(cnt,sec)).. K(cnt,sec)
                   =E= ( KL(cnt,sec)*KLZ(cnt,sec)/KZ(cnt,sec)
                   *(gammaK(cnt,sec)/(RKC(cnt)*RKZ(cnt,sec)+delta(cnt,sec)*PI(cnt)))**sigmaKL(cnt,sec)
                   *PKL(cnt,sec)**sigmaKL(cnt,sec) *aKL(cnt,sec)**(sigmaKL(cnt,sec)-1) )$(gammaK(cnt,sec) lt 1)

                   + (KL(cnt,sec)*KLZ(cnt,sec)/KZ(cnt,sec))$(gammaK(cnt,sec) eq 1)

                   ;

* Sectoral demand for labour
EQL(cnt,sec)$(LZ(cnt,sec)).. L(cnt,sec) =E=

                   ( KL(cnt,sec)*KLZ(cnt,sec)/LZ(cnt,sec)
                   *(gammaL(cnt,sec)/PL(cnt))**sigmaKL(cnt,sec)
                   *PKL(cnt,sec)**sigmaKL(cnt,sec)*aKL(cnt,sec)**(sigmaKL(cnt,sec)-1) )$(gammaL(cnt,sec) lt 1)

                   + (KL(cnt,sec)*KLZ(cnt,sec)/LZ(cnt,sec))$(gammaL(cnt,sec) eq 1)
                   ;

* Composite capital and labour CES nest
EQKL(cnt,sec)$(KLZ(cnt,sec))..  KL(cnt,sec) =E=
                  XD(cnt,sec)*XDZ(cnt,sec) *( KLZ(cnt,sec)/XDZ(cnt,sec))
                  /KLZ(cnt,sec)   ;

* Demand for intermediates
EQIO(cnt,com,sec)$(IOZ(cnt,com,sec)).. IO(cnt,com,sec) =E=
                    ioc(cnt,com,sec)*XD(cnt,sec)*XDZ(cnt,sec)/IOZ(cnt,com,sec)   ;



* ============== PART IV: LABOUR AND CAPITAL MARKETS ===========================

* Endogenous supply of labour
EQLS(cnt)$(LSZ(cnt))..        LS(cnt) =E= LSZZ(cnt)/LSZ(cnt)
           *(PL(cnt)*INDEXZ(cnt)/(PLZ(cnt)*INDEX(cnt)))**elasLS(cnt) ;

* Equilibium on labour market
EQPL(cnt)..  LS(cnt) =E= sum(sec, L(cnt,sec)*LZ(cnt,sec)/LSZ(cnt)) ;

* Equilibrium on capital market
EQRKC(cnt)..      sum(sec,KZ(cnt,sec)) =E=  sum(sec,K(cnt,sec)*KZ(cnt,sec)) ;


* ============= PART V: INVESTMENTS, SAVINGS, CHANGES IN STOCKS ETC. ===========

* Total country level savings
EQST(cnt)..       ST(cnt) =E= SH(cnt)*SHZ(cnt)/STZ(cnt)
                   + SG(cnt)*SGZ(cnt)/STZ(cnt)*GDPDEF
                   + sum(sec,delta(cnt,sec)*K(cnt,sec)*KZ(cnt,sec)/STZ(cnt)*PI(cnt)) ;

* Fixed capital formation/investments
EQI(cnt,com)$(IZ(cnt,com)).. I(cnt,com)*(P(cnt,com)+ trm(cnt,com)
                   *PTM(cnt))*(1 + tc(cnt,com)) =E= alphaI(cnt,com)
                   *(IT(cnt)*ITZ(cnt))/IZ(cnt,com)  ;


* Total investments consist of savings plus changes in stocks
EQIT(cnt)..   IT(cnt) =E= ST(cnt)*STZ(cnt)/ITZ(cnt)
                   + SROW(cnt)*SROWZ(cnt)/ITZ(cnt)*ER
                   - sum(comm,SV(cnt,comm)*SVZ(cnt,comm)/ITZ(cnt)*P(cnt,comm)) ;

* Changes in stocks
EQSV(cnt,com)$(SVZ(cnt,com)).. SV(cnt,com) =E= svs(cnt,com)*
                  ( sum(sec,XDD(cnt,sec,com)*XDDZ(cnt,sec,com)/SVZ(cnt,com))
                   + E(cnt,com)*EZ(cnt,com)/SVZ(cnt,com)
                   + M(cnt,com)*MZ(cnt,com)/SVZ(cnt,com) ) ;

* Domestic sales
EQX(cnt,com)$(XZ(cnt,com)).. X(cnt,com) =E=
                     C(cnt,com)*CZ(cnt,com)/XZ(cnt,com)
                     + CG(cnt,com)*CGZ(cnt,com)/XZ(cnt,com)
                     + I(cnt,com)*IZ(cnt,com)/XZ(cnt,com)+ SV(cnt,com)*SVZ(cnt,com)/XZ(cnt,com)
                     + TMX(cnt,com)*TMXZ(cnt,com)/XZ(cnt,com)
                     + sum(sec,IO(cnt,com,sec)*IOZ(cnt,com,sec)/XZ(cnt,com)) ;


* Demand for transport and trade servics related to trade margins
EQTMX(cnt,com)$(TMXZ(cnt,com)).. TMX(cnt,com)*(1 + tc(cnt,com)) =E=
                    atm(cnt,com)*sum(comm,
                    trm(cnt,comm)*( C(cnt,comm)*CZ(cnt,comm)/TMXZ(cnt,com)
                    + I(cnt,comm)*IZ(cnt,comm)/TMXZ(cnt,com)
                    + CG(cnt,comm)*CGZ(cnt,comm)/TMXZ(cnt,com)
                    + sum(sec,IO(cnt,comm,sec)*IOZ(cnt,comm,sec)/TMXZ(cnt,com)) ) )  ;


* ================PART VI:   PRICE INDEXES =====================================

* Composite price of product sold in country cnt
EQP(cnt,com)$(XZ(cnt,com))..  P(cnt,com) =E= 1/aA(cnt,com)*(
                   (gammaA1(cnt,com)**sigmaA(cnt,com)*PM(cnt,com)**(1-sigmaA(cnt,com)))$gammaA1(cnt,com)
                   + (gammaA2(cnt,com)**sigmaA(cnt,com)*PXDDE(cnt,com)**(1-sigmaA(cnt,com)))$gammaA2(cnt,com)
                   )**(1/(1-sigmaA(cnt,com)))  ;

* CES price index for the choice of varieties / from which sector to buy com
EQPDDE(cnt,com)$(XXDZ(cnt,com)).. PDDE(cnt,com) =E=
                  ( 1/aB(cnt,com)*sum(sec$gammaB(cnt,sec,com),
                   gammaB(cnt,sec,com)**sigmaB(cnt,com)*PDD(cnt,sec,com)**(1-sigmaB(cnt,com))
                   )**(1/(1-sigmaB(cnt,com))) )

                   ;
* CES price index for capital labour nest
EQPKL(cnt,sec)$(KLZ(cnt,sec))..  PKL(cnt,sec) =E= 1/aKL(cnt,sec)*(
                  (gammaL(cnt,sec)**sigmaKL(cnt,sec)*PL(cnt)**(1-sigmaKL(cnt,sec)))$gammaL(cnt,sec)
                  + (gammaK(cnt,sec)**sigmaKL(cnt,sec)*(RKC(cnt)*RKZ(cnt,sec)
                    + delta(cnt,sec)*PI(cnt))**(1-sigmaKL(cnt,sec)))$gammaK(cnt,sec)
                  )**(1/(1-sigmaKL(cnt,sec))) ;

* Price index
EQINDEX(cnt)..     INDEX(cnt) =E=
                   sum(com$CZ(cnt,com),CZ(cnt,com)*(P(cnt,com)+trm(cnt,com)
                   *PTM(cnt))*(1+ tc(cnt,com)) )
                   /sum(com$CZ(cnt,com),CZ(cnt,com)*(PZ(cnt,com)+ trm(cnt,com)
                   *PTMZ(cnt))*(1+ tcz(cnt,com)) ) ;

* Investment price index
EQPI(cnt)..        PI(cnt) =E= prod(com$alphaI(cnt,com),((P(cnt,com)+ trm(cnt,com)
                   *PTM(cnt))*(1+ tc(cnt,com))/alphaI(cnt,com))**alphaI(cnt,com)) ;

* Nominal return to capital
EQRGD(cnt)..       RGD(cnt) =E= sum(sec,RKC(cnt)*RKZ(cnt,sec)*K(cnt,sec)*KZ(cnt,sec))
                   /sum(secc,K(cnt,secc)*KZ(cnt,secc)) ;

* Price of trade nd trandport margin
EQPTM(cnt)$(sum(com,TMXZ(cnt,com)))..  PTM(cnt) =E= sum(com,atm(cnt,com)*P(cnt,com)) ;


* ================= PART VII: GDP AND GDP DEFLATOR  ============================

* Formulation of GDP (real and nominal)
EQGDP(cnt)..      GDP(cnt) =E=
                   sum((sec,com),iop(cnt,sec,com)*XD(cnt,sec)*XDZ(cnt,sec)/GDPZ(cnt)
                   *PDZ(cnt,sec))- sum((com,sec),IO(cnt,com,sec)*IOZ(cnt,com,sec)/GDPZ(cnt)
                   *(PZ(cnt,com)+ trm(cnt,com)
                   *PTMZ(cnt))*(1 + tc(cnt,com)) )
                   + sum(com,tc(cnt,com)*(PZ(cnt,com)+ trm(cnt,com)
                   *PTMZ(cnt))*( C(cnt,com)*CZ(cnt,com)/GDPZ(cnt)
                   + I(cnt,com)*IZ(cnt,com)/GDPZ(cnt)
                   + CG(cnt,com)*CGZ(cnt,com)/GDPZ(cnt)
                   + TMX(cnt,com)*TMXZ(cnt,com)/GDPZ(cnt)
                   + sum(sec,IO(cnt,com,sec)*IOZ(cnt,com,sec)/GDPZ(cnt))  ) ) ;

EQGDPC(cnt)..     GDPC(cnt) =E=
                   sum((sec,com),iop(cnt,sec,com)*XD(cnt,sec)*XDZ(cnt,sec)/GDPZ(cnt)
                   *PD(cnt,sec))- sum((com,sec),IO(cnt,com,sec)*IOZ(cnt,com,sec)/GDPZ(cnt)
                   *(P(cnt,com)+ trm(cnt,com)
                   *PTM(cnt))*(1 + tc(cnt,com)) )
                   + sum(com,tc(cnt,com)*(P(cnt,com)+ trm(cnt,com)
                   *PTM(cnt))*( C(cnt,com)*CZ(cnt,com)/GDPZ(cnt)
                   + I(cnt,com)*IZ(cnt,com)/GDPZ(cnt)
                   + CG(cnt,com)*CGZ(cnt,com)/GDPZ(cnt)
                   + TMX(cnt,com)*TMXZ(cnt,com)/GDPZ(cnt)
                   + sum(sec,IO(cnt,com,sec)*IOZ(cnt,com,sec)/GDPZ(cnt) )  ) ) ;

* GDP deflator is used as the numeraire
EQGDPDEF..    GDPDEF =E= sum(cnt,GDPC(cnt))/sum(cnt,GDP(cnt)) ;


* =========== PAR VIII: DOMESTIC TRADE PART ====================================

* Exports decisions via CET function
EQE(cnt,com)$(EZ(cnt,com)).. E(cnt,com) =E=
                    (XXD(cnt,com)*XXDZ(cnt,com)/EZ(cnt,com)*(gammaT1(cnt,com)
                     /PE(cnt,com))**sigmaT(cnt,com)
                     *PDDE(cnt,com)**sigmaT(cnt,com)*aT(cnt,com)
                     **(sigmaT(cnt,com)-1))$(gammaT1(cnt,com) lt 1)

                     + (XXD(cnt,com)*XXDZ(cnt,com)/EZ(cnt,com)
                     *PDDEZ(cnt,com)/PEZ(cnt,com))$(gammaT1(cnt,com) eq 1)

                     ;

* Imports decisions via CES function
EQM(cnt,com)$(MZ(cnt,com)).. M(cnt,com) =E=
                    (X(cnt,com)*XZ(cnt,com)/MZ(cnt,com)*(gammaA1(cnt,com)
                     /PM(cnt,com))**sigmaA(cnt,com)
                     *P(cnt,com)**sigmaA(cnt,com)*aA(cnt,com)
                     **(sigmaA(cnt,com)-1))$(gammaA1(cnt,com) lt 1)

                     + (X(cnt,com)*XZ(cnt,com)/MZ(cnt,com)
                     *PZ(cnt,com)/PMZ(cnt,com))$(gammaA1(cnt,com) eq 1)

                     ;

* CES function zero profit: Total value of production of commodity com
* in the country is equal to value of exports plus the value of domestically
* sold products

EQXXD(cnt,com)$(XXDZ(cnt,com)).. PDDE(cnt,com)*XXD(cnt,com)  =E=
                     PXDDE(cnt,com)*XDDE(cnt,com)*XDDEZ(cnt,com)/XXDZ(cnt,com)
                     + PE(cnt,com)*E(cnt,com)*EZ(cnt,com)/XXDZ(cnt,com) ;


* Supply of domestically produced and domestically consumed good
EQPXDDE(cnt,com)$(XDDEZ(cnt,com)).. XDDE(cnt,com) =E=
                     (XXD(cnt,com)*XXDZ(cnt,com)/XDDEZ(cnt,com)*(gammaT2(cnt,com)
                     /PXDDE(cnt,com))**sigmaT(cnt,com)*PDDE(cnt,com)**sigmaT(cnt,com)*aT(cnt,com)
                     **(sigmaT(cnt,com)-1))$(gammaT2(cnt,com) lt 1)

                     + ( (XXD(cnt,com)*XXDZ(cnt,com)/XDDEZ(cnt,com)
                     *PDDEZ(cnt,com)/PXDDEZ(cnt,com))$(gammaT2(cnt,com) eq 1) );

* Demand for domestically produced and domestically consumed good
EQXDDE(cnt,com)$(XDDEZ(cnt,com))..  XDDE(cnt,com)
                      =E= (X(cnt,com)*XZ(cnt,com)/XDDEZ(cnt,com)
                     *(gammaA2(cnt,com)/PXDDE(cnt,com))**sigmaA(cnt,com)
                     *P(cnt,com)**sigmaA(cnt,com)*aA(cnt,com)**(sigmaA(cnt,com)-1)
                     )$(gammaA2(cnt,com) lt 1)

                     + (X(cnt,com)*XZ(cnt,com)/XDDEZ(cnt,com)*PZ(cnt,com)/PXDDEZ(cnt,com)
                     )$(gammaA2(cnt,com) eq 1)

                      ;


* Supply of commodity com produced by sector sec
EQPDD(cnt,sec,com)$(XDDZ(cnt,sec,com)).. XDD(cnt,sec,com)*XDDZ(cnt,sec,com) =E=
                   iop(cnt,sec,com)*XD(cnt,sec)*XDZ(cnt,sec) ;

* Demand for commodity com produced by sector sec
EQXDD(cnt,sec,com)$(XDDZ(cnt,sec,com))..  0 =E=
                     (XDD(cnt,sec,com) - ( ( XXD(cnt,com)*XXDZ(cnt,com)/XDDZ(cnt,sec,com)
                     *(gammaB(cnt,sec,com)/PDD(cnt,sec,com))**sigmaB(cnt,com)
                     *PDDE(cnt,com)**sigmaB(cnt,com)*aB(cnt,com)
                     **(sigmaB(cnt,com)-1) )$(gammaB(cnt,sec,com) lt 1)

                     + ( XXD(cnt,com)*XXDZ(cnt,com)/XDDZ(cnt,sec,com)*PDDEZ(cnt,com)
                     /PDDZ(cnt,sec,com))$(gammaB(cnt,sec,com) eq 1) ) )
                    ;



* ================== PART IX: INTERNATIONAL TRADE PART =========================

*Exogenously fixed prices of RoW
EQPEROW(cnt,com)$(EROWZ(cnt,com) ).. PEROW(cnt,com)   =E=  PWEROWZ(cnt,com)*ER
                        *(PE(cnt,com)/PEZ(cnt,com))**0.5 ;
EQPMROW(cnt,com)$(MROWZ(cnt,com) ).. PMROW(cnt,com)   =E=  PWMROWZ(cnt,com)*ER
                        *(PM(cnt,com)/PMZ(cnt,com))**0.5 ;

* Composite price of imported goods
EQPM(cnt,com)$(MZ(cnt,com) )..   PM(cnt,com)
                        =E=  1/aAA(cnt,com)*( gammaAA1(cnt,com)**sigmaAA(cnt,com)
                        *PMROW(cnt,com)**(1-sigmaAA(cnt,com))
                        + sum(cntt$gammaAA2(cntt,cnt,com),
                        gammaAA2(cntt,cnt,com)**sigmaAA(cnt,com)
                        *(PETRADE(cntt,cnt,com)+ PTM(cnt)*Tmargin(com,cntt,cnt))**(1-sigmaAA(cnt,com)) )
                        )**(1/(1-sigmaAA(cnt,com)))    ;

* Composite price of expoerted goods
EQPE(cnt,com)$(EZ(cnt,com) )..   PE(cnt,com)
                        =E=  1/aAAT(cnt,com)*( (gammaAAT1(cnt,com)**sigmaAAT(cnt,com)
                        *PEROW(cnt,com)**(1-sigmaAAT(cnt,com)))$gammaAAT1(cnt,com)
                        + sum(cntt$gammaAAT2(cnt,cntt,com),
                        gammaAAT2(cnt,cntt,com)**sigmaAAT(cnt,com)
                        *PETRADE(cnt,cntt,com)**(1-sigmaAAT(cnt,com)) )
                        )**(1/(1-sigmaAAT(cnt,com)))    ;

* Imports from RoW
EQMROW(cnt,com)$(MROWZ(cnt,com)).. MROW(cnt,com) =E=
                    ( M(cnt,com)*MZ(cnt,com)/MROWZ(cnt,com)*(gammaAA1(cnt,com)
                     /PMROW(cnt,com) )**sigmaAA(cnt,com)
                     /( gammaAA1(cnt,com)**sigmaAA(cnt,com)
                     *PMROW(cnt,com)**(1-sigmaAA(cnt,com))
                     + sum(cntt$gammaAA2(cntt,cnt,com),
                     gammaAA2(cntt,cnt,com)**sigmaAA(cnt,com)
                     *(PETRADE(cntt,cnt,com)+ PTM(cnt)*Tmargin(com,cntt,cnt))**(1-sigmaAA(cnt,com)) ) )
                     )$(gammaAA1(cnt,com) lt 1)

                     + ( M(cnt,com)*MZ(cnt,com)*PMZ(cnt,com)/MROWZ(cnt,com)/
                     PMROWZ(cnt,com) )$(gammaAA1(cnt,com) eq 1)

                     ;

* Exports from RoW
EQEROW(cnt,com)$(EROWZ(cnt,com)).. EROW(cnt,com) =E=
                    (E(cnt,com)*EZ(cnt,com)/EROWZ(cnt,com)*(gammaAAT1(cnt,com)
                     /PEROW(cnt,com) )**sigmaAAT(cnt,com)
                     *PE(cnt,com)**sigmaAAT(cnt,com)*aAAT(cnt,com)
                     **(sigmaAAT(cnt,com)-1))$(gammaAAT1(cnt,com) lt 1)

                     + ( E(cnt,com)*EZ(cnt,com)*PEZ(cnt,com)/EROWZ(cnt,com)/
                     PEROWZ(cnt,com) )$(gammaAAT1(cnt,com) eq 1)

                     ;

* International trade flows between countries (demand side)
EQTRADE(com,cntt,cnt)$(TRADEZ(com,cntt,cnt)).. TRADE(com,cntt,cnt) =E=
                    ( M(cnt,com)*MZ(cnt,com)/TRADEZ(com,cntt,cnt)*(gammaAA2(cntt,cnt,com)
                     /((PETRADE(cntt,cnt,com)+ PTM(cnt)*Tmargin(com,cntt,cnt))) )**sigmaAA(cnt,com)
                     /( gammaAA1(cnt,com)**sigmaAA(cnt,com)
                     *PMROW(cnt,com)**(1-sigmaAA(cnt,com))
                     + sum(cnttt$gammaAA2(cnttt,cnt,com),
                     gammaAA2(cnttt,cnt,com)**sigmaAA(cnt,com)
                     *(PETRADE(cnttt,cnt,com)+ PTM(cnt)*Tmargin(com,cnttt,cnt))**(1-sigmaAA(cnt,com)) ) )
                     )$(gammaAA2(cntt,cnt,com) lt 1)

                     + (M(cnt,com)*MZ(cnt,com)/TRADEZ(com,cntt,cnt)*PMZ(cnt,com)/
                     ((PEZ(cntt,com)+ PTMZ(cnt)*TmarginZ(com,cntt,cnt))))$(gammaAA2(cntt,cnt,com) eq 1)

                    ;

* International trade flows between countries (supply side)
EQPETRADE(cnt,cntt,com)$(TRADEZ(com,cnt,cntt))..  TRADE(com,cnt,cntt) =E=
                    (E(cnt,com)*EZ(cnt,com)/TRADEZ(com,cnt,cntt)*(gammaAAT2(cnt,cntt,com)
                     /(PETRADE(cnt,cntt,com)) )**sigmaAAT(cnt,com)
                     *PE(cnt,com)**sigmaAAT(cnt,com)*aAAT(cnt,com)
                     **(sigmaAAT(cnt,com)-1))$(gammaAAT2(cnt,cntt,com) lt 1)

                     + (E(cnt,com)*EZ(cnt,com)/TRADEZ(com,cnt,cntt))$(gammaAAT2(cnt,cntt,com) eq 1)

                     ;

* ===========  Trade balanced equation is used to check Walras law =============
$ontext
*Used to check the Walras Law
EQER..            sum(cnt, sum(com,PMROW(cnt,com)*MROW(cnt,com)*MROWZ(cnt,com)
                   + sum(cntt,TRADE(com,cntt,cnt)*TRADEZ(com,cntt,cnt)
                   *(PDDE(cntt,com) + PTM(cnt)*Tmargin(com,cntt,cnt)) ) )
                   - SROW(cnt)*SROWZ(cnt)*ER - TRROW(cnt)*TRROWZ(cnt)*ER
                   - HTRROW(cnt)*HTRROWZ(cnt)*ER  )
                   =E=  sum(cnt, sum(com,PEROW(cnt,com)*EROW(cnt,com)*EROWZ(cnt,com)
                   + sum(cntt, TRADE(com,cnt,cntt)*TRADEZ(com,cnt,cntt)
                   *PDDE(cnt,com)) ) )  ;
$offtext



* ======================= Model definition =====================================
* The above set of equations augmented with closure equations and
* the numeraire constitute the model in GAMS-code and this model is
* called EXIOMOD_MCP in MCP format

* Model declaration in MCP format

Model EXIOMOD_MCP
/
    EQP.P
    EQPD.PD
    EQPDDE.PDDE
    EQPXDDE.PXDDE
    EQPDD.PDD
* Comment out equation that is used to check Walras law
*    EQER.ER
    EQINDEX.INDEX
    EQPI.PI

    EQPE.PE
    EQPM.PM

    EQPL.PL
    EQRKC.RKC

    EQK.K
    EQRGD.RGD

    EQKL.KL

    EQPKL.PKL

    EQLS.LS

    EQX.X
    EQXD.XD
    EQXDD.XDD

    EQXDDE.XDDE
    EQXXD.XXD

    EQTMX.TMX

    EQE.E
    EQM.M

    EQIT.IT

    EQL.L

    EQC.C
    EQCBUD.CBUD

    EQY.Y
    EQSH.SH
    EQST.ST
    EQI.I

    EQCG.CG
    EQTAXR.TAXR

    EQGDP.GDP
    EQGDPC.GDPC
    EQGDPDEF.ER

* Alternative closure rules
*    EQGDPDEF.SROW
*    EQGDPDEF.HTRROW

    EQPTM.PTM

    EQSV.SV
    EQIO.IO

    EQPEROW.PEROW
    EQPMROW.PMROW

    EQEROW.EROW
    EQMROW.MROW
    EQTRADE.TRADE
    EQPETRADE.PETRADE

/
;

* ============== Initial levels of variables ===================================

    P.L(cnt,com)           =   PZ(cnt,com)          ;
    PD.L(cnt,sec)          =   PDZ(cnt,sec)         ;
    PDD.L(cnt,sec,com)     =   PDDZ(cnt,sec,com)    ;
    PDDE.L(cnt,com)        =   PDDEZ(cnt,com)       ;
    PXDDE.L(cnt,com)       =   PXDDEZ(cnt,com)      ;
    ER.L                   =   ERZ                  ;
    INDEX.L(cnt)           =   INDEXZ(cnt)          ;
    PI.L(cnt)              =   PIZ(cnt)             ;

    PEROW.L(cnt,com)       =   PEROWZ(cnt,com)      ;
    PMROW.L(cnt,com)       =   PMROWZ(cnt,com)      ;

    PE.L(cnt,com)          =   PEROWZ(cnt,com)      ;
    PM.L(cnt,com)          =   PMROWZ(cnt,com)      ;

    PL.L(cnt)              =   PLZ(cnt)             ;
    RKC.L(cnt)             =   1                      ;

    RGD.L(cnt)             =   RGDZ(cnt)            ;

    PKL.L(cnt,sec)         =  PKLZ(cnt,sec)         ;

    LS.L(cnt)              =   1 ;

    X.L(cnt,com)           =   1 ;
    XD.L(cnt,sec)          =   1 ;
    XXD.L(cnt,com)         =   1 ;
    XDD.L(cnt,sec,com)     =   1 ;

    XDDE.L(cnt,com)        =   1 ;

    TMX.L(cnt,com)         =   1 ;

    E.L(cnt,com)           =   1 ;
    PETRADE.L(cnt,cntt,com) =   PEROWZ(cnt,com) ;
    M.L(cnt,com)           =   1 ;

    EROW.L(cnt,com)        =   1 ;
    MROW.L(cnt,com)        =   1 ;

    TRADE.L(com,cnt,cntt)   =   1 ;

    IT.L(cnt)              =   1 ;

    K.L(cnt,sec)           =   1 ;
    L.L(cnt,sec)           =   1 ;

    KL.L(cnt,sec)          =   1 ;

    C.L(cnt,com)           =   1 ;
    CBUD.L(cnt)            =   1 ;

    Y.L(cnt)               =   1 ;
    SH.L(cnt)              =   1 ;
    SG.L(cnt)              =   1 ;
    SROW.L(cnt)            =   1 ;
    ST.L(cnt)              =   1 ;
    I.L(cnt,com)           =   1 ;

    CG.L(cnt,com)          =   1 ;
    TAXR.L(cnt)            =   1 ;

    TRF.L(cnt)             =   1 ;

    TRROW.L(cnt)           =   1 ;

    HTRROW.L(cnt)          =   1 ;

    GDP.L(cnt)             =   1 ;
    GDPC.L(cnt)            =   1 ;
    GDPDEF.L               =   1 ;

    PTM.L(cnt)             =   PTMZ(cnt) ;

    SV.L(cnt,com)          =   1 ;
    IO.L(cnt,com,sec)      =   1 ;

    Tmargin.L(com,cntt,cnt) =  TmarginZ(com,cntt,cnt) ;

$ontext
* ===============  Check homogeneity ===========================================
    P.L(cnt,com)           =   2*PZ(cnt,com)          ;
    PD.L(cnt,sec)          =   2*PDZ(cnt,sec)         ;
    PDD.L(cnt,sec,com)     =   2*PDDZ(cnt,sec,com)    ;
    PDDE.L(cnt,com)        =   2*PDDEZ(cnt,com)       ;
    PXDDE.L(cnt,com)       =   2*PXDDEZ(cnt,com)      ;
    ER.L(t)                  =   2*ERZ(t)                ;
    INDEX.L(cnt)           =   2*INDEXZ(cnt)         ;
    PI.L(cnt)              =   2*PIZ(cnt)             ;

    PEROW.L(cnt,com)       =   2*PEROWZ(cnt,com)      ;
    PMROW.L(cnt,com)       =   2*PMROWZ(cnt,com)      ;

    PE.L(cnt,com)          =   2*PEROWZ(cnt,com)      ;
    PETRADE.L(cnt,cntt,com)     =   2*PEROWZ(cnt,com)      ;
    PM.L(cnt,com)          =   2*PMROWZ(cnt,com)      ;

    PMT.L(cnt,com)         =   2*PMROWZ(cnt,com)      ;
    PET.L(cnt,com)         =   2*PEROWZ(cnt,com)      ;

    PL.L(cnt)              =   2*PLZ(cnt)          ;

    RKC.L(cnt)             =   2*1                 ;
    RGD.L(cnt)             =   2*RGDZ(cnt)            ;

    PKL.L(cnt,sec)         =  2*PKLZ(cnt,sec)             ;

    IT.L(cnt)              =   2*1 ;

    CBUD.L(cnt,inc)        =   2*1 ;

    Y.L(cnt,inc)           =   2*1 ;
    SH.L(cnt,inc)          =   2*1 ;
    ST.L(cnt)              =   2*1 ;

    TAXR.L(cnt)            =   2*1 ;

    GDPC.L(cnt)            =   2*1 ;
    GDPDEF.L(t)              =   2*1 ;

    PTM.L(cnt)             =   2*PTMZ(cnt) ;
$offtext


* ==================== Model closure and numeraire =============================

* Trade and transport margins

   Tmargin.FX(com,cntt,cnt)  =  TmarginZ(com,cntt,cnt) ;

* Exogenously fixed: other transfers and government savings

    TRF.FX(cnt)     = 1 ;
    SG.FX(cnt)      = 1 ;

* Exogenously fixed: RoW variables

    SROW.FX(cnt)    = 1 ;
    TRROW.FX(cnt)   = 1 ;
    HTRROW.FX(cnt)  = 1 ;
*    ER.FX      = ERZ ;

* Fixing of the numeraire

    GDPDEF.FX   = 1 ;


* ========== Fix variables with initial levels zero ============================

    P.FX(cnt,com)$(XZ(cnt,com)  eq 0)               =   1      ;
    PD.FX(cnt,sec)$(XDZ(cnt,sec) eq 0)              =   1      ;
    PDD.FX(cnt,sec,com)$(XDDZ(cnt,sec,com) eq 0)    =   1      ;
    PDDE.FX(cnt,com)$(XXDZ(cnt,com) eq 0)           =   1      ;
    PXDDE.FX(cnt,com)$(XDDEZ(cnt,com) eq 0)         =   1      ;

    PEROW.FX(cnt,com)$(EROWZ(cnt,com) eq 0)         =   1      ;
    PMROW.FX(cnt,com)$(MROWZ(cnt,com) eq 0)         =   1      ;

    PE.FX(cnt,com)$(EZ(cnt,com) eq 0)               =   1      ;
    PM.FX(cnt,com)$(MZ(cnt,com) eq 0)               =   1      ;
    PKL.FX(cnt,sec)$(KLZ(cnt,sec) eq 0)             =   1      ;

    X.FX(cnt,com)$(XZ(cnt,com) eq 0)                =   1      ;
    XD.FX(cnt,sec)$(XDZ(cnt,sec) eq 0)              =   1      ;
    XDD.FX(cnt,sec,com)$(XDDZ(cnt,sec,com) eq 0)    =   1      ;

    XDDE.FX(cnt,com)$(XDDEZ(cnt,com) eq 0)       =   1   ;
    XXD.FX(cnt,com)$(XXDZ(cnt,com) eq 0)         =   1   ;

    TMX.FX(cnt,com)$(TMXZ(cnt,com) eq 0)         =   1   ;

    E.FX(cnt,com)$(EZ(cnt,com) eq 0)             =   1   ;
    PETRADE.FX(cnt,cntt,com)$(TRADEZ(com,cnt,cntt) eq 0)       =   1   ;
    M.FX(cnt,com)$(MZ(cnt,com) eq 0)             =   1   ;

    EROW.FX(cnt,com)$(EROWZ(cnt,com) eq 0)       =   1   ;
    MROW.FX(cnt,com)$(MROWZ(cnt,com) eq 0)       =   1   ;

    TRADE.FX(com,cnt,cntt)$(TRADEZ(com,cnt,cntt) eq 0) =  1   ;

    K.FX(cnt,sec)$(KZ(cnt,sec) eq 0)             =   1   ;
    L.FX(cnt,sec)$(LZ(cnt,sec) eq 0)             =   1   ;

    KL.FX(cnt,sec)$(KLZ(cnt,sec) eq 0)              =  1        ;

    C.FX(cnt,com)$(CZ(cnt,com) eq 0)             =   1   ;
    I.FX(cnt,com)$(IZ(cnt,com) eq 0)             =   1   ;

    CG.FX(cnt,com)$(CGZ(cnt,com) eq 0)           =   1   ;

    SV.FX(cnt,com)$(SVZ(cnt,com) eq 0)           =   1   ;
    IO.FX(cnt,com,sec)$(IOZ(cnt,com,sec) eq 0)   =   1   ;

    Tmargin.FX(com,cnt,cntt)$(TRADEZ(com,cnt,cntt) eq 0) = 1 ;


* ====== Examples of policy simulations ========================================

* Increase in labour endowments
*LSZZ('NL') = LSZZ('NL')*1.05 ;

* Increase in trade barriers
*Tmargin.FX(com,'NL','US')  =  TmarginZ(com,'NL','US')*1.5 ;
*Tmargin.FX(com,'US','NL')  =  TmarginZ(com,'US','NL')*1.5 ;


* Introduce additional energy use tax of 10% in EU
*tc(cnt,'C_FUEL')$EU(cnt) =  tc(cnt,'C_FUEL') + 0.1 ;

* =================== Model solution in different formats ======================

Option iterlim            = 1000000 ;
*Option iterlim            = 0 ;

EXIOMOD_MCP.holdfixed     = 1 ;
EXIOMOD_MCP.TOLINFREP     = .001 ;

*EXIOMOD_TRADE.holdfixed   = 1 ;
*EXIOMOD_TRADE.TOLINFREP   = .001 ;

Option LIMROW = 0, LIMCOL = 0;

Option mcp = path ;


* ================== Solve EXIOMOD =============================================

     Solve EXIOMOD_MCP USING MCP;
*Check that the model was solved correctly
     abort$(EXIOMOD_MCP.MODELSTAT ne 1) 'Model is not completed normally',EXIOMOD_MCP.MODELSTAT ;
     abort$(EXIOMOD_MCP.SOLVESTAT ne 1) 'No optimum found',EXIOMOD_MCP.SOLVESTAT ;


* ===================== RESULTS OF SIMULATIONS =================================
* ===================== Parameters to report results ===========================

Parameters
    walras
    P_index(cnt,com)          domestic sales prices of commodities and price of leisure
    PD_index(cnt,sec)         domestic producer prices of commodities
    PDDE_index(cnt,com)       price of goods produced domestically
    PXDDE_index(cnt,com)      price of goods produced domestically and purchased domestically
    PDD_index(cnt,sec,com)    price of domestic variety
    ER_index                  exchange rate
    INDEX_index(cnt)          consumer price index
    PI_index(cnt)             price of investments private

    PEROW_index(cnt,com)      price of exports to ROW in national currency
    PMROW_index(cnt,com)      import price of imports from ROW in local currency

    PE_index(cnt,com)         price of exports
    PM_index(cnt,com)         import price of imports

    PMT_index(cnt,com)        import price of imports
    PET_index(cnt,com)        import price of imports

    PL_index(cnt)             domestic price of labor
    PKL_index(cnt,sec)        price of capital labour bundle
    RGD_index(cnt)            nominal interest rate

    LS_index(cnt)             labor supply (exogenous)

    X_index(cnt,com)          domestic sales (domestic+foreign origin)
    XD_index(cnt,sec)         gross domestic output
    XDD_index(cnt,sec,com)    domestic output

    XDDE_index(cnt,com)       domestic production delivered to domestic market
    XXD_index(cnt,com)        total demand for commodity produced within the country

    TMX_index(cnt,com)        commodity consumed for prod of transp and trade marins

    EROW_index(cnt,com)       exports to RoW
    MROW_index(cnt,com)       imports from RoW

    E_index(cnt,com)          exports
    M_index(cnt,com)          imports

    TRADE_index(com,cnt,cntt) international trade in FOB prices

    IT_index(cnt)             total investments private

    K_index(cnt,sec)          capital input (exogenous)
    L_index(cnt,sec)          labor input

    C_index(cnt,com)          demand for consumer goods and leisure
    CBUD_index(cnt)           consumer expenditure commodities

    Y_index(cnt)              household income
    SH_index(cnt)             household savings
    SG_index(cnt)             government savings
    SROW_index(cnt)           savings of or from RoW (exogenous)
    ST_index(cnt)             national savings
    I_index(cnt,com)          demand for investment goods private

    CG_index(cnt,com)         intermediate public demand for goods
    TAXR_index(cnt)           tax revenues

    TRF_index(cnt)            total transfers of government to households (exogenous)

    TRROW_index(cnt)          total transfers to government from or to ROW

    HTRROW_index(cnt)         total transfers to households from or to ROW

    GDP_index(cnt)            gross domestic product (real)
    GDPC_index(cnt)           gross domestic product (nominal)
    GDPDEF_index              GDP deflator (exogenous-numeraire)

    PTM_index(cnt)            composite price of trade and transport margin

    SV_index(cnt,com)         changes in stocks
    IO_index(cnt,com,sec)     intermediate use of commodities

;

* ===================== Check Walras law =======================================

walras =           sum(cnt, sum(com,PM.L(cnt,com)*M.L(cnt,com)*MZ(cnt,com))
                   - SROW.L(cnt)*SROWZ(cnt)*ER.L - TRROW.L(cnt)*TRROWZ(cnt)*ER.L
                   - HTRROW.L(cnt)*HTRROWZ(cnt)*ER.L  )
                   -  sum(cnt, sum(com,PE.L(cnt,com)*E.L(cnt,com)*EZ(cnt,com)
                    )  ) ;

Display walras ;



* =================== Calculate results ========================================

    P_index(cnt,com)          =  (P.L(cnt,com)/PZ(cnt,com) -1)*100 ;
    PD_index(cnt,sec)         =  (PD.L(cnt,sec)/PDZ(cnt,sec) -1)*100 ;
    PDDE_index(cnt,com)       =  (PDDE.L(cnt,com)/PDDEZ(cnt,com) -1)*100 ;
    PXDDE_index(cnt,com)      =  (PXDDE.L(cnt,com)/PXDDEZ(cnt,com) -1)*100 ;
    PDD_index(cnt,sec,com)    =  (PDD.L(cnt,sec,com)/PDDZ(cnt,sec,com) -1)*100 ;
    ER_index                  =  (ER.L/ERZ -1)*100 ;
    INDEX_index(cnt)          =  (INDEX.L(cnt)/INDEXZ(cnt) -1)*100 ;
    PI_index(cnt)             =  (PI.L(cnt)/PIZ(cnt) -1)*100 ;

    PEROW_index(cnt,com)      =  (PEROW.L(cnt,com)/PEROWZ(cnt,com) -1)*100 ;
    PMROW_index(cnt,com)      =  (PMROW.L(cnt,com)/PMROWZ(cnt,com) -1)*100 ;

    PE_index(cnt,com)         =  (PE.L(cnt,com)/PEZ(cnt,com) -1)*100 ;
    PM_index(cnt,com)         =  (PM.L(cnt,com)/PMZ(cnt,com) -1)*100 ;

    PL_index(cnt)             =  (PL.L(cnt)/PLZ(cnt) -1)*100 ;
    PKL_index(cnt,sec)        =  (PKL.L(cnt,sec)/PKLZ(cnt,sec) -1)*100 ;
    RGD_index(cnt)            =  (RGD.L(cnt)/RGDZ(cnt) -1)*100 ;

    LS_index(cnt)             =  (LS.L(cnt) -1)*100 ;

    X_index(cnt,com)          =  (X.L(cnt,com) -1)*100 ;
    XD_index(cnt,sec)         =  (XD.L(cnt,sec) -1)*100 ;
    XDD_index(cnt,sec,com)    =  (XDD.L(cnt,sec,com) -1)*100 ;

    XDDE_index(cnt,com)       =  (XDDE.L(cnt,com) -1)*100 ;
    XXD_index(cnt,com)        =  (XXD.L(cnt,com) -1)*100 ;

    TMX_index(cnt,com)        =  (TMX.L(cnt,com) -1)*100 ;

    EROW_index(cnt,com)       =  (EROW.L(cnt,com) -1)*100 ;
    MROW_index(cnt,com)       =  (MROW.L(cnt,com) -1)*100 ;

    E_index(cnt,com)          =  (E.L(cnt,com) -1)*100 ;
    M_index(cnt,com)          =  (M.L(cnt,com) -1)*100 ;

    TRADE_index(com,cnt,cntt) =  (TRADE.L(com,cnt,cntt) -1)*100 ;

    IT_index(cnt)             =  (IT.L(cnt) -1)*100 ;

    K_index(cnt,sec)          =  (K.L(cnt,sec) -1)*100 ;
    L_index(cnt,sec)          =  (L.L(cnt,sec) -1)*100 ;

    C_index(cnt,com)          =  (C.L(cnt,com) -1)*100 ;
    CBUD_index(cnt)           =  (CBUD.L(cnt) -1)*100 ;

    Y_index(cnt)              =  (Y.L(cnt) -1)*100 ;
    SH_index(cnt)             =  (SH.L(cnt) -1)*100 ;
    SG_index(cnt)             =  (SG.L(cnt) -1)*100 ;
    SROW_index(cnt)           =  (SROW.L(cnt) -1)*100 ;
    ST_index(cnt)             =  (ST.L(cnt) -1)*100 ;
    I_index(cnt,com)          =  (I.L(cnt,com) -1)*100 ;

    CG_index(cnt,com)         =  (CG.L(cnt,com) -1)*100 ;
    TAXR_index(cnt)           =  (TAXR.L(cnt) -1)*100 ;

    TRF_index(cnt)            =  (TRF.L(cnt) -1)*100 ;

    TRROW_index(cnt)          =  (TRROW.L(cnt) -1)*100 ;

    HTRROW_index(cnt)         =  (HTRROW.L(cnt) -1)*100 ;

    GDP_index(cnt)            =  (GDP.L(cnt) -1)*100 ;
    GDPC_index(cnt)           =  (GDPC.L(cnt) -1)*100 ;
    GDPDEF_index              =  (GDPDEF.L/1 -1)*100 ;

    PTM_index(cnt)            =  (PTM.L(cnt)/PTMZ(cnt) -1)*100 ;

    SV_index(cnt,com)         =  (SV.L(cnt,com) -1)*100 ;
    IO_index(cnt,com,sec)     =  (IO.L(cnt,com,sec) -1)*100 ;

* =============  Display results ===============================================
Display
    P_index
    PD_index
    PDDE_index
    PXDDE_index
    PDD_index
    ER_index
    INDEX_index
    PI_index

    PEROW_index
    PMROW_index

    PE_index
    PM_index

    PL_index
    PKL_index

    RGD_index

    LS_index

    X_index
    XD_index
    XDD_index

    XDDE_index
    XXD_index

    TMX_index

    EROW_index
    MROW_index

    E_index
    M_index

    TRADE_index

    IT_index

    K_index
    L_index

    C_index
    CBUD_index

    Y_index
    SH_index
    SG_index
    SROW_index
    ST_index
    I_index

    CG_index
    TAXR_index

    TRF_index

    TRROW_index

    HTRROW_index

    GDP_index
    GDPC_index
    GDPDEF_index

    PTM_index

    SV_index
    IO_index

    Walras

;


$exit
* ===================== Write results to gdx file ==============================
Execute_unload 'SimulationResults',



    P_index
    PD_index
    PDDE_index
    PXDDE_index
    PDD_index
    ER_index
    INDEX_index
    PI_index

    PEROW_index
    PMROW_index

    PE_index
    PM_index

    PMT_index
    PET_index

    PL_index
    PKL_index
    RGD_index

    LS_index

    X_index
    XD_index
    XDD_index

    XDDE_index
    XXD_index

    TMX_index

    EROW_index
    MROW_index

    E_index
    M_index

    TRADE_index

    IT_index

    K_index
    L_index

    C_index
    CBUD_index

    Y_index
    SH_index
    SG_index
    SROW_index
    ST_index
    I_index

    CG_index
    TAXR_index

    TRF_index

    TRROW_index

    HTRROW_index

    GDP_index
    GDPC_index
    GDPDEF_index

    PTM_index

    SV_index
    IO_index

    Tmargin_index

;

* ==============   End of the code =============================================
