class UserExercise < ActiveRecord::Base
  has_many :submissions, :order => 'created_at ASC'

  before_create do
    self.key = generate_key
  end

  def generate_key
    Digest::SHA1.hexdigest(secret)[0..23]
  end

  private

  def secret
    if ENV['USER_EXERCISE_SECRET']
      "#{ENV['USER_EXERCISE_SECRET']} #{rand(10**10)}"
    else
      "There is solemn satisfaction in doing the best you can for #{rand(10**10)} billion people."
    end
  end
end
