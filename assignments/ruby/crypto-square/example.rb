class Crypto
  attr_reader :plaintext
  def initialize(plaintext)
    @plaintext = plaintext
  end

  def normalize_plaintext
    @normalized ||= plaintext.downcase.gsub(/\W/, '')
  end

  def size
    Math.sqrt(normalize_plaintext.length).ceil
  end

  def plaintext_segments
    chunk(normalize_plaintext, size)
  end

  def ciphertext
    plaintext_segments.map do |segment|
      # There has to be a better way to make sure that
      # the last segment is as long as the others!
      segment.split('').fill('', segment.length...size)
    end.transpose.flatten.join
  end

  def normalize_ciphertext
    chunk(ciphertext, 5).join(" ")
  end

  def chunk(s, size)
    s.scan(/.{1,#{size}}/)
  end
end
