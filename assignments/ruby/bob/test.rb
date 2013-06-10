require 'minitest/autorun'
require 'minitest/pride'
require_relative 'bob'

class BobTest < MiniTest::Unit::TestCase
  attr_reader :bob

  def setup
    @bob = Bob.new
  end

  def test_stating_something
    assert_equal 'Whatever.', bob.hey('Tom-ay-to, tom-aaaah-to.')
  end

  def test_shouting
    skip
    assert_equal 'Woah, chill out!', bob.hey('WATCH OUT!')
  end

  def test_asking_a_question
    skip
    assert_equal 'Sure.', bob.hey('Does this cryogenic chamber make me look fat?')
  end

  def test_talking_forcefully
    skip
    assert_equal 'Whatever.', bob.hey("Let's go make out behind the gym!")
  end

  def test_shouting_numbers
    skip
    assert_equal 'Woah, chill out!', bob.hey('1, 2, 3 GO!')
  end

  def test_shouting_with_special_characters
    skip
    assert_equal 'Woah, chill out!', bob.hey('ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!')
  end

  def test_silence
    skip
    assert_equal 'Fine, be that way.', bob.hey('')
  end

end
