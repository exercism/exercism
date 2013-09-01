exports.WordProblem = class WordProblem

  BINARY_OPERATORS:
    'plus':          (l, r) -> l + r
    'minus':         (l, r) -> l - r
    'multiplied by': (l, r) -> l * r
    'divided by':    (l, r) -> l / r

  ERROR:
    tooComplicated: new Error("I don't understand the question")

  constructor: (@question = '') ->
    @matches = @question.match @pattern()

  operators: ->
    Object.keys @BINARY_OPERATORS

  pattern: ->
    operations = " (#{@operators().join('|')}) "

    /// (?:
      what[\x20]is[\x20] # what is
      ([-+]?[\d]+)       # +/- number
      #{operations}      # operator (plus, minus, etc.)
      ([-+]?[\d]+)       # +/- number
      (?:                # optional extra group
        #{operations}    # operator (plus, minus, etc.)
        ([-+]?[\d]+)     # +/- number
      )?                 # end optional extra group
    ) ///i

  tooComplicated: -> not @matches

  answer: =>
    throw @ERROR.tooComplicated if @tooComplicated()
    @evaluate()

  evaluate: ->
    out = 0
    m   = @matches

    out = @operate(m[2], m[1], m[3]) if m[1]? && m[2]? && m[3]?
    out = @operate(m[4], out,  m[5]) if m[4]? && m[5]?
    out

  operate: (operation, l, r) ->
    fn = @BINARY_OPERATORS[operation] || -> 0
    fn Number(l), Number(r)

