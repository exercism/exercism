package Example;
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

sub kind {
    my ($x, $y, $z) = @_;
    die 'TriangleError - Needs exactly 3 paramaters' if @_ != 3;
    foreach my $v (@_) {
        die "TriangleError - Not a number ($v)" if not looks_like_number($v);
		die "TriangleError - Negative number ($v)" if $v < 0;
		die "TriangleError - Zero side ($v)" if $v == 0;
    }
	die "TriangleError - illegal triple (@_)" if
		$x + $y <= $z or
		$x + $z <= $y or
		$y + $z <= $x;

    return 'equilateral' if $x == $y and $y == $z;
    return 'isosceles' if $x == $y or $x == $z or $y == $z;
	return 'scalene';
}


1;
