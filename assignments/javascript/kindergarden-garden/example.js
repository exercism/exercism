'use strict';

var defaultChildren = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Fred',
  'Ginny',
  'Harriet',
  'Ileana',
  'Joseph',
  'Kincaid',
  'Larry'
];

var plants = {
  G: 'grass',
  V: 'violets',
  R: 'radishes',
  C: 'clover'
};

function getPlants(pots, index) {
  var plants = [];
  var position = 2*index;
  plants.push(pots[0][position]);
  plants.push(pots[0][position+1]);
  plants.push(pots[1][position]);
  plants.push(pots[1][position+1]);
  return plants;
}

function parse(diagram) {
  return diagram.split("\n").map(function (row) {
    return row.split('').map(function (sign) {
      return plants[sign];
    });
  });
}

function Garden(diagram, students) {
  var instance = {};
  students = students || defaultChildren;
  students.sort();
  
  students.forEach(function (student, index) {
    instance[student.toLowerCase()] = getPlants(parse(diagram), index);
  });

  return instance;
}

module.exports = Garden;
