var School = require('./grade-school');

describe("School", function() {
  var school;

  beforeEach(function() {
    school = new School();
  });

  it("a new school has an empty roster", function() {
    expect(school.roster()).toEqual({});
  });

  xit("adding a student adds them to the roster for the given grade", function() {
    school.add("Aimee", 2);
    var expectedDb = { 2 : [ "Aimee" ] };
    expect(school.roster()).toEqual(expectedDb);
  });

  xit("adding more students to the same grade adds them to the roster", function() {
    school.add("Blair",2);
    school.add("James",2);
    school.add("Paul",2);
    var expectedDb = { 2 : [ "Blair", "James", "Paul" ] };
    expect(school.roster()).toEqual(expectedDb);
  });

  xit("adding students to different grades adds them to the roster", function() {
    school.add("Chelsea",3);
    school.add("Logan",7);
    var expectedDb = { 3 : [ "Chelsea" ], 7 : [ "Logan"] };
    expect(school.roster()).toEqual(expectedDb);
  });

  xit("grade returns the students in that grade in alphabetical order", function() {
    school.add("Franklin",5);
    school.add("Bradley",5);
    school.add("Jeff",1);
    var expectedStudents = [ "Bradley", "Franklin" ];
    expect(school.grade(5)).toEqual(expectedStudents);
  });

  xit("grade returns an empty array if there are no students in that grade", function() {
    expect(school.grade(1)).toEqual([]);
  });

  xit("the students names in each grade in the roster are sorted", function() {
    school.add("Jennifer", 4);
    school.add("Kareem", 6);
    school.add("Christopher", 4);
    school.add("Kyle", 3);
    sorted = {
      3 : ["Kyle"],
      4 : ["Christopher", "Jennifer"],
      6 : ["Kareem"]
    };
    expect(school.roster()).toEqual(sorted);
  });

});
