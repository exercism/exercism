require_relative '../test_helper'
require_relative '../x_helper'
require_relative '../../x/exercise'

module X
  class ExerciseTest < Minitest::Test
    def test_exists_gets_passed_a_track_id
      <<-NEED_HELP
        I would like to test the exists? method by checking that request is
        called when the method is called. I however am not sure how to mock out
        method from a module and expect that it was called. Any insight into
        how to do that?
      NEED_HELP
    end
  end
end
