require_relative '../../test_helper'
require_relative '../../dashboard_helper'
require_relative '../../../app/presenters/dashboard'

class PresentersDashboardTest < Minitest::Test
  include DBCleaner
  def setup
  end
  
  def test_current_exercises_order
    user = User.create(username: 'Alex')
    ruby_exercise_1 = UserExercise.create(user: user, iteration_count: 1, language: 'ruby')
    javascript_exercise_1 = UserExercise.create(user: user, archived: false, iteration_count: 1, language: 'javascript')
    javascript_exercise_2 = UserExercise.create(user: user, archived: false, iteration_count: 1, language: 'javascript')
    ruby_exercise_2 = UserExercise.create(user: user, archived: false, iteration_count: 1, language: 'ruby')
    dashboard = ExercismWeb::Presenters::Dashboard.new(user)
    assert_equal dashboard.current_exercises.pluck(:language), ['javascript', 'javascript', 'ruby', 'ruby']
  end
end
