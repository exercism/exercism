class Crypto
  attr_reader :plaintext
  def initialize(plaintext)
    @plaintext = plaintext
  end

  def normalize_plaintext
    @normalized ||= plaintext.downcase.scan(/[a-z0-9]/).join
  end

  def size
    Math.sqrt(normalize_plaintext.length).ceil
  end

  def plaintext_segments
    normalize_plaintext.scan(/.{1,#{size}}/)
  end

  def ciphertext
    cipher_chunks = []
    plaintext_segments.each do |segment|
      segment.chars.each_with_index do |letter, i|
        cipher_chunks[i] ||= []
        cipher_chunks[i] << letter
      end
    end
    cipher_chunks.map {|chunk| chunk.join}.join
  end

  def normalize_ciphertext
    ciphertext.scan(/.{1,5}/).join(" ")
  end
end
