use std::hashmap::HashMap;

#[deriving(Eq)]
struct Phrase {
    phrase: ~str
}

impl Phrase {
    pub fn new(phrase: ~str) -> Phrase { Phrase { phrase: phrase } }

    pub fn word_count(&self) -> HashMap<~str, int> {
        let word_count: HashMap<~str, int> = HashMap::new();

        return word_count;
    }
}
