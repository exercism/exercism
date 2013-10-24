use std::char;

pub fn number(s: &str) -> ~str {
    let digits: ~str = s
        .iter()
        .filter(|&c| char::is_digit_radix(c, 10))
        .collect();
    match digits.len() {
        10 => Some(digits),
        11 => match digits.char_at(0) {
            '1' => Some(digits.slice_from(1).into_owned()),
            _   => None
        },
        _  => None
    }.unwrap_or(~"0000000000")
}

pub fn area_code(s: &str) -> ~str {
    let n = number(s);
    n.slice_to(3).into_owned()
}

pub fn pretty_print(s: &str) -> ~str {
    let n = number(s);
    format!("({area}) {prefix}-{exchange}",
            area=n.slice_to(3),
            prefix=n.slice(3, 6),
            exchange=n.slice_from(6))
}
