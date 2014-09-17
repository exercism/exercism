class Look < ActiveRecord::Base

  belongs_to :exercise, class_name: 'UserExercise'
  belongs_to :user

  scope :for, ->(user) { where(user_id: user.id).order('updated_at DESC') }
  scope :recent_for, ->(user) { self.for(user).where('updated_at > ?', Time.now - 30.days) }

  def self.check!(exercise_id, user_id)
    Look.where(exercise_id: exercise_id, user_id: user_id).first_or_create.touch
  end

  def problem
    Problem.new(exercise.track_id, exercise.slug)
  end

end
