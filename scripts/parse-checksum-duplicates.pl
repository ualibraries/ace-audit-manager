#!/usr/bin/perl

use strict;
use warnings;

my %fixity = ();
my $linenum = 0;
my $duplicates = 0;
my $duplicate_files = 0;
my $debug = 0;

binmode(STDOUT, ":utf8");

while (<>) {
    my @line = split( / \| / );

    next if (! defined( $line[2] ) );

    $linenum++;

    chomp( $line[2] );
    
    if ($debug) { print( "LINE $linenum: $line[0] = $line[2]\n" ); }
    
    my @new_list = ();
    my $file_list = \@new_list;

    if ( defined( $fixity{ $line[2] } ) ) {
        $file_list = $fixity{ $line[2] };
        my $list_size = 0 + @$file_list;

        if ($debug) { print("USING existing array for $line[2], size $list_size \n"); }
    }

    push( @$file_list, $line[0] );

    $fixity{ $line[2] } = $file_list;
}

foreach my $checksum( keys %fixity ) {
    my $files = $fixity{ $checksum };

    my $num_duplicates = 0 + @$files;
    
    if ( $num_duplicates > 1 ) {
        print( 'DUPLICATES[ '.$num_duplicates.' ] '.$checksum."\n   " );
        print join( "\n   ", @$files )."\n";
        $duplicates++;
        $duplicate_files += $num_duplicates - 1;
    }
}

print "\n";
print "DUPLICATES_FILES: $duplicate_files\n";
print "DUPLICATES_TOTAL: $duplicates\n";
