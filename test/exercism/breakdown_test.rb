require './test/integration_helper'

class BreakdownTest < Minitest::Test

  def teardown
    Mongoid.reset
  end

  def test_simple_breakdown
    Submission.create(language: 'ruby', slug: 'bob')
    Submission.create(language: 'ruby', slug: 'bob')
    Submission.create(language: 'ruby', slug: 'word-count')
    Submission.create(language: 'python', slug: 'bob')
    Submission.create(language: 'python', slug: 'word-count')

    bob = Exercise.new('ruby', 'bob')
    word_count = Exercise.new('ruby', 'word-count')
    whatever = Exercise.new('ruby', 'whatever')

    breakdown = Breakdown.of('ruby')
    assert_equal 2, breakdown[bob]
    assert_equal 1, breakdown[word_count]
    assert_equal 0, breakdown[whatever]
  end

end
