## Installing JavaScript

Install [Node.js](http://nodejs.org/) [via package manager](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager)

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
$ jasmine-node bob_test.spec.js
```

All but the first test are skipped. Once you get a test passing,
unskip the next one by changing `xit` to `it`.

## Making Your First Node Module

To create a module that can be loaded with `var Bob = require('./bob');`, put this code in `bob.js`:

```javascript
var Bob = function() {};
module.exports = Bob;
```

You can find more information about modules in the [node documentation](http://nodejs.org/api/modules.html#modules_module_exports).

## Recommended Learning Resources

Exercism provides exercises and feedback but can be difficult to jump into for those learning JavaScript for the first time. These resources can help you get started:

* [Mozilla JavaScript Guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide)
* [Mozilla JavaScript Reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference)
* [Mozilla Recommended Resources](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
* [StackOverflow](http://stackoverflow.com/)
