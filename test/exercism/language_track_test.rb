require_relative '../test_helper'
require_relative '../../lib/exercism'

C_EXERCISES = %w(hamming raindrops).freeze
JAVA_EXERCISES = %w(etl nucleotide-count word-count anagram hamming bob robot-name meetup phone-number grade-school).freeze

class LanguageTrackTest < Minitest::Test
  include AppTestHelper

  def test_ordered_exercises
    Xapi.stub(:get, [200, language_tracks_json]) do
      lt = LanguageTrack.new('java')
      assert_equal lt.ordered_exercises, JAVA_EXERCISES

      lt = LanguageTrack.new('c')
      assert_equal lt.ordered_exercises, C_EXERCISES
    end
  end
end
