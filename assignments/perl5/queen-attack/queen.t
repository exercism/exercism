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
#diag explain $cases;

my  $tests = 3;
foreach my $c (@$cases) {
	foreach my $bo (@{ $c->{boards} }) {
		$tests += keys(%$bo) - 1;
		$tests++ if not exists $bo->{exception};
	}
}
plan tests => $tests;

ok -e "$module.pm", "missing $module.pm"
    or BAIL_OUT("You need to create a class called $module.pm with a constructor called new.");

eval "use $module";
ok !$@, "Cannot load $module.pm"
    or BAIL_OUT("Does $module.pm compile?  Does it end with 1; ? ($@)");

can_ok($module, 'new') or BAIL_OUT("Missing package $module; or missing sub new()");

foreach my $c (@$cases) {
	foreach my $board (@{ $c->{boards} }) {
        eval {
	        $board->{res} = $module->new(%{ $board->{params} });
        };
		if ($@) {
        	$board->{res} = { exception => $@ };
		}
    }
	foreach my $board (@{ $c->{boards} }) {
        if ($board->{exception}) {
			like $board->{res}{exception}, qr{^$board->{exception}}, "$c->{name} exception";
		} else {
			ok !$board->{res}{exception}, "$c->{name} no exception" or do {
				diag $board->{res}{exception};
				next;
			};
		}
	    if ($board->{white}) {
		    is_deeply $board->{res}->white, $board->{white}, "$c->{name} white";
	    }
	    if ($board->{black}) {
		    is_deeply $board->{res}->black, $board->{black}, "$c->{name} black";
	    }
        if ($board->{board}) {
            my $expected = join("\n", @{ $board->{board} }) . "\n";
            is $board->{res}->to_string, $expected , "$c->{name} board";
        }
        if (exists $board->{attack}) {
        	if ($board->{attack}) {
                ok $board->{res}->can_attack, "$c->{name} can attack";
			} else {
                ok !$board->{res}->can_attack, "$c->{name} can NOT attack";
			}
        }
    }
}


#done_testing();
