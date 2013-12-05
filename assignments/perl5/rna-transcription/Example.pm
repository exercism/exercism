package Example;
use strict;
use warnings;

sub to_rna {
	my ($dna) = @_;
    $dna =~ y/T/U/;
    #$dna =~ tr/T/U/;   # y and tr are synonymes in perl 5
    #$dna =~ s/T/U/g;   # regexes are not really the right tool for this
	return $dna;
}

1;

