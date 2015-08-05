$ontext

File:   04-rescale-cepii-data.gms
Author: Jinxue Hu
Date:   06-07-2015

This script rescales the capital data for China and Rest of the world. This is
done to match the resulting GDP with the GDP data from CEPII. Without this
adjustment China for instance has a GDP of almost 70 trillion euro instead of
around 25 trillion euro.

INPUTS
    PRODKL_CEPII_change(reg,year)       annual change in capital-labour
                                        productivity based on cepii data
    KS_CEPII_change(reg,year)           annual change in capital stock based on
                                        cepii data

OUTPUTS
    PRODKL_CEPII_change(reg,year)       annual change in capital-labour
                                        productivity based on cepii data
    KS_CEPII_change(reg,year)           annual change in capital stock based on
                                        cepii data

$offtext

$oneolcom
$eolcom #


* Use only 75% of the change
PRODKL_CEPII_change("CN",year)   =   (PRODKL_CEPII_change("CN",year) - 1 ) * 0.75 + 1 ;   
KS_CEPII_change("CN",year)       =   (KS_CEPII_change("CN",year) - 1 ) * 0.75 + 1 ;         

PRODKL_CEPII_change("WW",year)   =   (PRODKL_CEPII_change("WW",year) - 1 ) * 0.75 + 1 ;   
KS_CEPII_change("WW",year)       =   (KS_CEPII_change("WW",year) - 1 ) * 0.75 + 1 ;         

