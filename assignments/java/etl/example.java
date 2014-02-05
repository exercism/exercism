import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Etl {
    public Map<String, Integer> transform(Map<Integer, List<String>> old) {
        final Map<String, Integer> result = new HashMap<String, Integer>();
        for (Map.Entry<Integer, List<String>> e : old.entrySet()) {
            for (String s : e.getValue()) {
                result.put(s.toLowerCase(), e.getKey());
            }
        }
        return result;
    }
}
