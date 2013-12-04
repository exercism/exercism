package Anagram;
use strict;
use warnings;

sub match {
    my ($word, @words) = @_;

    my @results;
	my $canonical = _canonize($word);
	foreach my $w (@words) {
        next if $w eq $word;
        my $try = _canonize($w);
        if ($try eq $canonical) {
            push @results, $w;
        }
    }
    return \@results;
}


sub _canonize {
    my ($str) = @_;
    return join '', sort split //, lc $str
}


1;
