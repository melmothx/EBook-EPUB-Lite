#!perl

use utf8;
use strict;
use warnings;

use Test::More;
use File::Spec::Functions qw/catfile catdir/;
use File::Temp;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

# produce the epub
use_ok('EBook::EPUB::Lite');


my $epub_file = catfile(qw/t test.epub/);
my $specs = {
             css => '@page { margin: 5pt; } html, body { font-family: serif; font-size: 9pt; }',
             html => [
                      '<div>First piece</div>',
                      '<div>Second piece</div>',
                      '<div>Third piece</div>',
                     ],
             title => 'My title',
             author => 'My author',
             lang => 'it',
             source => 'My source',
             date => '2014',
             desc => 'My description of this piece',
            };

create_epub($epub_file, $specs);

ok (-f $epub_file, "$epub_file generated");

if (-f $epub_file) {
    if ($ENV{EPUB_NO_CLEANUP}) {
        diag "Leaving $epub_file in the tree";
    }
    else {
        unlink $epub_file or die "Can't unlink $epub_file $!";
    }
}

done_testing;

sub create_epub {
    my ($target, $spec) = @_;
    die unless $target && $spec;
    my $epub = EBook::EPUB::Lite->new;
    if (my $css = $spec->{css}) {
        $epub->add_stylesheet("stylesheet.css" => $css);
    }
    $epub->add_author($spec->{author} || 'Author');
    $epub->add_title($spec->{title} || 'Title');
    $epub->add_language($spec->{lang} || 'en');
    $epub->add_source($spec->{source} || 'Source');
    $epub->add_date($spec->{date} || '2015');
    $epub->add_description($spec->{desc} || 'Description');
    my $counter = 0;
    my $nav;
    foreach my $html (@{$spec->{html}}) {
        $counter++;
        my $filename = 'piece' . $counter . '.xhtml';
        my $id = $epub->add_xhtml($filename, html_wrap($html));
        $nav ||= $epub;
        $nav = $nav->add_navpoint(label => "Piece $counter",
                                  id => $id,
                                  play_order => $counter,
                                  content => $filename);
    }
    foreach my $file (@{$spec->{files} || []}) {
        $epub->copy_file(undef, $file);
    }
    $epub->pack_zip($target);
    return $target;
}

sub html_wrap {
    my ($body, $title) = @_;
    $title ||= "No title";
    my $xhtml = <<"XHTML";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>$title</title>
    <link href="stylesheet.css" type="text/css" rel="stylesheet" />
  </head>
  <body>
    <div id="page">
      $body
    </div>
  </body>
</html>

XHTML
}
