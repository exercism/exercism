module Stats
  # Quick-and-dirty.
  # Not quite sure what stats we actually want.
  class Snapshot
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def most_recent_submission_at
      user.submissions.reversed.first.try(:created_at).try(:iso8601)
    end

    def most_recent_nitpick_at
      user.comments.reversed.first.try(:created_at).try(:iso8601)
    end

    def active_exercise_count
      user.exercises.where(state: 'pending').count
    end

    def hibernating_exercise_count
      user.exercises.where(state: 'hibernating').count
    end

    def completed_exercise_count
      user.exercises.where(state: 'done').count
    end

    def total_nitpick_count
      user.comments.except_on_submissions_by(user).count
    end

    def total_submission_count
      user.submissions.count
    end

    def total_language_count
      user.submissions.pluck(:language).uniq.count
    end

    def recent_nitpick_count
      user.comments.where('comments.created_at > ?', 7.days.ago).except_on_submissions_by(user).count
    end

    def recent_submission_count
      user.submissions.recent.count
    end

    def recent_language_count
      user.submissions.recent.pluck(:language).uniq.count
    end
  end
end
