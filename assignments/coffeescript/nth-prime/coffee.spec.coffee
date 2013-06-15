Prime = require('./prime').Prime

describe 'Prime', ->

  it 'first', ->
    prime = Prime.nth(1)
    expect(prime).toEqual(2)

  it 'second', ->
    prime = Prime.nth(2)
    expect(prime).toEqual(3)

  it 'sixth', ->
    prime = Prime.nth(6)
    expect(prime).toEqual(13)

  it 'big prime', ->
    prime = Prime.nth(10001)
    expect(prime).toEqual(104743)

  it 'weird case', ->
    try
      Prime.nth(0)
    catch error
      expect(error).toEqual("Prime is not possible")