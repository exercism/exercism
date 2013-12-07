use strict;
use warnings;
use open ':std', ':encoding(utf8)';
use utf8;

my $module = $ENV{EXERCISM} ? 'Example' : 'Bob';

use Test::More;

my @cases = (
    # input                                           expected output        title
    ['Tom-ay-to, tom-aaaah-to.',                       'Whatever.',          'stating something'],
    ['WATCH OUT!',                                     'Woah, chill out!',   'shouting'],
    ['Does this cryogenic chamber make me look fat?',  'Sure.',              'question'],
    ['You are, what, like 15?',                        'Sure.',              'numeric question'],
    ["Let's go make out behind the gym!",              'Whatever.',          'talking forcefully'],
    ["It's OK if you don't want to go to the DMV.",    'Whatever.',          'using acronyms in regular speech'],
    ['WHAT THE HELL WERE YOU THINKING?',               'Woah, chill out!',   'forceful questions'],
    ['1, 2, 3 GO!',                                    'Woah, chill out!',   'shouting numbers'],
    ['1, 2, 3',                                        'Whatever.',          'only numbers'],
    ['4?',                                             'Sure.',              'question with only numbers'],
    ['ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!',  'Woah, chill out!',   'shouting with special characters'],
    ["ÜMLÄÜTS!",                                       'Woah, chill out!',   'shouting with umlauts'],
    ["\xdcML\xc4\xdcTS!",                              'Woah, chill out!',   'shouting with umlauts'],
    ["ÜMLäÜTS!",                                       'Whatever.',          'speaking calmly with umlauts'],
    #["\xdcML\xe4\xdcTS!",                              'Whatever.',          'speaking calmly with umlauts'],
    ['I HATE YOU',                                     'Woah, chill out!',   'shouting with no exclamation mark'],
    ['Ending with ? means a question.',                'Whatever.',          'statement containing question mark'],
    ["Wait! Hang on. Are you going to be OK?",         'Sure.',              'prattling on'],
    ['',                                               'Fine. Be that way!', 'silence'],
    ['    ',                                           'Fine. Be that way!', 'prolonged silence'],
);


plan tests => 3 + @cases;

ok -e "$module.pm", "missing $module.pm"
    or BAIL_OUT("You need to create a module called $module.pm with a function called hey() that gets one parameter: The text Bob hears.");

eval "use $module";
ok !$@, "Cannot load $module.pm"
    or BAIL_OUT("Does $module.pm compile?  Does it end with 1; ?");

can_ok($module, 'hey') or BAIL_OUT("Missing package $module; or missing sub hey()");

my $sub = $module . '::hey';

foreach my $c (@cases) {
    #diag uc $c->[0];
    my $title = $c->[2] ? "$c->[2]: $c->[0]" : $c->[0];
    no strict 'refs';
    is $sub->($c->[0]), $c->[1], $title;
}

