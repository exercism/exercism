#[link(name = "anagram", vers = "1.0")];
#[crate_type = "lib"];

extern mod std;
extern mod extra;

mod anagram;

#[test]
#[ignore]
fn test_no_matches() {
    assert_eq!(
        anagram::anagrams_for("diaper", ["hello", "world", "zombies", "pants"]),
        ~[]);
}

#[test]
#[ignore]
fn test_detect_simple_anagram() {
    assert_eq!(anagram::anagrams_for("ant", ["tan", "stand", "at"]), ~["tan"]);
}

#[test]
#[ignore]
fn test_does_not_confuse_different_duplicates() {
    assert_eq!(anagram::anagrams_for("galea", ["eagle"]), ~[]);
}

#[test]
#[ignore]
fn test_eliminate_anagram_subsets() {
    assert_eq!(anagram::anagrams_for("good", ["dog", "goody"]), ~[]);
}

#[test]
#[ignore]
fn test_detect_anagram() {
    assert_eq!(
        anagram::anagrams_for("listen",
                              ["enlists", "google", "inlets", "banana"]),
        ~["inlets"])
}

#[test]
#[ignore]
fn test_multiple_anagrams() {
    assert_eq!(
        anagram::anagrams_for("allergy",
                              ["gallery", "ballerina", "regally",
                               "clergy", "largely", "leading"]),
        ~["gallery", "regally", "largely"]);
}

#[test]
#[ignore]
fn test_case_insensitive_anagrams() {
    assert_eq!(
        anagram::anagrams_for("Orchestra",
                              ["cashregister", "Carthorse", "radishes"]),
        ~["Carthorse"]);
}

#[test]
#[ignore]
fn test_does_not_detect_a_word_as_its_own_anagram() {
    assert_eq!(anagram::anagrams_for("banana", ["banana"]), ~[]);
}
