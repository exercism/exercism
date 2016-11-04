# Getting Involved in an Exercism Language Track

[repositories]: http://exercism.io/repositories
[triaging-issues]: /docs/triaging-issues-in-a-track.md
[reviewing-prs]: /docs/reviewing-a-pull-request.md
[porting]: /docs/porting-an-exercise.md
[xcommon]: http://github.com/exercism/x-common
[blazon]: /docs/improving-consistency-across-tracks.md

The Exercism language tracks are a great way to get involved in:

- a programming language you love
- a programming language you're curious about
- open source (in general)

Each language track lives in its own repository, which means that you can contribute
to a track without having to know anything about the rest of the Exercism ecosystem.

Also, each track is focused, containing implementations of trivial exercises and the tools
to make development easier, so there's no big codebase to get acquainted with.

## Submit a Couple of Solutions

If you haven't used Exercism before, then we recommend submitting solutions to a couple of
exercises. It doesn't matter which language track you submit to, it's just to get a feel
for what a language track consists of.

## Watch The Track Repository

If you haven't picked a language you want to contribute to yet, check out the list of [language tracks
and their respective repositories][repositories].

Then go to the repository for the language you've chosen, click the _Watch_ button, and select _Watching_.
This will notify you of any new issues, pull requests, or comments in the repository, which is a great way
of getting acquainted with the people involved and the issues that tend to come up.

## Orient Yourself

Read the README, and look through the open issues and pull requests, and get a feel for what's going on.

## Contribute!

There are a number of ways to contribute to a track. All of them are sorely needed, and greatly appreciated!

### Triaging Issues

A great issue is detailed and actionable. When they're not, you can help ask the questions to make them so.

For more detailed suggestions about things to keep in mind when triaging, check out [this documentation][triaging-issues].

### Reviewing Pull Requests

We always need more eyeballs on pull requests. On language tracks most pull requests tend to be related to
the exercises themselves, and we have [detailed documentation][reviewing-prs] that should help
you get started with code reviews.

### Porting an Exercise

The easiest way to add a new exercise is to find an exercise that has already been implemented in another language
track, and port it over to your target language.

We've got [a guide][porting] that walks you through how to find an exercise to port, and the things to
keep in mind when implementing it.

### Reordering Exercises

We don't really have a formal process for deciding what order exercises should be in. The order is decided by the
order of the `exercises` array in the `config.json` file in the track repository.

As you do the exercises in a track, keep an eye on how you feel about an exercise.

* If it's **too easy**, move it higher up in the array.
* If it's **too hard**, move it further down in the array.
* If two exercises are **too similar** then move one of them so that there are some different exercises between them.

We can also deprecate an exercise by removing it from the `exercises` array and adding the slug to the `deprecated` key,
which is also in the `config.json` file.

### Improving the Contributing Documentation

It's not always obvious how to get started contributing to a language track. As you get involved, help improve the
README in the track repository.

* Are there undocumented dependencies?
* How do you run the tests? Is there a way to run all the tests for all the exercises?
* Are there any naming conventions for files or types or classes or functions?
* Is there any tooling that we're using? Linters?
* Is there continuous integration? Are there any gotchas?

### Improving the Curriculum

Sometimes people run into edge cases. If you're considering adding a new test, open a discussion in the [x-common][xcommon]
repository and get other track implementors' feedback on whether this makes sense. It might make sense only for this track,
or perhaps it would be an improvement to all the various language tracks that have this exercise. If so then we'll want to

- hash out all the details together
- add it to the canonical data for the exercise (if it exists)
- submit an issue to all the tracks that implement the exercise

We have a [tool and a process][blazon] for doing that.
