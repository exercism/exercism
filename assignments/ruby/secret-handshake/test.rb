require 'minitest/autorun'
require 'minitest/pride'
require_relative 'secret_handshake'

class SecretHandshakeTest < MiniTest::Unit::TestCase
  def test_handshake_1_to_wink
    handshake = SecretHandshake.new(1)
    assert_equal ["wink"], handshake.commands
  end

  def test_handshake_10_to_double_blink
    skip
    handshake = SecretHandshake.new(2)
    assert_equal ["double blink"], handshake.commands
  end

  def test_handshake_100_to_close_your_eyes
    skip
    handshake = SecretHandshake.new(4)
    assert_equal ["close your eyes"], handshake.commands
  end

  def test_handshake_1000_to_jump
    skip
    handshake = SecretHandshake.new(8)
    assert_equal ["jump"], handshake.commands
  end

  def test_handshake_11_to_wink_and_double_blink
    skip
    handshake = SecretHandshake.new(3)
    assert_equal ["wink","double blink"], handshake.commands
  end

  def test_handshake_10011_to_double_blink_and_wink
    skip
    handshake = SecretHandshake.new(19)
    assert_equal ["double blink","wink"], handshake.commands
  end

  def test_handshake_11111_to_double_blink_and_wink
    skip
    handshake = SecretHandshake.new(31)
    assert_equal ["jump","close your eyes","double blink","wink"], handshake.commands
  end

  def test_invalid_handshake
    skip
    handshake = SecretHandshake.new("piggies")
    assert_equal [], handshake.commands
  end
end
