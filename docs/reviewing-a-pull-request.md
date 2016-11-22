# Reviewing a Pull Request

This guide is about reviewing pull requests on Exercism language tracks.

## Philosophy

* **Respond Kindly** We want every contributor to be glad they are here, even if we don't ultimately merge their pull request.
* **Respond Quickly** Promptness encourages frequent, high-quality contributions from community members and other maintainers.
* **Resolve Quickly** A pull request should either be actively in-progress, or it should be merged or closed.

Closing pull requests kindly is not easy. Two great articles about this are:

* [Kindly Closing Pull Requests](https://github.com/blog/2124-kindly-closing-pull-requests) by Mike McQuaid
* [The Art of Closing](https://blog.jessfraz.com/post/the-art-of-closing/) by Jessie Frazelle

## Reviewing an Exercism Exercise

When reviewing a pull request, always remember the past. That is, remember that numerous users have already submitted an exercise and any significant change to an exercise invalidates their submissions to some extent.

That said, we should not be afraid to change things for the better.

If the tests do change significantly enough to break existing solutions, it's worth calling it out so that we can discuss whether or not the change is worth it in this particular case.

### Consider the Structural Requirements

We have a tool, [`configlet`](https://github.com/exercism/configlet#configlet), which does track-level linting. This runs on Travis CI when a pull request is submitted.

The tool checks the following (so you don't have to):

- Is the `config.json` file syntactically correct?
- Does the `config.json` list the correct exercises?
    - Has every exercise listed been implemented?
    - Has every implemented exercise been added to the config?
    - Have any exercises been implemented that shouldn't have been? E.g. exercises that are inappropriate or uninteresting in the language.
- Is the example solution named with `/example/i` in the path? If not that file will be served when people fetch the exercise.

You can also [download it](https://github.com/exercism/configlet/releases/latest) and run it locally.

Things that the tool does not yet do, and which should be checked:

- Is the test file named correctly, per the guidelines in the language track? (TODO: add to `configlet`)
- Does the directory name of the exercise match that of [an existing, known exercism exercise slug](https://github.com/exercism/x-common/tree/master/exercises)?

If there is no automated checking, then you should also verify:

- Do the tests pass against the example solution?

### Consider Future Maintainers

- Does the commit message contain the [exercise slug](https://github.com/exercism/x-common/blob/master/CONTRIBUTING.md#updating-a-generic-problem-description)?
- Does the commit message explain _why_ the change was made?

### Consider the User Experience

- Is the exercise listed too early in the list? Too late?
- Is the exercise too similar to the ones just before or after it?
- Are the tests forcing people towards a particular implementation?
- Are the tests ordered so that they encourage incremental changes?
- Do the test names help the user understand the _why_ of the requirement?
- Will the test failures make sense to the person trying to solve the problem?
- Does the exercise pull in unnecessary dependencies?
- Have all but the first test been skipped? (Only for tracks that use `pending` or `skip` or `ignore` directives)
- If the exercise introduced difficult language features, is there a `HINTS.md` file that points to some good documentation about it?
- Do the tests use the data from the [`canonical-data.json`](https://github.com/exercism/x-common#test-data-format-canonical-datajson) file (if it exists)? Are any of the deviations from `canonical-data.json` generally useful to other language tracks? _If so, consider submitting them back to the x-common repository._

There is usually no right answer, and sometimes the best answer is "I don't know, we'll see."
If it seems good enough we can merge it. It can always be improved later.

### Encourage Best Practices

Consider the tests carefully. They are the public-facing product. These should follow language-idioms and make good use of the standard library.

When reviewing pull requests, try to coach the contributor towards a better solution. Try not to prescribe changes outright. Ask questions, be curious, and remember that their perspective might be just as valid as yours.

Exercism should generally adhere to the idioms of a language. However, that should not stand in the way of implementing a great exercise.

The example solution is not public-facing, and as long as it passes the tests, we can let it in.

## Reviewing Changes to Track Tooling

Changes to tooling are not user-facing, but anything that is weird or complicated will make it harder to contribute to the track.

---------

Inspired by the ["reviewing a pull request"](https://github.com/jekyll/jekyll/blob/master/docs/_docs/maintaining/reviewing-a-pull-request.md) documentation in the Jekyll project.
