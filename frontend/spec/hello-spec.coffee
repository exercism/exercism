describe ".helloText", ->
  When -> @result = helloText()
  Then -> expect(@result).toEqual("Hello, World!")