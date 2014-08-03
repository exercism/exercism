require_relative '../test_helper'
require 'exercism/rikki'

class RikkiTest < Minitest::Test
  def test_validate
    Rikki.stub(:secret, 'ok') do
      refute Rikki.validate 'abc123'
      assert Rikki.validate '7a85f4764bbd6daf1c3545efbbf0f279a6dc0beb'
    end
  end
end
