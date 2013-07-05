class Atbash

  def self.encode(plaintext)
    new(plaintext).encode
  end

  attr_reader :plaintext

  def initialize(plaintext)
    @plaintext = plaintext
  end

  def encode
    chunk convert(normalize(plaintext))
  end

  private

  def convert(s)
    s.tr(alphabet, key)
  end

  def chunk(s)
    s.scan(/.{1,5}/).join(' ')
  end

  def normalize(s)
    s.downcase.gsub(/[^a-z0-9]/, '')
  end

  def alphabet
    "abcdefghijklmnopqrstuvwxyz"
  end

  def key
    alphabet.reverse
  end

end
