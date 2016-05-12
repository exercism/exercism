require_relative '../../integration_helper'
require_relative '../../../app/helpers/submission'

class AppHelpersSubmissionTest < Minitest::Test
  include DBCleaner

  def setup
    super
    @alice      = User.new(username: 'alice', email: 'alice@example.com')
    @fred       = User.new(username: 'fred', email: 'fred@example.com')
    @submission = Submission.create(user: @alice)
  end

  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(ExercismWeb::Helpers::Submission)
    @helper
  end

  def test_sentencify_none
    assert_equal '', helper.sentencify([])
  end

  def test_sentencify_one
    assert_equal 'alice', helper.sentencify(['alice'])
  end

  def test_sentencify_two
    assert_equal 'alice and bob', helper.sentencify(%w(alice bob))
  end

  def test_sentencify_three
    assert_equal 'alice, bob, and charlie', helper.sentencify(%w(alice bob charlie))
  end

  def test_like_submission_button_for_owner
    refute helper.like_submission_button(@submission, @alice)
  end

  def test_like_submission_button_for_nitpicker
    @fred.track_mentor << 'ruby'
    @submission.problem.track_id = 'ruby'
    expected = %(
      <form accept-charset="UTF-8" action="/submissions/#{@submission.key}/like" method="POST" class="submission-like-button">
        <button type="submit" name="like" class="btn"><i class="fa"></i> Looks great!</button>
      </form>
    ).strip.squeeze(" ")
    actual = helper.like_submission_button(@submission, @fred).strip.squeeze(" ")
    assert_equal expected, actual
  end

  def test_like_submission_button_for_someone_who_has_liked
    @fred.track_mentor << 'ruby'
    @submission.problem.track_id = 'ruby'
    @submission.liked_by << @fred
    expected = %(
      <form accept-charset="UTF-8" action="/submissions/#{@submission.key}/unlike" method="POST" class="submission-like-button">
        <button type="submit" name="unlike" class="btn"><i class="fa"></i> I didn't mean to like this!</button>
      </form>
    ).strip.squeeze(" ")
    actual = helper.like_submission_button(@submission, @fred).strip.squeeze(" ")
    assert_equal expected, actual
  end
end
