class Atbash

  def self.encode(plaintext)
    cipher = ""
    normalize(plaintext).chars.each do |char|
      i = alphabet.index(char)
      if i
        cipher << key[i]
      else
        cipher << char
      end
    end
    cipher.scan(/.{1,5}/).join(' ')
  end

  def self.normalize(s)
    s.downcase.gsub(/[^a-z0-9]/, '')
  end

  def self.alphabet
    "abcdefghijklmnopqrstuvwxyz"
  end

  def self.key
    alphabet.reverse
  end

end
