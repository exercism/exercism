require_relative '../test_helper'
require_relative '../x_helper'

module X
  class TodoTest < Minitest::Test
    def test_track_level_information
      track = java

      assert_equal track.language, 'Java'
      assert_equal track.track_id, 'java'

      assert_equal track.todos.map(&:slug), [
        'alphametics', 'bank-account', 'without-implementations'
      ]
      assert_equal track.with_implementations.map(&:slug), [
        'alphametics', 'bank-account'
      ]
    end

    def test_problem_level_information
      todo = java.todos.first

      assert_equal todo.slug, 'alphametics'
      assert_equal todo.name, 'Alphametics'

      implementation = todo.implementations.first

      assert_equal implementation['track_id'], "lua"
      url = "https://github.com/exercism/xlua/tree/master/exercises/alphametics"
      assert_equal implementation['url'], url
    end

    def java
      f = './test/fixtures/xapi_v3_todos.json'
      Xapi.stub(:get, [200, File.read(f)]) do
        Todo.track("java")
      end
    end
  end
end
