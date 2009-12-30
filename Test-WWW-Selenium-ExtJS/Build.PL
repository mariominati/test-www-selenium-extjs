use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::WWW::Selenium::ExtJS',
    license             => 'perl',
    dist_author         => 'Mario Minati <mario.minati@minati.de>',
    dist_version_from   => 'lib/Test/WWW/Selenium/ExtJS.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Test-WWW-Selenium-ExtJS-*' ],
);

$builder->create_build_script();
