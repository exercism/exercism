package Example;
use strict;
use warnings;

sub hey {
    my ($text) = @_;

    return 'Fine. Be that way!'
        if $text =~ /^\s*$/;
    return 'Woah, chill out!'
        if uc($text) eq $text and $text =~ /\p{Uppercase}/;
    return 'Sure.'
        if '?' eq substr $text, -1;

    return 'Whatever.';
}

1;
