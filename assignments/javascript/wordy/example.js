exports.WordProblem   = WordProblem;
exports.ArgumentError = ArgumentError;

var BINARY_OPERATORS = {
  'plus':          function(l, r) { return l + r; },
  'minus':         function(l, r) { return l - r; },
  'multiplied by': function(l, r) { return l * r; },
  'divided by':    function(l, r) { return l / r; }
};

function operators() {
  return Object.keys(BINARY_OPERATORS);
}

function pattern() {
  var expression = '';
  var operations = ' (' + operators().join('|') + ') ';

  expression += '(?:what is ([-+]?[\\d]+)';
  expression += operations;
  expression += '([-+]?[\\d]+)(?:';
  expression += operations;
  expression += '([-+]?[\\d]+))?)';

  return new RegExp(expression, 'i');
}

function WordProblem(question) {
  this.question = question || '';
  this.matches  = this.question.match(pattern());
}

WordProblem.prototype.tooComplicated = function() {
  return this.matches === null;
};

WordProblem.prototype.answer = function() {
  if (this.tooComplicated()) throw new ArgumentError("I don't understand the question");
  return this.evaluate();
};

WordProblem.prototype.evaluate = function() {
  var out = 0;
  var m   = this.matches;

  if (m[1] !== undefined && m[2] !== undefined && m[3] !== undefined) {
    out = this.operate(m[2], m[1], m[3]);
  }

  if (m[4] !== undefined && m[5] !== undefined) {
    out = this.operate(m[4], out, m[5]);
  }

  return out;
};

WordProblem.prototype.operate = function(operation, l, r) {
  var fn = BINARY_OPERATORS[operation] || function() { return 0; };
  return fn(Number(l), Number(r));
};

function ArgumentError() {}
ArgumentError.prototype = new Error();
