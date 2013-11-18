package Bob;

sub hey {
    my ($text) = @_;

    return 'Fine. Be that way!'
        if $text eq '';
    return 'Woah, chill out!'
        if uc($text) eq $text and $text =~ /\p{Uppercase}/;
    return 'Sure.'
        if '?' eq substr $text, -1;

    return 'Whatever.';
}

1;
