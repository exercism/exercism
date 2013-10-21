use std::iter;

pub fn verse(n: int) -> ~str {
    match n {
        0 =>
            ~"No more bottles of beer on the wall, no more bottles of beer.\n\
              Go to the store and buy some more, 99 bottles of beer on the wall.\n",
        1 =>
            ~"1 bottle of beer on the wall, 1 bottle of beer.\n\
              Take it down and pass it around, no more bottles of beer on the wall.\n",
        2 =>
            ~"2 bottles of beer on the wall, 2 bottles of beer.\n\
              Take one down and pass it around, 1 bottle of beer on the wall.\n",
        n if n > 2 && n <= 99 =>
            format!(
                "{n} bottles of beer on the wall, {n} bottles of beer.\n\
                 Take one down and pass it around, {n_minus_1} bottles of beer on the wall.\n",
                n=n,
                n_minus_1=n - 1),
        _ =>
            fail!(),
    }
}

pub fn sing(start: int, end: int) -> ~str {
    let mut s = iter::range_inclusive(end, start)
        .invert()
        .map(verse)
        .to_owned_vec()
        .connect("\n");
    s.push_char('\n');
    s
}
