def get_them
  cells.select do |cell|
    cell[0] == FLAGGED
  end
end