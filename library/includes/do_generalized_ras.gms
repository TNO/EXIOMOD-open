* ==============================================================================
*
* File:   do_generalized_ras.gms
* Author: Jelmer Ypma
* Date:   27/08/2014
*
* This script performas a generalized RAS procedure to balance an IO table and
* returns the balanced output in new parameters.
*
* Input parameters:
*   II_new            Name of new parameter containing intermediate input block (result after balancing).
*   FD_new            Name of new parameter containing final demand block (result after balancing).
*   VA_new            Name of new parameter containing value added block (result after balancing).
*   II_block          Intermediate input block (from input data).
*   FD_block          Final demand block (from input data).
*   VA_block          Value added block (from input data).
*   TotalOutput_data  Total output is sum over columns and rows (see structure below).
*   TotalII_data      Sum over rows of intermediate input data (see structure below).
*   TotalFD_data      Sum over rows of final demand input data (see structure below).
*   ii_idx            indices for (rows and columns of) intermediate input block.
*   ii_idx_alias      alias indices for intermediate input block.
*   fd_idx            indices for (columns of) final demand block.
*   va_idx            indices for (rows of) value added block.
*
* This script is an adapted version of:
*   http://yetanothermathprogrammingconsultant.blogspot.nl/2013/06/gras-generalized-ras-example.html
*
* Generalized RAS method
*
* THEO JUNIUS & JAN OOSTERHAVEN
* The Solution of Updating or Regionalizing a Matrix
* with both Positive and Negative Entries
* Economic Systems Research, Vol. 15, No. 1, 2003
*
* Lenzen, M., Wood, R. and Gallego, B. (2007)
* Some comments on the GRAS method,
* Economic Systems Research, 19, pp. 461–465
*
* Structure of input-output table
*                (regg,secc)                (regg,fd)
* (reg,sec)      Intermediate inputs        Final demand          Total output
*                Total intermediate inputs  Total final demand
* (factors)      Value-added block
*                Total output
*
* 1. Sum over regg,secc of intermediate inputs + sum over regg,fd of final demand
*    should equal total output (sum_over_cols).
* 2. Sum over reg,sec of intermediate inputs + sum over factors should equal
*    total output (sum_over_rows).
* 3. Sum over reg,sec of intermediate inputs should equal total intermediate
*    inputs (sum_ii_over_rows).
* 4. Sum over reg,sec of final demand should equal total final demand
*    (sum_fd_over_rows).
* ;
*
* Example:
*    $batinclude do_generalized_ras II_new FD_new VA_new II_block FD_block VA_block TotalOutput_data TotalII_data TotalFD_data reg,sec regg,secc regg,fd factors
* ==============================================================================

$setargs II_new FD_new VA_new II_data FD_data VA_data TotalOutput_data TotalII_data TotalFD_data ii_idx ii_idx_alias fd_idx va_idx *
Display "==============================="
Display "do_generalized_ras input parameters:"
Display "  II_new :           %II_new%"
Display "  FD_new :           %FD_new%"
Display "  VA_new :           %VA_new%"
Display "  II_data :          %II_data%"
Display "  FD_data :          %FD_data%"
Display "  VA_data :          %VA_data%"
Display "  TotalOutput_data : %TotalOutput_data%"
Display "  TotalII_data :     %TotalII_data%"
Display "  TotalFD_data :     %TotalFD_data%"
Display "  ii_idx :           %ii_idx%"
Display "  ii_idx_alias :     %ii_idx_alias%"
Display "  fd_idx :           %fd_idx%"
Display "  va_idx :           %va_idx%"

Parameters
   e       '1 or exp(1) depending on paper'
;
* Junius/Oosterhaven:
* e = 1;
* Lenzen,e.a.:
e = exp(1);
* e = exp(1) gives the best scaling in my experience.

* x is new value, a is old value.
* note: z(i,j)=x(i,j)/a(i,j)
Variables
  tmp_gras_II_z(%ii_idx%,%ii_idx_alias%)
  tmp_gras_VA_z(%va_idx%,%ii_idx_alias%)
  tmp_gras_FD_z(%ii_idx%,%fd_idx%)
  tmp_gras_obj
;

Equations
  tmp_gras_objective
  tmp_gras_sum_over_cols(%ii_idx%)
  tmp_gras_sum_over_rows(%ii_idx%)
  tmp_gras_sum_ii_over_rows(%ii_idx%)
  tmp_gras_sum_fd_over_rows(%fd_idx%)
;

