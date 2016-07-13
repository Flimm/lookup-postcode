#!perl -T
use 5.012;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Geo::LookupPostcode' ) || print "Bail out!\n";
}

diag( "Testing Geo::LookupPostcode $Geo::LookupPostcode::VERSION, Perl $], $^X" );
