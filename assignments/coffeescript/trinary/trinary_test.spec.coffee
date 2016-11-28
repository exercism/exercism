Trinary = require './example'

describe 'Trinary', ->

  it '1 is decimal 1', ->
    expect(1).toEqual new Trinary('1').toDecimal()

  xit '2 is decimal 2', ->
    expect(2).toEqual new Trinary('2').toDecimal()

  xit '10 is decimal 3', ->
    expect(3).toEqual new Trinary('10').toDecimal()

  xit '11 is decimal 4', ->
    expect(4).toEqual new Trinary('11').toDecimal()

  xit '100 is decimal 9', ->
    expect(9).toEqual new Trinary('100').toDecimal()

  xit '112 is decimal 14', ->
    expect(14).toEqual new Trinary('112').toDecimal()

  xit '222 is 26', ->
    expect(26).toEqual new Trinary('222').toDecimal()

  xit '1122000120 is 32091', ->
    expect(32091).toEqual new Trinary('1122000120').toDecimal()

  xit 'invalid trinary is decimal 0', ->
    expect(0).toEqual new Trinary('carrot').toDecimal()

