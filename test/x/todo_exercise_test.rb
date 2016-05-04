require_relative '../test_helper'
require_relative '../x_helper'

module X
  class TodoExerciseTest < Minitest::Test
    def test_todos_exercise
      f= './test/fixtures/xapi_v3_todos.json'
      Xapi.stub(:get, [200, File.read(f)]) do
        todo_exercise = Todo.track("java").todos.first
        assert_equal todo_exercise.slug, 'alphametics'
        assert_equal todo_exercise.name, 'Alphametics'
        assert_equal implementation(todo_exercise)['track_id'], "lua"
        assert_equal implementation(todo_exercise)['url'], "https://github.com/exercism/xlua/tree/master/exercises/alphametics"
      end
    end

    def implementation(e)
      e.implementations.first
    end
  end
end
