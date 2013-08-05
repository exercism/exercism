pub fn reply(message: &str) -> &str {
    if is_silence(message) { "Fine. Be that way." }
    else if is_yelling(message) { "Woah, chill out!" }
    else if is_question(message) { "Sure." }
    else  { "Whatever." }
}

fn is_silence(message: &str) -> bool {
    message == ""
}

fn is_yelling(message: &str) -> bool {
    let upcase_message: &[Ascii] = message.to_ascii().to_upper();
    let ascii_message: &[Ascii] = message.to_ascii();
    upcase_message == ascii_message
}

fn is_question(message: &str) -> bool {
    message.ends_with("?")
}
