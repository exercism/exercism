use strict;
use warnings;

use Test::More;

plan tests => 3;

ok -e 'DNA.pm', 'missing DNA.pm'
    or BAIL_OUT("You need to create a module called DNA.pm with a function called to_rna() that gets one parameter: a DNA sequence");

eval "use DNA";
ok !$@, 'Cannot load DNA.pm'
    or BAIL_OUT('Does DNA.pm compile?  Does it end with some true value?');

can_ok('DNA', 'to_rna') or BAIL_OUT("Missing package DNA; or missing sub to_rna");


