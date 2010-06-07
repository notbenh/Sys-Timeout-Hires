package TEST::Sys::Timeout::HiRes;
use strict;
use warnings;
use Fennec;

tests load => sub {
    require_ok( 'Sys::Timeout::HiRes' );
};

1;
