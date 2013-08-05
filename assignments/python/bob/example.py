class Bob:
    def hey(self, message):
        if self.is_silence(message):
            return "Fine. Be that way!"
        elif self.is_yelling(message):
            return "Woah, chill out!"
        elif self.is_question(message):
            return "Sure."
        else:
            return "Whatever."

    def is_silence(self, message):
        return not (message and message.strip())

    def is_yelling(self, message):
        return message.strip and message == message.upper()

    def is_question(self, message):
        return message.endswith("?")
