#!/usr/local/bin/perl

###############################################################################
#
# File:   documentation/gamsdocs.pl
# Author: Jelmer Ypma
# Date:   5 June 2014
#
# This script takes a .gms file as input on the command line and automatically
# creates documentation from the .gms file. The files that are included in the
# .gms file are recursively read and included in the final documentation.
# Markdown can be used to format the documentation.
# 
# Documentation that should be included in the output can be commented in two
# ways in GAMS. All lines starting with *' are included in the documentation.
# All lines between $ontext startdoc and $offtext are also included.
#
# Examples:
# *' This comment is included in the documentation.
# * This comment is not included in the documentation.
#
# $ontext startdoc
# This comment-block is included in the documentation.
# $offtext
#
# $ontext
# This comment-block is not included in the documentation.
# $offtext
#
# In addition to copying the marked comments from the input file (and the
# .gms files included from there), a calling tree is shown with all the 
# .gms files, and the values for all global variables are shown in a table.
#
# This .pl script can be compiled into an executable with PAR::Packer, using
#   pp -o gamsdocs.exe gamsdocs.pl
#
# There are two ways to run the program, depending on whether perl is installed.
#
# Run from the command line (if perl is installed):
#       perl documentation/gamsdocs.pl main.gms
#
# Run from the command line (without perl installed):
#       gamsdocs.exe main.gms
#
# TODO: Any code between $ontext and $offtext is currently read, such as 
#       $include statements. This code should ofcourse not be included.
#
###############################################################################

##
#
# Sub-routine to remove returns (\r\n) from a string.
#
# Input: string
#
# Output: string with returns removed.
#
##
sub clean {

    my $text = shift;

    $text =~ s/\n//g;
    $text =~ s/\r//g;

    return $text;
}

# http://johnmacfarlane.net/pandoc/demo/example9/pandocs-markdown.html#header-identifiers-in-html-latex-and-context
sub makeMarkdownReference {
    
    my $text = shift;
    
    # Convert to lowercase.
    $text = lc $text;
    
    # Remove backward slashes and forward slashes in separate statements.
    $text =~ s/\\//g;
    $text =~ s/\///g;
    
    # Replace space by hyphen.
    $text =~ s/ /-/g;
    
    # Add -index to the end (as we add a link to the index automatically).
    $text = $text . "-index";
    
    # Return result.
    return $text;
}

sub getFileExtension {
    my $infile = shift;
    
    my ($extension) = $infile =~ /((\.[^.\s]+)+)$/;
    
    return $extension;
}

sub replaceGlobals {
    # Parse input arguments.
    my ( $infile, @globalslist ) = @_;
    
    # Only do replacement if a % sign occurs in the filename.
    if ( index( $infile, "%" ) != -1 ) {
        # Replace global variable by value.
        # A global variable in GAMS is surrounded by %var_name%.
        for (my $i=0; $i < scalar (@globalslist); $i++) {
            $infile =~ s/%$globalslist[$i]{'variable'}%/$globalslist[$i]{'value'}/gi;
        }
    }
    
    # Return new filename.
    return $infile;
}

sub getglobals {
    # Rename first argument passed to function.
    # The arrays calltree and globalslist are passed as reference.
    my ( $infile, $calltree, $globalslist ) = @_;

    # Add current file to the call tree.
    push( @$calltree, $infile );
    
    # Nested list in markdown are indented by four spaces.
    if ( getFileExtension( $infile ) eq ".gms" ) {
        # Add link for .gms files.
        print ("    " x (scalar(@$calltree)-1) );
        print "* [`" . $infile . "`](#" . makeMarkdownReference( $infile ) . ")\n";
    } else {
        # Currently, do not show non .gms files.
        # Add non .gms files without link.
        # print ("    " x (scalar(@$calltree)-1) );
        # print "* `" . $infile . "`\n";
    }
    
    # Open file and read lines.
    open( my $infile_fh, "<", $infile ) || die "Can't open $infile: $!";
    while (my $line = <$infile_fh>) {
        
        if ( substr($line, 0, 1) eq "*" ) {
            # Skip line starting with comment.
        } elsif ( index($line, "\$setglobal") != -1 ) {
            
            my @elements = split( ' ', $line );
            my $idx;
            foreach my $i (0..$#elements) {
                if ( $elements[$i] eq "\$setglobal") {
                    $idx = $i;
                    last;
                }
            }
            push( @$globalslist, { 
                "variable" => $elements[$idx+1],
                "value"    => $elements[$idx+2],
                "fromfile" => $infile
            } );
            
        } elsif ( index($line, "\$include") != -1 ) {
            my($first, $subfile) = split(/ /, $line, 2);
            $subfile = clean( $subfile );
            
            $subfile_new = replaceGlobals( $subfile, @$globalslist );
            @globalslist = getglobals( $subfile_new, $calltree, $globalslist );
        } else {
            # Do nothing.
        }
    }
    close $infile_fh;
    
    # Remove current file from calltree, as we are moving back up the tree.
    # Since we pass the reference to the call tree, all function calls use
    # the same tree. This makes it required to remove the last element.
    pop( @$calltree );
    
    return @$globalslist;
}

