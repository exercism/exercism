#[link(name = "dna", vers = "1.0")];
#[crate_type = "lib"];

use std::hashmap::HashMap;

mod dna;

fn check_dna(s: &str, pairs: &[(char, uint)]) {
    // The reason for the awkward code in here is to ensure that the failure
    // message for assert_eq! is as informative as possible. A simpler
    // solution would simply check the length of the map, and then
    // check for the presence and value of each key in the given pairs vector.
    let mut m: HashMap<char, uint> = dna::nucleotide_counts(s);
    for &(k, v) in pairs.iter() {
        assert_eq!((k, m.pop(&k).unwrap()), (k, v));
    }
    // may fail with a message that clearly shows all extra pairs in the map
    assert_eq!(m.iter().to_owned_vec(), ~[]);
}

#[test]
#[ignore]
fn test_count_empty() {
    assert_eq!(dna::count('A', ""), 0);
}

#[test]
#[ignore]
fn test_count_repetitive_cytidine() {
    assert_eq!(dna::count('C', "CCCCC"), 5);
}

#[test]
#[ignore]
fn test_count_only_thymidine() {
    assert_eq!(dna::count('T', "GGGGGTAACCCGG"), 1);
}

#[test]
#[ignore]
fn test_count_dna_has_no_no_uracil() {
    assert_eq!(dna::count('U', "GATTACA"), 0);
}

/*
testCase "validates nucleotides" $
assertError "invalid nucleotide 'X'" $ count 'X' "GACT"
*/

#[test]
#[ignore]
fn test_nucleotide_count_empty() {
    check_dna(
        "",
        [('A', 0), ('T', 0), ('C', 0), ('G', 0)]);
}

#[test]
#[ignore]
fn test_nucleotide_count_only_guanosine() {
    check_dna(
        "GGGGGGGG",
        [('A', 0), ('T', 0), ('C', 0), ('G', 8)]);
}

#[test]
#[ignore]
fn test_nucleotide_count_counts_all() {
    check_dna(
        "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAA\
         GAGTGTCTGATAGCAGC",
        [('A', 20), ('T', 21), ('C', 12), ('G', 17)]);
}
