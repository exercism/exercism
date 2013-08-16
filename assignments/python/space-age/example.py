import math

def period_converter(period):
    def inner(self):
        return round(
            self.seconds / period,
            2
        )

    return inner

class SpaceAge(object):

    on_mercury = period_converter(7600530.24)
    on_venus = period_converter(19413907.2)
    on_earth = period_converter(31558149.76)
    on_mars = period_converter(59354294.4)
    on_jupiter = period_converter(374335776.0)
    on_saturn = period_converter(929596608.0)
    on_uranus = period_converter(2661041808.0)
    on_neptune = period_converter(5200418592.0)

    def __init__(self, seconds):
        self.seconds = seconds
