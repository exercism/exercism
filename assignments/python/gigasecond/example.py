from datetime import timedelta

class Gigasecond(object):
    def __init__(self, date_of_birth):
        self.date = date_of_birth + timedelta(seconds=1e9)
