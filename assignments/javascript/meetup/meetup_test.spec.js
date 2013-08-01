var Meetup = require('./meetup');

describe("Meetup", function() {

  it("monteenth of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 13);
    expect(meetup.monteenth()).toEqual(expectedDate);
  });

  xit("monteenth of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 19);
    expect(meetup.monteenth()).toEqual(expectedDate);
  });

  xit("monteenth of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 16);
    expect(meetup.monteenth()).toEqual(expectedDate);
  });

  xit("tuesteenth of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 19);
    expect(meetup.tuesteenth()).toEqual(expectedDate);
  });

  xit("tuesteenth of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 16);
    expect(meetup.tuesteenth()).toEqual(expectedDate);
  });

  xit("tuesteenth of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 13);
    expect(meetup.tuesteenth()).toEqual(expectedDate);
  });

  xit("wednesteenth of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 16);
    expect(meetup.wednesteenth()).toEqual(expectedDate);
  });

  xit("wednesteenth of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 13);
    expect(meetup.wednesteenth()).toEqual(expectedDate);
  });

  xit("wednesteenth of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 19);
    expect(meetup.wednesteenth()).toEqual(expectedDate);
  });

  xit("thursteenth of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 16);
    expect(meetup.thursteenth()).toEqual(expectedDate);
  });

  xit("thursteenth of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 13);
    expect(meetup.thursteenth()).toEqual(expectedDate);
  });

  xit("thursteenth of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 19);
    expect(meetup.thursteenth()).toEqual(expectedDate);
  });

  xit("friteenth of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 19);
    expect(meetup.friteenth()).toEqual(expectedDate);
  });

  xit("friteenth of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 16);
    expect(meetup.friteenth()).toEqual(expectedDate);
  });

  xit("friteenth of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 13);
    expect(meetup.friteenth()).toEqual(expectedDate);
  });

  xit("saturteenth of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 16);
    expect(meetup.saturteenth()).toEqual(expectedDate);
  });

  xit("saturteenth of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 13);
    expect(meetup.saturteenth()).toEqual(expectedDate);
  });

  xit("saturteenth of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 19);
    expect(meetup.saturteenth()).toEqual(expectedDate);
  });

  xit("sunteenth of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 19);
    expect(meetup.sunteenth()).toEqual(expectedDate);
  });

  xit("sunteenth of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 16);
    expect(meetup.sunteenth()).toEqual(expectedDate);
  });

  xit("sunteenth of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 13);
    expect(meetup.sunteenth()).toEqual(expectedDate);
  });

  xit("first monday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 4);
    expect(meetup.firstMonday()).toEqual(expectedDate);
  });

  xit("first monday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 1);
    expect(meetup.firstMonday()).toEqual(expectedDate);
  });

  xit("first tuesday of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 7);
    expect(meetup.firstTuesday()).toEqual(expectedDate);
  });

  xit("first tuesday of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 4);
    expect(meetup.firstTuesday()).toEqual(expectedDate);
  });

  xit("first wednesday of july 2013",function() {
    var meetup = new Meetup(6,2013);
    var expectedDate = new Date(2013, 6, 3);
    expect(meetup.firstWednesday()).toEqual(expectedDate);
  });

  xit("first wednesday of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 7);
    expect(meetup.firstWednesday()).toEqual(expectedDate);
  });

  xit("first thursday of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 5);
    expect(meetup.firstThursday()).toEqual(expectedDate);
  });

  xit("first thursday of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 3);
    expect(meetup.firstThursday()).toEqual(expectedDate);
  });

  xit("first friday of november 2013",function() {
    var meetup = new Meetup(10,2013);
    var expectedDate = new Date(2013, 10, 1);
    expect(meetup.firstFriday()).toEqual(expectedDate);
  });

  xit("first friday of december 2013",function() {
    var meetup = new Meetup(11,2013);
    var expectedDate = new Date(2013, 11, 6);
    expect(meetup.firstFriday()).toEqual(expectedDate);
  });

  xit("first saturday of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 5);
    expect(meetup.firstSaturday()).toEqual(expectedDate);
  });

  xit("first saturday of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 2);
    expect(meetup.firstSaturday()).toEqual(expectedDate);
  });

  xit("first sunday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 3);
    expect(meetup.firstSunday()).toEqual(expectedDate);
  });

  xit("first sunday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 7);
    expect(meetup.firstSunday()).toEqual(expectedDate);
  });

  xit("second monday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 11);
    expect(meetup.secondMonday()).toEqual(expectedDate);
  });

  xit("second monday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 8);
    expect(meetup.secondMonday()).toEqual(expectedDate);
  });

  xit("second tuesday of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 14);
    expect(meetup.secondTuesday()).toEqual(expectedDate);
  });

  xit("second tuesday of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 11);
    expect(meetup.secondTuesday()).toEqual(expectedDate);
  });

  xit("second wednesday of july 2013",function() {
    var meetup = new Meetup(6,2013);
    var expectedDate = new Date(2013, 6, 10);
    expect(meetup.secondWednesday()).toEqual(expectedDate);
  });

  xit("second wednesday of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 14);
    expect(meetup.secondWednesday()).toEqual(expectedDate);
  });

  xit("second thursday of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 12);
    expect(meetup.secondThursday()).toEqual(expectedDate);
  });

  xit("second thursday of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 10);
    expect(meetup.secondThursday()).toEqual(expectedDate);
  });

  xit("second friday of november 2013",function() {
    var meetup = new Meetup(10,2013);
    var expectedDate = new Date(2013, 10, 8);
    expect(meetup.secondFriday()).toEqual(expectedDate);
  });

  xit("second friday of december 2013",function() {
    var meetup = new Meetup(11,2013);
    var expectedDate = new Date(2013, 11, 13);
    expect(meetup.secondFriday()).toEqual(expectedDate);
  });

  xit("second saturday of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 12);
    expect(meetup.secondSaturday()).toEqual(expectedDate);
  });

  xit("second saturday of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 9);
    expect(meetup.secondSaturday()).toEqual(expectedDate);
  });

  xit("second sunday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 10);
    expect(meetup.secondSunday()).toEqual(expectedDate);
  });

  xit("second sunday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 14);
    expect(meetup.secondSunday()).toEqual(expectedDate);
  });

  xit("third monday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 18);
    expect(meetup.thirdMonday()).toEqual(expectedDate);
  });

  xit("third monday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 15);
    expect(meetup.thirdMonday()).toEqual(expectedDate);
  });

  xit("third tuesday of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 21);
    expect(meetup.thirdTuesday()).toEqual(expectedDate);
  });

  xit("third tuesday of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 18);
    expect(meetup.thirdTuesday()).toEqual(expectedDate);
  });

  xit("third wednesday of july 2013",function() {
    var meetup = new Meetup(6,2013);
    var expectedDate = new Date(2013, 6, 17);
    expect(meetup.thirdWednesday()).toEqual(expectedDate);
  });

  xit("third wednesday of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 21);
    expect(meetup.thirdWednesday()).toEqual(expectedDate);
  });

  xit("third thursday of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 19);
    expect(meetup.thirdThursday()).toEqual(expectedDate);
  });

  xit("third thursday of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 17);
    expect(meetup.thirdThursday()).toEqual(expectedDate);
  });

  xit("third friday of november 2013",function() {
    var meetup = new Meetup(10,2013);
    var expectedDate = new Date(2013, 10, 15);
    expect(meetup.thirdFriday()).toEqual(expectedDate);
  });

  xit("third friday of december 2013",function() {
    var meetup = new Meetup(11,2013);
    var expectedDate = new Date(2013, 11, 20);
    expect(meetup.thirdFriday()).toEqual(expectedDate);
  });

  xit("third saturday of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 19);
    expect(meetup.thirdSaturday()).toEqual(expectedDate);
  });

  xit("third saturday of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 16);
    expect(meetup.thirdSaturday()).toEqual(expectedDate);
  });

  xit("third sunday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 17);
    expect(meetup.thirdSunday()).toEqual(expectedDate);
  });

  xit("third sunday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 21);
    expect(meetup.thirdSunday()).toEqual(expectedDate);
  });

  xit("fourth monday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 25);
    expect(meetup.fourthMonday()).toEqual(expectedDate);
  });

  xit("fourth monday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 22);
    expect(meetup.fourthMonday()).toEqual(expectedDate);
  });

  xit("fourth tuesday of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 28);
    expect(meetup.fourthTuesday()).toEqual(expectedDate);
  });

  xit("fourth tuesday of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 25);
    expect(meetup.fourthTuesday()).toEqual(expectedDate);
  });

  xit("fourth wednesday of july 2013",function() {
    var meetup = new Meetup(6,2013);
    var expectedDate = new Date(2013, 6, 24);
    expect(meetup.fourthWednesday()).toEqual(expectedDate);
  });

  xit("fourth wednesday of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 28);
    expect(meetup.fourthWednesday()).toEqual(expectedDate);
  });

  xit("fourth thursday of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 26);
    expect(meetup.fourthThursday()).toEqual(expectedDate);
  });

  xit("fourth thursday of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 24);
    expect(meetup.fourthThursday()).toEqual(expectedDate);
  });

  xit("fourth friday of november 2013",function() {
    var meetup = new Meetup(10,2013);
    var expectedDate = new Date(2013, 10, 22);
    expect(meetup.fourthFriday()).toEqual(expectedDate);
  });

  xit("fourth friday of december 2013",function() {
    var meetup = new Meetup(11,2013);
    var expectedDate = new Date(2013, 11, 27);
    expect(meetup.fourthFriday()).toEqual(expectedDate);
  });

  xit("fourth saturday of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 26);
    expect(meetup.fourthSaturday()).toEqual(expectedDate);
  });

  xit("fourth saturday of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 23);
    expect(meetup.fourthSaturday()).toEqual(expectedDate);
  });

  xit("fourth sunday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 24);
    expect(meetup.fourthSunday()).toEqual(expectedDate);
  });

  xit("fourth sunday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 28);
    expect(meetup.fourthSunday()).toEqual(expectedDate);
  });

  xit("last monday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 25);
    expect(meetup.lastMonday()).toEqual(expectedDate);
  });

  xit("last monday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 29);
    expect(meetup.lastMonday()).toEqual(expectedDate);
  });

  xit("last tuesday of may 2013",function() {
    var meetup = new Meetup(4,2013);
    var expectedDate = new Date(2013, 4, 28);
    expect(meetup.lastTuesday()).toEqual(expectedDate);
  });

  xit("last tuesday of june 2013",function() {
    var meetup = new Meetup(5,2013);
    var expectedDate = new Date(2013, 5, 25);
    expect(meetup.lastTuesday()).toEqual(expectedDate);
  });

  xit("last wednesday of july 2013",function() {
    var meetup = new Meetup(6,2013);
    var expectedDate = new Date(2013, 6, 31);
    expect(meetup.lastWednesday()).toEqual(expectedDate);
  });

  xit("last wednesday of august 2013",function() {
    var meetup = new Meetup(7,2013);
    var expectedDate = new Date(2013, 7, 28);
    expect(meetup.lastWednesday()).toEqual(expectedDate);
  });

  xit("last thursday of september 2013",function() {
    var meetup = new Meetup(8,2013);
    var expectedDate = new Date(2013, 8, 26);
    expect(meetup.lastThursday()).toEqual(expectedDate);
  });

  xit("last thursday of october 2013",function() {
    var meetup = new Meetup(9,2013);
    var expectedDate = new Date(2013, 9, 31);
    expect(meetup.lastThursday()).toEqual(expectedDate);
  });

  xit("last friday of november 2013",function() {
    var meetup = new Meetup(10,2013);
    var expectedDate = new Date(2013, 10, 29);
    expect(meetup.lastFriday()).toEqual(expectedDate);
  });

  xit("last friday of december 2013",function() {
    var meetup = new Meetup(11,2013);
    var expectedDate = new Date(2013, 11, 27);
    expect(meetup.lastFriday()).toEqual(expectedDate);
  });

  xit("last saturday of january 2013",function() {
    var meetup = new Meetup(0,2013);
    var expectedDate = new Date(2013, 0, 26);
    expect(meetup.lastSaturday()).toEqual(expectedDate);
  });

  xit("last saturday of february 2013",function() {
    var meetup = new Meetup(1,2013);
    var expectedDate = new Date(2013, 1, 23);
    expect(meetup.lastSaturday()).toEqual(expectedDate);
  });

  xit("last sunday of march 2013",function() {
    var meetup = new Meetup(2,2013);
    var expectedDate = new Date(2013, 2, 31);
    expect(meetup.lastSunday()).toEqual(expectedDate);
  });

  xit("last sunday of april 2013",function() {
    var meetup = new Meetup(3,2013);
    var expectedDate = new Date(2013, 3, 28);
    expect(meetup.lastSunday()).toEqual(expectedDate);
  });

});
