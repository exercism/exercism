require 'minitest/autorun'
require 'minitest/pride'
require_relative './cipher'

class ShiftCipherTest < MiniTest::Unit::TestCase
  def setup
    @cipher = Cipher.new(3)
  end

  def test_cipher_encode
    plaintext = "aaaaaaaaaa"
    ciphertext = "dddddddddd"
    assert_equal(ciphertext, @cipher.encode(plaintext))
  end

  def test_cipher_encode_wrap
    skip
    plaintext = "zzzzzzzzzz"
    ciphertext = "cccccccccc"
    assert_equal(ciphertext, @cipher.encode(plaintext))
  end

  def test_cipher_decode
    skip
    plaintext = "aaaaaaaaaa"
    ciphertext = "dddddddddd"
    assert_equal(plaintext, @cipher.decode(ciphertext))
  end

  def test_cipher_reversible
    skip
    plaintext = "abcdefghij"
    assert_equal(plaintext, @cipher.decode(@cipher.encode(plaintext)))
  end

  # Private method tests
  # These are generally bad to test but sometimes we do during particularly
  # complicated things.
  # def test_to_bytes
  #   assert_equal([0, 1, 2], @cipher.to_bytes("abc"))
  # end

  # def test_to_string
  #   assert_equal("abc", @cipher.to_string([0, 1, 2]))
  # end
end
