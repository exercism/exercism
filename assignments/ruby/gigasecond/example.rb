class Gigasecond

  attr_reader :born_at
  def initialize(date_of_birth)
    @born_at = date_of_birth.to_time
  end

  def date
    (born_at + 1_000_000_000).to_date
  end

end

