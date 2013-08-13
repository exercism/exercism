#[link(name = "rna-transcription", vers = "1.0")];
#[crate_type = "lib"];

extern mod std;

mod dna;

#[test]
#[should_fail]
fn test_acid_equals_acid() {
    assert_eq!(dna::RibonucleicAcid::new(~"CGA"), dna::RibonucleicAcid::new(~"CGA"));
    assert!(dna::RibonucleicAcid::new(~"CGA") != dna::RibonucleicAcid::new(~"AGC"));
}

#[test]
#[should_fail]
fn test_transcribes_cytidine_unchanged() {
    assert_eq!(dna::RibonucleicAcid::new(~"C"), dna::DeoxyribonucleicAcid::new(~"C").to_rna());
}

#[test]
#[should_fail]
fn test_transcribes_guanosine_unchanged() {
    assert_eq!(dna::RibonucleicAcid::new(~"G"), dna::DeoxyribonucleicAcid::new(~"G").to_rna());
}

#[test]
#[should_fail]
fn test_transcribes_adenosine_unchanged() {
    assert_eq!(dna::RibonucleicAcid::new(~"A"), dna::DeoxyribonucleicAcid::new(~"A").to_rna());
}

#[test]
#[should_fail]
fn test_transcribes_thymidine_to_uracil() {
    assert_eq!(dna::RibonucleicAcid::new(~"U"), dna::DeoxyribonucleicAcid::new(~"T").to_rna());
}

#[test]
#[should_fail]
fn test_transcribes_all_occurrences_of_thymidine_to_uracil() {
    assert_eq!(dna::RibonucleicAcid::new(~"ACGUGGUCUUAA"), dna::DeoxyribonucleicAcid::new(~"ACGTGGTCTTAA").to_rna())
}

#[test]
#[should_fail]
fn test_acid_converts_to_string() {
    assert_eq!(dna::RibonucleicAcid::new(~"AGC").to_str(), ~"AGC");
    assert_eq!(dna::RibonucleicAcid::new(~"CGA").to_str(), ~"CGA");
}
