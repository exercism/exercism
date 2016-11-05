# Improving Consistency Across Tracks

[blazon]: https://github.com/exercism/blazon
[x-common]: https://github.com/exercism/x-common/tree/master/exercises

## Canonical Data

Each exercise has a generic, language-agnostic problem description, which
can then be implemented in any of the Exercism language tracks.

A great test suite will help people solve the problem gradually.

We want to avoid

* too much redundancy
* steps that are too big

Once we've found a good set of tests, we formalize the inputs and outputs and
store it in a file called `canonical-data.json` alongside the language-agnostic
problem description in the [x-common][] repository.

Some things vary from language to language, so don't feel constrained to
implementing exactly what is in the `canonical-data.json` file.

## Evolving Exercises

Over time we find that the problem definitions can be improved in various ways.

When they do, we need to notify all of the tracks that have an implementation
of that problem so that they can update it.

We've built some tooling for this, [blazon][blazon], to make it easier to manage.

The process goes like this:

**Open an issue** in the x-common repository describing the problem, the fix,
and the reasoning behind it. Link to any relevant discussions. This is the _parent
issue_.

In the comment of the issue, **draft the body of an issue** which will be
submitted to each of the language tracks that have implemented this problem.

This should contain:

- a description of the edge case or change
- explicit instructions about what change to make
- a note saying "if this isn't relevant in this language track, close the
  issue"
- a link to the canonical data (if it exists)
- a link to the parent issue.

Linking back to the parent issue is important for two reasons:

1. It provides context. If someone wants to know more about the issue,
   they can follow links to read the history.
2. It will show a _living TODO list_. The parent issue will have a list
   of links to the open issues, showing whether the issue is open or
   closed. Once all of the child issues are closed, then we can
   close the parent issue.

It's worth drafting this in a comment because other people will often weigh in
to help make it as clear as possible, or add any missing context, and it's
easier to fix this _before_ it get submitted to a bajillion different repos.

**Create a text file** containing the issue template that you drafted.

The first line of the file will be used as the issue title. Make it
descriptive. It should contain the slug of the relevant exercise.

**Download [blazon][blazon]** and use it to submit the issue.

    $ blazon -exercise=<slug> -file=<filename>

