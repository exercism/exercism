require 'time'
require_relative '../../active_record_helper'
require 'exercism/use_cases/updates_user_exercise'
require 'exercism/use_cases/hibernation'
require 'exercism/use_cases/notify'
require 'exercism/alert'
require 'exercism/notification'

class HibernationTest < Minitest::Test
  include DBCleaner

  FakeUser = Struct.new(:id, :username, :email)

  FakeComment = Struct.new(:user, :created_at)
  FakeSubmission = Struct.new(:user, :comments, :state) do
    def track_id
      'ruby'
    end

    def problem
      Problem.new('ruby', 'one')
    end

    def user_exercise
      obj = Object.new
      def obj.key
        'abc'
      end
      obj
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
      1
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
    bob = FakeUser.new(3, 'bob', 'bob@example.com')
    comment = FakeComment.new(bob, cutoff - 1)
    submission = FakeSubmission.new(alice, [comment], 'pending')
    Hack::UpdatesUserExercise.stub(:new, NullHack.new) do
      Hibernation.stub(:admin, admin) do
        Hibernation.new(submission, :intercept).process
        assert_equal 'hibernating', submission.state
      end
    end
  end

  def test_skip_a_submission_with_recent_comments
    alice = FakeUser.new(2, 'alice', 'alice@example.com')
    bob = FakeUser.new(3, 'bob', 'bob@example.com')
    comment = FakeComment.new(bob, cutoff + 1)
    submission = FakeSubmission.new(alice, [comment], 'pending')
    Hack::UpdatesUserExercise.stub(:new, NullHack.new) do
      Hibernation.stub(:admin, admin) do
        Hibernation.new(submission, :intercept).process
        assert_equal 'pending', submission.state
      end
    end
  end

  def test_mark_submission_where_submitter_is_most_recent_as_needing_input
    alice = FakeUser.new(2, 'alice', 'alice@example.com')
    bob = FakeUser.new(3, 'bob', 'bob@example.com')
    comment1 = FakeComment.new(bob, cutoff - 2)
    comment2 = FakeComment.new(alice, cutoff - 1)
    submission = FakeSubmission.new(alice, [comment1, comment2], 'pending')
    Hack::UpdatesUserExercise.stub(:new, NullHack.new) do
      Hibernation.stub(:admin, admin) do
        Hibernation.new(submission, :intercept).process
        assert_equal 'needs_input', submission.state
      end
    end
  end
end
