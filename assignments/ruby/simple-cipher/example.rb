# # Step 1 version

# class Cipher
#   def initialize(shift_length)
#     @shift_length = shift_length
#   end

#   def encode(plaintext)
#     ciphertext = []

#     to_bytes(plaintext).each_with_index do |byte, index|
#       ciphertext << (byte + @shift_length) % 26
#     end

#     ciphertext = to_string(ciphertext)

#     return ciphertext
#   end

#   def decode(ciphertext)
#     plaintext = []

#     to_bytes(ciphertext).each_with_index do |byte, index|
#       plaintext << (byte - @shift_length) % 26
#     end

#     plaintext = to_string(plaintext)

#     return plaintext
#   end

#   private

#   def to_bytes(string)
#     string.unpack("c*").map {|c| c - 97}
#   end

#   def to_string(bytes)
#     bytes.map {|c| c + 97}.pack("c*")
#   end
# end

class Cipher
  attr_reader :key, :key_bytes

  def initialize(key=nil, key_length=100)
    if key
      check_key_validity(key)
      @key = key
      @key_bytes = to_bytes(@key)
    else
      @key_bytes = []
      key_length.times { @key_bytes << Random.rand(0...26) }
      @key = to_string(@key_bytes)
    end
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

  def check_key_validity(key)
    if key =~ /[A-Z]/
      raise ArgumentError.new("Keys must not contain capital letters")
    elsif key =~ /[0-9]/
      raise ArgumentError.new("Keys must not contain numbers")
    elsif key.empty?
      raise ArgumentError.new("Keys must contain at least one letter")
    end
  end
end