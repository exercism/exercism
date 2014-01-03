require 'minitest/autorun'
require_relative 'proverb'

class ProverbTest < MiniTest::Unit::TestCase
  def test_a_single_consequence
    proverb = Proverb.new('nail', 'shoe')
    expected = "For want of a nail the shoe was lost.\n" +
      "And all for the want of a nail."
    assert_equal expected, proverb.to_s
  end

  def test_a_short_chain_of_consequences
    skip
    proverb = Proverb.new('nail', 'shoe', 'horse')
    expected = "For want of a nail the shoe was lost.\n" +
      "For want of a shoe the horse was lost.\n" +
      "And all for the want of a nail."
    assert_equal expected, proverb.to_s
  end

  def test_a_longer_chain_of_consequences
    skip
    proverb = Proverb.new('nail', 'shoe', 'horse', 'rider')
    expected = "For want of a nail the shoe was lost.\n" +
      "For want of a shoe the horse was lost.\n" +
      "For want of a horse the rider was lost.\n" +
      "And all for the want of a nail."
    assert_equal expected, proverb.to_s
  end

  def test_proverb_does_not_hard_code_the_rhyme_dictionary
    skip
    proverb = Proverb.new('key', 'value')
    expected = "For want of a key the value was lost.\n" +
      "And all for the want of a key."
    assert_equal expected, proverb.to_s
  end

  def test_the_whole_proverb
    skip
    chain = [
      'nail', 'shoe', 'horse', 'rider', 'message', 'battle', 'kingdom'
    ]
    proverb = Proverb.new(*chain)
    expected = "For want of a nail the shoe was lost.\n" +
      "For want of a shoe the horse was lost.\n" +
      "For want of a horse the rider was lost.\n" +
      "For want of a rider the message was lost.\n" +
      "For want of a message the battle was lost.\n" +
      "For want of a battle the kingdom was lost.\n" +
      "And all for the want of a nail."
    assert_equal expected, proverb.to_s
  end

  def test_an_optional_qualifier_in_the_final_consequence
    skip
    chain = [
      'nail', 'shoe', 'horse', 'rider', 'message', 'battle', 'kingdom'
    ]
    proverb = Proverb.new(*chain, qualifier: 'horseshoe')
    expected = "For want of a nail the shoe was lost.\n" +
      "For want of a shoe the horse was lost.\n" +
      "For want of a horse the rider was lost.\n" +
      "For want of a rider the message was lost.\n" +
      "For want of a message the battle was lost.\n" +
      "For want of a battle the kingdom was lost.\n" +
      "And all for the want of a horseshoe nail."
    assert_equal expected, proverb.to_s
  end

  def test_proverb_is_same_each_time
    skip
    proverb = Proverb.new('nail', 'shoe')
    assert_equal proverb.to_s, proverb.to_s
  end
end
