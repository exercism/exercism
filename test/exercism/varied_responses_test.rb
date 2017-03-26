require_relative '../test_helper'
require 'exercism/varied_responses'

class VariedResponsesTest < Minitest::Test
  def test_sentence_starter
    response = VariedResponses.sentence_starter
    assert response.is_a?(String), '#sentence_starter should have returned a String'
  end
end
