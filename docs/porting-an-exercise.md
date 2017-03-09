# Porting an Exercise to Another Language Track

[x-common]: http://github.com/exercism/x-common/tree/master/exercises
[support-chat]: https://gitter.im/exercism/support
[topics]: https://github.com/exercism/x-common/blob/master/TOPICS.txt
[configlet]: https://github.com/exercism/configlet#configlet

Exercism has a lot of exercises in a lot of languages.

There is a common pool of problem definitions, which can be implemented in any
of the language tracks.

The language-agnostic definition lives in the [x-common][] repository, within
the `exercises/` directory:

    /exercises/$SLUG/
    ├── canonical-data.json (OPTIONAL)
    ├── description.md
    └── metadata.yml

The shared data will always have a `description.md` file which contains the basic
problem specification, and which later gets used to generate the README for the
exercises.

The `metadata.yml` contains a summary (or "blurb") of the exercise, as well as
attribution and some other handy things that get used in various places.

For some exercises we have defined a `canonical-data.json` file. If this exists
then you won't need to go look at implementations in other languages. This will
contain the implementation notes and test inputs and outputs that you'll need
to create a test suite in your target language.

## Finding an Exercise to Port

Navigate to the language track on Exercism via the [http://exercism.io/languages](http://exercism.io/languages) page.

The last item in the sidebar will be about contributing. Go to that section.

This is a full list of every exercise that exists, but has not yet been implemented
in that language track.

For every exercise it will link to:

- The generic README.
- The canonical data (if it exists).
- All the individual language implementations.

## Avoiding Duplicate Work

When you decide to implement an exercise, first check that there are no open pull requests
for the same exercise.

Then open a "work in progress" (WIP) pull request, so others will see that you're working on it.

The way to open a WIP pull request even if you haven't done any work yet is:

* Fork and clone the repository.
* Check out a branch for the exercise.
* Add an empty commit `git commit --allow-empty -m "Implement exercise <slug>"`
  (replace <slug> with the actual name of the exercise).
* Push the new branch to your repository, and open a pull request against that branch.

Once you have added the actual exercise, then you can rebase your branch onto the upstream
master, which will make the WIP commit go away.

## Implementing the Exercise

You'll need to find the `slug` for the exercise. That's the URL-friendly identifier
for an exercise that is used throughout all of Exercism.

**The name of the exercise directory in the [x-common][] repository is the slug.**

Create a new directory named after the slug in the `exercises` directory of the language
track repository.

The exercise should consist of, at minimum:

* A test suite.
* A reference solution that passes the tests.

Each language track might have additional requirements; check the README in
the repository for the track.

### The Test Suite

Look at the other exercises in the track to get an idea of:

* The conventions used.
* How to name the test file.

### The Reference Solution

The reference solution is named something with `example` or `Example` in the path.

Again, check the other exercises to see what the naming pattern is.

The solution does not need to be particularly great code, it is only used to verify
that the exercise is coherent.

### Configuring the Exercise

Add a new entry in the `exercises` key in the `config.json` file in the root of the repository.

Add the slug, estimate the difficulty level. Topics are optional, but can be really helpful.


    {
      "slug": <slug>,
      "difficulty": <a number from 1 to 10>,
      "topics": [ ]
    }

Take a look at the (non-exhaustive) [topics list][topics] and see if any of these make sense.

We have a tool, [configlet][configlet] that will help make sure that everything is configured right.
Download that and run it against the track repository.

### Submitting a Pull Request

Rebase against the most recent upstream master, and submit a pull request.

If you have questions your best bet is the [support chat][support-chat]. Once you
figure it out, if you could help improve this documentation, that would be great!

### Providing Feedback on the Site for an Exercise You Implemented

Once you've created an exercise, you'll probably want to provide feedback to people who
submit solutions to it. By default you only get access to exercises you've submitted
a solution for.

You can fetch the problem using the CLI:

```bash
$ exercism fetch <track_id> <slug>
```

Go ahead and submit the reference solution that you wrote when creating the problem.
Remember to archive it if you don't want other people to comment on it.
