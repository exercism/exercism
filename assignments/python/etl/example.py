def transform(old):
    return {
        letter.lower(): points
        for points, letters in old.items()
        for letter in letters
    }
