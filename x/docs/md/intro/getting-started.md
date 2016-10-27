1. [Sign up](/login?return_path=/how-it-works) via GitHub.
1. Select the language you wish to practice. See [language tracks](/languages).
1. Download and configure the [command-line client](/cli).
1. Fetch the first exercise (`exercism fetch TRACK_ID`).
1. Write a solution to make the test suite pass.
1. Submit your solution (`exercism submit path/to/file`).
1. _Optional_: Kick off the discussion by noting what you found interesting or challenging about the exercise.

### Next Steps

Once you have submitted your first exercise, there are several other things you can do:

1. Iterate on your solution. Integrate feedback. Try other approaches.
1. Browse other solutions to the same problem.
   Provide feedback: ask questions, suggest improvements, and ponder style and readability.
1. Fetch a new exercise and solve it.

## Command Line Tips

You can submit multiple files as part of your solution:

```
$ cd path/to/solution/
$ exercism submit file1 file2
```

Another way to submit a header file along with your implementation file:
`exercism submit path/to/file{.headerExtension,.ImplementationExtension}`
This works with shells like `bash` on the language tracks like C `file{.h,.m}` or C++ `file{.h,.cpp}` etc.

