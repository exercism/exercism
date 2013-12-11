public class Hamming {

    public static int compute(String leftStrand, String rightStrand) {
        final int length = Math.min(leftStrand.length(), rightStrand.length());
        int distance = 0;
        for (int i = 0; i < length; i++) {
          distance += hammingContributionAt(i, leftStrand, rightStrand);
        }

        return distance;
    }

    private static int hammingContributionAt(int index, String leftStrand, String rightStrand) {
      return leftStrand.charAt(index) != rightStrand.charAt(index) ? 1 : 0;
    }

}
