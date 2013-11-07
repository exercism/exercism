defmodule SpaceAge do

  def age_on(:earth, seconds), do: seconds / 31557600.0
  def age_on(planet, seconds), do: age_on(:earth, seconds) / planet_rel_years(planet)

  defp planet_rel_years(:mercury), do: 0.2408467
  defp planet_rel_years(:venus),   do: 0.61519726
  defp planet_rel_years(:mars),    do: 1.8808158
  defp planet_rel_years(:jupiter), do: 11.862615
  defp planet_rel_years(:saturn),  do: 29.447498
  defp planet_rel_years(:uranus),  do: 84.016846
  defp planet_rel_years(:neptune), do: 164.79132
end
