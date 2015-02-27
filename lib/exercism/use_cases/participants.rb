class Participants
  def self.in(submission)
    self.new(submission).users_who_particiated_in_exercise
  end

  def initialize(submission)
    @submission = submission
    @exercise = submission.user_exercise
  end

  def users_who_particiated_in_exercise
    list_of_user_ids = ids_of_submitters + exercise_commenter_ids
    users = get_users_from_db(list_of_user_ids) + at_mentions_on_submission
    users.uniq do |user|
      user.id
    end
  end

  private

  def get_users_from_db(ids)
    User.where(id: ids)
  end

  def exercise_commenter_ids
    Comment.where(submission_id: submission_ids_of_exercise).pluck(:user_id)
  end

  def submission_ids_of_exercise
    ids_of_submitters_and_submissions.map(&:id)
  end

  def ids_of_submitters
    ids_of_submitters_and_submissions.map(&:user_id)
  end

  def ids_of_submitters_and_submissions
    @user_and_submission_ids_of ||= @exercise.submissions.select([:id, :user_id])
  end

  def at_mentions_on_submission
    bodies_of_comments = @submission.comments.pluck(:body).join(" ")
    ExtractsMentionsFromMarkdown.extract(bodies_of_comments)
  end

end
