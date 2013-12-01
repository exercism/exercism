package atbash

import(
	"strings"
	"regexp"
)

var alphabet = "abcdefghijklmnopqrstuvwxyz"

func Atbash(s string) string {
	return chunk(convert(normalize(s)))
}

func chunk(s string) string {
	reg, _ := regexp.Compile(".{1,5}")
	value := reg.FindAllString(s, -1)
	s = strings.Join(value, " ")
	return s
}

func convert(s string) string {
	key := reverse(alphabet)
	inputSlice := strings.Split(s, "")
	originalSlice := strings.Split(alphabet, "")
	reversedSlice := strings.Split(key, "")
	result := ""
	for i := 0; i < len(s); i++ {
		char := inputSlice[i]
		index := indexOf(originalSlice, char)
		result = result + reversedSlice[index]
	}
	return result
}

func normalize(s string) string {
	s = strings.ToLower(s)
	reg, _ := regexp.Compile("[^a-z0-9]")
	s = reg.ReplaceAllString(s, "")
	return s
}

func reverse(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}

func indexOf(slice []string, string string) int {
	for p, v := range slice {
		if (v == string) {
			return p
		}
	}
	return -1
}
