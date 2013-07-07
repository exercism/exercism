
/*
jasmine-given 2.1.0
Adds a Given-When-Then DSL to jasmine as an alternative style for specs
site: https://github.com/searls/jasmine-given
*/


(function() {

  (function(jasmine) {
    var getBlock, invariantList, mostRecentExpectations, mostRecentlyUsed, o, root, stringifyExpectation, whenList;
    mostRecentlyUsed = null;
    stringifyExpectation = function(expectation) {
      var matches;
      matches = expectation.toString().replace(/\n/g, '').match(/function\s?\(\)\s?{\s*(return\s+)?(.*?)(;)?\s*}/i);
      if (matches && matches.length >= 3) {
        return matches[2];
      } else {
        return "";
      }
    };
    beforeEach(function() {
      return this.addMatchers({
        toHaveReturnedFalseFromThen: function(context, n) {
          var exception, result;
          result = false;
          exception = void 0;
          try {
            result = this.actual.call(context);
          } catch (e) {
            exception = e;
          }
          this.message = function() {
            var msg;
            msg = "Then clause " + (n > 1 ? " #" + n : "") + " `" + (stringifyExpectation(this.actual)) + "` failed by ";
            if (exception) {
              msg += "throwing: " + exception.toString();
            } else {
              msg += "returning false";
            }
            return msg;
          };
          return result === false;
        }
      });
    });
    root = this;
    root.Given = function() {
      mostRecentlyUsed = root.Given;
      return beforeEach(getBlock(arguments));
    };
    whenList = [];
    root.When = function() {
      var b;
      mostRecentlyUsed = root.When;
      b = getBlock(arguments);
      beforeEach(function() {
        return whenList.push(b);
      });
      return afterEach(function() {
        return whenList.pop();
      });
    };
    invariantList = [];
    root.Invariant = function() {
      var b;
      mostRecentlyUsed = root.Invariant;
      b = getBlock(arguments);
      beforeEach(function() {
        return invariantList.push(b);
      });
      return afterEach(function() {
        return invariantList.pop();
      });
    };
    getBlock = function(thing) {
      var assignResultTo, setupFunction;
      setupFunction = o(thing).firstThat(function(arg) {
        return o(arg).isFunction();
      });
      assignResultTo = o(thing).firstThat(function(arg) {
        return o(arg).isString();
      });
      return function() {
        var context, result;
        context = jasmine.getEnv().currentSpec;
        result = setupFunction.call(context);
        if (assignResultTo) {
          if (!context[assignResultTo]) {
            return context[assignResultTo] = result;
          } else {
            throw new Error("Unfortunately, the variable '" + assignResultTo + "' is already assigned to: " + context[assignResultTo]);
          }
        }
      };
    };
    mostRecentExpectations = null;
    root.Then = function() {
      var expectationFunction, expectations, label;
      label = o(arguments).firstThat(function(arg) {
        return o(arg).isString();
      });
      expectationFunction = o(arguments).firstThat(function(arg) {
        return o(arg).isFunction();
      });
      mostRecentlyUsed = root.subsequentThen;
      mostRecentExpectations = expectations = [expectationFunction];
      it("then " + (label != null ? label : stringifyExpectation(expectations)), function() {
        var block, i, _i, _len, _ref, _results;
        _ref = whenList != null ? whenList : [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          block = _ref[_i];
          block();
        }
        i = 0;
        expectations = invariantList.concat(expectations);
        _results = [];
        while (i < expectations.length) {
          expect(expectations[i]).not.toHaveReturnedFalseFromThen(jasmine.getEnv().currentSpec, i + 1);
          _results.push(i++);
        }
        return _results;
      });
      return {
        Then: subsequentThen,
        And: subsequentThen
      };
    };
    root.subsequentThen = function(additionalExpectation) {
      mostRecentExpectations.push(additionalExpectation);
      return this;
    };
    mostRecentlyUsed = root.Given;
    root.And = function() {
      return mostRecentlyUsed.apply(this, jasmine.util.argsToArray(arguments));
    };
    return o = function(thing) {
      return {
        isFunction: function() {
          return Object.prototype.toString.call(thing) === "[object Function]";
        },
        isString: function() {
          return Object.prototype.toString.call(thing) === "[object String]";
        },
        firstThat: function(test) {
          var i;
          i = 0;
          while (i < thing.length) {
            if (test(thing[i]) === true) {
              return thing[i];
            }
            i++;
          }
          return void 0;
        }
      };
    };
  })(jasmine);

}).call(this);
