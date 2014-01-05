require './test/active_record_helper'
require 'exercism'
require 'seed'

class SeedTest < MiniTest::Unit::TestCase
  include DBCleaner

  def test_generate
    # Just make sure it doesn't blow up.
    Seed.generate(1)
  end
end
