defmodule SpaceAge do
  def earth_years(seconds),   do: seconds / 31557600.0
  def mercury_years(seconds), do: earth_years(seconds) / 0.2408467
  def venus_years(seconds),   do: earth_years(seconds) / 0.61519726
  def mars_years(seconds),    do: earth_years(seconds) / 1.8808158
  def jupiter_years(seconds), do: earth_years(seconds) / 11.862615
  def saturn_years(seconds),  do: earth_years(seconds) / 29.447498
  def uranus_years(seconds),  do: earth_years(seconds) / 84.016846
  def neptune_years(seconds), do: earth_years(seconds) / 164.79132
end
