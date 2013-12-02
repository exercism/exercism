use strict;
use warnings;

use Test::More;

my @cases = (
   ['C', 'C',  'cytidine unchanged'],
   ['G', 'G',  'guanosine unchanged'],
   ['A', 'A',  'adenosine unchanged'],
   ['T', 'U',  'thymidine to uracil'],
   ['ACGTGGTCTTAA', 'ACGUGGUCUUAA', 'transcribes all occurences'],
);
 
plan tests => 3 + @cases;

ok -e 'DNA.pm', 'missing DNA.pm'
    or BAIL_OUT("You need to create a module called DNA.pm with a function called to_rna() that gets one parameter: a DNA sequence");

eval "use DNA";
ok !$@, 'Cannot load DNA.pm'
    or BAIL_OUT('Does DNA.pm compile?  Does it end with some true value?');

can_ok('DNA', 'to_rna') or BAIL_OUT("Missing package DNA; or missing sub to_rna");

foreach my $c (@cases) {
    is DNA::to_rna($c->[0]), $c->[1], "$c->[2]: $c->[0]   => $c->[1]";
}


