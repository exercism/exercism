use std::rand::{task_rng, Rng};
use std::str;

pub struct Robot {
    name: ~str
}

fn generateName() -> ~str {
    let mut rng = task_rng();
    let mut s = str::with_capacity(6);
    static LETTERS: &'static [u8] = bytes!("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    static NUMBERS: &'static [u8] = bytes!("0123456789");
    for _ in range(0, 3) {
        s.push_char(rng.choose(LETTERS) as char);
    }
    for _ in range(0, 3) {
        s.push_char(rng.choose(NUMBERS) as char);
    }
    s
}

impl Robot {
    pub fn new() -> Robot {
        Robot { name: generateName() }
    }

    pub fn name<'a>(&'a self) -> &'a str {
        self.name.as_slice()
    }

    pub fn resetName(&mut self) {
        self.name = generateName();
    }

}
