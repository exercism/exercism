use std::hashmap::HashMap;
// Rust 0.8 does not have proper unicode support :(
use std::ascii::StrAsciiExt; 

pub fn word_count(input: &str) -> HashMap<~str, uint> {
    let mut map: HashMap<~str, uint> = HashMap::new();
    let norm = input.to_ascii_lower();
    for word in norm.split_iter(|c: char| !c.is_alphanumeric()).filter(|s| !s.is_empty()) {
        map.insert_or_update_with(word.to_owned(), 1, |_, count| *count += 1);
    }
    map
}
