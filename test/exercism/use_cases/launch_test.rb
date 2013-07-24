require './test/integration_helper'

class LaunchTrailTest < Minitest::Test

  def test_start_existing_trail
    user = User.new
    Launch.new(user, 'ruby').start
    bob = Exercise.new('ruby', 'bob')

    assert_equal [bob], user.current_exercises
  end

  def test_cannot_start_nonexistent_trail
    assert_raises Exercism::UnknownLanguage do
      Launch.new(:someuser, 'milk').start
    end
  end

end
