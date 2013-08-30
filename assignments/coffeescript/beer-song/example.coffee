##############
# Public API #
##############
verse = module.exports.verse = (num) ->
  switch num # Not breaking because of return.
    when 0 then """
    No more bottles of beer on the wall, no more bottles of beer.
    Go to the store and buy some more, 99 bottles of beer on the wall.
    """
    else """
    #{ bottles(num) } of beer on the wall, #{ bottles(num) } of beer.
    Take #{ one(num) } down and pass it around, #{ bottles(num - 1) } of beer on the wall.
    """

sing = module.exports.sing = (start, end = 0) ->
  (verse(num) + "\n" for num in [start..end]).join "\n"


###################
# Private Helpers #
###################
bottles = (num) ->
  switch num
    when 0 then "no more bottles"
    when 1 then "1 bottle"
    else "#{num} bottles"

one = (num) ->
  switch num # Not breaking because of return.
    when 1 then "it"
    else "one"
