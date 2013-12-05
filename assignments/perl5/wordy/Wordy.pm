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

        # it seems the expressions are always left associative so:
        #return eval $expression;
        my @parts = split /\s+/, $expression;
        while (@parts > 2) {
            my ($x, $op, $y, @leftover) = @parts;
            @parts = (eval("$x $op $y"), @leftover);
        }
        return shift @parts;
    }

    die "ArgumentError";
}


1;

