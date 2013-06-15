exports.Prime = class Prime
  @nth: (nthPrime) ->
    throw "Prime is not possible" if nthPrime == 0
    @generatePrimes(200000)
    @realPrimes[nthPrime - 1]

  @generatePrimes: (uptoNumber) ->
    return @realPrimes if @realPrimes

    possiblePrimes = []

    for numberValue in [2..uptoNumber]
      possiblePrimes.push({ number: numberValue, prime: true })

    for number in [2..Math.sqrt(possiblePrimes.length)]
      for currentPrime in possiblePrimes
        if currentPrime.number != number && currentPrime.number % number == 0
          currentPrime.prime = false

    primeCount = 0

    @realPrimes = possiblePrimes.filter (possiblePrime) -> possiblePrime.prime
    @realPrimes = @realPrimes.map (prime) -> prime.number