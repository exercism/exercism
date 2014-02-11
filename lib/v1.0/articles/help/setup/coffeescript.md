## Installing CoffeeScript

Make sure you have [Node.js installed](http://nodejs.org/) [via package manager](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager)

Install jasmine-node:

```bash
$ npm install jasmine-node -g
```

Update your `PATH` to include the npm binaries by adding the following to either `~/.bash_profile` or `~/.zshrc`:

```bash
$ export PATH=/usr/local/share/npm/bin:$PATH
```

## Running Tests

Execute the tests with:

```bash
$ jasmine-node --coffee bob_test.spec.coffee
```

## Making Your First Node Module

To create a module that can be loaded with `Bob = require './bob';`, put this code in `bob.coffee`:

```coffeescript
class Bob

module.exports = Bob
```

You can find more information about modules in the [node documentation](http://nodejs.org/api/modules.html#modules_module_exports).

## Recommended Learning Resources

If you want to learn the basics about CoffeeScript you may want to try these resources:

* [Code School course on CoffeeScript](https://www.codeschool.com/courses/coffeescript)
* [CoffeeScript Website](http://coffeescript.org)
* [StackOverflow](http://stackoverflow.com/)
