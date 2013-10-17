use std::iter;

pub fn verse(n: int) -> ~str {
    match n {
        0 =>
            ~"No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n",
        1 =>
            ~"1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n",
        2 =>
            ~"2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n",
        n if n > 2 && n <= 99 =>
            [n.to_str(), ~" bottles of beer on the wall, ",
             n.to_str(), ~" bottles of beer.\n",
             ~"Take one down and pass it around, ",
             (n - 1).to_str(), ~" bottles of beer on the wall.\n"].concat(),
        _ =>
            fail!(),
    }
}

pub fn sing(start: int, end: int) -> ~str {
    iter::range_inclusive(end, start)
        .invert()
        .map(verse)
        .collect::<~[~str]>()
        .connect("\n") + "\n"
}
