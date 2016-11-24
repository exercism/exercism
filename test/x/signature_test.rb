require_relative '../test_helper'
require_relative '../../x/signature'

module X
  class SignatureTest < Minitest::Test
    def test_compute
      secret = "50decffdc"
      payload = {
        "expire" => Time.utc(2016, 1, 2, 3, 4, 5).to_i,
        "comment" => "ohai",
        "sig" => "IGNORED",
      }
      assert_equal "1da7e3d8b7ac2d21edb0f27062063c9a", Signature.compute(secret, payload)
    end

    def test_ok
      secret = "50decffdc"
      payload = {
        "expire" => Time.utc(2016, 1, 2, 3, 4, 5).to_i,
        "comment" => "ohai",
        "sig" => "1da7e3d8b7ac2d21edb0f27062063c9a",
      }
      assert Signature.ok(secret, payload)

      payload["sig"] = "bf6e44cf9ecc8766534b2072dec7a86f"
      refute Signature.ok(secret, payload)
    end
  end
end
