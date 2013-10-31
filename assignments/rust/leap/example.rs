pub fn is_leap_year(year: int) -> bool {
    let has_factor = |n| year % n == 0;
    has_factor(4) && (!has_factor(100) || has_factor(400))
}
