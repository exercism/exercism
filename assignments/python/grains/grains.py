def on_square(number):
    return 2 ** (number - 1)

def total_after(square):
    return sum([
        on_square(n + 1) for n
        in range(0, square)
    ])
