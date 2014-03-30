## Installing Clojure

### Homebrew for Mac OS X

Update your homebrew to latest:

```bash
$ brew update
```

Install Leiningen:

```bash
$ brew install leiningen
```

To install `lein-exec` edit `~/.lein/profiles.clj` and add `{:user {:plugins [[lein-exec "0.3.1"]]}}`.

### Installing from Source

Download the latest table release jar file Clojure-1.5.1

## Running tests

If you installed `lein-exec`:

```bash
$ lein exec bob_test.clj
```

If jar file downloaded, assuming `clojure-1.5.1.jar`

```bash
$ java -cp clojure-1.5.1.jar clojure.main bob_test.clj
```