sub parsefile {
    # Rename first argument passed to function.
    # The arrays calltree and globalslist are passed as reference.
    my ( $infile, $message, $calltree, $globalslist ) = @_;
       
    print "\n## " . $infile . " ([index](#file-loading-structure))\n\n";
    
    # Add current file (including markup) to the call tree.
    push( @$calltree, "`" . $infile . "`" . $message );
    
    # Nested list in markdown are indented by four spaces.
    foreach my $i (1..scalar(@$calltree)) {
        print ( "    " x ($i-1) );
        print "* " . $calltree->[$i-1] . "\n";
    }
    print "\n";
    
    # Open file and read lines.
    open( my $infile_fh, "<", $infile ) || die "Can't open $infile: $!";
    
    my $startdoc = 0;       # Start with startdoc = FALSE.
    
    # Loop over lines in file.
    while (my $line = <$infile_fh>) {
        
        # Check for comment character as first character.
        if ( $startdoc eq 1 ) {
            if ( $line =~ m/^\$offtext/ ) {
                # Set startdoc to FALSE as the documentation ended.
                $startdoc = 0;
            } else {
                print $line;
            }
        } else {
            if ( $line =~ m/^\$ontext startdoc/ ) {
                # Set startdoc flag to TRUE. All the following text will be printed until a line starting with $offtext is found.
                $startdoc = 1;
            }
            if ( substr($line, 0, 1) eq "*" ) {
                if ( substr($line, 0, 2) eq "*'" ) {
                    print substr($line, 2);
                }
            } elsif ( index($line, "\$include") != -1 ) {
                my($first, $subfile) = split(/ /, $line, 2);
                $subfile = clean( $subfile );
                
                $subfile_new = replaceGlobals( $subfile, @globalslist );
                if ( $subfile_new ne $subfile ) {
                    # Currently this text appears at the wrong place (just before the section it belongs to. So we should pass this as an additional argument to parsefile and let parsefile print the text after the initial section.
                    #print "This file was included from GAMS as `" . $subfile . "`. With the current values of the [global variables](#values-of-global-variables) this has been replaced by `" . $subfile_new . "`\n";
                    $message = " (included from GAMS as `" . $subfile . "`)"; 
                } else {
                    $message = "";
                    #print "\nfound include: " . $subfile_new . "\n";
                }
                if ( getFileExtension( $subfile_new ) eq ".gms" ) {
                    parsefile( $subfile_new, $message, $calltree, $globalslist );
                }
            } else {
                # print "Do nothing: " . $line;
            }
        }
    }
    close $infile_fh;

    # Remove current file from calltree, as we are moving back up the tree.
    # Since we pass the reference to the call tree, all function calls use
    # the same tree. This makes it required to remove the last element.
    pop( @$calltree );
        
}

##
#
# Determine last time the file with perl code was modified.
# If the .exe file was create before that, we need to re-compile the perl script into an executable.
#
##
use Time::localtime;    # USES ctime.
use File::stat;         # USES stat.

# Get the name of the script.
my $scriptname = $0;

# Create a string with the filename without extension.
my $withoutext = $scriptname;
$withoutext =~ s{\.[^.]+$}{}; # Removes extension.

# Create string with the filename with .pl extension and .exe extension.
$scriptname_exe = $withoutext . ".exe";
$scriptname_pl  = $withoutext . ".pl";

if ( stat($scriptname_exe)->mtime <  stat($scriptname_pl)->mtime ) {
    print "Error: perl script was modified at a later time than the executable was created.\n\n";
    print "Last modification time for executable:  " . $scriptname_exe . ": " . ctime( stat($scriptname_exe)->mtime ) . "\n";
    print "Last modification time for perl script: " . $scriptname_pl . ": " . ctime( stat($scriptname_pl)->mtime ) . "\n\n";
    print "Please re-compile the executable using:\n";
    print "   pp -o gamsdocs.exe gamsdocs.pl\n";
    exit;
}

##
#
# Read command line parameters.
#
##

# Determine total number of arguments passed to this script.
my $nargs = $#ARGV + 1;
if ($nargs < 1 ) {
	print "Error: Please provide .gms file as input.\n";
	exit;
}
if ($nargs > 1 ) {
    print "Error: More than one input argument found. Please provide a .gms file as input only.\n";
    exit;
}

# Read input file from command line.
$mainfile = @ARGV[0];

##
#
# Start writing documentation.
#
##

my @globalslist;
my @calltree;

# Title.
print "# Documentation of " . $mainfile . "\n\n";

# Print file loading structure and get value of global variables.
print "## File loading structure\n\n";

@globalslist = getglobals( $mainfile,  \@calltree, \@globalslist );

# Print table with values of global variables.
print "\n## Values of global variables\n\n";
print "Global        | Value         | Defined in file\n";
print "------------- |:------------- |:---------------\n";
for (my $i=0; $i < scalar (@globalslist); $i++) {
    print "`" . $globalslist[$i]{'variable'} . "` | `" . $globalslist[$i]{'value'} . "` | [`" . $globalslist[$i]{'fromfile'} . "`](#" . makeMarkdownReference( $globalslist[$i]{'fromfile'} ) . ")\n";
}
print "\n";

parsefile( $mainfile, "", \@calltree, \@globalslist );
