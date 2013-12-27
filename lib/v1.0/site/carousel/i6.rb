def flagged_cells
  cells.select do |cell|
    cell.flagged?
  end
end