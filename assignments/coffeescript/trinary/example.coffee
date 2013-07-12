module.exports = class Trinary
  BASE: 3

  constructor: (decimal) ->
    @digits = decimal.split('').reverse().map Number

  toDecimal: ->
    out = this.digits.reduce this.accumulator, 0
    if isNaN out then 0 else out

  accumulator: (decimal, digit, index) =>
    decimal += digit * Math.pow @BASE, index
