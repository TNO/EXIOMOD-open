$title  Run a Systematic Sensitivity Analysis

set dummy   /0*2000/;

*       ------------------------------------------------------------------------------
*       Model-Specific Parameters are here:  need to declare the set of inputs
*   and the set of values for each.

$set model  FILENAME.gms

$set inputs INPUT1,INPUT2
sets
    INPUT1 /'0.0','0.03'/
    INPUT2 /'0.0','0.03'/ ;

*       ------------------------------------------------------------------------------
*   Generate the code required to output assignments for a specific run:

$onecho >ssagen.gms
set inputs /%inputs%/;
file kgen /'ssainputs.gen'/; put kgen; kgen.lw=0;
loop(inputs,
    put "' --",inputs.tl,"=',",inputs.tl,".tl";
    if (ord(inputs)<card(inputs),
      put ','/;
    else
      put "/;"
    );
);
$offecho
$call 'gams ssagen'

*   Generate code to count the number of scenarios to run:

$onecho >ssadef.gms
set inputs /%inputs%/;
file nsdef /'ssa_eval.gms'/; put nsdef; nsdef.lw=0;
put '$eval ns ';
loop(inputs,
    if (ord(inputs)<card(inputs),
      put 'card(',inputs.tl,')*';
    else
      put 'card(',inputs.tl,')';
    );
);
put /;
put '$setglobal ns %ns%'/;
$offecho
$call 'gams ssadef'
$include ssa_eval

*       ------------------------------------------------------------------------------
*   Number of scenarios in total:

set     scn     Enumeration of scenarios /1*%ns%/;

*   Association of scenario indices and input assumptions:

set     inputs(scn,%inputs%)  Scenario definitions;

*       Assign inputs to scenarios:

set     sc(scn)         Current scenario /1/;
loop((%inputs%),
        inputs(sc,%inputs%) = yes;
        sc(scn+1)$sc(scn) = yes;
        sc(scn)$sc(scn+1) = no;
);

*   Save this association for generating the pivot report:

execute_unload 'ssa.gdx', scn, inputs;

*       ------------------------------------------------------------------------------
*       Generic SSA Code:

*       Load Multiple Processors

parameter       nprocessor Default number of processors to load /4/;

*       Under NT we can use the environment variable to define
*       the number of processors to employ.  The environment
*       variable %NUMBER_OF_PROCESSORS% returns the number of
*       logical processors which is typical twice the number of
*       physical cores.

*       Comment out the next line if you want to fix the number of
*       processors:

*.$if %system.filesys% == MSNT  nprocessor = round(%sysenv.NUMBER_OF_PROCESSORS%/2);


file    kbat /runmodel.bat/; kbat.lw=0; put kbat;

parameter       processor       Processor count /0/;

put     '@echo off'/
        'if not exist lst\nul mkdir lst'/
        'if not exist gdx\nul mkdir gdx'//
        'if not "%','1"=="" goto processor%','1'//;
        for (processor=1 to nprocessor,
*.    put 'sleep 1'/;
          put 'start /HIGH runmodel ',processor:0:0/;
        );
        put 'goto :eof'/;

parameter       nscn    Scenario count;

processor = 0;
loop(scn,
  loop(inputs(scn,%inputs%),
          if (scn.val > (processor/nprocessor)*card(scn),
            if (processor>0,
              put 'title Processor ',processor:0:0,' (100%%)'/;
              put 'goto :eof'/;);
            processor = processor + 1;
            put //':processor',processor:0:0/;
            nscn = 0;
          );
          put 'title Processor ',processor:0:0,' (',
                round(100*nscn/(card(scn)/nprocessor)):0:0,'%%)'/;
$if set prelim %prelim%
          put 'gams %model%',
                ' o=lst\',scn.tl,'.lst',
                ' --gdx_path=gdx\',scn.tl,'.gdx',
$include ssainputs.gen

*       ------------------------------------------------------------------------------

          nscn = nscn + 1;
        );
);
put 'title Processor ',nprocessor:0:0,' (100%%)'/;

putclose;
