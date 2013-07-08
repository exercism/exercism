School = function(name) {
  this.db = {};

  this.add = function(studentName,grade) {
    var currentGrade = this.db[grade] || [];
    currentGrade.push(studentName);
    this.db[grade] = currentGrade;
  };

  this.grade = function(level) {
    return this.db[level] || [];
  }

  this.sort = function() {
    var currentDb = this.db;
    for (var grade in currentDb) {
      currentDb[grade].sort();
    }
    return currentDb;
  };
};