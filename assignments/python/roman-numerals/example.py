class RomanNumeral(object):
    mappings = (
        (1000, 'M'),
        (900,  'CM'),
        (500,  'D'),
        (400,  'CD'),
        (100,  'C'),
        (90,   'XC'),
        (50,   'L'),
        (40,   'XL'),
        (10,   'X'),
        (9,    'IX'),
        (5,    'V'),
        (4,    'IV'),
        (1,    'I')
    )

    def __init__(self, arabic):
        self.arabic = arabic

    def to_roman(self):
        i = int(self.arabic)
        s = ''
        for arabic, roman in self.mappings:
            while i >= arabic:
                s += roman
                i -= arabic

        return s

    def __str__(self):
        return self.to_roman()
