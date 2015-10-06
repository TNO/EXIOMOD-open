* ==============================================================================
*
* File:   compare_data.gms
* Author: Jelmer Ypma
* Date:   27/08/2014
*
* This script compares values of two variables defined over the same sets and
* returns a parameter that contains the differences, for those values where the
* relative difference is larger than display_tolerance. The return value is also
* displayed.
*
* Input parameters:
*   output_data        Name of output parameter that will contain the result of
*                      this script (a comparison of the values in the two
*                      variables).
*   first_data         Parameter corresponding to first variable.
*   second_data        Parameter corresponding to second variable.
*   idx                indices for first_data and second_data.
*   display_tolerance  relative difference used as cutoff whether to display
*                      values or not.
*
* The indices can contain multiple dimensions, separate by a comma. No spaces
* can be used inside the definition of a multi-dimensional index.
*
* Example:
*    $batinclude compare_data output_data first_data second_data idx display_tolerance
* ==============================================================================

$setargs output_data first_data second_data idx display_tolerance *
Display "==============================="
Display "compare_data input parameters:"
Display "  output_data :       %output_data%"
Display "  first_data :        %first_data%"
Display "  second_data :       %second_data%"
Display "  idx :               %idx%"
Display "  display_tolerance : %display_tolerance%"

Parameters
  %output_data%(%idx%,*)
;

%output_data%(%idx%,'ratio')$(
    %second_data%(%idx%) and
    abs( %first_data%(%idx%) / %second_data%(%idx%) - 1 ) ge %display_tolerance% ) =
  %first_data%(%idx%) / %second_data%(%idx%) ;

%output_data%(%idx%,'difference')$(
    %second_data%(%idx%) and
    abs( %first_data%(%idx%) / %second_data%(%idx%) - 1 ) ge %display_tolerance% ) =
  %first_data%(%idx%) - %second_data%(%idx%) ;

%output_data%(%idx%,'%second_data%')$(
    %second_data%(%idx%) and
    abs( %first_data%(%idx%) / %second_data%(%idx%) - 1 ) ge %display_tolerance% ) =
  %second_data%(%idx%) ;

%output_data%(%idx%,'%first_data%')$(
    %second_data%(%idx%) and
    abs( %first_data%(%idx%) / %second_data%(%idx%) - 1 ) ge %display_tolerance% ) =
  %first_data%(%idx%) ;

* Take special care when old data = 0, and old and new data are not equal.
%output_data%(%idx%,'ratio')$(
    not %second_data%(%idx%) and
    %second_data%(%idx%) ne %first_data%(%idx%) ) =
  NA ;

%output_data%(%idx%,'difference')$(
    not %second_data%(%idx%) and
    %second_data%(%idx%) ne %first_data%(%idx%) ) =
  %first_data%(%idx%) - %second_data%(%idx%) ;

%output_data%(%idx%,'%second_data%')$(
    not %second_data%(%idx%) and
    %second_data%(%idx%) ne %first_data%(%idx%) ) =
  %second_data%(%idx%) ;

%output_data%(%idx%,'%first_data%')$(
    not %second_data%(%idx%) and
    %second_data%(%idx%) ne %first_data%(%idx%) ) =
  %first_data%(%idx%) ;

Display
  %output_data%
;
