exports.Luhn = class Luhn
  constructor: (number) ->
    @checkDigit = number % 10
    @addends = @calculateAddends(number)
    @checksum = @calculateChecksum(@addends)
    @valid = @determineIfValid(@checksum)

  calculateAddends: (number) ->

    numberAsString = "" + number + ""
    numbers = numberAsString.split('')

    addends = (@calculateAddend(i,numbers) for i in [0..numbers.length-1])
    addends.reverse()

  calculateAddend: (i,numbers) ->
    index = numbers.length - 1 - i

    currentAddend = parseInt(numbers[index])

    if (i + 1) % 2 == 0
      currentAddend = currentAddend * 2
      if currentAddend > 10
        currentAddend = currentAddend - 9

    currentAddend

  calculateChecksum: (numbers) ->
    numbers.reduce (x,y) -> x + y

  determineIfValid: (sum) ->
    (sum % 10 == 0)


Luhn.create = (number) ->
  finalNumber = number * 10
  luhnNumber = new Luhn(finalNumber)
  index = 0

  while(!luhnNumber.valid)
    finalNumber = number * 10 + index
    luhnNumber = new Luhn(finalNumber)
    break if luhnNumber.valid
    index += 1

  finalNumber