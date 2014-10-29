* ==============================================================================
*
* File:   compare_data.gms
* Author: Jelmer Ypma
* Date:   27/08/2014
*
* This script compares two variables of new and old data and returns a parameter
* that contains the differences, for those values where the relative difference
* is larger than display_tolerance. The return value is also displayed.
*
* Input parameters:
*   output_data        Name of output parameter that will contain the result of
*                      this script (a comparison of the values in the old and
*                      new data).
*   new_data           Parameter corresponding to new data.
*   old_data           Parameter corresponding to old data.
*   idx                indices for new_data and old_data.
*   display_tolerance  relative difference used as cutoff whether to display
*                      values or not.
*
* The indices can contain multiple dimensions, separate by a comma. No spaces
* can be used inside the definition of a multi-dimensional index.
*
* Example:
*    $batinclude compare_data output_data new_data old_data idx display_tolerance
* ==============================================================================

$setargs output_data new_data old_data idx display_tolerance *
Display "==============================="
Display "compare_data input parameters:"
Display "  output_data :       %output_data%"
Display "  new_data :          %new_data%"
Display "  old_data :          %old_data%"
Display "  idx:                %idx%"
Display "  display_tolerance : %display_tolerance%"

Parameters
  %output_data%(%idx%,*)
;

%output_data%(%idx%,'perc')$(
    %old_data%(%idx%) and
    abs( %new_data%(%idx%) / %old_data%(%idx%) - 1 ) ge %display_tolerance% ) =
  %new_data%(%idx%) / %old_data%(%idx%) ;

%output_data%(%idx%,'old')$(
    %old_data%(%idx%) and
    abs( %new_data%(%idx%) / %old_data%(%idx%) - 1 ) ge %display_tolerance% ) =
  %old_data%(%idx%) ;

%output_data%(%idx%,'new')$(
    %old_data%(%idx%) and
    abs( %new_data%(%idx%) / %old_data%(%idx%) - 1 ) ge %display_tolerance% ) =
  %new_data%(%idx%) ;

%output_data%(%idx%,'absolute')$(
    %old_data%(%idx%) and
    abs( %new_data%(%idx%) / %old_data%(%idx%) - 1 ) ge %display_tolerance% ) =
  %new_data%(%idx%) - %old_data%(%idx%) ;

* Take special care when old data = 0, and old and new data are not equal.
%output_data%(%idx%,'perc')$(
    not %old_data%(%idx%) and
    %old_data%(%idx%) ne %new_data%(%idx%) ) =
  NA ;

%output_data%(%idx%,'old')$(
    not %old_data%(%idx%) and
    %old_data%(%idx%) ne %new_data%(%idx%) ) =
  %old_data%(%idx%) ;

%output_data%(%idx%,'new')$(
    not %old_data%(%idx%) and
    %old_data%(%idx%) ne %new_data%(%idx%) ) =
  %new_data%(%idx%) ;

%output_data%(%idx%,'absolute')$(
    not %old_data%(%idx%) and
    %old_data%(%idx%) ne %new_data%(%idx%) ) =
  %new_data%(%idx%) - %old_data%(%idx%) ;

Display
  %output_data%
;
