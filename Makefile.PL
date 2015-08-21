use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'EBook::EPUB::Lite',
    AUTHOR              => q{Oleksandr Tymoshenko <gonzo@bluezbox.com>},
    VERSION_FROM        => 'lib/EBook/EPUB/Lite.pm',
    ABSTRACT_FROM       => 'lib/EBook/EPUB/Lite.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'bsd')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Archive::Zip'  => 0,
        'Carp'          => 0,
        'Data::UUID'    => 0,
        'File::Copy'    => 0,
        'File::Find'    => 0,
        'File::Temp'    => 0,
        'Moose'         => '0.90',
        'Test::More'    => 0,
        'XML::Writer'   => 0,
    },
    META_ADD => {
        resources => {
            repository => 'http://github.com/melmothx/EBook-EPUB-Lite',
        },
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'EBook-EPUB-*' },
);
