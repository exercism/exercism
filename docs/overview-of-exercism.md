# Overview of Exercism

Exercism—as an open source project—has two distinct parts.

1. The Product
2. The Curriculum

Most open source projects are code that people incorporate into their own projects. They're tools and components used to build software: libraries and frameworks, packages and infrastructure.

Exercism is unusual in the open source landscape. Exercism isn't a component or infrastructure. Exercism is an experience targeted at the end-user.

If you want to follow along on the high-level goings-on on the Exercism project, watch the [discussions][] repository, and sign up for the [newsletter][].

## The Product

The product consists of a website and a command-line client (CLI).

We are currently investing our efforts in design research and product design.

While we welcome fixes and improvements to the existing site, we are taking a step back from it and doing design research from scratch. You can read more about this in the article [The Delightful Design of Exercism][design-of-exercism].

The website lives in the [exercism/exercism.io][exercism-io] GitHub repository, whereas the CLI is in [exercism/cli][cli].

## The Curriculum

The curriculum is much more like a traditional open source project than the product is. It consists of many small, well-defined components, and it is a lot easier to contribute to.

The goal of the curriculum is to create many small, trivial exercises. These provide lots of achievable challenges, giving people many small wins.

There is a common pool of exercises and the exercises are implemented in many different programming languages.

We have a library, [Trackler][trackler], that provides a unified interface to the entire curriculum.

### The Common Pool

An exercise is a description of a problem to solve. This description is not specific to any particular programming language or library or tool.

An example is:

> Determine whether or not a word is an [isogram][].

You could do this on the back of a napkin, or on a whiteboard, or by writing code.

There are many ways to contribute to the common pool:

- fix typos
- improve exercise descriptions
- document edge cases
- discuss philosophical questions
- make up more exercises
- define canonical data-sets to make it easier to implement the exercise

The common pool is maintained in the [exercism/x-common][x-common] repository.

### The Language Tracks

A programming language that implements exercises from the common pool is called a _language track_.

A language-specific implementation of an exercise consists of a collection of automated tests, that define the requirements of the solution.

A good test suite will not mandate a particular approach, but will allow people to try many different approaches, and solve the exercise in many different ways.

There are many ways to contribute to a language track, described in the document [Getting Involved in a Language Track][getting-started-track].

You can navigate to the repository for any language track on Exercism via the [trackler][trackler-tracks] library. This list includes both active and upcoming tracks, as well as tracks that have been requested where no work has yet been done.

[exercism-io]: https://github.com/exercism/exercism.io
[cli]: https://github.com/exercism/cli
[isogram]: https://en.wikipedia.org/wiki/Isogram
[discussions]: https://github.com/exercism/discussions/issues
[newsletter]: http://tinyletter.com/exercism
[design-of-exercism]: http://tinyletter.com/exercism/letters/the-delightful-design-of-exercism
[x-common]: https://github.com/exercism/x-common
[getting-started-track]: /docs/getting-involved-in-a-track.md
[trackler]: https://github.com/exercism/trackler
[trackler-tracks]: https://github.com/exercism/trackler/tree/master/tracks
