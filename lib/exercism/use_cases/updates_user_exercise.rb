module Hack
  class UpdatesUserExercise
    attr_reader :user_id, :language, :slug

    def initialize(user_id, language, slug)
      @user_id = user_id
      @language = language
      @slug = slug
    end

    def update
      return unless latest

      exercise.user_id = user_id
      exercise.state = latest.state
      exercise.language = latest.language
      exercise.slug = latest.slug
      exercise.created_at ||= earliest_submission_at
      exercise.updated_at = most_recent_change_at
      exercise.completed_at = exercise.updated_at if done?
      exercise.is_nitpicker = true
      exercise.iteration_count = submissions.count
      exercise.save

      submissions.each do |s|
        s.user_exercise_id = exercise.id
        s.save
      end
    end

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

    def done?
      latest.state == 'done'
    end

    def options
      {user_id: user_id, language: language, slug: slug}
    end

    def submissions
      @submissions ||= Submission.where(options).order('created_at ASC')
    end

    def exercise
      @exercise ||= UserExercise.where(options).first || UserExercise.new
    end
  end
end
