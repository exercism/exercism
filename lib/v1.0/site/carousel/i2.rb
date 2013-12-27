def get_them
  list.select do |entry|
    entry[0] == 4
  end
end