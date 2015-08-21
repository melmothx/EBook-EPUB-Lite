#!perl

use strict;
use warnings;
use Test::More tests => 2;
use_ok("EBook::EPUB::Lite::Utils::Array");

my $array = EBook::EPUB::Lite::Utils::Array->new;

$array->push(1);
$array->push(2, 3);
my @res = $array->elements;
is_deeply(\@res, [1, 2, 3], "Works as advised");
