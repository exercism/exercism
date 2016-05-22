module Hack
  class UpdatesUserExercise
    attr_reader :user_id, :language, :slug

    def initialize(user_id, language, slug)
      @user_id = user_id
      @language = language
      @slug = slug
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def update
      return unless latest

      exercise.user_id = user_id
      exercise.language = latest.language
      exercise.slug = latest.slug
      exercise.created_at ||= earliest_submission_at
      exercise.updated_at = most_recent_change_at
      exercise.iteration_count = submissions.count
      exercise.skipped_at = nil if exercise.iteration_count > 0
      exercise.last_iteration_at = latest.created_at
      exercise.update_last_activity(latest)
      exercise.save

      submissions.each do |s|
        s.user_exercise_id = exercise.id
        s.save
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    private

    def latest
      submissions.last
    end

    def earliest_submission_at
      submissions.map(&:created_at).min
    end

    def most_recent_change_at
      latest.updated_at
    end

    def options
      { user_id: user_id, language: language, slug: slug }
    end

    def submissions
      @submissions ||= Submission.where(options).order('created_at ASC')
    end

    def exercise
      @exercise ||= UserExercise.where(options).first || UserExercise.new
    end
  end
end
