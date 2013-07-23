require 'minitest/autorun'
require_relative 'crypto'

class CryptoTest < MiniTest::Unit::TestCase
  def test_normalize_strange_characters
    crypto = Crypto.new('s#$%^&plunk')
    assert_equal "splunk", crypto.normalize_plaintext
  end

  def test_normalize_with_numbers
    skip
    crypto = Crypto.new('1, 2, 3 GO!')
    assert_equal "123go", crypto.normalize_plaintext
  end

  def test_size_of_small_square
    skip
    crypto = Crypto.new('1234')
    assert_equal 2, crypto.size
  end

  def test_size_of_slightly_larger_square
    skip
    crypto = Crypto.new('123456789')
    assert_equal 3, crypto.size
  end

  def test_size_of_non_perfect_square
    skip
    crypto = Crypto.new('123456789abc')
    assert_equal 4, crypto.size
  end

  def test_plaintext_segments
    skip
    crypto = Crypto.new('Never vex thine heart with idle woes')
    assert_equal ["neverv", "exthin", "eheart", "withid", "lewoes"], crypto.plaintext_segments
  end

  def test_other_plaintext_segments
    skip
    crypto = Crypto.new('ZOMG! ZOMBIES!!!')
    assert_equal ["zomg", "zomb", "ies"], crypto.plaintext_segments
  end

  def test_ciphertext
    skip
    crypto = Crypto.new('Time is an illusion. Lunchtime doubly so.')
    assert_equal "tasneyinicdsmiohooelntuillibsuuml", crypto.ciphertext
  end

  def test_another_ciphertext
    skip
    crypto = Crypto.new('We all know interspecies romance is weird.')
    assert_equal "wneiaweoreneawssciliprerlneoidktcms", crypto.ciphertext
  end

  def test_normalized_ciphertext
    skip
    crypto = Crypto.new('Madness, and then illumination.')
    assert_equal 'msemo aanin dninn dlaet ltshu i', crypto.normalize_ciphertext
  end

  def test_more_normalized_ciphertext
    skip
    crypto = Crypto.new('Vampires are people too!')
    assert_equal 'vrela epems etpao oirpo', crypto.normalize_ciphertext
  end
end
