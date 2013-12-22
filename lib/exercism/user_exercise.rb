class UserExercise < ActiveRecord::Base
  has_many :submissions
end
