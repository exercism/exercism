class UserStatistics
  def self.of(user)
    by_username(user)
  end

  def self.by_username(user)
    {
      user_info: user.public_user_attributes,
      comment_statistics: user_comment_statistics(user),
      submission_statistics: user_problem_statistcs(user)
    }
  end

  def self.problem_completion(user, track)
    user.exercises.completed.where(language: track.id).map(&:slug)
  end

  def self.user_comment_statistics(user)
    {
      total_comments_received: total_comments_received(user),
      comments_received_from_others: comments_received_from_others(user).length,
      total_comments_given: user.comments.count,
      comments_given_to_others: comments_given_to_others(user),
      days_since_last_comment_given: last_comment_given(user),
      days_since_last_comment_received: last_comment_received(user)
    }
  end

  def self.total_comments_received(user)
    user.submissions.joins(:comments).count
  end

  def self.comments_received_from_others(user)
    user.submissions.joins(:comments).where.not("comments.user_id = #{user.id}")
  end

  def self.last_comment_given(user)
    (Date.today - user.comments.first.created_at.to_date).to_i
  end

  def self.last_comment_received(user)
    comments = Comment.where.not(user_id: user.id).joins(:submission).where("submissions.user_id = #{user.id}")
    if !comments.empty?
      (Date.today - comments.last.created_at.to_date).to_i
    end
  end

  def self.comments_given_to_others(user)
    user.comments.joins(:submission).where.not("submissions.user_id = #{user.id}").length
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
