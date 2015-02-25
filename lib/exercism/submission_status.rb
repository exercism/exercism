class SubmissionStatus
  DONE_STATE = 'done'
  WORKING_STATES = %w(pending needs_input)

  def self.done_submissions(relation = nil)
    relation ||= Submission
    relation.where(state: DONE_STATE)
  end

  def self.submissions_completed_for(problem, relation: nil)
    relation ||= Submission
    relation.where(completed_problem_hash(problem))
  end

  def self.is_user_working_on?(user, problem)
    users_who_are_working_on_submission_for(problem).where(id: user.id).exists?
  end

  def self.is_user_done_with?(user, problem)
    users_who_have_completed(problem).where(id: user.id).exists?
  end

  def self.users_who_are_working_on_submission_for(problem, user_relation: nil)
    user_relation ||= User
    user_relation.includes(:submissions).where(:submissions => working_on_problem_hash(problem)).references(:submissions)
  end

  def self.users_who_have_completed(problem, user_relation: nil)
    user_relation ||= User
    user_relation.includes(:submissions).where(:submissions => completed_problem_hash(problem)).references(:submissions)
  end

  def self.users_who_have_completed_or_are_working_on(problem, user_relation: nil)
    user_relation ||= User
    user_relation.includes(:submissions).where(*working_or_done_sql_query(problem)).references(:submissions)
  end

  private

  def self.completed_problem_hash(problem)
    {
      :language => problem.track_id,
      :slug => problem.slug,
      :state => DONE_STATE
    }
  end

  def self.working_on_problem_hash(problem)
    {
      :language => problem.track_id,
      :slug => problem.slug,
      :state => WORKING_STATES
    }
  end

  def self.working_or_done_sql_query(problem)
    sql = <<-SQL
      submissions.language = ? AND
      submissions.slug = ? AND
      (submissions.state = ? OR
      submissions.state in (?))
    SQL

    [sql, problem.track_id, problem.slug, DONE_STATE, WORKING_STATES]
  end

end

