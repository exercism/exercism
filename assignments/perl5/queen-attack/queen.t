use strict;
use warnings;

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

ok -e 'Queens.pm', 'missing Queens.pm'
    or BAIL_OUT("You need to create a class called Queens.pm with a constructor called new.");

eval "use Queens";
ok !$@, 'Cannot load Queens.pm'
    or BAIL_OUT("Does Queens.pm compile?  Does it end with 1; ? ($@)");

can_ok('Queens', 'new') or BAIL_OUT("Missing package Queens; or missing sub new()");

foreach my $c (@$cases) {
	my @q;
    my @exceptions;
	foreach my $params (@{ $c->{params} }) {
        eval {
	        push @q, Queens->new(%$params);
        };
        push @exceptions, $@;
    }
    foreach my $i (0 .. @q-1) {
	    if ($c->{white}) {
		    is_deeply $q[$i]->white, $c->{white}[$i], "$c->{name} white";
	    }
	    if ($c->{black}) {
		    is_deeply $q[$i]->black, $c->{black}[$i], "$c->{name} black";
	    }
        if ($c->{exception}) {
			like $exceptions[$i], qr{^$c->{exception}[$i]}, "$c->{name} exception";
		}
        if ($c->{board}) {
            my $expected = join("\n", @{ $c->{board}[$i] }) . "\n";
            is $q[$i]->to_string, $expected , "$c->{name} board";
        }
        if (exists $c->{attack}) {
            ok !$q[$i]->can_attack, "$c->{name} can attack";
        }
    }
}


done_testing();
