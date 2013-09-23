require './test/test_helper'
require 'exercism/exercise'
require 'exercism/locksmith'

class Smith
  include Locksmith

  attr_accessor :mastery

  def initialize
    @mastery = []
  end
end


class MasterLocksmithTest < Minitest::Test
  attr_reader :master
  def setup
    super
    @master = Smith.new
    @master.mastery << 'ruby'
  end

  def test_is_locksmith
    assert master.locksmith?, "Should be locksmith"
  end

  def test_is_locksmith_in_ruby
    assert master.locksmith_in?("ruby"), "Should be locksmith in Ruby"
  end

  def test_is_not_locksmith_in_python
    refute master.locksmith_in?("python"), "Should not be locksmith in Python"
  end
end

