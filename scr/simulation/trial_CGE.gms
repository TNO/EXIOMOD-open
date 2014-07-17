

KLS_V.FX('EU27','COE')                 = 1.1 * KLS('EU27','COE')                      ;



*Option iterlim = 0 ;
*Option nlp = pathnlp ;
*Option cns = path ;
CGE_MCP.optfile = 1 ;

*Solve CGE using nlp maximizing obj ;
*Solve CGE_TRICK using cns
Solve CGE_MCP using mcp ;

