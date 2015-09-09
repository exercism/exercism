require_relative '../../integration_helper'

class MuteTest < Minitest::Test
  include DBCleaner

  def teardown
    super
    @alice = nil
    @bob = nil
    @submission = nil
  end

  def alice
    @alice ||= User.create(username: 'alice', mastery: ['ruby'])
  end

  def bob
    @bob ||= User.create(username: 'bob')
  end

  def submission
    @submission ||= Submission.create(user: bob, language: 'ruby', slug: 'bob')
  end

  def test_mute_submission
    refute submission.muted_by?(alice), "Unexpectedly muted"
    Mute.new(submission, alice).save
    submission.reload
    assert submission.muted_by?(alice), "Should be muted"
  end
end

