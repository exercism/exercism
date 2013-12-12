use strict;
use warnings;

my $module = $ENV{EXERCISM} ? 'Example' : 'Queens';

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
    or BAIL_OUT("You need to create a class called $module.pm with a constructor called new.");

eval "use $module";
ok !$@, "Cannot load $module.pm"
    or BAIL_OUT("Does $module.pm compile?  Does it end with 1; ? ($@)");

can_ok($module, 'new') or BAIL_OUT("Missing package $module; or missing sub new()");

foreach my $c (@$cases) {
	my @q;
	foreach my $params (@{ $c->{params} }) {
        eval {
	        push @q, $module->new(%$params);
        };
		if ($@) {
        	push @q, { exception => $@ };
		}
    }
    foreach my $i (0 .. @q-1) {
        if ($c->{exception}) {
			like $q[$i]{exception}, qr{^$c->{exception}[$i]}, "$c->{name} exception";
		} elsif ($q[$i]{exception}) {
			ok !$q[$i]{exception}, "$c->{name} no exception" or do {
				diag $q[$i]{exception};
				next;
			};
		}
	    if ($c->{white}) {
		    is_deeply $q[$i]->white, $c->{white}[$i], "$c->{name} white";
	    }
	    if ($c->{black}) {
		    is_deeply $q[$i]->black, $c->{black}[$i], "$c->{name} black";
	    }
        if ($c->{board}) {
            my $expected = join("\n", @{ $c->{board}[$i] }) . "\n";
            is $q[$i]->to_string, $expected , "$c->{name} board";
        }
        if (exists $c->{attack}) {
        	if ($c->{attack}[$i]) {
                ok $q[$i]->can_attack, "$c->{name} can attack";
			} else {
                ok !$q[$i]->can_attack, "$c->{name} can NOT attack";
			}
        }
    }
}


done_testing();