tmp_gras_objective.. tmp_gras_obj =e=
  sum( (%ii_idx%,%ii_idx_alias%),
       abs( %II_data%(%ii_idx%,%ii_idx_alias%) ) * tmp_gras_II_z(%ii_idx%,%ii_idx_alias%) * log(tmp_gras_II_z(%ii_idx%,%ii_idx_alias%) / e) ) +
  sum( (%va_idx%,%ii_idx_alias%),
       abs( %VA_data%(%va_idx%,%ii_idx_alias%) ) * tmp_gras_VA_z(%va_idx%,%ii_idx_alias%) * log(tmp_gras_VA_z(%va_idx%,%ii_idx_alias%) / e) ) +
  sum( (%ii_idx%,%fd_idx%),
       abs( %FD_data%(%ii_idx%,%fd_idx%) ) * tmp_gras_FD_z(%ii_idx%,%fd_idx%) * log(tmp_gras_FD_z(%ii_idx%,%fd_idx%) / e) )
;

tmp_gras_sum_over_cols(%ii_idx%)..
  sum((%ii_idx_alias%),  tmp_gras_II_z(%ii_idx%,%ii_idx_alias%) * %II_data%(%ii_idx%,%ii_idx_alias%)) +
  sum((%fd_idx%),        tmp_gras_FD_z(%ii_idx%,%fd_idx%) * %FD_data%(%ii_idx%,%fd_idx%))
  =e=
  %TotalOutput_data%(%ii_idx%) ;

tmp_gras_sum_over_rows(%ii_idx%)..
  sum((%ii_idx_alias%),  tmp_gras_II_z(%ii_idx_alias%,%ii_idx%) * %II_data%(%ii_idx_alias%,%ii_idx%)) +
  sum((%va_idx%),        tmp_gras_VA_z(%va_idx%,%ii_idx%) * %VA_data%(%va_idx%,%ii_idx%))
  =e=
  %TotalOutput_data%(%ii_idx%) ;

tmp_gras_sum_ii_over_rows(%ii_idx%)..
  sum((%ii_idx_alias%),  tmp_gras_II_z(%ii_idx_alias%,%ii_idx%) * %II_data%(%ii_idx_alias%,%ii_idx%))
  =e=
  %TotalII_data%(%ii_idx%) ;

tmp_gras_sum_fd_over_rows(%fd_idx%)..
  sum((%ii_idx%),  tmp_gras_FD_z(%ii_idx%,%fd_idx%) * %FD_data%(%ii_idx%,%fd_idx%))
  =e=
  %TotalFD_data%(%fd_idx%) ;

**
*
* Define initial values and lower bounds.
*
**
tmp_gras_II_z.L(%ii_idx%,%ii_idx_alias%)  = 1 ;
tmp_gras_VA_z.L(%va_idx%,%ii_idx_alias%)  = 1 ;
tmp_gras_FD_z.L(%ii_idx%,%fd_idx%)        = 1 ;

tmp_gras_II_z.LO(%ii_idx%,%ii_idx_alias%) = 0.0001 ;
tmp_gras_VA_z.LO(%va_idx%,%ii_idx_alias%) = 0.0001 ;
tmp_gras_FD_z.LO(%ii_idx%,%fd_idx%)       = 0.0001 ;

**
*
* Define model and solve optimization problem.
*
**
model tmp_gras_m /
  tmp_gras_objective
  tmp_gras_sum_over_cols
  tmp_gras_sum_over_rows
  tmp_gras_sum_ii_over_rows
  tmp_gras_sum_fd_over_rows
/;
solve tmp_gras_m using nlp minimizing tmp_gras_obj;

**
*
* Calculate new levels from fractions.
*
**
Parameters
  %II_new% (%ii_idx%,%ii_idx_alias%)
  %VA_new% (%va_idx%,%ii_idx_alias%)
  %FD_new% (%ii_idx%,%fd_idx%)
;

%II_new%(%ii_idx%,%ii_idx_alias%) =
  tmp_gras_II_z.L(%ii_idx%,%ii_idx_alias%) * %II_data%(%ii_idx%,%ii_idx_alias%) ;

%VA_new%(%va_idx%,%ii_idx_alias%) =
  tmp_gras_VA_z.L(%va_idx%,%ii_idx_alias%) * %VA_data%(%va_idx%,%ii_idx_alias%) ;

%FD_new%(%ii_idx%,%fd_idx%)       =
  tmp_gras_FD_z.L(%ii_idx%,%fd_idx%)       * %FD_data%(%ii_idx%,%fd_idx%) ;
