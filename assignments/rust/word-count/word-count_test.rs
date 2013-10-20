#[link(name = "word_count", vers = "1.0")];
#[crate_type = "lib"];

use std::hashmap::HashMap;

mod word_count;


#[test]
#[ignore]
fn test_no_words() {
    assert_eq!(word_count::word_count(""), HashMap::new());
    assert_eq!(word_count::word_count("-!@#$ $#() @@@"), HashMap::new());
}

#[test]
#[ignore]
fn test_count_one_word() {
    let m = word_count::word_count("word");
    assert_eq!(m.find(&~"word").unwrap(), &1);
}

#[test]
#[ignore]
fn test_count_one_of_each() {
    let m = word_count::word_count("one of each");
    assert_eq!(m.find(&~"one").unwrap(), &1);
    assert_eq!(m.find(&~"of").unwrap(), &1);
    assert_eq!(m.find(&~"each").unwrap(), &1);
}

#[test]
#[ignore]
fn test_count_multiple_occurrences() {
    let m = word_count::word_count("one fish two fish red fish blue fish");
    assert_eq!(m.find(&~"one").unwrap(), &1);
    assert_eq!(m.find(&~"fish").unwrap(), &4);
    assert_eq!(m.find(&~"two").unwrap(), &1);
    assert_eq!(m.find(&~"red").unwrap(), &1);
    assert_eq!(m.find(&~"blue").unwrap(), &1);
}

#[test]
#[ignore]
fn test_ignore_punctuation() {
    let m = word_count::word_count("car : carpet as java : javascript!!&@$%^&");
    assert_eq!(m.find(&~"car").unwrap(), &1);
    assert_eq!(m.find(&~"carpet").unwrap(), &1);
    assert_eq!(m.find(&~"as").unwrap(), &1);
    assert_eq!(m.find(&~"java").unwrap(), &1);
    assert_eq!(m.find(&~"javascript").unwrap(), &1);
}

#[test]
#[ignore]
fn test_include_numbers() {
    let m = word_count::word_count("testing, 1, 2 testing");
    assert_eq!(m.find(&~"testing").unwrap(), &2);
    assert_eq!(m.find(&~"1").unwrap(), &1);
    assert_eq!(m.find(&~"2").unwrap(), &1);
}

#[test]
#[ignore]
fn test_normalize_case() {
    let m = word_count::word_count("go Go GO");
    assert_eq!(m.find(&~"go").unwrap(), &3);
}

#[test]
#[ignore]
fn test_prefix_punctuation() {
    let m = word_count::word_count("!%%#testing, 1, 2 testing");
    assert_eq!(m.find(&~"testing").unwrap(), &2);
    assert_eq!(m.find(&~"1").unwrap(), &1);
    assert_eq!(m.find(&~"2").unwrap(), &1);
}

#[test]
#[ignore]
fn test_symbols_are_separators() {
    let m = word_count::word_count("hey,my_spacebar_is_broken.");
    assert_eq!(m.find(&~"hey").unwrap(), &1);
    assert_eq!(m.find(&~"my").unwrap(), &1);
    assert_eq!(m.find(&~"spacebar").unwrap(), &1);
    assert_eq!(m.find(&~"is").unwrap(), &1);
    assert_eq!(m.find(&~"broken").unwrap(), &1);
}
