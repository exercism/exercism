var School = require('./grade-school');

describe("School", function() {
  var school;

  beforeEach(function() {
    school = new School("Haleakala Hippy School");
  });

  it("an empty school", function() {
    expect(school.db).toEqual({});
  });

  xit("add a student", function() {
    school.add("Aimee",2);
    var expectedDb = { 2 : [ "Aimee" ] };
    expect(school.db).toEqual(expectedDb);
  });

  xit("add mores students in the same class", function() {
    school.add("James",2);
    school.add("Blair",2);
    school.add("Paul",2);
    var expectedDb = { 2 : [ "James", "Blair", "Paul" ] };
    expect(school.db).toEqual(expectedDb);
  });

  xit("add students to different grades", function() {
    school.add("Chelsea",3);
    school.add("Logan",7);
    var expectedDb = { 3 : [ "Chelsea" ], 7 : [ "Logan"] };
    expect(school.db).toEqual(expectedDb);
  });

  xit("get students in a grade", function() {
    school.add("Franklin",5);
    school.add("Bradley",5);
    school.add("Jeff",1);
    var expectedStudents = [ "Franklin", "Bradley" ];
    expect(school.grade(5)).toEqual(expectedStudents);
  });

  xit("get students in a non-existant grade", function() {
    expect(school.grade(1)).toEqual([]);
  });


  xit("sort school", function() {
    school.add("Jennifer", 4);
    school.add("Kareem", 6);
    school.add("Christopher", 4);
    school.add("Kyle", 3);
    sorted = {
      3 : ["Kyle"],
      4 : ["Christopher", "Jennifer"],
      6 : ["Kareem"]
    };
    expect(school.sort()).toEqual(sorted);
  });

});
