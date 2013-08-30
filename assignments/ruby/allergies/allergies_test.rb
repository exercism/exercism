require 'minitest/autorun'
require_relative 'allergies'

class AllergiesTest < MiniTest::Unit::TestCase

  def test_no_allergies_at_all
    allergies = Allergies.new(0)
    assert_equal [], allergies.list
  end

  def test_allergic_to_just_eggs
    skip
    allergies = Allergies.new(1)
    assert_equal ['eggs'], allergies.list
  end

  def test_allergic_to_just_peanuts
    skip
    allergies = Allergies.new(2)
    assert_equal ['peanuts'], allergies.list
  end

  def test_allergic_to_just_strawberries
    skip
    allergies = Allergies.new(8)
    assert_equal ['strawberries'], allergies.list
  end

  def test_allergic_to_eggs_and_peanuts
    skip
    allergies = Allergies.new(3)
    assert_equal ['eggs', 'peanuts'], allergies.list
  end

  def test_allergic_to_more_than_eggs_but_not_peanuts
    skip
    allergies = Allergies.new(5)
    assert_equal ['eggs', 'shellfish'], allergies.list
  end

  def test_allergic_to_lots_of_stuff
    skip
    allergies = Allergies.new(248)
    assert_equal ['strawberries', 'tomatoes', 'chocolate', 'pollen', 'cats'], allergies.list
  end

  def test_allergic_to_everything
    skip
    allergies = Allergies.new(255)
    assert_equal ['eggs', 'peanuts', 'shellfish', 'strawberries', 'tomatoes', 'chocolate', 'pollen', 'cats'], allergies.list
  end

  def test_no_allergies_means_not_allergic
    skip
    allergies = Allergies.new(0)
    assert !allergies.allergic_to?('peanuts')
    assert !allergies.allergic_to?('cats')
    assert !allergies.allergic_to?('strawberries')
  end

  def test_is_allergic_to_eggs
    skip
    allergies = Allergies.new(1)
    assert allergies.allergic_to?('eggs')
  end

  def test_allergic_to_eggs_in_addition_to_other_stuff
    skip
    allergies = Allergies.new(5)
    assert allergies.allergic_to?('eggs')
  end

  def test_ignore_non_allergen_score_parts
    skip
    allergies = Allergies.new(509)
    assert_equal ['eggs', 'shellfish', 'strawberries', 'tomatoes', 'chocolate', 'pollen', 'cats'], allergies.list
  end

end
