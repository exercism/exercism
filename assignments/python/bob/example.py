class Bob(object):
    def hey(self, stimulus):
        if self._is_silence(stimulus):
            return 'Fine. Be that way!'
        elif self._is_shouting(stimulus):
            return 'Woah, chill out!'
        elif self._is_question(stimulus):
            return 'Sure.'
        else:
            return 'Whatever.'

    def _is_silence(self, stimulus):
        return stimulus.strip() == ''

    def _is_shouting(self, stimulus):
        return (stimulus.upper() == stimulus and
                any(c.isalpha() for c in stimulus))

    def _is_question(self, stimulus):
        return stimulus.endswith('?')
