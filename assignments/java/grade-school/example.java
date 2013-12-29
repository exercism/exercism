import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

public class School {

  private final Map<Integer, Set<String>> database = new HashMap<Integer, Set<String>>();

  public Map<Integer, Set<String>> db() {
    // Leaks internal storage to caller
    return database;
  }

  public void add(String student, int grade) {
    Set<String> students = grade(grade);
    students.add(student);
  }

  public Set<String> grade(int grade) {
    // Leaks internal storage to caller
    if (!database.containsKey(grade)) {
      database.put(grade, new TreeSet<String>());
    }
    return database.get(grade);
  }

  public Map<Integer, List<String>> sort() {
    Map<Integer, List<String>> sortedStudents = new HashMap<Integer, List<String>>();
    for (Integer grade : database.keySet()) {
      // Relies on using a TreeSet internally
      List<String> sortedGrade = new ArrayList<String>(database.get(grade));
      sortedStudents.put(grade, sortedGrade);
    }
    return sortedStudents;
  }
}
