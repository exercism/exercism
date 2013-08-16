Code.load_file("allergies.exs")
ExUnit.start

defmodule AllergiesTest do
  use ExUnit.Case, async: true
  doctest Allergies

  test "no_allergies_at_all" do
    assert [] == Allergies.list(0)
  end

  test "allergic_to_just_eggs" do
    assert ["eggs"] == Allergies.list(1)
  end

  test "allergic_to_just_peanuts" do
    assert ["peanuts"] == Allergies.list(2)
  end

  test "allergic_to_just_strawberries" do
    assert ["strawberries"] == Allergies.list(8)
  end

  test "allergic_to_eggs_and_peanuts" do
    assert ["eggs", "peanuts"] == Allergies.list(3)
  end

  test "allergic_to_more_than_eggs_but_not_peanuts" do
    assert ["eggs", "shellfish"] == Allergies.list(5)
  end

  test "allergic_to_lots_of_stuff" do
    assert ["strawberries", "tomatoes", "chocolate", "pollen", "cats"] == Allergies.list(248)
  end

  test "allergic_to_everything" do
    assert ["eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"] == Allergies.list(255)
  end

  test "no_allergies_means_not_allergic" do
    assert ! Allergies.allergic_to?(0, "peanuts")
    assert ! Allergies.allergic_to?(0, "cats")
    assert ! Allergies.allergic_to?(0, "strawberries")
  end

  test "is_allergic_to_eggs" do
    assert Allergies.allergic_to?(1, "eggs")
  end

  test "allergic_to_eggs_in_addition_to_other_stuff" do
    assert Allergies.allergic_to?(5, "eggs")
  end

  test "ignore_non_allergen_score_parts" do
    assert ["eggs", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"] == Allergies.list(509)
  end
end
