package TEST::Sys::Timeout::HiRes;
use strict;
use warnings;
use Fennec;

tests load {
   use_ok('Sys::Timeout::HiRes' );
   #can_ok('main', qw{ timeout retry } );
}

tests timeout {
   use Sys::Timeout::HiRes;
   ok (!timeout 1 { sleep(2) }, q{timeout yanks a sleep process correctly });
   ok (!timeout 2 { sleep(1) }, q{timeout does not yank this one });
}

tests retry {
   use Sys::Timeout::HiRes;
   ok( retry 2 {1}, q{retry passes} );
   ok(!retry 2 {0}, q{retru cought} );

   my $i = 0;
   # single cycle 
   ok( retry 10 { $i++; 1; }, q{run test} ); # block returns true, no need to retry
   is( $i , 1, q{corect number of runs} );
   
   $i = 0;
   ok(!retry 10 { $i++; 0; }, q{run test} ); # block returns false, hit every cycle
   is( $i , 10, q{corect number of runs} );
}


1;
