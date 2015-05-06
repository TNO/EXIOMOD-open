* File:   library/scr/09_declare_model.gms
* Author: Trond Husby
* Date:   22 April 2015
* Adjusted:

* gams-master-file: 00_simulation_prepare.gms

$ontext startdoc
Documentation is missing
$offtext

* activate end of line comment and specify the activating character
$oneolcom
$eolcom #

* ========================== Declare model equations ===========================

Model IO_product_technology
/
EQBAL
EQX
EQINTU_T
EQINTU_D
EQINTU_M
EQIMP_T
EQIMP_MOD
EQTRADE
EQOBJ
/
;

Model IO_industry_technology
/
EQBAL
EQY
EQINTU_T
EQINTU_D
EQINTU_M
EQIMP_T
EQIMP_MOD
EQTRADE
EQOBJ
/
;

Model CGE_TRICK
/
EQBAL
EQY
EQINTU_T
EQINTU_D
EQINTU_M
EQVA
EQKL
EQCONS_H_T
EQCONS_H_D
EQCONS_H_M
EQCONS_G_T
EQCONS_G_D
EQCONS_G_M
EQGFCF_T
EQGFCF_D
EQGFCF_M
EQSV
EQIMP_T
EQIMP_MOD
EQIMP_ROW
EQTRADE
EQEXP
EQFACREV
EQTSPREV
EQNTPREV
EQTIMREV
EQGRINC_H
EQGRINC_G
EQGRINC_I
EQCBUD_H
EQCBUD_G
EQCBUD_I
EQPY
EQP
EQPKL
EQPVA
EQPIU
EQPC_H
EQPC_G
EQPC_I
EQPIMP_T
EQPIMP_MOD
EQSCLFD_H
EQSCLFD_G
EQSCLFD_I
EQPROW
EQPAASCHE
EQLASPEYRES
EQGDPCUR
EQGDPCONST
EQGDPDEF
EQOBJ
/
;

Model CGE_MCP
/
EQBAL.X_V
EQY.Y_V
EQINTU_T.INTER_USE_T_V
EQINTU_D.INTER_USE_D_V
EQINTU_M.INTER_USE_M_V
EQVA.VA_V
EQKL.KL_V
EQCONS_H_T.CONS_H_T_V
EQCONS_H_D.CONS_H_D_V
EQCONS_H_M.CONS_H_M_V
EQCONS_G_T.CONS_G_T_V
EQCONS_G_D.CONS_G_D_V
EQCONS_G_M.CONS_G_M_V
EQGFCF_T.GFCF_T_V
EQGFCF_D.GFCF_D_V
EQGFCF_M.GFCF_M_V
EQSV.SV_V
EQIMP_T.IMPORT_T_V
EQIMP_MOD.IMPORT_MOD_V
EQIMP_ROW.IMPORT_ROW_V
EQTRADE.TRADE_V
EQEXP.EXPORT_ROW_V
EQFACREV.FACREV_V
EQTSPREV.TSPREV_V
EQNTPREV.NTPREV_V
EQTIMREV.TIMREV_V
EQGRINC_H.GRINC_H_V
EQGRINC_G.GRINC_G_V
EQGRINC_I.GRINC_I_V
EQCBUD_H.CBUD_H_V
EQCBUD_G.CBUD_G_V
EQCBUD_I.CBUD_I_V
EQPY.PY_V
EQP.P_V
EQPKL.PKL_V
EQPVA.PVA_V
EQPIU.PIU_V
EQPC_H.PC_H_V
EQPC_G.PC_G_V
EQPC_I.PC_I_V
EQPIMP_T.PIMP_T_V
EQPIMP_MOD.PIMP_MOD_V
EQSCLFD_H.SCLFD_H_V
EQSCLFD_G.SCLFD_G_V
EQSCLFD_I.SCLFD_I_V
EQPROW.PROW_V
EQPAASCHE.PAASCHE_V
EQLASPEYRES.LASPEYRES_V
EQGDPCUR.GDPCUR_V
EQGDPCONST.GDPCONST_V
EQGDPDEF.GDPDEF_V
/
;
