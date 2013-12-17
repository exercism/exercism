import java.util.*;

public class Anagram {

    final private AnagramSubject anagramSubject;

    public Anagram(String word) {
        anagramSubject = new AnagramSubject(word);
    }

    public List<String> match(List<String> candidates) {
        List<String> anagrams = new ArrayList<String>();

        for (String candidate : candidates) {
            if (anagramSubject.anagramOf(candidate)) {
                anagrams.add(candidate);
            }
        }

        return anagrams;
    }

    static final class AnagramSubject {

        private String word;
        final private char[] fingerprint;

        public AnagramSubject(String other) {
            this.word = other;
            this.fingerprint = canonicalize(other);
        }

        public boolean anagramOf(String other) {
            return !duplicate(other) && Arrays.equals(fingerprint,canonicalize(other));
        }

        private boolean duplicate(String other) {
            return word.equalsIgnoreCase(other);
        }

        private char[] canonicalize(String other) {
            char[] chars = other.toLowerCase().toCharArray();
            Arrays.sort(chars);
            return chars;
        }
    }
}

