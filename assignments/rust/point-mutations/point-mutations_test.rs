#[crate_id = "point-mutations_test#1.0"];
#[crate_type = "lib"];

extern mod std;

mod dna;

#[test]
#[ignore]
fn test_no_difference_between_empty_strands() {
    assert_eq!(dna::hamming_distance("", ""), 0);
}

#[test]
#[ignore]
fn test_no_difference_between_identical_strands() {
    assert_eq!(dna::hamming_distance("GGACTGA", "GGACTGA"), 0);
}

#[test]
#[ignore]
fn test_complete_hamming_distance_in_small_strand() {
    assert_eq!(dna::hamming_distance("ACT", "GGA"), 3);
}

#[test]
#[ignore]
fn test_hamming_distance_in_off_by_one_strand() {
    assert_eq!(
        dna::hamming_distance(
            "GGACGGATTCTGACCTGGACTAATTTTGGGG",
            "AGGACGGATTCTGACCTGGACTAATTTTGGGG"),
        19);
}

#[test]
#[ignore]
fn test_small_hamming_distance_in_the_middle_somewhere() {
    assert_eq!(dna::hamming_distance("GGACG", "GGTCG"), 1);
}

#[test]
#[ignore]
fn test_larger_distance() {
    assert_eq!(dna::hamming_distance("ACCAGGG", "ACTATGG"), 2);
}

#[test]
#[ignore]
fn test_ignores_extra_length_on_the_other_strand_when_longer() {
    assert_eq!(dna::hamming_distance("AAACTAGGGG", "AGGCTAGCGGTAGGAC"), 3);
}

#[test]
#[ignore]
fn test_ignores_extra_length_on_the_original_strand_when_longer() {
    assert_eq!(
        dna::hamming_distance("GACTACGGACAGGGTAGGGAAT", "GACATCGCACACC"),
        5);
}

#[test]
#[ignore]
fn test_hamming_distance() {
    let cases = [
        ("AGACAACAGCCAGCCGCCGGATT", "AGGCAA", 1),
        ("AGACAACAGCCAGCCGCCGGATT", "AGACATCTTTCAGCCGCCGGATTAGaGCAA", 4),
        ("AGACAACAGCCAGCCGCCGGATT", "AGG", 1)];
    for &(a, b, expect) in cases.iter() {
        assert_eq!(dna::hamming_distance(a, b), expect);
    } 
}