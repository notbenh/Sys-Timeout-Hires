package Sys::Timeout::HiRes;
use warnings;
use strict;
use Time::HiRes qw{ualarm};
use Exporter::Declare; 

=head1 NAME

Sys::Timeout::HiRes - handy wrapper simplifying hires alarm timeout's

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Sys::Timeout::HiRes;

    timeout 0.10 { ... } or do { ... };

=head1 EXPORT


=head2 timeout 

Just enough abstraction around Time::HiRes's ualarm to make a nice clean syntax.

    use Sys::Timeout::HiRes;
    timeout $time { ... } or do { ... };

Much like the example timeout in L<http://perldoc.perl.org/functions/alarm.html> your codeblock
is wrapped as an eval, please take approperate lexiacl precautions.

NOTE: If $time <= 0 then your codeblock is never run and you jump right to your catch block.

=cut

export timeout sublike {
   my ($time, $code) = @_;
   return 0 unless $time > 0;
   
   eval {
      local $SIG{ALRM} = sub { die "alarm\n" }; # NB: \n required
      ualarm($time);
      &$code;
      ualarm(0);
   } or do {
      die unless $@ eq "alarm\n";   # propagate unexpected errors
      return 0; # timed out
   };

   return 1;
}


=head2 retry

Retry a block till it passes or count has been met.

    retry 5 { timeout 1 { $obj->long_call } } or do { $obj->error('system not available') };

=cut

export retry sublike {
   my ($times, $code) = @_;
   return 0 unless $times > 0;
   for( 1..$times ) {
      return 1 if &$code;
   }
   return 0;
}

=head1 AUTHOR

ben hengst, C<< <notbenh at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-sys-timeout-hires at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Sys-Timeout-HiRes>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Sys::Timeout::HiRes


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Sys-Timeout-HiRes>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Sys-Timeout-HiRes>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Sys-Timeout-HiRes>

=item * Search CPAN

L<http://search.cpan.org/dist/Sys-Timeout-HiRes/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 ben hengst.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Sys::Timeout::HiRes
