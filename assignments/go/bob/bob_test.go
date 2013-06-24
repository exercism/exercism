package bob

import "testing"

func assertHey(in string, out string, t *testing.T) {
	if reply := Hey(in); reply != out {
		t.Errorf("Hey(\"%v\"): Got \"%v\", expected \"%v\"", in, reply, out)
	}
}

func TestBobStatement(t *testing.T) {
	assertHey("Tom-ay-to, tom-aaaah-to.", "Whatever.", t)
}

func TestShouting(t *testing.T) {
	assertHey("WATCH OUT!", "Woah, chill out!", t)
}

func TestExclaiming(t *testing.T) {
	assertHey("Let's go make out behind the gym!", "Whatever.", t)
}

func TestAsking(t *testing.T) {
	assertHey("Does this cryogenic chamber make me look fat?", "Sure.", t)
}

func TestShoutNumbers(t *testing.T) {
	assertHey("1, 2, 3 GO!", "Woah, chill out!", t)
}

func TestShoutWeirdCharacters(t *testing.T) {
	assertHey("ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!", "Woah, chill out!", t)
}

func TestShoutWithoutPunctuation(t *testing.T) {
	assertHey("I HATE YOU", "Woah, chill out!", t)
}

func TestStatementWithQuestionMark(t *testing.T) {
	assertHey("Ending with ? means a question.", "Whatever.", t)
}

func TestSilentTreatment(t *testing.T) {
	assertHey("", "Fine. Be that way.", t)
}

