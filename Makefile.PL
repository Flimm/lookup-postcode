use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Geo::PostcodeToProvince',
    AUTHOR           => q{David D Lowe <daviddlowe.flimm@gmail.com>},
    VERSION_FROM     => 'lib/Geo/PostcodeToProvince.pm',
    ABSTRACT_FROM    => 'lib/Geo/PostcodeToProvince.pm',
    LICENSE          => 'unrestricted',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Geo-PostcodeToProvince-*' },
);
