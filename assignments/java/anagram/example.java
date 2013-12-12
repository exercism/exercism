import java.util.*;

public class Anagram {

    private AnagramSubject subject;

    public Anagram(String word) {
        subject = new AnagramSubject(word);
    }

    public List<String> match(List<String> candidates) {
        List<String> anagrams = new ArrayList<String>();

        for (String candidate : candidates) {
            if (subject.anagramOf(candidate)) {
                anagrams.add(candidate);
            }
        }

        return anagrams;
    }

    class AnagramSubject {

        private String subject;
        private char[] fingerprint;

        public AnagramSubject(String word) {
            this.subject = word;
            this.fingerprint = canonicalize(word);
        }

        public boolean anagramOf(String word) {
            return !duplicate(word) && Arrays.equals(fingerprint,(canonicalize(word)));
        }

        private boolean duplicate(String word) {
            return subject.equalsIgnoreCase(word);
        }

        private char[] canonicalize(String word) {
            char[] chars = word.toLowerCase().toCharArray();
            Arrays.sort(chars);
            return chars;
        }
    }
}

