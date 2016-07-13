use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Geo::LookupPostcode',
    AUTHOR           => q{David D Lowe <daviddlowe.flimm@gmail.com>},
    VERSION_FROM     => 'lib/Geo/LookupPostcode.pm',
    ABSTRACT_FROM    => 'lib/Geo/LookupPostcode.pm',
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
    clean => { FILES => 'Geo-LookupPostcode-*' },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url => 'https://github.com/Flimm/lookup-postcode.git',
                web => 'https://github.com/Flimm/lookup-postcode',
            },
            bugtracker => {
                web => 'https://github.com/Flimm/lookup-postcode/issues',
            },
        },
    },
);
