use strict;
use warnings;

my $module = $ENV{EXERCISM} ? 'Example' : 'Prime';

use Test::More;
use JSON qw(from_json);

my $cases_file = 'cases.json';
my $cases;
if (open my $fh, '<', $cases_file) {
    local $/ = undef;
    $cases = from_json scalar <$fh>;
} else {
    die "Could not open '$cases_file' $!";
}

#plan tests => 3 + @$cases;
#diag explain $cases;

ok -e "$module.pm", "missing $module.pm"
    or BAIL_OUT("You need to create a class called $module.pm with a constructor called factors.");

eval "use $module";
ok !$@, "Cannot load $module.pm"
    or BAIL_OUT("Does $module.pm compile?  Does it end with 1; ? ($@)");

can_ok($module, 'factors') or BAIL_OUT("Missing package $module; or missing sub factors()");

my $sub = $module . '::factors';

foreach my $c (@$cases) {
    no strict 'refs';
    is_deeply $sub->($c->{input}), $c->{expected}, $c->{name}
}


done_testing();
