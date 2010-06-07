use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Sys::Timeout::HiRes',
    license             => 'perl',
    dist_author         => q{ben hengst <notbenh@cpan.org>},
    dist_version_from   => 'lib/Sys/Timeout/HiRes.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Sys-Timeout-HiRes-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
