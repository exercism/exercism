require "./test/test_helper"
require "./test/x_helper"
require 'faraday'

# https://github.com/exercism/exercism.io/issues/2631

class ExerciseExamples < Minitest::Test
  def test_that_you_can_find_a_readme
    readme = X::Exercise::Readme.find('ruby', 'bob')

    assert_match /Bob is a lackadaisical teenager/, readme.readme
    assert "Ruby", readme.language
    assert "bob", readme.slug
  end

  def test_that_an_invalid_track_still_return_the_right_readme_but_language_is_unknown
    readme = X::Exercise::Readme.find('xxx-not-a-track-xxx', 'bob')

    assert_match /Bob is a lackadaisical teenager/, readme.readme
    assert "Unknown", readme.language
    assert "bob", readme.slug
  end

  def test_that_an_invalid_slug_fails_with_error
    err = assert_raises JSON::ParserError do
      X::Exercise::Readme.find('ruby', 'xxx-not-a-slug-xxx')
    end
    
    assert_match /unexpected token at 'Puma caught this error/, err.message
  end
  
  # TEST: invalid language (track) returns nothing
  # TEST: invalid slug (problem name) returns nothing
  # TEST: case-sensitive?
end
