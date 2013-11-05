import org.junit.Test;

import static org.junit.Assert.*;

public class BobTest {
    private final Bob bob = new Bob();

    @Test
    public void say_something() {
        assertEquals(
            "Whatever.",
            bob.hey("Tom-ay-to, tom-aaaah-to.")
        );
    }

    @Test
    public void shouting() {
        assertEquals(
            "Woah, chill out!",
            bob.hey("WATCH OUT!")
        );
    }

    @Test
    public void asking_a_question() {
        assertEquals(
            "Sure.",
            bob.hey("Does this cryogenic chamber make me look fat?")
        );
    }

    @Test
    public void asking_a_numeric_question() {
        assertEquals(
            "Sure.",
            bob.hey("You are, what, like 15?")
        );
    }

    @Test
    public void talking_forcefully() {
        assertEquals(
            "Whatever.",
            bob.hey("Let's go make out behind the gym!")
        );
    }

    @Test
    public void using_acronyms_in_regular_speech() {
        assertEquals(
            "Whatever.", bob.hey("It's OK if you don't want to go to the DMV.")
        );
    }

    @Test
    public void forceful_questions() {
        assertEquals(
            "Woah, chill out!", bob.hey("WHAT THE HELL WERE YOU THINKING?")
        );
    }

    @Test
    public void shouting_numbers() {
        assertEquals(
            "Woah, chill out!", bob.hey("1, 2, 3 GO!")
        );
    }

    @Test
    public void only_numbers() {
        assertEquals(
            "Whatever.", bob.hey("1, 2, 3")
        );
    }

    @Test
    public void question_with_only_numbers() {
        assertEquals(
            "Sure.", bob.hey("4?")
        );
    }

    @Test
    public void shouting_with_special_characters() {
        assertEquals(
            "Woah, chill out!", bob.hey("ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!")
        );
    }

    @Test
    public void shouting_with_umlauts() {
        assertEquals(
            "Woah, chill out!", bob.hey("\u00dcML\u00c4\u00dcTS!")
        );
    }

    @Test
    public void calmly_speaking_with_umlauts() {
        assertEquals(
            "Whatever.", bob.hey("\u00dcML\u00e4\u00dcTS!")
        );
    }

    @Test
    public void shouting_with_no_exclamation_mark() {
        assertEquals(
            "Woah, chill out!", bob.hey("I HATE YOU")
        );
    }

    @Test
    public void statement_containing_question_mark() {
        assertEquals(
            "Whatever.", bob.hey("Ending with ? means a question.")
        );
    }

    @Test
    public void prattling_on() {
        assertEquals(
            "Sure.", bob.hey("Wait! Hang on. Are you going to be OK?")
        );
    }

    @Test
    public void silence() {
        assertEquals(
            "Fine. Be that way!", bob.hey("")
        );
    }

    @Test
    public void prolonged_silence() {
        assertEquals(
            "Fine. Be that way!", bob.hey("    ")
        );
    }
}
