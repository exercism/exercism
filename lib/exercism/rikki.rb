require 'digest/sha1'

module Rikki
  def self.validate(key)
    key == shared_key
  end

  def self.secret
    @secret ||= (ENV['RIKKI_SECRET'] || default)
  end

  def self.shared_key
    Digest::SHA1.hexdigest(secret)
  end

  def self.default
    "I wish a robot would get elected president. That way, when he came to town, we could all take a shot at him and not feel too bad."
  end

  def self.supported_attempt?(attempt)
    supported_tracks = ["ruby", "go", "crystal"]
    supported_tracks.include?(attempt.track)
  end
end
