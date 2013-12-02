import org.junit.Test;

import static org.junit.Assert.*;

public class PhoneNumberTest {

    @Test
    public void cleansNumber() {
        final String expectedNumber = "1234567890";
        final String actualNumber = new PhoneNumber("(123) 456-7890").getNumber();

        assertEquals(
            expectedNumber, actualNumber
        );
    }

    @Test
    public void cleansNumberWithDots() {
        final String expectedNumber = "1234567890";
        final String actualNumber = new PhoneNumber("123.456.7890").getNumber();

        assertEquals(
            expectedNumber, actualNumber
        );
    }

    @Test
    public void validWhen11DigitsAndFirstIs1() {
        final String expectedNumber = "1234567890";
        final String actualNumber = new PhoneNumber("11234567890").getNumber();

        assertEquals(
            expectedNumber, actualNumber
        );
    }

    @Test
    public void invalidWhenOnly11Digits() {
        final String expectedNumber = "0000000000";
        final String actualNumber = new PhoneNumber("21234567890").getNumber();

        assertEquals(
            expectedNumber, actualNumber
        );
    }

    @Test
    public void invalidWhen9Digits() {
        final String expectedNumber = "0000000000";
        final String actualNumber = new PhoneNumber("123456789").getNumber();

        assertEquals(
            expectedNumber, actualNumber
        );
    }

    @Test
    public void areaCode() {
        final String expectedAreaCode = "123";
        final String actualAreaCode = new PhoneNumber("1234567890").getAreaCode();

        assertEquals(
            expectedAreaCode, actualAreaCode
        );
    }

    @Test
    public void prettyPrint() {
        final String expectedPrettyNumber = "(123) 456-7890";
        final String actualPrettyNumber = new PhoneNumber("1234567890").pretty();

        assertEquals(
            expectedPrettyNumber, actualPrettyNumber
        );
    }

    @Test
    public void prettyPrintWithFullUSPhoneNumber() {
        final String expectedPrettyNumber = "(123) 456-7890";
        final String actualPrettyNumber = new PhoneNumber("11234567890").pretty();

        assertEquals(
            expectedPrettyNumber, actualPrettyNumber
        );
    }

}
