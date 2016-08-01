require_relative '../../test_helper'
require_relative '../../x_helper'

module X
  class ExerciseTest < Minitest::Test
    def fixture_data
      { 'slug' => 'test-slug',
        'data' => 'some data',
        'readme_url' => 'readme_url',
        'implementations' => [],
        'blurb' => 'blurb' }
    end

    def test_attr_reader_methods
      exercise = Todo::Exercise.new(fixture_data)

      assert_equal 'test-slug', exercise.slug
      assert_equal 'some data', exercise.data
      assert_equal 'readme_url', exercise.readme_url
      assert_equal [], exercise.implementations
      assert_equal 'blurb', exercise.blurb
    end

    def test_name
      exercise = Todo::Exercise.new(fixture_data)

      assert_equal 'Test Slug', exercise.name
    end

  end
end
