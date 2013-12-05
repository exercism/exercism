use strict;
use warnings;
use 5.010;

opendir my $dh, '.' or die;
my @dirs = grep { $_ ne '.' and $_ ne '..' and -d $_ } readdir $dh;
close $dh;

$ENV{EXERCISM} = 1;
foreach my $d (@dirs) {
	say $d;
    chdir $d;
    opendir my $dh, '.' or die;
    my ($test) = grep { /\.t$/ } readdir $dh;
    close $dh;
	system "prove $test";
    chdir '..';
}
