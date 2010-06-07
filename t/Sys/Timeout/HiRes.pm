package TEST::Sys::Timeout::HiRes;
use strict;
use warnings;
use Fennec;
use Carp::Always;

tests load {
   use_ok('Sys::Timeout::HiRes' );
   #can_ok('main', qw{ timeout retry } );
}

tests timeout {
   use Sys::Timeout::HiRes;

   # seems that fennec's ok really really really does not like this open syntax
   #ok(!timeout '0.1' { sleep(1) } , q{tripped timeout} );
   #ok( timeout '2.1' { sleep(1) } , q{passed timeout} );

   my $t = sub{ timeout shift { sleep(1) } };
   ok(!$t->(0.1),    q{tripped timeout} );
   ok(!$t->('m500'), q{tripped timeout} );
   ok(!$t->(2.1),    q{passed timeout}  );
   ok(!$t->('m5000000'),q{passed timeout}  );
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
