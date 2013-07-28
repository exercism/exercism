(function() {
  'use strict';

  function School() {
    this.db = {};
  }

  School.prototype.add = function(studentName,grade) {
    var currentGrade = this.db[grade] || [];
    currentGrade.push(studentName);
    this.db[grade] = currentGrade;
  };

  School.prototype.grade = function(level) {
    return this.db[level] || [];
  };

  School.prototype.sort = function() {
    var currentDb = this.db;
    for (var grade in currentDb) {
      if (currentDb.hasOwnProperty(grade)) {
        currentDb[grade].sort();
      }
    }
    return currentDb;
  };

  module.exports = School;
})();