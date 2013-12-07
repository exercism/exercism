package Example;
use strict;
use warnings;

sub convert {
   my ($num) = @_;

   my $str = '';
   $str .= "Pling" if $num / 3 == int($num / 3);
   $str .= "Plang" if $num / 5 == int($num / 5);
   $str .= "Plong" if $num / 7 == int($num / 7);
   return $str if $str;

   return $num;
}

1;

