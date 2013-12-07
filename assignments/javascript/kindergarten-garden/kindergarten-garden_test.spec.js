var Garden = require('./kindergarten-garden');

describe('Garden', function () {

  it('for Alice', function () {
    expect(new Garden("RC\nGG").alice)
      .toEqual(['radishes', 'clover', 'grass', 'grass']);
  });

  xit('another for Alice', function () {
    expect(new Garden("VC\nRC").alice)
      .toEqual(['violets', 'clover', 'radishes', 'clover']);
  });

  xit('for Bob', function () {
    expect(new Garden("VVCG\nVVRC").bob)
      .toEqual(['clover', 'grass', 'radishes', 'clover']);
  });

  xit('for Bob and Charlie', function () {
    var garden = new Garden("VVCCGG\nVVCCGG");
    expect(garden.bob).toEqual(['clover', 'clover', 'clover', 'clover']);
    expect(garden.charlie).toEqual(['grass', 'grass', 'grass', 'grass']);
  });

});

describe('Full garden', function () {
  var diagram = "VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV";
  var garden = new Garden(diagram);

  xit('for Alice', function () {
    expect(garden.alice)
      .toEqual(['violets', 'radishes', 'violets', 'radishes']);
  });

  xit('for Bob', function () {
    expect(garden.bob)
      .toEqual(['clover', 'grass', 'clover', 'clover']);
  });

  xit('for Charlie', function () {
    expect(garden.charlie)
      .toEqual(['violets', 'violets', 'clover', 'grass']);
  });

  xit('for David', function () {
    expect(garden.david)
      .toEqual(['radishes', 'violets', 'clover', 'radishes']);
  });

  xit('for Eve', function () {
    expect(garden.eve)
      .toEqual(['clover', 'grass', 'radishes', 'grass']);
  });

  xit('for Fred', function () {
    expect(garden.fred)
      .toEqual(['grass', 'clover', 'violets', 'clover']);
  });

  xit('for Ginny', function () {
    expect(garden.ginny)
      .toEqual(['clover', 'grass', 'grass', 'clover']);
  });

  xit('for Harriet', function () {
    expect(garden.harriet)
      .toEqual(['violets', 'radishes', 'radishes', 'violets']);
  });

  xit('for Ileana', function () {
    expect(garden.ileana)
      .toEqual(['grass', 'clover', 'violets', 'clover']);
  });

  xit('for Joseph', function () {
    expect(garden.joseph)
      .toEqual(['violets', 'clover', 'violets', 'grass']);
  });

  xit('for Kincaid', function () {
    expect(garden.kincaid)
      .toEqual(['grass', 'clover', 'clover', 'grass']);
  });

  xit('for Larry', function () {
    expect(garden.larry)
      .toEqual(['grass', 'violets', 'clover', 'violets']);
  });

});

describe('Disordered class', function () {
  var diagram = "VCRRGVRG\nRVGCCGCV";
  var students = ['Samantha', 'Patricia', 'Xander', 'Roger'];
  var garden = new Garden(diagram, students);

  xit('Patricia', function () {
    expect(garden.patricia)
      .toEqual(['violets', 'clover', 'radishes', 'violets']);
  });

  xit('Roger', function () {
    expect(garden.roger)
      .toEqual(['radishes', 'radishes', 'grass', 'clover']);
  });

  xit('Samantha', function () {
    expect(garden.samantha)
      .toEqual(['grass', 'violets', 'clover', 'grass']);
  });

  xit('Xander', function () {
    expect(garden.xander)
      .toEqual(['radishes', 'grass', 'clover', 'violets']);
  });

});

describe('Two gardens, different students', function () {
  var diagram = "VCRRGVRG\nRVGCCGCV";
  var garden1 = new Garden(diagram, ["Alice", "Bob", "Charlie", "Dan"]);
  var garden2 = new Garden(diagram, ["Bob", "Charlie", "Dan", "Erin"]);

  xit('Bob and Charlie for each garden', function () {
    expect(garden1.bob)
      .toEqual(['radishes', 'radishes', 'grass', 'clover']);
    expect(garden2.bob)
      .toEqual(['violets', 'clover', 'radishes', 'violets']);
    expect(garden1.charlie)
      .toEqual(['grass', 'violets', 'clover', 'grass']);
    expect(garden2.charlie)
      .toEqual(['radishes', 'radishes', 'grass', 'clover']);
  });

});
