class SpaceAge

  attr_reader :seconds
  def initialize(seconds)
    @seconds = seconds
  end

  def on_earth
    earth_year.round(2)
  end

  def on_mercury
    (earth_year / 0.2408467).round(2)
  end

  def on_venus
    (earth_year / 0.61519726).round(2)
  end

  def on_mars
    (earth_year / 1.8808158).round(2)
  end

  def on_jupiter
   (earth_year / 11.862615).round(2)
  end

  def on_saturn
   (earth_year / 29.447498).round(2)
  end

  def on_uranus
   (earth_year / 84.016846).round(2)
  end

  def on_neptune
   (earth_year / 164.79132).round(2)
  end

  private

  def earth_year
    seconds / seconds_per_earth_year
  end

  def seconds_per_day
    60 * 60 * 24
  end

  def seconds_per_earth_year
    31557600.0
  end
end
