function SpaceAge(seconds) {
  'use strict';

  this.seconds = seconds;
  this.earthYears = seconds / 31557600;

  this.earthToOtherPlanets = {
    mercury : 0.2408467,
    venus   : 0.61519726,
    earth   : 1,
    mars    : 1.8808158,
    jupiter : 11.862615,
    saturn  : 29.447498,
    uranus  : 84.016846,
    neptune : 164.79132
  };

  this.yearsOnPlanet = function(planet) {
    var years = this.earthYears / this.earthToOtherPlanets[planet];
    return parseFloat(years.toFixed(2));
  };

  this.onMercury = function() {
    return this.yearsOnPlanet("mercury");
  };

  this.onVenus = function() {
    return this.yearsOnPlanet("venus");
  };

  this.onEarth = function() {
    return this.yearsOnPlanet("earth");
  };

  this.onMars = function() {
    return this.yearsOnPlanet("mars");
  };

  this.onJupiter = function() {
    return this.yearsOnPlanet("jupiter");
  };

  this.onSaturn = function() {
    return this.yearsOnPlanet("saturn");
  };

  this.onUranus = function() {
    return this.yearsOnPlanet("uranus");
  };

  this.onNeptune = function() {
    return this.yearsOnPlanet("neptune");
  };

}

module.exports = SpaceAge;