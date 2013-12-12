import static org.hamcrest.CoreMatchers.*;
import static org.junit.matchers.JUnitMatchers.*;
import static org.junit.Assert.*;

import java.util.*;
import org.junit.*;

public class AnagramTest {

    @Test
    public void testNoMatches() {
        Anagram detector = new Anagram("diaper");
        assertTrue(detector.match(Arrays.asList("hello", "world", "zombies", "pants")).isEmpty());
    }

    @Test
    public void testSimpleAnagram() {
        Anagram detector = new Anagram("ant");
        List<String> anagram = detector.match(Arrays.asList("tan", "stand", "at"));
        assertThat(anagram, hasItems("tan"));
    }

    @Test
    public void testDetectMultipleAnagrams() {
        Anagram detector = new Anagram("master");
        List<String> anagrams = detector.match(Arrays.asList("stream", "pigeon", "maters"));
        assertThat(anagrams, hasItems("maters", "stream"));
    }

    @Test
    public void testDoesNotConfuseDifferentDuplicates() {
        Anagram detector = new Anagram("galea");
        List<String> anagrams = detector.match(Arrays.asList("eagle"));
        assertTrue(anagrams.isEmpty());
    }

    @Test
    public void testIdenticalWordIsNotAnagram() {
        Anagram detector = new Anagram("corn");
        List<String> anagrams = detector.match(Arrays.asList("corn", "dark", "Corn", "rank", "CORN", "cron", "park"));
        assertThat(anagrams, hasItems("cron"));
    }

    @Test
    public void testEliminateAnagramsWithSameChecksum() {
        Anagram detector = new Anagram("mass");
        assertTrue(detector.match(Arrays.asList("last")).isEmpty());
    }

    @Test
    public void testEliminateAnagramSubsets() {
        Anagram detector = new Anagram("good");
        assertTrue(detector.match(Arrays.asList("dog", "goody")).isEmpty());
    }

    @Test
    public void testDetectAnagrams() {
        Anagram detector = new Anagram("listen");
        List<String> anagrams = detector.match(Arrays.asList("enlists", "google", "inlets", "banana"));
        assertThat(anagrams, hasItems("inlets"));
    }

    @Test
    public void testMultipleAnagrams() {
        Anagram detector = new Anagram("allergy");
        List<String> anagrams = detector.match(Arrays.asList("gallery", "ballerina", "regally", "clergy", "largely", "leading"));
        assertThat(anagrams, hasItems("gallery", "largely", "regally"));
    }

    @Test
    public void testAnagramsAreCaseInsensitive() {
        Anagram detector = new Anagram("Orchestra");
        List<String> anagrams = detector.match(Arrays.asList("cashregister", "Carthorse", "radishes"));
        assertThat(anagrams, hasItems("Carthorse"));
    }

}
