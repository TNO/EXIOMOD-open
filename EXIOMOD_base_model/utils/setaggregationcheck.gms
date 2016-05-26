
* adopted from http://blog.modelworks.ch/?p=265

$ontext
Snippet to check aggregation scheme between two sets.

Use: $BATINCLUDE path/setaggregationcheck origset aggrset map

Where:
    'path' - directory where the snippet is located
    'origset' - set with original with a long list of elements
    'aggrset' - aggregated set
    'map' - multi-dimensional describing relation between 'origset' and
        'aggrset'

The snippet will give an exit with an error in cases:
    an element of 'origset' is not referenced in 'map'
    an element of 'aggrset' is not referenced in 'map'
    'map' allows 1:m or m:m relations
$offtext

$setargs origset aggrset map

SETS
         error1  First index missing error
         error2  Second index missing or twice error
;

* Check first index
$macro errorFirstDim_%map%(%origset%,%aggrset%,%map%)     YES$(SUM(%aggrset%, 1$%map%(%origset%,%aggrset%)) ne 1) ;

error1(%origset%) = errorFirstDim_%map%(%origset%,%aggrset%,%map%) ;

ABORT$CARD(error1)
    "Inconsistent %map% first index! missing or multiple elements:", error1 ;

* Check second index
$macro errorSecondDim_%map%(%origset%,%aggrset%,%map%)    YES$(SUM(%origset%, 1$%map%(%origset%,%aggrset%)) eq 0) ;

error2(%aggrset%) = errorSecondDim_%map%(%origset%,%aggrset%,%map%)

ABORT$CARD(error2)
    "Inconsistent %map% second index! missing or multiple elements:", error2 ;
