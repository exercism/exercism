
Prime = {
  nth: function(nthPrime) {
    if (nthPrime == 0) { throw "Prime is not possible"; }
    this.generatePrimes(200000);
    return this.realPrimes[nthPrime - 1];
  },
  generatePrimes: function(uptoNumber) {
    if (this.realPrimes) { return this.realPrimes; }

    var possiblePrimes = [];

    for (var i = 2; i <= uptoNumber; i++) {
      possiblePrimes.push({ number: i, prime: true});
    }

    for (var i = 2; i < Math.sqrt(possiblePrimes.length); i++) {
      for (var j = 0; j < possiblePrimes.length; j++) {
        var currentPrime = possiblePrimes[j];
        if (currentPrime.number != i && currentPrime.number % i == 0) {
          currentPrime.prime = false;
        }
      }
    }

    var primeCount = 0;

    this.realPrimes = [];

    for (var i = 0; i < possiblePrimes.length; i++) {
      var currentPrime = possiblePrimes[i];
      if (currentPrime.prime) {
        this.realPrimes.push(currentPrime.number);
      }
    };
  }

};
