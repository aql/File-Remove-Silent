use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'File::Remove::Silent',
    AUTHOR              => 'TOYODA Tetsuya <cpan@hikoboshi.org>',
    VERSION_FROM        => 'lib/File/Remove/Silent.pm',
    ABSTRACT_FROM       => 'lib/File/Remove/Silent.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'File-Remove-Silent-*' },
);
