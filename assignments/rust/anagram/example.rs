extern mod extra;

// Rust 0.8 does not have proper unicode support :(
use std::ascii::StrAsciiExt; 
use extra::sort;

pub fn anagrams_for<'a>(word: &str, inputs: &[&'a str]) -> ~[&'a str] {
    let lower_word = word.to_ascii_lower();
    let norm_word = alphagram(lower_word);
    inputs.iter()
        .filter(|other| {
            let lower_other = other.to_ascii_lower();
            lower_other != lower_word && norm_word == alphagram(lower_other)
        })
        .map(|s| *s)
        .to_owned_vec()
}

fn alphagram(str: &str) -> ~[char] {
    let mut chars: ~[char] = str.iter().collect();
    sort::tim_sort(chars);
    chars
}