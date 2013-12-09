var SpaceAge = require('./space-age');

describe("Space Age", function() {
  it("age in seconds", function() {
    var age = new SpaceAge(1000000);
    expect(age.seconds).toEqual(1000000);
  });

  xit("age in earth years", function() {
    var age = new SpaceAge(1000000000);
    expect(age.onEarth()).toEqual(31.69);
  });

  xit("age in mercury years", function() {
    var age = new SpaceAge(2134835688);
    expect(age.onEarth()).toEqual(67.65);
    expect(age.onMercury()).toEqual(280.88);
  });

  xit("age in venus years", function() {
    var age = new SpaceAge(189839836);
    expect(age.onEarth()).toEqual(6.02);
    expect(age.onVenus()).toEqual(9.78);
  });

  xit("age in mars years", function() {
    var age = new SpaceAge(2329871239);
    expect(age.onEarth()).toEqual(73.83);
    expect(age.onMars()).toEqual(39.25);
  });

  xit("age in jupiter years", function() {
    var age = new SpaceAge(901876382);
    expect(age.onEarth()).toEqual(28.58);
    expect(age.onJupiter()).toEqual(2.41);
  });

  xit("age in saturn years", function() {
    var age = new SpaceAge(3000000000);
    expect(age.onEarth()).toEqual(95.06);
    expect(age.onSaturn()).toEqual(3.23);
  });

  xit("age in uranus years", function() {
    var age = new SpaceAge(3210123456);
    expect(age.onEarth()).toEqual(101.72);
    expect(age.onUranus()).toEqual(1.21);
  });

  xit("age in neptune year", function() {
    var age = new SpaceAge(8210123456);
    expect(age.onEarth()).toEqual(260.16);
    expect(age.onNeptune()).toEqual(1.58);
  });
});
