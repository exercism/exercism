class SpaceAge
  attr_reader :seconds

  def initialize(seconds)
    @seconds = seconds.to_f
  end

  EARTH_YEAR = 31_557_600

  {
    "mercury" => EARTH_YEAR * 0.2408467,
    "earth"   => EARTH_YEAR,
    "venus"   => EARTH_YEAR * 0.61519726,
    "mars"    => EARTH_YEAR * 1.8808158,
    "jupiter" => EARTH_YEAR * 11.862615,
    "saturn"  => EARTH_YEAR * 29.447498,
    "uranus"  => EARTH_YEAR * 84.016846,
    "neptune" => EARTH_YEAR * 164.79132
  }.each do |planet, seconds_per_year|

    define_method("on_#{planet}") do
      (seconds / seconds_per_year).round(2)
    end

  end
end

