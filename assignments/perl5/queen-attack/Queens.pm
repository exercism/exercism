package Queens;
use strict;
use warnings;

sub new {
    my ($class, %data) = @_;

    my $self = bless \%data, $class;

	$self->{white} //= [0, 3];
	$self->{black} //= [7, 3];

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



1;

