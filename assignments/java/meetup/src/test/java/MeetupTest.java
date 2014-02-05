import org.joda.time.DateTime;
import org.joda.time.DateTimeConstants;
import org.junit.Test;

import static org.fest.assertions.api.Assertions.assertThat;
import static org.joda.time.DateTimeConstants.*;

/*
 * We use Joda Time here to encourage the use of a saner date manipulation library.
 */
public class MeetupTest {
    @Test
    public void test_monteenth_of_may_2013() {
        DateTime expected = new DateTime(2013, 5, 13, 0, 0);
        Meetup meetup = new Meetup(5, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_monteenth_of_august_2013() {
        DateTime expected = new DateTime(2013, 8, 19, 0, 0);
        Meetup meetup = new Meetup(8, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_monteenth_of_september_2013() {
        DateTime expected = new DateTime(2013, 9, 16, 0, 0);
        Meetup meetup = new Meetup(9, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_tuesteenth_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 19, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_tuesteenth_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 16, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_tuesteenth_of_august_2013() {
        DateTime expected = new DateTime(2013, 8, 13, 0, 0);
        Meetup meetup = new Meetup(8, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_wednesteenth_of_january_2013() {
        DateTime expected = new DateTime(2013, 1, 16, 0, 0);
        Meetup meetup = new Meetup(1, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_wednesteenth_of_february_2013() {
        DateTime expected = new DateTime(2013, 2, 13, 0, 0);
        Meetup meetup = new Meetup(2, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_wednesteenth_of_june_2013() {
        DateTime expected = new DateTime(2013, 6, 19, 0, 0);
        Meetup meetup = new Meetup(6, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_thursteenth_of_may_2013() {
        DateTime expected = new DateTime(2013, 5, 16, 0, 0);
        Meetup meetup = new Meetup(5, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_thursteenth_of_june_2013() {
        DateTime expected = new DateTime(2013, 6, 13, 0, 0);
        Meetup meetup = new Meetup(6, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_thursteenth_of_september_2013() {
        DateTime expected = new DateTime(2013, 9, 19, 0, 0);
        Meetup meetup = new Meetup(9, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_friteenth_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 19, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_friteenth_of_august_2013() {
        DateTime expected = new DateTime(2013, 8, 16, 0, 0);
        Meetup meetup = new Meetup(8, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_friteenth_of_september_2013() {
        DateTime expected = new DateTime(2013, 9, 13, 0, 0);
        Meetup meetup = new Meetup(9, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_saturteenth_of_february_2013() {
        DateTime expected = new DateTime(2013, 2, 16, 0, 0);
        Meetup meetup = new Meetup(2, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_saturteenth_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 13, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_saturteenth_of_october_2013() {
        DateTime expected = new DateTime(2013, 10, 19, 0, 0);
        Meetup meetup = new Meetup(10, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_sunteenth_of_map_2013() {
        DateTime expected = new DateTime(2013, 5, 19, 0, 0);
        Meetup meetup = new Meetup(5, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_sunteenth_of_june_2013() {
        DateTime expected = new DateTime(2013, 6, 16, 0, 0);
        Meetup meetup = new Meetup(6, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_sunteenth_of_october_2013() {
        DateTime expected = new DateTime(2013, 10, 13, 0, 0);
        Meetup meetup = new Meetup(10, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.TEENTH)).isEqualTo(expected);
    }

    @Test
    public void test_first_monday_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 4, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_monday_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 1, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_tuesday_of_may_2013() {
        DateTime expected = new DateTime(2013, 5, 7, 0, 0);
        Meetup meetup = new Meetup(5, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_tuesday_of_june_2013() {
        DateTime expected = new DateTime(2013, 6, 4, 0, 0);
        Meetup meetup = new Meetup(6, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_wednesday_of_july_2013() {
        DateTime expected = new DateTime(2013, 7, 3, 0, 0);
        Meetup meetup = new Meetup(7, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_wednesday_of_august_2013() {
        DateTime expected = new DateTime(2013, 8, 7, 0, 0);
        Meetup meetup = new Meetup(8, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_thursday_of_september_2013() {
        DateTime expected = new DateTime(2013, 9, 5, 0, 0);
        Meetup meetup = new Meetup(9, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_thursday_of_october_2013() {
        DateTime expected = new DateTime(2013, 10, 3, 0, 0);
        Meetup meetup = new Meetup(10, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_friday_of_november_2013() {
        DateTime expected = new DateTime(2013, 11, 1, 0, 0);
        Meetup meetup = new Meetup(11, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_friday_of_december_2013() {
        DateTime expected = new DateTime(2013, 12, 6, 0, 0);
        Meetup meetup = new Meetup(12, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_saturday_of_january_2013() {
        DateTime expected = new DateTime(2013, 1, 5, 0, 0);
        Meetup meetup = new Meetup(1, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_saturday_of_february_2013() {
        DateTime expected = new DateTime(2013, 2, 2, 0, 0);
        Meetup meetup = new Meetup(2, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_sunday_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 3, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_first_sunday_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 7, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.FIRST)).isEqualTo(expected);
    }

    @Test
    public void test_second_monday_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 11, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_monday_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 8, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_tuesday_of_may_2013() {
        DateTime expected = new DateTime(2013, 5, 14, 0, 0);
        Meetup meetup = new Meetup(5, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_tuesday_of_june_2013() {
        DateTime expected = new DateTime(2013, 6, 11, 0, 0);
        Meetup meetup = new Meetup(6, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_wednesday_of_july_2013() {
        DateTime expected = new DateTime(2013, 7, 10, 0, 0);
        Meetup meetup = new Meetup(7, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_wednesday_of_august_2013() {
        DateTime expected = new DateTime(2013, 8, 14, 0, 0);
        Meetup meetup = new Meetup(8, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_thursday_of_september_2013() {
        DateTime expected = new DateTime(2013, 9, 12, 0, 0);
        Meetup meetup = new Meetup(9, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_thursday_of_october_2013() {
        DateTime expected = new DateTime(2013, 10, 10, 0, 0);
        Meetup meetup = new Meetup(10, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_friday_of_november_2013() {
        DateTime expected = new DateTime(2013, 11, 8, 0, 0);
        Meetup meetup = new Meetup(11, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_friday_of_december_2013() {
        DateTime expected = new DateTime(2013, 12, 13, 0, 0);
        Meetup meetup = new Meetup(12, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_saturday_of_january_2013() {
        DateTime expected = new DateTime(2013, 1, 12, 0, 0);
        Meetup meetup = new Meetup(1, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_saturday_of_february_2013() {
        DateTime expected = new DateTime(2013, 2, 9, 0, 0);
        Meetup meetup = new Meetup(2, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_sunday_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 10, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_second_sunday_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 14, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.SECOND)).isEqualTo(expected);
    }

    @Test
    public void test_third_monday_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 18, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_monday_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 15, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_tuesday_of_may_2013() {
        DateTime expected = new DateTime(2013, 5, 21, 0, 0);
        Meetup meetup = new Meetup(5, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_tuesday_of_june_2013() {
        DateTime expected = new DateTime(2013, 6, 18, 0, 0);
        Meetup meetup = new Meetup(6, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_wednesday_of_july_2013() {
        DateTime expected = new DateTime(2013, 7, 17, 0, 0);
        Meetup meetup = new Meetup(7, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_wednesday_of_august_2013() {
        DateTime expected = new DateTime(2013, 8, 21, 0, 0);
        Meetup meetup = new Meetup(8, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_thursday_of_september_2013() {
        DateTime expected = new DateTime(2013, 9, 19, 0, 0);
        Meetup meetup = new Meetup(9, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_thursday_of_october_2013() {
        DateTime expected = new DateTime(2013, 10, 17, 0, 0);
        Meetup meetup = new Meetup(10, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_friday_of_november_2013() {
        DateTime expected = new DateTime(2013, 11, 15, 0, 0);
        Meetup meetup = new Meetup(11, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_friday_of_december_2013() {
        DateTime expected = new DateTime(2013, 12, 20, 0, 0);
        Meetup meetup = new Meetup(12, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_saturday_of_january_2013() {
        DateTime expected = new DateTime(2013, 1, 19, 0, 0);
        Meetup meetup = new Meetup(1, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_saturday_of_february_2013() {
        DateTime expected = new DateTime(2013, 2, 16, 0, 0);
        Meetup meetup = new Meetup(2, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_sunday_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 17, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_third_sunday_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 21, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.THIRD)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_monday_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 25, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_monday_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 22, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_tuesday_of_may_2013() {
        DateTime expected = new DateTime(2013, 5, 28, 0, 0);
        Meetup meetup = new Meetup(5, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_tuesday_of_june_2013() {
        DateTime expected = new DateTime(2013, 6, 25, 0, 0);
        Meetup meetup = new Meetup(6, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_wednesday_of_july_2013() {
        DateTime expected = new DateTime(2013, 7, 24, 0, 0);
        Meetup meetup = new Meetup(7, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_wednesday_of_august_2013() {
        DateTime expected = new DateTime(2013, 8, 28, 0, 0);
        Meetup meetup = new Meetup(8, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_thursday_of_september_2013() {
        DateTime expected = new DateTime(2013, 9, 26, 0, 0);
        Meetup meetup = new Meetup(9, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_thursday_of_october_2013() {
        DateTime expected = new DateTime(2013, 10, 24, 0, 0);
        Meetup meetup = new Meetup(10, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_friday_of_november_2013() {
        DateTime expected = new DateTime(2013, 11, 22, 0, 0);
        Meetup meetup = new Meetup(11, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_friday_of_december_2013() {
        DateTime expected = new DateTime(2013, 12, 27, 0, 0);
        Meetup meetup = new Meetup(12, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_saturday_of_january_2013() {
        DateTime expected = new DateTime(2013, 1, 26, 0, 0);
        Meetup meetup = new Meetup(1, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_saturday_of_february_2013() {
        DateTime expected = new DateTime(2013, 2, 23, 0, 0);
        Meetup meetup = new Meetup(2, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_sunday_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 24, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_fourth_sunday_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 28, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.FOURTH)).isEqualTo(expected);
    }

    @Test
    public void test_last_monday_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 25, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_monday_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 29, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(MONDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_tuesday_of_may_2013() {
        DateTime expected = new DateTime(2013, 5, 28, 0, 0);
        Meetup meetup = new Meetup(5, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_tuesday_of_june_2013() {
        DateTime expected = new DateTime(2013, 6, 25, 0, 0);
        Meetup meetup = new Meetup(6, 2013);
        assertThat(meetup.day(TUESDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_wednesday_of_july_2013() {
        DateTime expected = new DateTime(2013, 7, 31, 0, 0);
        Meetup meetup = new Meetup(7, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_wednesday_of_august_2013() {
        DateTime expected = new DateTime(2013, 8, 28, 0, 0);
        Meetup meetup = new Meetup(8, 2013);
        assertThat(meetup.day(WEDNESDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_thursday_of_september_2013() {
        DateTime expected = new DateTime(2013, 9, 26, 0, 0);
        Meetup meetup = new Meetup(9, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_thursday_of_october_2013() {
        DateTime expected = new DateTime(2013, 10, 31, 0, 0);
        Meetup meetup = new Meetup(10, 2013);
        assertThat(meetup.day(THURSDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_friday_of_november_2013() {
        DateTime expected = new DateTime(2013, 11, 29, 0, 0);
        Meetup meetup = new Meetup(11, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_friday_of_december_2013() {
        DateTime expected = new DateTime(2013, 12, 27, 0, 0);
        Meetup meetup = new Meetup(12, 2013);
        assertThat(meetup.day(FRIDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_saturday_of_january_2013() {
        DateTime expected = new DateTime(2013, 1, 26, 0, 0);
        Meetup meetup = new Meetup(1, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_saturday_of_february_2013() {
        DateTime expected = new DateTime(2013, 2, 23, 0, 0);
        Meetup meetup = new Meetup(2, 2013);
        assertThat(meetup.day(SATURDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_sunday_of_march_2013() {
        DateTime expected = new DateTime(2013, 3, 31, 0, 0);
        Meetup meetup = new Meetup(3, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }

    @Test
    public void test_last_sunday_of_april_2013() {
        DateTime expected = new DateTime(2013, 4, 28, 0, 0);
        Meetup meetup = new Meetup(4, 2013);
        assertThat(meetup.day(SUNDAY, MeetupSchedule.LAST)).isEqualTo(expected);
    }
}
