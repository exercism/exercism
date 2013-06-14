class Cipher
  def initialize(key)
    @key = key
    @key_bytes = to_bytes(@key)
  end

  def encode(plaintext)
    ciphertext = []

    to_bytes(plaintext).each_with_index do |byte, index|
      ciphertext << (byte + @key_bytes[index % @key.length]) % 26
    end

    ciphertext = to_string(ciphertext)

    return ciphertext
  end

  def decode(ciphertext)
    plaintext = []

    to_bytes(ciphertext).each_with_index do |byte, index|
      plaintext << (byte - @key_bytes[index % @key.length]) % 26
    end

    plaintext = to_string(plaintext)

    return plaintext
  end

  private

  def to_bytes(string)
    string.unpack("c*").map {|c| c - 97}
  end

  def to_string(bytes)
    bytes.map {|c| c + 97}.pack("c*")
  end
end