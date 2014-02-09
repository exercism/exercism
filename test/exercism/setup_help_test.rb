require './test/test_helper'
require 'exercism/setup_help'

class SetupHelpTest < MiniTest::Unit::TestCase
  def test_text
    help = SetupHelp.new('ruby', './test/fixtures')
    assert_equal "Setup help.\n", help.to_s
  end

  def test_missing_text
    help = SetupHelp.new('python', './test/fixtures')
    assert_equal "", help.to_s
  end
end
