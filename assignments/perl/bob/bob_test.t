use strict;
use warnings;

use Test::More;

plan tests => 2;

ok -e 'Bob.pm', 'missing Bob.pm';

eval "use Bob";
ok !$@, 'Cannot load Bob.pm';

