require 'date'

class Year

  def self.leap?(year)
    begin
      Date.new(year, 2, 29) and true
    rescue
      false
    end
  end

end

