use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Lingua::HU::Numbers',
    AUTHOR              => 'Bálint Szilakszi <szbalint@cpan.org>',
    VERSION_FROM        => 'lib/Lingua/HU/Numbers.pm',
    ABSTRACT_FROM       => 'lib/Lingua/HU/Numbers.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Lingua-HU-Numbers-*' },
);
