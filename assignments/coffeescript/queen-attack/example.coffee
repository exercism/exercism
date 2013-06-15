exports.Queens = class Queens
  constructor: (options) ->
    if options == undefined
      options = { white: [0,3], black: [7,3] }

    if (options.white[0] == options.black[0] && options.white[1] == options.black[1])
      throw "Queens cannot share the same space"

    @white = options.white
    @black = options.black

  canAttack: ->
    canAttack = false

    canAttack = true if @white[0] == @black[0]
    canAttack = true if @white[1] == @black[1]

    yDiagonal = @white[0] - @black[0]
    xDiagonal = @white[1] - @black[1]

    canAttack = true if xDiagonal == yDiagonal
    canAttack

  toString: ->
    @boardRepresentation()

  boardRow: (rowNumber) ->
    row = (@boardPosition(rowNumber,rowColumn) for rowColumn in [0..7])
    row.join(" ")

  boardPosition: (rowNumber,rowColumn) ->
    if @white[0] == rowNumber && @white[1] == rowColumn
      "W"
    else if @black[0] == rowNumber && @black[1] == rowColumn
      "B"
    else
      "O"

  boardRepresentation: ->
    boardRepresentation = (@boardRow row for row in [0..7])
    boardRepresentation.join("\n")