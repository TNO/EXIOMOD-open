

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


*Solve CGE_TRICK using nlp maximizing obj;
*Solve CGE_TRICK using cns ;
Solve CGE_MCP using MCP ;

Parameter
Y_change(regg,ind)
X_change(reg,prd)
;

Y_change(regg,ind) = Y_V.L(regg,ind) / Y(regg,ind) ;
X_change(reg,prd)  = X_V.L(reg,prd) / X(reg,prd) ;

Display Y_change, X_change ;

Parameter
VA_check(regg,ind)
VA_check_CES(regg,ind)
;

VA_check(regg,ind) = facA(regg,ind) * prod((reg,kl), KL_V.L(reg,kl,regg,ind)**facC(reg,kl,regg,ind) )
                     / VA_V.L(regg,ind) ;

VA_check_CES(regg,ind) = ( sum((reg,kl)$facC(reg,kl,regg,ind), facC(reg,kl,regg,ind)**( 1 / elasKL(regg,ind) ) *
                                         KL_V.L(reg,kl,regg,ind)**( ( elasKL(regg,ind) - 1 ) / elasKL(regg,ind) ) ) )**( elasKL(regg,ind) / ( elasKL(regg,ind) - 1 ) )
                     / VA_V.L(regg,ind) ;

Display VA_check, VA_check_CES, KL_V.L, VA_V.L, facA, facC ;

Parameter
CBUD_check(regg,fd)
;

CBUD_check(regg,fd) = sum((reg,prd), FINAL_USE_V.L(reg,prd,regg,fd) * P_V.L(reg,prd) *
                                    ( 1 + tc_fd(prd,regg,fd) ) )
                     / CBUD_V.L(regg,fd) ;

Display CBUD_check ;

Parameter numer_check(regg,ind)
;

numer_check(regg,ind) =  Y_V.L(regg,ind) * PY_V.L(regg,ind) *
        ( 1 - sum((reg,ntp), txd_ind(reg,ntp,regg,ind) ) ) / (
        sum((reg,prd), INTER_USE_V.L(reg,prd,regg,ind) * P_V.L(reg,prd) *
        ( 1 + tc_ind(prd,regg,ind) ) ) +
        sum((reg,kl), KL_V.L(reg,kl,regg,ind) * PKL_V.L(reg,kl) )  ) ;

Display numer_check ;
