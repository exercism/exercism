package bob

import "testing"

var testCases = []struct {
	description string
	expected    string
	input       string
}{
	{
		"stating something",
		"Whatever.",
		"Tom-ay-to, tom-aaaah-to.",
	},
	{
		"shouting",
		"Woah, chill out!",
		"WATCH OUT!",
	},
	{
		"asking a question",
		"Sure.",
		"Does this cryogenic chamber make me look fat?",
	},
	{
		"asking a numeric question",
		"Sure.",
		"You are, what, like 15?",
	},
	{
		"talking forcefully",
		"Whatever.",
		"Let's go make out behind the gym!",
	},
	{
		"using acronyms in regular speech",
		"Whatever.",
		"It's OK if you don't want to go to the DMV.",
	},
	{
		"forceful questions",
		"Woah, chill out!",
		"WHAT THE HELL WERE YOU THINKING?",
	},
	{
		"shouting numbers",
		"Woah, chill out!",
		"1, 2, 3 GO!",
	},
	{
		"only numbers",
		"Whatever.",
		"1, 2, 3",
	},
	{
		"question with only numbers",
		"Sure.",
		"4?",
	},
	{
		"shouting with special characters",
		"Woah, chill out!",
		"ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!",
	},
	{
		"shouting with no exclamation mark",
		"Woah, chill out!",
		"I HATE YOU",
	},
	{
		"statement containing question mark",
		"Whatever.",
		"Ending with ? means a question.",
	},
	{
		"prattling on",
		"Sure.",
		"Wait! Hang on. Are you going to be OK?",
	},
	{
		"silence",
		"Fine. Be that way!",
		"",
	},
	{
		"prolonged silence",
		"Fine. Be that way!",
		"    ",
	},
	{
		"really prolonged silence",
		"Fine. Be that way!",
		"                 ",
	},
	{
		"multi line trick question",
		"Whatever.",
		"Do I ever change my mind?\nNo.",
	},
}

func TestHeyBob(t *testing.T) {
	for _, tt := range testCases {
		actual := Hey(tt.input)
		if actual != tt.expected {
			msg := `
	ALICE (%s): %s
	BOB: %s

	Expected Bob to respond: %s
			`
			t.Fatalf(msg, tt.description, tt.input, actual, tt.expected)
		}
	}
}

func BenchmarkBob(b *testing.B) {
	b.StopTimer()
	for _, tt := range testCases {
		b.StartTimer()

		for i := 0; i < b.N; i++ {
			Hey(tt.input)
		}

		b.StopTimer()
	}
}
