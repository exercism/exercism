require 'time'
require './test/active_record_helper'
require './lib/exercism/use_cases/updates_user_exercise'
require './lib/exercism/use_cases/hibernation'
require './lib/exercism/use_cases/notify'
require './lib/services/message'
require './lib/services/email'
require './lib/services/hibernation_message'
require './lib/exercism/notification'
require './lib/exercism/named'
require './lib/exercism/exercise'

class HibernationTest < MiniTest::Unit::TestCase
  include DBCleaner

  FakeUser = Struct.new(:id, :username, :email)

  FakeComment = Struct.new(:user, :created_at)
  FakeSubmission = Struct.new(:user, :comments, :state) do
    def exercise
      Exercise.new('ruby', 'one')
    end

    def id
      1
    end

    def save
      true
    end

    # For the user exercise Hack.
    # Temporary measure.
    def user_id
    end
    def language
    end
    def slug
    end
  end

  class NullHack
    def update
    end
  end

  def admin
    @admin ||= FakeUser.new(1, 'kytrinyx', 'kytrinyx@example.com')
  end

  def cutoff
    Time.now - Hibernation::WINDOW
  end

  def test_hibernate_a_submission_with_old_comments
    alice = FakeUser.new(2, 'alice', 'alice@example.com')
    comment = FakeComment.new(alice, cutoff - 1)
    submission = FakeSubmission.new(alice, [comment], 'pending')
    Hack::UpdatesUserExercise.stub(:new, NullHack.new) do
      Hibernation.stub(:admin, admin) do
        Hibernation.new(submission, :intercept).process
        assert_equal 'hibernating', submission.state
      end
    end
  end

  def test_skip_a_submission_with_recent_comments
    bob = FakeUser.new(3, 'bob', 'bob@example.com')
    comment = FakeComment.new(bob, cutoff + 1)
    submission = FakeSubmission.new(bob, [comment], 'pending')
    Hack::UpdatesUserExercise.stub(:new, NullHack.new) do
      Hibernation.stub(:admin, admin) do
        Hibernation.new(submission, :intercept).process
        assert_equal 'pending', submission.state
      end
    end
  end
end
