require "./test/test_helper"
require "./test/x_helper"
require 'faraday'

# https://github.com/exercism/exercism.io/issues/2631

class ApiV3Examples < Minitest::Test
  def test_that_you_can_find_a_readme
    readme = X::Exercise::Readme.find('ruby', 'bob')

    assert_match /Bob is a lackadaisical teenager/, readme.readme
    assert "ruby", readme.track
    assert "bob", readme.slug
  end

  # TEST: invalid language (track) returns nothing
  # TEST: invalid slug (problem name) returns nothing
  # TEST: case-sensitive?
end
