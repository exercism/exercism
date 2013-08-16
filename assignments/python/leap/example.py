class Year(object):
    def __init__(self, year):
        self.year = year

    def is_leap_year(self):
        return (self._by_4() and not self._by_100()) \
               or self._by_400()

    def _by_4(self):
        return self.year % 4 == 0

    def _by_100(self):
        return self.year % 100 == 0

    def _by_400(self):
        return self.year % 400 == 0
