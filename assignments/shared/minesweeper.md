Minesweeper is a popular game where the user has to find the mines using numeric
hints that indicate how many mines are directly adjacent (horizontally,
vertically, diagonally) to a square.

In this exercise you have to create some code that counts the number of mines
adjacent to a square and transforms boards like this (where `*` indicates a
mine):

    +-----+
    | * * |
    |  *  |
    |  *  |
    |     |
    +-----+

into this:

    +-----+
    |1*3*1|
    |13*31|
    | 2*2 |
    | 111 |
    +-----+
