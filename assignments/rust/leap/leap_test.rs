#[link(name = "leap_year", vers = "1.0")];
#[crate_type = "lib"];

mod leap_year;

#[test]
#[ignore]
fn test_vanilla_leap_year() {
    assert_eq!(leap_year::is_leap_year(1996), true);
}

#[test]
#[ignore]
fn test_any_old_year() {
    assert_eq!(leap_year::is_leap_year(1997), false);
}

#[test]
#[ignore]
fn test_century() {
    assert_eq!(leap_year::is_leap_year(1900), false);
}

#[test]
#[ignore]
fn test_exceptional_century() {
    assert_eq!(leap_year::is_leap_year(2000), true);
}
