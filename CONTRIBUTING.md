# Contributing to Exercism.io

First of all, **thank you** for helping with Exercism.io!

## Issues

Please file issues on the [GitHub issues list](https://github.com/exercism/exercism.io/issues) and give as much detail as possible.

## Features / Pull Requests

If you want a feature implemented, the best way to get it done is to submit a pull request that implements it. Tests and docs would be wonderful.

There are full instructions on getting the app running [in the README](https://github.com/exercism/exercism.io/blob/master/README.md).

Please try and stick to the [Ruby Style Guidelines](https://github.com/styleguide/ruby) with the one exception of using Jim Weirich's style of [braces vs do-end](http://onestepback.org/index.cgi/Tech/Ruby/BraceVsDoEnd.rdoc).

## Creating a new Language Track

Each language will need at least 10 exercises in order to launch, as well as a small handful of people who can kick off the nitpicking. These people should have a good grasp of the styles and idioms in use in that language.

In addition to the exercises (test suites + example solution), it also requires:

1. An icon in `frontend/app/img/$LANGUAGE.png`
2. A reference to the icon in [frontend/app/css/style.css](https://github.com/exercism/exercism.io/blob/496f541f886c38ec5b39379b63ea3d97e3165529/frontend/app/css/style.css#L94-L124)
3. A help file: `lib/app/views/setup/$LANGUAGE.erb`
4. An entry in `lib/exercism/curriculum.rb`
5. A curriculum definition in `lib/exercism/curriculum/$LANGUAGE.rb`

Thank you again!
:heart: :sparkling_heart: :heart:
