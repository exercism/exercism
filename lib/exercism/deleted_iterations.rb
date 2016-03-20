class DeletedIterations < ActiveRecord::Base
  belongs_to :user
  belongs_to :submission

  def self.store_iterations(exercise, user_id)
    exercise.submissions.each do |sub|
      create(submission: sub, user_id: user_id)
    end
  end
end
