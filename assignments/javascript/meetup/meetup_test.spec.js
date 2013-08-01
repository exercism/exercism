var Meetup = require('./meetup');

describe("Meetup", function() {

  it("monteenth of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 13);
    expect(meetup.monteenth()).toEqual(expectedDate);
  });

  it("monteenth of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 19);
    expect(meetup.monteenth()).toEqual(expectedDate);
  });

  it("monteenth of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 16);
    expect(meetup.monteenth()).toEqual(expectedDate);
  });

  it("tuesteenth of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 19);
    expect(meetup.tuesteenth()).toEqual(expectedDate);
  });

  it("tuesteenth of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 16);
    expect(meetup.tuesteenth()).toEqual(expectedDate);
  });

  it("tuesteenth of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 13);
    expect(meetup.tuesteenth()).toEqual(expectedDate);
  });

  it("wednesteenth of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 16);
    expect(meetup.wednesteenth()).toEqual(expectedDate);
  });

  it("wednesteenth of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 13);
    expect(meetup.wednesteenth()).toEqual(expectedDate);
  });

  it("wednesteenth of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 19);
    expect(meetup.wednesteenth()).toEqual(expectedDate);
  });

  it("thursteenth of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 16);
    expect(meetup.thursteenth()).toEqual(expectedDate);
  });

  it("thursteenth of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 13);
    expect(meetup.thursteenth()).toEqual(expectedDate);
  });

  it("thursteenth of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 19);
    expect(meetup.thursteenth()).toEqual(expectedDate);
  });

  it("friteenth of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 19);
    expect(meetup.friteenth()).toEqual(expectedDate);
  });

  it("friteenth of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 16);
    expect(meetup.friteenth()).toEqual(expectedDate);
  });

  it("friteenth of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 13);
    expect(meetup.friteenth()).toEqual(expectedDate);
  });

  it("saturteenth of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 16);
    expect(meetup.saturteenth()).toEqual(expectedDate);
  });

  it("saturteenth of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 13);
    expect(meetup.saturteenth()).toEqual(expectedDate);
  });

  it("saturteenth of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 19);
    expect(meetup.saturteenth()).toEqual(expectedDate);
  });

  it("sunteenth of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 19);
    expect(meetup.sunteenth()).toEqual(expectedDate);
  });

  it("sunteenth of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 16);
    expect(meetup.sunteenth()).toEqual(expectedDate);
  });

  it("sunteenth of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 13);
    expect(meetup.sunteenth()).toEqual(expectedDate);
  });

  it("first monday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 4);
    expect(meetup.firstMonday()).toEqual(expectedDate);
  });

  it("first monday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 1);
    expect(meetup.firstMonday()).toEqual(expectedDate);
  });

  it("first tuesday of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 7);
    expect(meetup.firstTuesday()).toEqual(expectedDate);
  });

  it("first tuesday of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 4);
    expect(meetup.firstTuesday()).toEqual(expectedDate);
  });

  it("first wednesday of july 2013",function() {
    var meetup = new Meetup(6,2013);
    var expectedDate = new Date(2013, 6, 3);
    expect(meetup.firstWednesday()).toEqual(expectedDate);
  });

  it("first wednesday of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 7);
    expect(meetup.firstWednesday()).toEqual(expectedDate);
  });

  it("first thursday of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 5);
    expect(meetup.firstThursday()).toEqual(expectedDate);
  });

  it("first thursday of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 3);
    expect(meetup.firstThursday()).toEqual(expectedDate);
  });

  it("first friday of november 2013",function() {
    var meetup = new Meetup(10,2013);
    var expectedDate = new Date(2013, 10, 1);
    expect(meetup.firstFriday()).toEqual(expectedDate);
  });

  it("first friday of december 2013",function() {
    var meetup = new Meetup(11,2013);
    var expectedDate = new Date(2013, 11, 6);
    expect(meetup.firstFriday()).toEqual(expectedDate);
  });

  it("first saturday of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 5);
    expect(meetup.firstSaturday()).toEqual(expectedDate);
  });

  it("first saturday of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 2);
    expect(meetup.firstSaturday()).toEqual(expectedDate);
  });

  it("first sunday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 3);
    expect(meetup.firstSunday()).toEqual(expectedDate);
  });

  it("first sunday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 7);
    expect(meetup.firstSunday()).toEqual(expectedDate);
  });

  it("second monday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 11);
    expect(meetup.secondMonday()).toEqual(expectedDate);
  });

  it("second monday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 8);
    expect(meetup.secondMonday()).toEqual(expectedDate);
  });

  it("second tuesday of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 14);
    expect(meetup.secondTuesday()).toEqual(expectedDate);
  });

  it("second tuesday of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 11);
    expect(meetup.secondTuesday()).toEqual(expectedDate);
  });

  it("second wednesday of july 2013",function() {
    var meetup = new Meetup(6,2013);
    var expectedDate = new Date(2013, 6, 10);
    expect(meetup.secondWednesday()).toEqual(expectedDate);
  });

  it("second wednesday of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 14);
    expect(meetup.secondWednesday()).toEqual(expectedDate);
  });

  it("second thursday of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 12);
    expect(meetup.secondThursday()).toEqual(expectedDate);
  });

  it("second thursday of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 10);
    expect(meetup.secondThursday()).toEqual(expectedDate);
  });

  it("second friday of november 2013",function() {
    var meetup = new Meetup(10,2013);
    var expectedDate = new Date(2013, 10, 8);
    expect(meetup.secondFriday()).toEqual(expectedDate);
  });

  it("second friday of december 2013",function() {
    var meetup = new Meetup(11,2013);
    var expectedDate = new Date(2013, 11, 13);
    expect(meetup.secondFriday()).toEqual(expectedDate);
  });

  it("second saturday of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 12);
    expect(meetup.secondSaturday()).toEqual(expectedDate);
  });

  it("second saturday of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 9);
    expect(meetup.secondSaturday()).toEqual(expectedDate);
  });

  it("second sunday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 10);
    expect(meetup.secondSunday()).toEqual(expectedDate);
  });

  it("second sunday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 14);
    expect(meetup.secondSunday()).toEqual(expectedDate);
  });

  it("third monday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 18);
    expect(meetup.thirdMonday()).toEqual(expectedDate);
  });

  it("third monday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 15);
    expect(meetup.thirdMonday()).toEqual(expectedDate);
  });

  it("third tuesday of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 21);
    expect(meetup.thirdTuesday()).toEqual(expectedDate);
  });

  it("third tuesday of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 18);
    expect(meetup.thirdTuesday()).toEqual(expectedDate);
  });

  it("third wednesday of july 2013",function() {
    var meetup = new Meetup(6,2013);
    var expectedDate = new Date(2013, 6, 17);
    expect(meetup.thirdWednesday()).toEqual(expectedDate);
  });

  it("third wednesday of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 21);
    expect(meetup.thirdWednesday()).toEqual(expectedDate);
  });

  it("third thursday of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 19);
    expect(meetup.thirdThursday()).toEqual(expectedDate);
  });

  it("third thursday of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 17);
    expect(meetup.thirdThursday()).toEqual(expectedDate);
  });

  it("third friday of november 2013",function() {
    var meetup = new Meetup(10,2013);
    var expectedDate = new Date(2013, 10, 15);
    expect(meetup.thirdFriday()).toEqual(expectedDate);
  });

  it("third friday of december 2013",function() {
    var meetup = new Meetup(11,2013);
    var expectedDate = new Date(2013, 11, 20);
    expect(meetup.thirdFriday()).toEqual(expectedDate);
  });

  it("third saturday of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 19);
    expect(meetup.thirdSaturday()).toEqual(expectedDate);
  });

  it("third saturday of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 16);
    expect(meetup.thirdSaturday()).toEqual(expectedDate);
  });

  it("third sunday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 17);
    expect(meetup.thirdSunday()).toEqual(expectedDate);
  });

  it("third sunday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 21);
    expect(meetup.thirdSunday()).toEqual(expectedDate);
  });

  it("fourth monday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 25);
    expect(meetup.fourthMonday()).toEqual(expectedDate);
  });

  it("fourth monday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 22);
    expect(meetup.fourthMonday()).toEqual(expectedDate);
  });

  it("fourth tuesday of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 28);
    expect(meetup.fourthTuesday()).toEqual(expectedDate);
  });

  it("fourth tuesday of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 25);
    expect(meetup.fourthTuesday()).toEqual(expectedDate);
  });

  it("fourth wednesday of july 2013",function() {
    var meetup = new Meetup(6,2013);
    var expectedDate = new Date(2013, 6, 24);
    expect(meetup.fourthWednesday()).toEqual(expectedDate);
  });

  it("fourth wednesday of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 28);
    expect(meetup.fourthWednesday()).toEqual(expectedDate);
  });

  it("fourth thursday of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 26);
    expect(meetup.fourthThursday()).toEqual(expectedDate);
  });

  it("fourth thursday of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 24);
    expect(meetup.fourthThursday()).toEqual(expectedDate);
  });

  it("fourth friday of november 2013",function() {
    var meetup = new Meetup(10,2013);
    var expectedDate = new Date(2013, 10, 22);
    expect(meetup.fourthFriday()).toEqual(expectedDate);
  });

  it("fourth friday of december 2013",function() {
    var meetup = new Meetup(11,2013);
    var expectedDate = new Date(2013, 11, 27);
    expect(meetup.fourthFriday()).toEqual(expectedDate);
  });

  it("fourth saturday of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 26);
    expect(meetup.fourthSaturday()).toEqual(expectedDate);
  });

  it("fourth saturday of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 23);
    expect(meetup.fourthSaturday()).toEqual(expectedDate);
  });

  it("fourth sunday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 24);
    expect(meetup.fourthSunday()).toEqual(expectedDate);
  });

  it("fourth sunday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 28);
    expect(meetup.fourthSunday()).toEqual(expectedDate);
  });

  it("last monday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 25);
    expect(meetup.lastMonday()).toEqual(expectedDate);
  });

  it("last monday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 29);
    expect(meetup.lastMonday()).toEqual(expectedDate);
  });

  it("last tuesday of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 28);
    expect(meetup.lastTuesday()).toEqual(expectedDate);
  });

  it("last tuesday of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 25);
    expect(meetup.lastTuesday()).toEqual(expectedDate);
  });

  it("last wednesday of july 2013",function() {
    var meetup = new Meetup(6,2013);
    var expectedDate = new Date(2013, 6, 31);
    expect(meetup.lastWednesday()).toEqual(expectedDate);
  });

  it("last wednesday of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 28);
    expect(meetup.lastWednesday()).toEqual(expectedDate);
  });

  it("last thursday of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 26);
    expect(meetup.lastThursday()).toEqual(expectedDate);
  });

  it("last thursday of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 31);
    expect(meetup.lastThursday()).toEqual(expectedDate);
  });

  it("last friday of november 2013",function() {
    var meetup = new Meetup(10,2013);
    var expectedDate = new Date(2013, 10, 29);
    expect(meetup.lastFriday()).toEqual(expectedDate);
  });

  it("last friday of december 2013",function() {
    var meetup = new Meetup(11,2013);
    var expectedDate = new Date(2013, 11, 27);
    expect(meetup.lastFriday()).toEqual(expectedDate);
  });

  it("last saturday of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 26);
    expect(meetup.lastSaturday()).toEqual(expectedDate);
  });

  it("last saturday of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 23);
    expect(meetup.lastSaturday()).toEqual(expectedDate);
  });

  it("last sunday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 31);
    expect(meetup.lastSunday()).toEqual(expectedDate);
  });

  it("last sunday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 28);
    expect(meetup.lastSunday()).toEqual(expectedDate);
  });

});
