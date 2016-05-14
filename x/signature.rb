module X
  class Signature
    def self.compute(secret, payload)
      Digest::MD5.hexdigest(presort(payload) + secret)
    end

    def self.presort(payload)
      payload.sort_by { |k, _v| k }.reject { |k, _v| k == "sig" }.map { |k, v| "%s=%s" % [k, v] }.join
    end

    def self.ok(secret, payload)
      sig = payload["sig"]
      compute(secret, payload) == sig
    end
  end
end
