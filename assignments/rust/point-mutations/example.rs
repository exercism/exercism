pub fn hamming_distance(a: &str, b: &str) -> uint {
    a.chars().zip(b.chars()).filter(|&(a, b)| a != b).len()
}
