class Anagram
  constructor: (source) ->
    @source = standardForm(source)

  match: (targets) ->
    target for target in targets when @source is standard_form target

standardForm = (word) ->
  word.toLowerCase().split("").sort().join()

module.exports = Anagram
