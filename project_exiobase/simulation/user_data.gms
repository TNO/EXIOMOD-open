* File:   library/scr/user_data.gms
* Author: Trond Husby
* Date:   19 February 2015
* Adjusted: 19 February 2015

* gams-master-file: main.gms

$ontext
This is a file where additional project-specific data can be read in. Data should be placed in %project%/data/.
$offtext

Sets
*Sets included to map wagedata from EXIOMOD60
totset60 /t001*t060,t204,t206*t209,t212/
sec60(totset60) /t001*t060/
;

$onmulti 
Sets
    va /"LOW","MID","HIGH"/
    klpr(va) / "COE", "LOW","MID","HIGH"/
; 
$offmulti 


Alias
    (klpr,klprr) ;


Parameters
Wdata(reg_data,totset60,sec60)
mapdmod(sec60,ind)
wag(reg_data,ind,klpr)
;
   
* Read in data from EXIOBASE60 to create split for wages
$libinclude xlimport Wdata %project%/data/EXIOBASE60_aggr_tl.xlsx USE!a1:bj3001 ;
$libinclude xlimport mapdmod %project%/data/mapdmod.xlsx Sheet1!a1:aj61 ;

wag(reg_data,ind,"LOW")= sum(sec60$mapdmod(sec60,ind), Wdata(reg_data,'t206',sec60) ) ;
wag(reg_data,ind,"MID")= sum(sec60$mapdmod(sec60,ind), Wdata(reg_data,'t207',sec60) ) ;
wag(reg_data,ind,"HIGH")= sum(sec60$mapdmod(sec60,ind), Wdata(reg_data,'t208',sec60) ) ;


Parameter
LZ_share(reg,ind,klpr) ;
   

*Skill-groups'share of income
*LZ_share(reg,ind,klpr) = sum(reg_data$(all_reg_aggr(reg_data,reg) and wag(reg_data,ind,klpr) ), wag(reg_data,ind,klpr)/SUM(klprr$wag(reg_data,ind,klprr), wag(reg_data,ind,klprr) ) ) ;
LZ_share(reg,ind,klpr) = sum(reg_data$all_reg_aggr(reg_data,reg), wag(reg_data,ind,klpr ) ) ;
LZ_share(reg,ind,klpr)$LZ_share(reg,ind,klpr) = LZ_share(reg,ind,klpr) / sum(klprr$LZ_share(reg,ind,klprr), LZ_share(reg,ind,klprr)) ;

*Correct for missing values


Display Wdata, mapdmod, wag, LZ_share, klpr ;