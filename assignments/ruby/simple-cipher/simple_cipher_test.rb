require 'minitest/autorun'
require_relative 'cipher'

class RandomKeyCipherTest < MiniTest::Unit::TestCase
  def setup
    @cipher = Cipher.new(nil)
  end

  def test_cipher_key_is_letters
    assert_match(/[a-z]+/, @cipher.key)
  end

  # Here we take advantage of the fact that plaintext of "aaa..." doesn't outputs
  # the key. This is a critical problem with shift ciphers, some characters
  # will always output the key verbatim.
  def test_cipher_encode
    skip
    plaintext = "aaaaaaaaaa"
    assert_equal(@cipher.key[0,10], @cipher.encode(plaintext))
  end

  def test_cipher_decode
    skip
    plaintext = "aaaaaaaaaa"
    assert_equal(plaintext, @cipher.decode(@cipher.key[0,10]))
  end

  def test_cipher_reversible
    skip
    plaintext = "abcdefghij"
    assert_equal(plaintext, @cipher.decode(@cipher.encode(plaintext)))
  end
end

class IncorrectKeyCipherTest < MiniTest::Unit::TestCase
  def test_cipher_with_caps_key
    skip
    assert_raises ArgumentError do
      Cipher.new("ABCDEF")
    end
  end

  def test_cipher_with_numeric_key
    skip
    assert_raises ArgumentError do
      Cipher.new("12345")
    end
  end

  def test_cipher_with_empty_key
    skip
    assert_raises ArgumentError do
      Cipher.new("")
    end
  end
end

class SubstitutionCipherTest < MiniTest::Unit::TestCase
  def setup
    @key = "abcdefghij"
    @cipher = Cipher.new(@key)
  end

  def test_cipher_key_is_as_submitted
    skip
    assert_equal(@cipher.key, @key)
  end

  def test_cipher_encode
    skip
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
