package Bob;

sub hey {
    my ($text) = @_;

    return 'Woah, chill out!'
        if uc($text) eq $text and $text =~ /[A-Z]/;
    return 'Sure.'
        if '?' eq substr $text, -1;

    return 'Whatever.';
}

1;
