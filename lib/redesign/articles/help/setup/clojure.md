## Installing Clojure

### Installing Leiningen

The simplest approach to setting up a Clojure environment is to install the build tool [Leiningen](https://github.com/technomancy/leiningen) which will provide access to a REPL (Read Eval Print Loop) for interactive development and allow you to run Clojure code.

#### Linux and Windows

For installation instructions on most platforms see: [https://github.com/technomancy/leiningen#installation](https://github.com/technomancy/leiningen#installation).

#### Homebrew for Mac OS X

Update your Homebrew to latest:

```bash
$ brew update
```

Install Leiningen:

```bash
$ brew install leiningen
```

### Installing the standalone JAR

Alternatively you can download the latest stable release jar file from [clojure.org/downloads](http://clojure.org/downloads) which contains everything required to run Clojure code and provides a basic REPL.

## Working on an exercise and running tests

A Clojure REPL allows you to easily run code and get immediate feedback and can also be used to run tests.

### Leiningen

To open a REPL using Leiningen change to the directory containing the exercise and run:

```bash
$ lein repl
```

Once you are ready to work on an exercise and have created a file to hold your solution (such as `bob.clj`) you can run the tests using `load-file`:

```clojure
(load-file "bob_test.clj")
```

To execute a Clojure file directly with `lein` then you will need to install the `lein-exec` plugin by adding `{:user {:plugins [[lein-exec "0.3.1"]]}}` to your `~/.lein/profiles.clj`. You can then execute a file using:

```bash
$ lein exec bob_test.clj
```

### Standalone JAR

To open a REPL using the standalone JAR file (assuming Clojure 1.5.1) run:

```bash
$ java -cp clojure-1.5.1.jar clojure.main
```

To execute a file use:

```bash
$ java -cp clojure-1.5.1.jar clojure.main bob_test.clj
```
