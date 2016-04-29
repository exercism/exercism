require_relative '../test_helper'
require_relative '../x_helper'

module X
  class TodoTest < Minitest::Test
    def test_todos
      f= './test/fixtures/xapi_v3_todos.json'
      Xapi.stub(:get, [200, File.read(f)]) do
        todo_track = Todo.track("java")
        expected = ['alphametics', 'bank-account']
        assert_equal todo_track.todos.map(&:slug), expected
      end
    end
  end
end
