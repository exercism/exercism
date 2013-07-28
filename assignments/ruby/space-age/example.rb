class SpaceAge
  attr_reader :seconds

  def initialize(seconds)
    @seconds = seconds
  end

  ORBITAL_PERIODS = {
    :mercury => 7600530.24,
    :venus   => 19413907.2,
    :earth   => 31558149.76,
    :mars    => 59354294.4,
    :jupiter => 374335776.0,
    :saturn  => 929596608.0,
    :uranus  => 2661041808.0,
    :neptune => 5200418592.0
  }

  ORBITAL_PERIODS.each do |planet, period|

    define_method("on_#{planet}") do
      (seconds / period).round(2)
    end

  end
end

