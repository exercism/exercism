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

ok -e 'Deque.pm', 'missing Deque.pm'
    or BAIL_OUT("You need to create a class called Deque.pm with a constructor called new.");

eval "use Deque";
ok !$@, 'Cannot load Deque.pm'
    or BAIL_OUT("Does Deque.pm compile?  Does it end with 1; ? ($@)");

can_ok('Deque', 'new') or BAIL_OUT("Missing package Deque; or missing sub new()");

foreach my $c (@$cases) {
   diag "Start $c->{name}";
   my $q = Deque->new;
   foreach my $s (@{ $c->{set} }) {
      foreach my $command (qw(push unshift)) {
         if (exists $s->{$command}) {
            $q->$command($s->{$command})
         }
      }
      foreach my $assert (qw(pop shift)) {
         if (exists $s->{$assert}) {
             is $q->$assert, $s->{$assert}, "$c->{name} $assert";
         }
      }
   }
}


done_testing();
