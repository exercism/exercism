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

class ApiV3Examples < Minitest::Test
  def test_that_it_returns_bob_readme
    client = SampleClient

    readme = SampleClient.get "tracks/ruby/exercises/bob/readme"

    assert('Bob', readme['exercise']['name'])
  end

  # TEST: kill logging, or allow switching on/off from stdout
  # TEST: what happens when resource is not found?
end
