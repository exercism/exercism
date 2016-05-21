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

  def self.user_comment_statistics(user)
    {
      total_comments_received: total_comments_received(user),
      total_comments_received_from_others: comments_received_from_others(user).length,
      total_comments_created: user.comments.count,
      total_comments_given_to_others: comments_given_to_others(user),
      days_since_last_comment_given: days_since_last_comment_given(user),
      days_since_last_comment_received: days_since_last_comment_received(user)
    }
  end

  def self.user_problem_statistcs(user)
    X::Track.all.map do |track|
      [track.id, track_stats_hash(user, track)]
    end.to_h
  end

  def self.track_stats_hash(user, track)
    {
      language: track.language,
      total: track.problems.count,
      completed: problem_completion(user, track)
    }
  end

  def self.problem_completion(user, track)
    user.exercises.completed.where(language: track.id).map(&:slug)
  end

  def self.total_comments_received(user)
    user.submissions.joins(:comments).count
  end

  def self.comments_received_from_others(user)
    user.submissions.joins(:comments).where.not("comments.user_id = #{user.id}")
  end

  def self.days_since_last_comment_given(user)
    if !user.comments.empty?
      (Date.today - user.comments.order(:created_at).last.created_at.to_date).to_i
    end
  end

  def self.days_since_last_comment_received(user)
    comments = Comment.where.not(user_id: user.id).joins(:submission).where("submissions.user_id = #{user.id}").order(:created_at)
    if !comments.empty?
      (Date.today - comments.last.created_at.to_date).to_i
    end
  end

  def self.comments_given_to_others(user)
    user.comments.joins(:submission).where.not("submissions.user_id = #{user.id}").count
  end
end
