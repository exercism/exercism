pub fn hamming_distance(a: &str, b: &str) -> uint {
    a.iter().zip(b.iter()).filter(|&(a, b)| a != b).len()
}
