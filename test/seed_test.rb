require './test/mongo_helper'
require 'exercism'
require 'seed'

class SeedTest < Minitest::Test
  def teardown
    Mongoid.reset
  end

  def test_generate
    Seed.generate(1)
  end
end
