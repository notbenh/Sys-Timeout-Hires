#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Sys::Timeout::HiRes' ) || print "Bail out!
";
}

diag( "Testing Sys::Timeout::HiRes $Sys::Timeout::HiRes::VERSION, Perl $], $^X" );
