import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.*;

import org.junit.Test;

public class HammingTest {
    
    @Test
    public void testNoDifferenceBetweenIdenticalStrands() {
        assertThat(Hamming.compute("A", "A"), is(0));
    }

    @Test
    public void testCompleteHammingDistanceOfForSingleNucleotideStrand() {
        assertThat(Hamming.compute("A", "G"), is(1));
    }

    @Test
    public void testCompleteHammingDistanceOfForSmallStrand() {
        assertThat(Hamming.compute("AG", "CT"), is(2)); 
    }

    @Test
    public void testSmallHammingDistance() {
        assertThat(Hamming.compute("AT", "CT"), is(1));
    }

    @Test
    public void testSmallHammingDistanceInLongerStrand() {
        assertThat(Hamming.compute("GGACG", "GGTCG"), is(1));
    }

    @Test
    public void testIgnoresExtraLengthOnFirstStrandWhenLonger() {
        assertThat(Hamming.compute("AAAG", "AAA"), is(0));
    }

    @Test
    public void testIgnoresExtraLengthOnOtherStrandWhenLonger() {
        assertThat(Hamming.compute("AAA", "AAAG"), is(0));
    }

    @Test
    public void testLargeHammingDistance() {
        assertThat(Hamming.compute("GATACA", "GCATAA"), is(4));
    }

    @Test
    public void testHammingDistanceInVeryLongStrand() {
        assertThat(Hamming.compute("GGACGGATTCTG", "AGGACGGATTCT"), is(9));
    }

}
