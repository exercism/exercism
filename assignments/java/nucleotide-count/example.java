import java.util.HashMap;
import java.util.Map;

public final class DNA {
  private final String sequence;

  public DNA(String sequence) {
    this.sequence = sequence;
  }

  public int count(char base) {
    if (isCountable(base))
      throw new IllegalArgumentException(base + " is not a nucleotide");

    try {
      return nucleotideCounts().get(base);
    } catch (NullPointerException e) {
      return 0;
    }
  }

  private static boolean isCountable(char base) {
    final String COUNTABLE_NUCLEOTIDES = "ACGTU";
    return COUNTABLE_NUCLEOTIDES.indexOf(base) == -1;
  }

  public Map<Character, Integer> nucleotideCounts() {
    Map<Character, Integer> counts = emptyCounts();
    for (char c : sequence.toCharArray()) {
      counts.put(c, counts.get(c) + 1);
    }
    return counts;
  }

  private static Map<Character, Integer> emptyCounts() {
    Map<Character, Integer> counts = new HashMap<Character, Integer>();
    counts.put('A', 0);
    counts.put('C', 0);
    counts.put('T', 0);
    counts.put('G', 0);
    return counts;
  }
}
