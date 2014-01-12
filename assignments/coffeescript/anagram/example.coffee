class Anagram
  constructor: (source) ->
    @source = source

  match: (targets) ->
    (target.toLowerCase() for target in targets when areAnagrams(@source, target))

areAnagrams = (word1, word2) ->
  return false if word1.toLowerCase() == word2.toLowerCase()

  standardForm(word1) == standardForm(word2)

standardForm = (word) ->
  word.toLowerCase().split("").sort().join()

module.exports = Anagram
