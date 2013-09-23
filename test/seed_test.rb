require './test/test_helper'
require 'exercism'
require 'seed'

class SeedTest < Minitest::Test
  def test_generate
    Seed.generate(1)
  end
end
