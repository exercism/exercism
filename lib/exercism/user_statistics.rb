class UserStatistics
  def self.of(user)
    by_username(user)
  end

  def self.by_username(user)
    {
      user: user.public_user_attributes,
      statistics: user_problem_statistcs(user)
    }
  end

  def self.problem_completion(user, track)
    user.exercises.current.where(language: track.id).map do |exercise|
      exercise.slug
    end
  end

  def self.user_problem_statistcs(user)
    X::Track.all.map do |track|
      { track_id: track.id,
        language: track.language,
        total: track.problems.count,
        completed: problem_completion(user, track) }
    end
  end

end
