class Word(object):
    def __init__(self, word):
        self.word = word
        self.canonical = self._canonicalize(word)

    def _canonicalize(self, word):
        return sorted(word.lower())

    def is_anagram_of(self, other):
        return self.word != other and self.canonical == self._canonicalize(other)


class Anagram(object):
    def __init__(self, target):
        self.target = Word(target)

    def match(self, candidates):
        return [
            candidate for candidate in candidates
            if self.target.is_anagram_of(candidate)
        ]
