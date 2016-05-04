require_relative '../test_helper'
require_relative '../x_helper'

module X
  class TodoTest < Minitest::Test
    def test_todos
      f= './test/fixtures/xapi_v3_todos.json'
      Xapi.stub(:get, [200, File.read(f)]) do
        todo_track = Todo.track("java")
        assert_equal todo_track.language, 'Java'
        assert_equal todo_track.track_id, 'java'
        assert_equal get_slugs(todo_track.todos), ['alphametics', 'bank-account', 'without-implementations']
        assert_equal get_slugs(todo_track.with_implementations), ['alphametics', 'bank-account']
      end
    end

    def get_slugs(t)
      t.map { |x| x.slug }
    end
  end
end
