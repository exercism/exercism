require "./test/test_helper"
require "./test/x_helper"
require 'faraday'

class SampleClient
  class << self
    @@client = X::Xapi
    
    def get(url)
      reply = @@client.request url
      
      JSON.parse(reply.body)  
    end
  end
end

# https://github.com/exercism/exercism.io/issues/2631

class ApiV3Examples < Minitest::Test
  def test_that_it_returns_a_readme
    readme = X::Exercise::Readme.find('ruby', 'bob')

    assert_match /Bob is a lackadaisical teenager/, readme.readme
    assert "ruby", readme.track
    assert "bob", readme.slug
  end

  # TEST: invalid language (track) returns nothing
  # TEST: invalid slug (problem name) returns nothing
  # TEST: case-sensitive?
end
