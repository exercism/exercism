class UserExercise < ActiveRecord::Base
  has_many :submissions, :order => 'created_at ASC'
end
