use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Test::WWW::Selenium::ExtJS',
    AUTHOR              => 'Mario Minati <mario.minati@minati.de>',
    VERSION_FROM        => 'lib/Test/WWW/Selenium/ExtJS.pm',
    ABSTRACT_FROM       => 'lib/Test/WWW/Selenium/ExtJS.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'    => 0,
        'version'       => 0,
        'Readonly'      => 0,
        'Time::HiRes'   => 0,
        'WWW::Selenium' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Test-WWW-Selenium-ExtJS-*' },
);
