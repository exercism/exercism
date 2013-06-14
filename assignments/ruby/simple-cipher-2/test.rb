require 'minitest/autorun'
require 'minitest/pride'
require_relative './cipher'

class SubstitutionCipherTest < MiniTest::Unit::TestCase
  def setup
    key = "abcdefghij"
    @cipher = Cipher.new(key)
  end

  def test_cipher_encode
    plaintext = "aaaaaaaaaa"
    ciphertext = "abcdefghij"
    assert_equal(ciphertext, @cipher.encode(plaintext))
  end

  def test_cipher_decode
    skip
    plaintext = "aaaaaaaaaa"
    ciphertext = "abcdefghij"
    assert_equal(plaintext, @cipher.decode(ciphertext))
  end

  def test_cipher_reversible
    skip
    plaintext = "abcdefghij"
    assert_equal(plaintext, @cipher.decode(@cipher.encode(plaintext)))
  end

  def test_double_shift_encode
    skip
    plaintext = "iamapandabear"
    ciphertext = "qayaeaagaciai"
    assert_equal(ciphertext, Cipher.new("iamapandabear").encode(plaintext))
  end

  def test_cipher_encode_wrap
    skip
    plaintext = "zzzzzzzzzz"
    ciphertext = "zabcdefghi"
    assert_equal(ciphertext, @cipher.encode(plaintext))
  end
end

class PseudoShiftCipherTest < MiniTest::Unit::TestCase
  def setup
    @cipher = Cipher.new("dddddddddd")
  end

  def test_cipher_encode
    skip
    plaintext = "aaaaaaaaaa"
    ciphertext = "dddddddddd"
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
end
