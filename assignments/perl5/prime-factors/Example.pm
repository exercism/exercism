package Example;
use strict;
use warnings;

sub factors {
    my ($num) = @_;

	return [] if $num == 1;
    my @factors;
    my $i = 2;
	while ($i*$i <= $num) {
		my $div = $num/$i;
	    if ($div == int $div) {
            push @factors, $i;
            $num = $div;
            next;
        }
        $i++;
	}
	push @factors, $num;

    return \@factors;
}

1;

