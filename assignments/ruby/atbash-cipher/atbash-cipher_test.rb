require 'minitest/autorun'
require 'minitest/pride'
require_relative 'atbash'

class AtbashTest < MiniTest::Unit::TestCase

  def test_encode_no
    assert_equal 'ml', Atbash.encode('no')
  end

  def test_encode_yes
    skip
    assert_equal 'bvh', Atbash.encode('yes')
  end

  def test_encode_OMG
    skip
    assert_equal 'lnt', Atbash.encode('OMG')
  end

  def test_encode_O_M_G
    skip
    assert_equal 'lnt', Atbash.encode('O M G')
  end

  def test_encode_long_word
    skip
    assert_equal 'nrmwy oldrm tob', Atbash.encode('mindblowingly')
  end

  def test_encode_numbers
    skip
    assert_equal 'gvhgr mt123 gvhgr mt', Atbash.encode('Testing, 1 2 3, testing.')
  end

  def test_encode_sentence
    skip
    assert_equal 'gifgs rhurx grlm', Atbash.encode('Truth is fiction.')
  end

  def test_encode_all_the_things
    skip
    plaintext = 'The quick brown fox jumps over the lazy dog.'
    cipher = 'gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt'
    assert_equal cipher, Atbash.encode(plaintext)
  end

end
