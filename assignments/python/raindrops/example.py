
def _is_pling(number):
    return number % 3 == 0


def _is_plang(number):
    return number % 5 == 0


def _is_plong(number):
    return number % 7 == 0


def _drops_for(number):
    drops = []
    if _is_pling(number):
        drops.append('Pling')

    if _is_plang(number):
        drops.append('Plang')

    if _is_plong(number):
        drops.append('Plong')

    return drops


def raindrops(number):
    drops = _drops_for(number)

    return ''.join(drops) or str(number)
