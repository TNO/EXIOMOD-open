

KLS_V.FX('EU27','COE')                 = 1.1 * KLS('EU27','COE')                      ;


*Option iterlim = 0 ;
Option iterlim = 20000000 ;
*Option nlp = pathnlp ;
*Option cns = path ;
Option decimals = 7 ;
*CGE_MCP.optfile = 1 ;
*CGE_TRICK.optfile = 1 ;
*option nlp=gamschk ;
option nlp = conopt3 ;
CGE_TRICK.scaleopt = 1 ;
CGE_MCP.scaleopt = 1 ;


*Solve CGE_TRICK using nlp maximizing obj ;
*Solve CGE_TRICK using cns
Solve CGE_MCP using mcp ;

Parameter
Y_change(reg,ind)
X_change(reg,prd)
;

Y_change(reg,ind) = Y_V.L(reg,ind) / Y(reg,ind) ;
X_change(reg,prd) = X_V.L(reg,prd) / X(reg,prd) ;

Display Y_change, X_change ;

Parameter
VA_check(reg,ind)
VA_check_CES(reg,ind)
;

VA_check(reg,ind) = facA_V.L(reg,ind) * prod((regg,kl), KL_V.L(regg,kl,reg,ind)**facC_V.L(reg,kl,regg,ind) )
                     / VA_V.L(reg,ind) ;

VA_check_CES(reg,ind) = ( sum((regg,kl)$facC_V.L(regg,kl,reg,ind), facC_V.L(regg,kl,reg,ind)**( 1 / elas(reg,ind) ) *
                                         KL_V.L(regg,kl,reg,ind)**( ( elas(reg,ind) - 1 ) / elas(reg,ind) ) ) )**( elas(reg,ind) / ( elas(reg,ind) - 1 ) )
                     / VA_V.L(reg,ind) ;

Display VA_check, VA_check_CES, KL_V.L, VA_V.L, facA_V.L, facC_V.L ;

Parameter
CBUD_check(reg,fd)
;

CBUD_check(reg,fd) = sum((regg,prd), FINAL_USE_V.L(regg,prd,reg,fd) * P_V.L(regg,prd) *
                                    ( 1 + tc_fd_V.L(regg,prd,reg,fd) ) )
                     / CBUD_V.L(reg,fd) ;

Display CBUD_check ;

Parameter numer_check(reg,ind)
;

numer_check(reg,ind) =  Y_V.L(reg,ind) * PY_V.L(reg,ind) *
        ( 1 - sum((regg,ntp), txd_ind_V.L(regg,ntp,reg,ind) ) ) / (
        sum((regg,prd), INTER_USE_V.L(regg,prd,reg,ind) * P_V.L(regg,prd) *
        ( 1 + tc_ind_V.L(regg,prd,reg,ind) ) ) +
        sum((regg,kl), KL_V.L(regg,kl,reg,ind) * PKL_V.L(regg,kl) )  ) ;

Display numer_check ;
