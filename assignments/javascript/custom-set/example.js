(function() {

  'use strict';

  var CustomSet = function(inputData) {
    this.data = inputData || [];
  };

  CustomSet.prototype.delete = function(element) {
    var index = this.data.indexOf(element);
    if (index !== -1) {
      this.data.splice(index, 1);
    }
    return this;
  };

  CustomSet.prototype.difference = function(other) {
    var thisData = this.data.sort();
    var thatData = other.data.sort();
    var result = [];
    for (var i=0; i < thisData.length; i++) {
      if (thatData.indexOf(thisData[i]) === -1) {
        result.push(thisData[i]);
      }
    }
    return new CustomSet(result);
  };

  CustomSet.prototype.disjoint = function(other) {
    if (this.data.length === 0) { return false };
    for (var i = 0; i < this.data.length; i++) {
      if (other.data.indexOf(this.data[i]) !== -1) {
        return false;
      }
    }
    return true;
  };

  CustomSet.prototype.empty = function() {
    return new CustomSet([]);
  };

  CustomSet.prototype.intersection = function(other) {
    var thisData = this.data.sort();
    var thatData = other.data.sort();
    var result = [];
    for (var i=0; i < thisData.length; i++) {
      if (thatData.indexOf(thisData[i]) !== -1) {
        result.push(thisData[i]);
      }
    }
    return new CustomSet(result);
  };

  CustomSet.prototype.member = function(datum) {
    return this.data.indexOf(datum) !== -1;
  };

  CustomSet.prototype.put = function(datum) {
    if (this.data.indexOf(datum) === -1) {
      this.data.push(datum);
    }
    return this;
  };

  CustomSet.prototype.size = function() {
    return arrayUnique(this.data).length;
  };

  CustomSet.prototype.subset = function(other) {
    for (var i=0; i < other.data.length; i++) {
      if (this.data.indexOf(other.data[i]) === -1) {
        return false;
      }
    }
    return true;
  };

  CustomSet.prototype.toList = function() {
    return arrayUnique(this.data);
  };

  CustomSet.prototype.union = function(other) {
    var result = [];

    for (var i=0; i < this.data.length; i++) {
      result.push(this.data[i]);
    }
    for (var j=0; j < other.data.length; j++) {
      result.push(other.data[j]);
    }

    return new CustomSet(arrayUnique(result));
  };

  CustomSet.prototype.eql = function(other) {
    var thisData = this.data.sort();
    var thatData = other.data.sort();

    if (!other || this.data.length !== other.data.length) {
      return false;
    }

    for (var i = 0; i < this.length; i++) {
      if (thisData[i] !== otherData[i]) {
        return false;
      }
    }
    return true;
  };

  var arrayUnique = function(a) {
    return a.reduce(function(p, c) {
        if (p.indexOf(c) < 0) p.push(c);
        return p;
    }, []);
  };

  module.exports = CustomSet;
})();