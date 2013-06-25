package bob

import "testing"

func assertReply(t *testing.T, in string, out string) {
	if reply := Hey(in); reply != out {
		t.Errorf("Hey(\"%v\"): Got \"%v\", expected \"%v\"", in, reply, out)
	}
}

func TestBobStatement(t *testing.T) {
	assertReply(t, "Tom-ay-to, tom-aaaah-to.", "Whatever.")
}

func TestShouting(t *testing.T) {
	t.SkipNow()
	assertReply(t, "WATCH OUT!", "Woah, chill out!")
}

func TestExclaiming(t *testing.T) {
	t.SkipNow()
	assertReply(t, "Let's go make out behind the gym!", "Whatever.")
}

func TestAsking(t *testing.T) {
	t.SkipNow()
	assertReply(t, "Does this cryogenic chamber make me look fat?", "Sure.")
}

func TestShoutNumbers(t *testing.T) {
	t.SkipNow()
	assertReply(t, "1, 2, 3 GO!", "Woah, chill out!")
}

func TestShoutWeirdCharacters(t *testing.T) {
	t.SkipNow()
	assertReply(t, "ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!", "Woah, chill out!")
}

func TestShoutWithoutPunctuation(t *testing.T) {
	t.SkipNow()
	assertReply(t, "I HATE YOU", "Woah, chill out!")
}

func TestStatementWithQuestionMark(t *testing.T) {
	t.SkipNow()
	assertReply(t, "Ending with ? means a question.", "Whatever.")
}

func TestSilentTreatment(t *testing.T) {
	t.SkipNow()
	assertReply(t, "", "Fine. Be that way.")
}
