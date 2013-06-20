require 'minitest/autorun'
require 'minitest/pride'
require_relative 'teenager'

class TeenagerTest < MiniTest::Unit::TestCase
  attr_reader :teenager

  def setup
    @teenager = Bob.new
  end

  def test_stating_something
    assert_equal 'Whatever.', teenager.hey('Tom-ay-to, tom-aaaah-to.')
  end

  def test_shouting
    skip
    assert_equal 'Woah, chill out!', teenager.hey('WATCH OUT!')
  end

  def test_asking_a_question
    skip
    assert_equal 'Sure.', teenager.hey('Does this cryogenic chamber make me look fat?')
  end

  def test_talking_forcefully
    skip
    assert_equal 'Whatever.', teenager.hey("Let's go make out behind the gym!")
  end

  def test_shouting_numbers
    skip
    assert_equal 'Woah, chill out!', teenager.hey('1, 2, 3 GO!')
  end

  def test_shouting_with_special_characters
    skip
    assert_equal 'Woah, chill out!', teenager.hey('ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!')
  end

  def test_silence
    skip
    assert_equal 'Fine. Be that way.', teenager.hey('')
  end

end
