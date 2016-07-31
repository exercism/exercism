require_relative '../../test_helper'
require_relative '../../x_helper'

module X
  # Stub out Xapi
  module Xapi
    def self.get(*_args)
      fixture = './test/fixtures/xapi_v3_todos.json'
      [200, File.read(fixture)]
    end
  end

  class TodoTest < Minitest::Test
    TEST_TRACK = 'test_track'.freeze

    def test_track_factory_method
      exercises = Todo.track(TEST_TRACK)
      assert_instance_of X::Todo, exercises
    end

    def test_attr_reader_methods
      exercises = Todo.track(TEST_TRACK)

      assert_equal 'LanguageFixture', exercises.language
      assert_equal 'language_fixture', exercises.track_id
      assert_equal "https://example.com/exercism/xlanguage/", exercises.repository
    end

    def test_exercises
      exercises = Todo.track(TEST_TRACK)

      assert_equal 3, exercises.exercises.size

      expected_slugs = %w(alphametics bank-account without-implementations)
      assert_equal expected_slugs, exercises.exercises.map(&:slug)
    end

    def test_enumerable
      exercises = Todo.track(TEST_TRACK)
      assert_kind_of Enumerable, exercises
      assert_equal 3, exercises.each.size
    end

    def test_nonexistant
      X::Xapi.stub(:get, [404, "{\"error\":\"No track 'nonexistant'\"}"]) do
        assert_raises( LanguageNotFound ) { Todo.track('nonexistant') }
      end
    end
  end
end
