package pointmutations

func HammingDistance(strand1, strand2 string) (count int) {
	strand2Runes := []rune(strand2)
	for i, nucleotide := range strand1 {
		if i >= len(strand2) {
			return
		}
		if strand2Runes[i] != nucleotide {
			count++
		}
	}
	return
}
