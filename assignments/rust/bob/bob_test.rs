#[crate_id = "bob_test#1.0"];
#[crate_type = "lib"];

extern mod std;

mod bob;

#[test]
#[ignore]
fn test_statement() {
    assert_eq!("Whatever.", bob::reply("Tom-ay-to, tom-aaaah-to."));
}

#[test]
#[ignore]
fn test_shouting() {
    assert_eq!("Woah, chill out!", bob::reply("WATCH OUT!"));
}

#[test]
#[ignore]
fn test_exclaiming() {
    assert_eq!("Whatever.", bob::reply("Let's go make out behind the gym!"));
}

#[test]
#[ignore]
fn test_asking() {
    assert_eq!("Sure.", bob::reply("Does this cryogenic chamber make me look fat?"));
}

#[test]
#[ignore]
fn test_shout_numbers() {
    assert_eq!("Woah, chill out!", bob::reply("1, 2, 3 GO!"));
}

#[test]
#[ignore]
fn test_shout_weird_characters() {
    assert_eq!("Woah, chill out!", bob::reply("ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!"));
}

#[test]
#[ignore]
fn test_shout_without_punctuation() {
    assert_eq!("Woah, chill out!", bob::reply("I HATE YOU"));
}

#[test]
#[ignore]
fn test_shout_without_question_mark() {
    assert_eq!("Whatever.", bob::reply("Ending with ? means a question."));
}

#[test]
#[ignore]
fn test_silent_treatment() {
    assert_eq!("Fine. Be that way!", bob::reply(""));
}

