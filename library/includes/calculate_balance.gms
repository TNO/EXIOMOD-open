* ==============================================================================
*
* File:   calculate_balance.gms
* Author: Jelmer Ypma
* Date:   27/08/2014
*
* Calculate whether an IO table is balanced by summing the intermediate input
* block and the final demand block over the columns, and by summing the
* intermediate input block and the value added block over the rows.
*
* Input parameters:
*   SAM_balance    Name of output parameter that will contain the result of this
*                  script (a comparison between the row and column sums of the
*                  IO table).
*   II_block       Intermediate input block.
*   FD_block       Final demand block.
*   VA_block       Value added block.
*   ii_idx         indices for (rows and columns of) intermediate input block.
*   ii_idx_alias   alias indices for intermediate input block.
*   fd_idx         indices for (columns of) final demand block.
*   va_idx         indices for (rows of) value added block.
*
* The rows of the final demand block are indexed by ii_idx.
* The columns of the value added block are indexed by ii_idx_alias.
* The indices can contain multiple dimensions, separate by a comma. No spaces
* can be used inside the definition of a multi-dimensional index.
*
* Example:
*    $batinclude calculate_balance SAM_balance II_block FD_block VA_block ii_idx ii_idx_alias fd_idx va_idx
*    $batinclude calculate_balance SAM_balance II_block FD_block VA_block reg,sec regg,secc regg,fd factors
*
* In the second example the original file should contain parameters defined as
* Parameters
*   II_block(reg,sec,regg,secc)
*   FD_block(reg,sec,regg,fd)
*   VA_block(factors,regg,secc)
* ;
* ==============================================================================

$setargs SAM_balance II_block FD_block VA_block ii_idx ii_idx_alias fd_idx va_idx *
Display "==============================="
Display "check_balance input parameters:"
Display "  SAM_balance :  %SAM_balance%"
Display "  II_block :     %II_block%"
Display "  FD_block :     %FD_block%"
Display "  VA_block :     %VA_block%"
Display "  ii_idx :       %ii_idx%"
Display "  ii_idx_alias : %ii_idx_alias%"
Display "  fd_idx :       %fd_idx%"
Display "  va_idx :       %va_idx%"

Parameters
  %SAM_balance%(%ii_idx%,*)
;

* Empty parameters. If we do not do this, values may be left from previous runs.
%SAM_balance%(%ii_idx%,'sum_over_rows')     = 0 ;
%SAM_balance%(%ii_idx%,'sum_over_cols')     = 0 ;
%SAM_balance%(%ii_idx%,'absolute')          = 0 ;
%SAM_balance%(%ii_idx%,'rel_sum_over_rows') = 0 ;
%SAM_balance%(%ii_idx%,'rel_sum_over_cols') = 0 ;

* Sum intermediate inputs and factor inputs over all rows, given one column.
%SAM_balance%(%ii_idx%,'sum_over_rows') =
  sum((%ii_idx_alias%),  %II_block%(%ii_idx_alias%,%ii_idx%)) +
  sum((%va_idx%),        %VA_block%(%va_idx%,%ii_idx%))
;

* Sum intermediate inputs and final demand over all columns, given one row.
%SAM_balance%(%ii_idx%,'sum_over_cols' ) =
  sum((%ii_idx_alias%), %II_block%(%ii_idx%,%ii_idx_alias%)) +
  sum((%fd_idx%),       %FD_block%(%ii_idx%,%fd_idx%))
;

* Define balance as difference between sums over rows and columns.
%SAM_balance%(%ii_idx%,'absolute') =
  %SAM_balance%(%ii_idx%,'sum_over_rows') -
  %SAM_balance%(%ii_idx%,'sum_over_cols' )
;

* Calculate relative error.
%SAM_balance%(%ii_idx%,'rel_sum_over_rows')$( %SAM_balance%(%ii_idx%,'sum_over_rows') ) =
  %SAM_balance%(%ii_idx%,'absolute') / %SAM_balance%(%ii_idx%,'sum_over_rows')
;

%SAM_balance%(%ii_idx%,'rel_sum_over_cols')$( %SAM_balance%(%ii_idx%,'sum_over_cols') ) =
  %SAM_balance%(%ii_idx%,'absolute') / %SAM_balance%(%ii_idx%,'sum_over_cols')
;
