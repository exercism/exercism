require 'digest/sha1'

module Rikki
  extend self

  def validate(key)
    key == shared_key
  end

  def secret
    @secret ||= (ENV['RIKKI_SECRET'] || default)
  end

  def shared_key
    Digest::SHA1.hexdigest(secret)
  end

  def default
    "I wish a robot would get elected president. That way, when he came to town, we could all take a shot at him and not feel too bad."
  end

  def supported_attempt?(attempt)
    ((attempt.track == 'ruby' && attempt.slug == 'hamming') ||
     attempt.track == 'go' ||
     attempt.track == 'crystal')
  end
end
