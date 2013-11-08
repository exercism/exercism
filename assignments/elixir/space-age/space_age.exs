defmodule SpaceAge do
  @type planet :: :mercury | :venus | :earth | :mars | :jupiter
                | :saturn | :neptune | :uranus

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'. 
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(planet, seconds) do

  end
end
