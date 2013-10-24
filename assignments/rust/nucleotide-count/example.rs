use std::hashmap::HashMap;

pub fn count(nucleotide: char, input: &str) -> uint {
    input.iter().count(|c| c == nucleotide)
}

pub fn nucleotide_counts(input: &str) -> HashMap<char, uint> {
    let mut map: HashMap<char, uint> = "ACGT".iter().map(|c| (c, 0)).collect();
    for nucleotide in input.iter() {
        map.insert_or_update_with(nucleotide, 1, |_, count| *count += 1);
    }
    map
}
