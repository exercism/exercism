'use strict';

module.exports = {
  nth: function(nthPrime) {
    if (nthPrime === 0) { throw new Error("Prime is not possible"); }
    this.generatePrimes(200000);
    return this.realPrimes[nthPrime - 1];
  },
  generatePrimes: function(uptoNumber) {
    var i, j, currentPrime, primeCount, possiblePrimes = [];

    if (this.realPrimes) { return this.realPrimes; }

    for (i = 2; i <= uptoNumber; i++) {
      possiblePrimes.push({ number: i, prime: true});
    }

    for (i = 2; i < Math.sqrt(possiblePrimes.length); i++) {
      for (j = 0; j < possiblePrimes.length; j++) {
        currentPrime = possiblePrimes[j];
        if (currentPrime.number !== i && currentPrime.number % i === 0) {
          currentPrime.prime = false;
        }
      }
    }

    primeCount = 0;

    this.realPrimes = [];

    for (i = 0; i < possiblePrimes.length; i++) {
      currentPrime = possiblePrimes[i];
      if (currentPrime.prime) {
        this.realPrimes.push(currentPrime.number);
      }
    }
  }

};
