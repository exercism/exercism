## Installing Go

Follow the instructions for your system on the installation page at [golang.org](http://golang.org/doc/install).

## Running tests

Go exercises within your exercism project directory can be run by changing to the exercise directory, and running `go test`.

```bash
$ cd exercism/project/directory/go/bob
$ go test
```

## Benchmarks

Many test suites contain benchmarks that allow you to easily determine how changes to your solution affect its performance.
Use the command below to run the benchmarks:

```bash
$ go test -bench exercism/project/directory/go/exercise-name
```

## Linting

Remember to run [`go fmt`](http://blog.golang.org/go-fmt-your-code) on your code before submitting it.

You might also look at [`golint`](https://github.com/golang/lint) and [`go vet`](http://godoc.org/code.google.com/p/go.tools/cmd/vet), which warn about potential problems in your code.

## Recommended Learning Resources

Exercism provides exercises and feedback but can be difficult to jump into for those learning Go for the first time. These resources can help you get started:

* [A Tour of Go](http://tour.golang.org)
* [Go By Example](https://gobyexample.com/)
* [Go Language Documentation](http://golang.org/pkg/)
* [StackOverflow](http://stackoverflow.com/)
