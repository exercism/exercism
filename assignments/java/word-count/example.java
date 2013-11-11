import java.lang.Integer;
import java.lang.String;
import java.util.HashMap;
import java.util.Map;

public class WordCount {

    public Map<String, Integer> Phrase( String input ) {
        Map<String, Integer> countMap = new HashMap<String, Integer>();
        input = input.trim().toLowerCase().replaceAll("[\\W]", " ");
        final String[] tokenizedInput = input.split("\\s+");
        for( String aWord : tokenizedInput ) {
            Integer count = countMap.get(aWord);
            countMap.put(aWord, count == null ? 1 : count + 1 );
        }
        return countMap;
    }

}
