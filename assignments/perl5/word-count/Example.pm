package Example;
use strict;
use warnings;

sub word_count {
    my ($text) = @_;
    my %count;

	foreach my $word ($text =~ /(\w+)/g) {
		$count{lc $word}++;
	}

    return \%count;
}

1;
