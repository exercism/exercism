require 'time'
require 'date'

class Gigasecond
  attr_reader :date_of_birth
  def initialize(date_of_birth)
    @date_of_birth = date_of_birth
  end

  def date
    (date_of_birth.to_time + 1_000_000_000).to_date
  end
end
