package Wordy;
use strict;
use warnings;

my %operators = (
    'minus'         => '-',
    'plus'          => '+',
    'divided by'    => '/',
    'multiplied by' => '*',
);
my $OPERATORS = join '|', keys %operators;
my $NUMBER = qr/[\d-]+/;

sub answer {
    my ($str) = @_;

	if ($str =~ m{^What\s+is\s+((?:$NUMBER\s+($OPERATORS)\s+)+$NUMBER)\s*\?}) {
        my $expression = $1;
        $expression =~ s/($OPERATORS)/$operators{$1}/g;
		#return $expression;
        return eval $expression;
	}

    die "ArgumentError";
}


1;

