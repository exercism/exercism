package phonenumber

import (
	"fmt"
	"regexp"
	"strings"
)

func Number(in string) (ret string) {
	re := regexp.MustCompile("[^0-9]*")
	ret = re.ReplaceAllString(in, "")
	if len(ret) < 10 || !strings.HasPrefix(ret, "1") {
		ret = "0000000000"
	}
	return
}

func AreaCode(in string) string {
	return in[0:3]
}

func Format(in string) (ret string) {
	format := "(%s) %s-%s"
	if len(in) == 10 {
		ret = fmt.Sprintf(format, AreaCode(in), in[3:6], in[6:])
	} else {
		ret = fmt.Sprintf(format, in[1:4], in[4:7], in[7:])
	}
	return
}
