package accumulate

func Accumulate(s []string, f func(st string) string) (result []string) {
	for _, v := range s {
		result = append(result, []string{f(v)}...)
	}
	return result
}
