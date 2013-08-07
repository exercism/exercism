'use strict';

function Allergies(allergenIndex) {
  this.allergenIndex = allergenIndex;
}

Allergies.possibleAllergies = [ "eggs", "peanuts", "shellfish", "strawberries",
                                 "tomatoes", "chocolate", "pollen", "cats"];

Allergies.prototype = {
  list: function() {
    var possibleAllergies = Allergies.possibleAllergies;

    var allergicTo = [];

    for (var i = 0; i < possibleAllergies.length; i++) {
      var allergy = possibleAllergies[i];
      if (this.allergenIndex & Math.pow(2,i)) {
        allergicTo.push(allergy);
      }
    }
    return allergicTo;
  },
  allergicTo: function(food) {
    var isAllergic = false;

    var allergyList = this.list();
    for (var i = 0; i < allergyList.length; i++) {
      if (allergyList[i] === food) {
        isAllergic = true;
        break;
      }
    }

    return isAllergic;
  }
};

module.exports = Allergies;