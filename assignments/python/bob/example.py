class Bob(object):
    def hey(self, stimulus):
        if self._is_silence(stimulus):
            return 'Fine. Be that way!'

        elif self._is_shouting(stimulus):
            return 'Woah, chill out!'

        elif self._is_statement(stimulus):
            return 'Whatever.'

        elif self._is_question(stimulus):
            return 'Sure.'

    def _is_silence(self, stimulus):
        return stimulus == ''

    def _is_shouting(self, stimulus):
        return stimulus == stimulus.upper()

    def _is_statement(self, stimulus):
        return stimulus.endswith('.')

    def _is_question(self, stimulus):
        return stimulus.endswith('?')

