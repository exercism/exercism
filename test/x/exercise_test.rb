require_relative '../test_helper'
require_relative '../x_helper'
require_relative '../../x/exercise'

module X
  class ExerciseTest < Minitest::Test
    def test_exists_returns_true
      response = Minitest::Mock.new
      response.expect(:status, 200, [])

      X::Xapi.stub(:request, response) do
        result = X::Exercise.exists?('valid_track_id')
        assert_equal(true, result)
      end
    end

    def test_exists_returns_false
      response = Minitest::Mock.new
      response.expect(:status, 404, [])

      X::Xapi.stub(:request, response) do
        result = X::Exercise.exists?('invalid_track_id')
        assert_equal(false, result)
      end
    end
  end
end
