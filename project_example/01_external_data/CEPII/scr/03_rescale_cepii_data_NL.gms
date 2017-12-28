
$ontext

File:   03-rescale-cepii-data-NL.gms
Author: Jinxue Hu
Date:   18-02-2015

This script rescales the baseline data from CEPII (version 2.2) in such a way
that CBS values Dutch GDP are respected.

$offtext

$oneolcom
$eolcom #

* *********************** Baseyear should have value one ***********************
* CBS GDP growth is 
*        CBS    EXIOMOD/CEPII
*2012   -1.1%   2.2%
*2013   -0.2%   1.6%
*2014   1.4%    1.5%
*2015   2.3%    1.5%
*2016   2.2%    2.1%

PRODKL_CEPII_change("NL","2012")  = 1 + (-0.5) * (PRODKL_CEPII_change("NL","2012") - 1 ) ;
PRODKL_CEPII_change("NL","2013")  = 1 + (-0.5) * (PRODKL_CEPII_change("NL","2013") - 1 ) ;
PRODKL_CEPII_change("NL","2014")  = 1 + ( 0.6) * (PRODKL_CEPII_change("NL","2014") - 1 ) ;
PRODKL_CEPII_change("NL","2015")  = 1 + ( 0.8) * (PRODKL_CEPII_change("NL","2015") - 1 ) ;
PRODKL_CEPII_change("NL","2016")  = PRODKL_CEPII_change("NL","2016") ;

* CBS active population growth is
*        CBS    CEPII
*2012    -0.3%  -1.1%
*2013    -0.3%  -1.3%
*2014    -0.2%  -1.3%
*2015    0.01%  -1.3%
*2016    0.1%   -0.1%
*2017    0.3%   -0.1%

*LS_CEPII_change("NL",year)        = LS_CEPII_change("NL",year) + 0.0048 ;
LS_CEPII_change("NL","2012")      = 0.997 ;
LS_CEPII_change("NL","2013")      = 0.997 ;
LS_CEPII_change("NL","2014")      = 0.998 ;
LS_CEPII_change("NL","2015")      = 1.0001 ;
LS_CEPII_change("NL","2016")      = 1.001 ;
LS_CEPII_change("NL","2017")      = 1.003 ;

Display PRODKL_CEPII_change, LS_CEPII_change ;