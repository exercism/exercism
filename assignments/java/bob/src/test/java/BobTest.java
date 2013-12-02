import org.junit.Test;

import static org.junit.Assert.*;

public class BobTest {
    private final Bob bob = new Bob();

    @Test
    public void saySomething() {
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
    public void askingAQuestion() {
        assertEquals(
            "Sure.",
            bob.hey("Does this cryogenic chamber make me look fat?")
        );
    }

    @Test
    public void askingANumericQuestion() {
        assertEquals(
            "Sure.",
            bob.hey("You are, what, like 15?")
        );
    }

    @Test
    public void talkingForcefully() {
        assertEquals(
            "Whatever.",
            bob.hey("Let's go make out behind the gym!")
        );
    }

    @Test
    public void usingAcronymsInRegularSpeech() {
        assertEquals(
            "Whatever.", bob.hey("It's OK if you don't want to go to the DMV.")
        );
    }

    @Test
    public void forcefulQuestions() {
        assertEquals(
            "Woah, chill out!", bob.hey("WHAT THE HELL WERE YOU THINKING?")
        );
    }

    @Test
    public void shoutingNumbers() {
        assertEquals(
            "Woah, chill out!", bob.hey("1, 2, 3 GO!")
        );
    }

    @Test
    public void onlyNumbers() {
        assertEquals(
            "Whatever.", bob.hey("1, 2, 3")
        );
    }

    @Test
    public void questionWithOnlyNumbers() {
        assertEquals(
            "Sure.", bob.hey("4?")
        );
    }

    @Test
    public void shoutingWithSpecialCharacters() {
        assertEquals(
            "Woah, chill out!", bob.hey("ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!")
        );
    }

    @Test
    public void shoutingWithUmlauts() {
        assertEquals(
            "Woah, chill out!", bob.hey("\u00dcML\u00c4\u00dcTS!")
        );
    }

    @Test
    public void calmlySpeakingWithUmlauts() {
        assertEquals(
            "Whatever.", bob.hey("\u00dcML\u00e4\u00dcTS!")
        );
    }

    @Test
    public void shoutingWithNoExclamationMark() {
        assertEquals(
            "Woah, chill out!", bob.hey("I HATE YOU")
        );
    }

    @Test
    public void statementContainingQuestionMark() {
        assertEquals(
            "Whatever.", bob.hey("Ending with ? means a question.")
        );
    }

    @Test
    public void prattlingOn() {
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
    public void prolongedSilence() {
        assertEquals(
            "Fine. Be that way!", bob.hey("    ")
        );
    }
}
