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

plan tests => 3 + @$cases;
#diag explain $cases; 

ok -e 'Wordy.pm', 'missing Wordy.pm'
    or BAIL_OUT("You need to create a class called Wordy.pm with an function called answer() that gets the original word as the first parameter and a reference to a list of word to check. It should return a referene to a list of words.");

eval "use Wordy";
ok !$@, 'Cannot load Wordy.pm'
    or BAIL_OUT('Does Wordy.pm compile?  Does it end with 1; ?');

can_ok('Wordy', 'answer') or BAIL_OUT("Missing package Wordy; or missing sub answer()");

foreach my $c (@$cases) {
    my $answer;
    eval {
        $answer = Wordy::answer($c->{input});
    };
diag $answer;
    if ($c->{exception}) {
		like $@, qr/^$c->{exception}/, "Exception $c->{name}";
	} else {
        is $answer, $c->{expected}, $c->{name};
    }
}



