class Look < ActiveRecord::Base
  def self.check!(exercise_id, user_id)
    Look.where(exercise_id: exercise_id, user_id: user_id).first_or_create.touch
  end
end
