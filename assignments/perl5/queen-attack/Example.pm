package Example;
use strict;
use warnings;

sub new {
    my ($class, %data) = @_;

    my $self = bless \%data, $class;

	$self->{white} //= [0, 3];
	$self->{black} //= [7, 3];

    foreach my $c (@{ $self->{white} }, @{ $self->{black} }) {
       die "ArgumentError" if $c < 0 or $c > 7 or $c != int($c);
    }

    die "ArgumentError" if
        $self->{white}[0] == $self->{black}[0] and
        $self->{white}[1] == $self->{black}[1];

	return $self;
}

sub white {
    my ($self) = @_;
    $self->{white};
}

sub black {
    my ($self) = @_;
    $self->{black};
}

sub to_string {
    my ($self) = @_;
    my @board;
	push @board, [('O') x 8] for 1..8;
	$board[$self->white->[0]][$self->white->[1]] = 'W';
	$board[$self->black->[0]][$self->black->[1]] = 'B';

	return join '',
        map { "$_\n" }
		map { join ' ', @$_ } @board
}

sub can_attack {
	my ($self) = @_;

	return 1 if $self->white->[0] == $self->black->[0];
	return 1 if $self->white->[1] == $self->black->[1];
	return 1 if
		abs($self->white->[0] - $self->black->[0]) ==
		abs($self->white->[1] - $self->black->[1]);

	return;
}

1;

