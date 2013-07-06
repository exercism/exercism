require './example'

describe '[].accumulate()', ->

  it 'empty accumulation', ->
    accumulator = (e) -> e * e
    expect([]).toEqual [].accumulate(accumulator)


  it 'accumulate squares', ->
    accumulator = (number) -> number * number
    expect([1, 4, 9]).toEqual [1, 2, 3].accumulate accumulator

  it 'accumulate upcases', ->
    accumulator = (word) -> word.toUpperCase()
    result      = 'hello world'.split(/\s/).accumulate accumulator

    expect(['HELLO', 'WORLD']).toEqual result

  it 'accumulate reversed strings', ->
    accumulator = (word) -> word.split('').reverse().join('')
    result      = 'the quick brown fox etc'.split(/\s/).accumulate accumulator

    expect(["eht", "kciuq", "nworb", "xof", "cte"]).toEqual result

  it 'accumulate recursively', ->
    result = 'a b c'.split(/\s+/).accumulate (char)  ->
      '1 2 3'.split(/\s+/).accumulate (digit) -> "#{char}#{digit}"

    expect([["a1", "a2", "a3"], ["b1", "b2", "b3"], ["c1", "c2", "c3"]]).toEqual result
