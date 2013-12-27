def get_them
  cells.select do |cell|
    cell.flagged?
  end
end