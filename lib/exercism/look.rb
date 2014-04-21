class Look < ActiveRecord::Base

  belongs_to :exercise, class_name: 'UserExercise'
  belongs_to :user

  scope :recent_for, ->(user) { where(user_id: user.id).where('updated_at > ?', Time.now - 2.days).order('updated_at DESC') }

  def self.check!(exercise_id, user_id)
    Look.where(exercise_id: exercise_id, user_id: user_id).first_or_create.touch
  end
end
