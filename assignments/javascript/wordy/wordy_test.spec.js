var WordProblem   = require('./wordy').WordProblem;
var ArgumentError = require('./wordy').ArgumentError;

describe('Word Problem', function() {

  it('add 1', function() {
    var question = 'What is 1 plus 1?';
    expect(2).toEqual(new WordProblem(question).answer());
  });

  xit('add 2', function() {
    var question = 'What is 53 plus 2?';
    expect(55).toEqual(new WordProblem(question).answer());
  });

  xit('add negative numbers', function() {
    var question = 'What is -1 plus -10?';
    expect(-11).toEqual(new WordProblem(question).answer());
  });

  xit('add more digits', function() {
    var question = 'What is 123 plus 45678?';
    expect(45801).toEqual(new WordProblem(question).answer());
  });

  xit('subtract', function() {
    var question = 'What is 4 minus -12?';
    expect(16).toEqual(new WordProblem(question).answer());
  });

  xit('multiply', function() {
    var question = 'What is -3 multiplied by 25?';
    expect(-75).toEqual(new WordProblem(question).answer());
  });

  xit('divide', function() {
    var question = 'What is 33 divided by -3?';
    expect(-11).toEqual(new WordProblem(question).answer());
  });

  xit('add twice', function() {
    var question = 'What is 1 plus 1 plus 1?';
    expect(3).toEqual(new WordProblem(question).answer());
  });

  xit('add then subtract', function() {
    var question = 'What is 1 plus 5 minus -2?';
    expect(8).toEqual(new WordProblem(question).answer());
  });

  xit('subtract twice', function() {
    var question = 'What is 20 minus 4 minus 13?';
    expect(3).toEqual(new WordProblem(question).answer());
  });

  xit('subtract then add', function() {
    var question = 'What is 17 minus 6 plus 3?';
    expect(14).toEqual(new WordProblem(question).answer());
  });

  xit('multiply twice', function() {
    var question = 'What is 2 multiplied by -2 multiplied by 3?';
    expect(-12).toEqual(new WordProblem(question).answer());
  });

  xit('add then multiply', function() {
    var question = 'What is -3 plus 7 multiplied by -2?';
    expect(-8).toEqual(new WordProblem(question).answer());
  });

  xit('divide twice', function() {
    var question = 'What is -12 divided by 2 divided by -3?';
    expect(2).toEqual(new WordProblem(question).answer());
  });

  xit('too advanced', function() {
    var question = 'What is 53 cubed?';
    var problem  = new WordProblem(question);

    expect(problem.answer.bind(problem)).toThrow(new ArgumentError());
  });

  xit('irrelevant', function() {
    var question = 'Who is the president of the United States?';
    var problem  = new WordProblem(question);

    expect(problem.answer.bind(problem)).toThrow(new ArgumentError());
  });

});
