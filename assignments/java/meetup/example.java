import org.joda.time.DateTime;

public class Meetup {
    private final DateTime startOfMonth;

    public Meetup(int monthOfYear, int year) {
        startOfMonth = new DateTime(year, monthOfYear, 1, 0, 0);
    }

    DateTime day(int dayOfWeek, MeetupSchedule schedule) {
        DateTime current = cycleToNext(dayOfWeek, startOfMonth);
        switch (schedule) {
            case FIRST:
                break;
            case SECOND:
                current = current.plusWeeks(1);
                break;
            case THIRD:
                current = current.plusWeeks(2);
                break;
            case FOURTH:
                current = current.plusWeeks(3);
                break;
            case TEENTH:
                while (current.getDayOfMonth() < 13) {
                    current = current.plusWeeks(1);
                }
                break;
            case LAST:
                current = cycleToPrev(dayOfWeek, startOfMonth.plusMonths(1).minusDays(1));
                break;
            default:
                return null;
        }
        return current;
    }

    private DateTime cycleToPrev(int dayOfWeek, DateTime current) {
        while (current.getDayOfWeek() != dayOfWeek) {
            current = current.minusDays(1);
        }
        return current;
    }

    private DateTime cycleToNext(int dayOfWeek, DateTime current) {
        while (current.getDayOfWeek() != dayOfWeek) {
            current = current.plusDays(1);
        }
        return current;
    }
}
