require './test/test_helper'
require 'exercism/exercise'
require 'exercism/locksmith'

class Smith
  include Locksmith

  attr_accessor :mastery, :journeymans_ticket, :apprenticeship,
    :completed_exercises

  def initialize
    @mastery = []
    @journeymans_ticket = []
    @apprenticeship = {}
    @completed_exercises = {}
  end

  def completed?(exercise)
    completed_exercises.any? {|_, exercises| exercises.include?(exercise)}
  end
end


class MasterLocksmithTest < Minitest::Test
  attr_reader :master
  def setup
    @master = Smith.new
    @master.mastery << 'ruby'
  end

  def test_unlocks_in_mastered_field
    exercise = Exercise.new('ruby', 'infinity')
    assert master.unlocks?(exercise), "Should unlock all ruby exercises"
  end

  def test_cannot_unlock_in_unmastered_field
    exercise = Exercise.new('python', 'whatever')
    refute master.unlocks?(exercise), "Cannot unlock python exercises"
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

class JourneymanLocksmithTest < Minitest::Test
  attr_reader :journeyman
  def bobrb
    @bobrb || Exercise.new('ruby', 'bob')
  end

  def bobpy
    @bobpy ||= Exercise.new('python', 'bob')
  end

  def setup
    @journeyman = Smith.new
    @journeyman.journeymans_ticket << 'ruby'
    @journeyman.completed_exercises = {
      'ruby' => [bobrb],
      'python' => [bobpy]
    }
  end

  def test_unlocks_completed_exercise_in_own_field
    assert journeyman.unlocks?(bobrb), "Expected to unlock ruby:bob"
  end

  def test_cannot_unlock_completed_exercise_in_other_field
    refute journeyman.unlocks?(bobpy), "Expected NOT to unlock python:bob"
  end

  def test_cannot_unlock_incomplete_exercise_in_own_field
    exercise = Exercise.new('ruby', 'whatever')
    refute journeyman.unlocks?(exercise), "Expected NOT to unlock incomplete ruby exercise"
  end

  def test_is_locksmith
    assert journeyman.locksmith?, "Should be locksmith."
  end

  def test_is_locksmith_in_ruby
    assert journeyman.locksmith_in?("ruby"), "Expected to be locksmith in Ruby"
  end

  def test_is_not_locksmith_in_python
    refute journeyman.locksmith_in?("python"), "Expected not to be locksmith in Python"
  end
end

class ApprenticeLocksmithTest < Minitest::Test
  def bobrb
    @bobrb || Exercise.new('ruby', 'bob')
  end

  def chickenrb
    @chickenrb ||= Exercise.new('ruby', 'chicken')
  end

  def bobpy
    @bobpy ||= Exercise.new('python', 'bob')
  end

  attr_reader :apprentice
  def setup
    @apprentice = Smith.new
    @apprentice.apprenticeship['ruby'] = ['bob']
    @apprentice.completed_exercises = {
      'ruby' => [bobrb, chickenrb],
      'python' => [bobpy]
    }
  end

  def test_is_locksmith_in_ruby
    assert apprentice.locksmith_in?("ruby"), "Expected to be locksmith in Ruby"
  end

  def test_is_not_locksmith_in_python
    refute apprentice.locksmith_in?("python"), "Expected NOT to be locksmith in Python"
  end

  def test_unlocks_apprenticed_exercise
    assert apprentice.unlocks?(bobrb), "Expected to unlock ruby:bob"
  end

  def test_does_not_unlock_completed_assignment_in_field
    refute apprentice.unlocks?(chickenrb), "Expected NOT to unlock ruby:chicken"
  end

  def test_does_not_unlock_completed_assignment_in_other_field
    refute apprentice.unlocks?(bobpy), "Expected NOT to unlock python:bob"
  end

  def test_is_locksmith
    assert apprentice.locksmith?, "Should be locksmith"
  end
end

