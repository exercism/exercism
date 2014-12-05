require_relative '../test_helper'
require_relative '../../lib/exercism'

C_EXERCISES = %w(hamming raindrops)
JAVA_EXERCISES = %w(etl nucleotide-count word-count anagram hamming bob robot-name meetup phone-number grade-school)

class LanguageTrackTest < Minitest::Test
  def test_ordered_exercises
    tracks_file = File.expand_path('../../fixtures/approvals/tracks.json', __FILE__)
    tracks_json = File.read(tracks_file)

    Xapi.stub(:get, [200, tracks_json]) do
      lt = LanguageTrack.new('java')
      assert_equal lt.ordered_exercises, JAVA_EXERCISES

      lt = LanguageTrack.new('c')
      assert_equal lt.ordered_exercises, C_EXERCISES
    end

  end
end
