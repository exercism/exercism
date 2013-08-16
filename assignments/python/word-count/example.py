from collections import defaultdict
import re

class Phrase(object):
    def __init__(self, phrase):
        self.phrase = phrase

    def word_count(self):
        'count words in the string'
        counts = defaultdict(int)

        for word in self._words():
            counts[word] += 1

        return counts

    def _words(self):
        'get the words (no symbols or numbers) in the phrase'
        words_re = re.compile(r'\w+')
        sanitized = self._sanitize()

        for word in words_re.finditer(sanitized):
            yield word.group()

    def _sanitize(self):
        'sanitize the phrase'
        return self.phrase.lower()
