def get_them
  them = []
  list.each do |entry|
    if entry[0] == 4
      them << entry
    end
  end
  them
end
