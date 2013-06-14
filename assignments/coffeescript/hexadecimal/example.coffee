exports.Hexadecimal = class Hexadecimal
  constructor: (hex) ->
    @hex = hex

  toDecimal: ->
    for char in this.hex.split("")
      return 0 if /[^0-9a-fA-F]/.exec(char)

    parseInt(this.hex,16)