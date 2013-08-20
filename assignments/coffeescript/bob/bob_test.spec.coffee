Bob = require "./bob"
describe "Bob", ->
  bob = new Bob()
  it "stating something", ->
    result = bob.hey "Tom-ay-to, tom-aaaah-to."
    expect(result).toEqual "Whatever."

  xit "shouting", ->
    result = bob.hey "WATCH OUT!"
    expect(result).toEqual "Woah, chill out!"

  xit "asking a question", ->
    result = bob.hey "Does this cryogenic chamber make me look fat?"
    expect(result).toEqual "Sure."

  xit "talking forcefully", ->
    result = bob.hey "Let's go make out behind the gym!"
    expect(result).toEqual "Whatever."

  xit "using acronyms in regular speech", ->
    result = bob.hey "It's OK if you don't want to go to the DMV."
    expect(result).toEqual "Whatever."

  xit "forceful questions", ->
    result = bob.hey "WHAT THE HELL WERE YOU THINKING?"
    expect(result).toEqual "Woah, chill out!"

  xit "shouting numbers", ->
    result = bob.hey "1, 2, 3 GO!"
    expect(result).toEqual "Woah, chill out!"

  xit "shouting with special characters", ->
    result = bob.hey "ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!"
    expect(result).toEqual "Woah, chill out!"

  xit "shouting with no exclamation mark", ->
    result = bob.hey "I HATE YOU"
    expect(result).toEqual "Woah, chill out!"

  xit "statement containing question mark", ->
    result = bob.hey "Ending with a ? means a question."
    expect(result).toEqual "Whatever."

  xit "prattling on", ->
    result = bob.hey "Wait! Hang on.  Are you going to be OK?"
    expect(result).toEqual "Sure."

  xit "silence", ->
    result = bob.hey ""
    expect(result).toEqual "Fine. Be that way!"

  xit "prolonged silence", ->
    result = bob.hey "   "
    expect(result).toEqual "Fine. Be that way!"
