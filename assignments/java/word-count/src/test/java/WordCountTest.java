import org.junit.Test;

import java.lang.Integer;
import java.lang.String;
import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.*;

public class WordCountTest {

    private final WordCount wordCount = new WordCount();

    @Test
    public void countOneWord() {
        Map<String, Integer> actualWordCount = new HashMap<String, Integer>();
        final Map<String, Integer> expectedWordCount = new HashMap<String, Integer>();
        expectedWordCount.put("word", 1);

        actualWordCount = wordCount.Phrase("word");
        assertEquals(
            expectedWordCount, actualWordCount
        );
    }

    @Test
    public void countOneOfEach() {
        Map<String, Integer> actualWordCount = new HashMap<String, Integer>();
        final Map<String, Integer> expectedWordCount = new HashMap<String, Integer>();
        expectedWordCount.put("one", 1);
        expectedWordCount.put("of", 1);
        expectedWordCount.put("each", 1);

        actualWordCount = wordCount.Phrase("one of each");
        assertEquals(
            expectedWordCount, actualWordCount
        );
    }

    @Test
    public void countMultipleOccurences() {
        Map<String, Integer> actualWordCount = new HashMap<String, Integer>();
        final Map<String, Integer> expectedWordCount = new HashMap<String, Integer>();
        expectedWordCount.put("one", 1);
        expectedWordCount.put("fish", 4);
        expectedWordCount.put("two", 1);
        expectedWordCount.put("red", 1);
        expectedWordCount.put("blue", 1);

        actualWordCount = wordCount.Phrase("one fish two fish red fish blue fish");
        assertEquals(
            expectedWordCount, actualWordCount
        );
    }

    @Test
    public void ignorePunctuation() {
        Map<String, Integer> actualWordCount = new HashMap<String, Integer>();
        final Map<String, Integer> expectedWordCount = new HashMap<String, Integer>();
        expectedWordCount.put("car", 1);
        expectedWordCount.put("carpet", 1);
        expectedWordCount.put("as", 1);
        expectedWordCount.put("java", 1);
        expectedWordCount.put("javascript", 1);

        actualWordCount = wordCount.Phrase("car : carpet as java : javascript!!&@$%^&");
        assertEquals(
            expectedWordCount, actualWordCount
        );

    }

    @Test
    public void includeNumbers() {
        Map<String, Integer> actualWordCount = new HashMap<String, Integer>();
        final Map<String, Integer> expectedWordCount = new HashMap<String, Integer>();
        expectedWordCount.put("testing", 2);
        expectedWordCount.put("1", 1);
        expectedWordCount.put("2", 1);

        actualWordCount = wordCount.Phrase("testing, 1, 2 testing");
        assertEquals(
            expectedWordCount, actualWordCount
        );
    }

    @Test
    public void normalizeCase() {
        Map<String, Integer> actualWordCount = new HashMap<String, Integer>();
        final Map<String, Integer> expectedWordCount = new HashMap<String, Integer>();
        expectedWordCount.put("go", 3);

        actualWordCount = wordCount.Phrase("go Go GO");
        assertEquals(
            expectedWordCount, actualWordCount
        );
    }

}
