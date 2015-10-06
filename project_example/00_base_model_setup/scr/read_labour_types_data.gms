* File:   %project%/00_base_model_setup/scr/read_labour_types_data.gms
* Author: Trond Husby
* Date:   19 February 2015
* Adjusted: 19 February 2015

* gams-master-file: run_EXIOMOD.gms

$ontext
This is a file where additional project-specific data can be read in. Data
should be placed in %project%/Labour_types/data/.

$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

Sets
*Sets included to map wagedata from EXIOMOD60
totset60
/
$include %project%/01_external_data/Labour_types/sets/totalsets_60sec.txt
/
sec60(totset60)
/
$include %project%/01_external_data/Labour_types/sets/industries_60sec.txt
/
;

*$onmulti
Sets
*Extending value added set to include three different skill groups
    vapr /'NTP','LOW','MID','HIGH','GOS','INM','TSE'/
    klpr(vapr) / 'GOS', 'LOW','MID','HIGH'/
;
*$offmulti

Alias
    (klpr,klprr)
;

Parameters
    wdata(reg_data,totset60,sec60) data from EXIOBASE 60
    mapdmod(sec60,ind)          mapping EXIOBASE 60 sectors
                                #to project specific industries
    wag(reg_data,ind,klpr)      wages per skill group per sector
    lz_share(reg,ind,klpr)      skill-groups'share of income
;

* Read in data from EXIOBASE60 to create split for wages
$libinclude xlimport wdata %project%/01_external_data/Labour_types/data/EXIOBASE60_aggr_tl.xlsx USE!a1:bj3001 ;
$libinclude xlimport mapdmod %project%/01_external_data/Labour_types/data/mapdmod.xlsx Sheet1!a1:aj61 ;

wag(reg_data,ind,'LOW')
    = sum(sec60$mapdmod(sec60,ind), Wdata(reg_data,'t206',sec60) ) ;
wag(reg_data,ind,'MID')
    = sum(sec60$mapdmod(sec60,ind), Wdata(reg_data,'t207',sec60) ) ;
wag(reg_data,ind,'HIGH')
    = sum(sec60$mapdmod(sec60,ind), Wdata(reg_data,'t208',sec60) ) ;

lz_share(reg,ind,klpr)
    = sum(reg_data$all_reg_aggr(reg_data,reg), wag(reg_data,ind,klpr ) ) ;

lz_share(reg,ind,klpr)$lz_share(reg,ind,klpr)
    = lz_share(reg,ind,klpr)
    / sum(klprr$lz_share(reg,ind,klprr), lz_share(reg,ind,klprr)) ;

Display
Wdata
mapdmod
wag
lz_share
klpr
value_added
;
