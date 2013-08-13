#[link(name = "word-count", vers = "1.0")];
#[crate_type = "lib"];

use std::hashmap::HashMap;

mod wordcount;

// Thanks to Luqman on irc://irc.mozilla.org/rust
// https://gist.github.com/luqmana/6219956
macro_rules! hashmap(
    { $($key:expr => $value:expr),+ } => {
        {
            let mut m = HashMap::new();
            $(
                m.insert($key, $value);
            )+
            m
        }
    };
    ($hm:ident, { $($key:expr => $value:expr),+ } ) => (
        {
            $(
                $hm.insert($key, $value);
            )+

            $hm
        }
    );
)

#[test]
// #[should_fail]
fn test_count_one_word() {
    let phrase = wordcount::Phrase::new(~"word");
    let counts = hashmap!{ ~"word" => 1 };
    assert_eq!(counts, phrase.word_count());
}

#[test]
// #[should_fail]
fn test_count_one_of_each() {
    let phrase = wordcount::Phrase::new(~"one of each");
    let counts = hashmap!{ ~"one" => 1, ~"of" => 1, ~"each" => 1 };
    assert_eq!(counts, phrase.word_count());
}

#[test]
// #[should_fail]
fn test_count_multiple_occurrences() {
    let phrase = wordcount::Phrase::new(~"one fish two fish red fish blue fish");
    let counts = hashmap!{ ~"one"=>1, ~"fish"=>4, ~"two"=>1, ~"red"=>1, ~"blue"=>1 };
    assert_eq!(counts, phrase.word_count());
}

#[test]
// #[should_fail]
fn test_count_everything_just_once() {
    let phrase = wordcount::Phrase::new(~"all the kings horses and all the kings men");
    phrase.word_count(); // count it an extra time;
    let counts = hashmap!{ ~"all"=>2, ~"the"=>2, ~"kings"=>2, ~"horses"=>1, ~"and"=>1, ~"men"=>1 };
    assert_eq!(counts, phrase.word_count());
}

#[test]
// #[should_fail]
fn test_ignore_punctuation() {
    let phrase = wordcount::Phrase::new(~"car : carpet as java : javascript!!&@$%^&");
    let counts = hashmap!{ ~"car"=>1, ~"carpet"=>1, ~"as"=>1, ~"java"=>1, ~"javascript"=>1 };
    assert_eq!(counts, phrase.word_count());
}

#[test]
// #[should_fail]
fn test_handles_cramped_lists() {
    let phrase = wordcount::Phrase::new(~"one,two,three");
    let counts = hashmap!{ ~"one"=>1, ~"two"=>1, ~"three" => 1 };
    assert_eq!(counts, phrase.word_count());
}

#[test]
// #[should_fail]
fn test_include_numbers() {
    let phrase = wordcount::Phrase::new(~"testing, 1, 2 testing");
    let counts = hashmap!{ ~"testing" => 2, ~"1" => 1, ~"2" => 1 };
    assert_eq!(counts, phrase.word_count());
}

#[test]
// #[should_fail]
fn test_normalize_case() {
    let phrase = wordcount::Phrase::new(~"go Go GO");
    let counts = hashmap!{~"go" => 3};
    assert_eq!(counts, phrase.word_count());
}
