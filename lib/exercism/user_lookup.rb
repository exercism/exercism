class UserLookup
  def initialize(params)
    @params = params
  end

  def lookup
    if query.blank?
      []
    else
      users_by_participation.pluck(:username)
    end
  end

  private

  def users_by_participation
    users.order("id IN (#{commenter_ids}) DESC").order(:username)
  end

  def users
    User.where('username LIKE ?', query + '%').limit(8)
  end

  def commenter_ids
    Comment.select(:user_id).where(submission: submission).to_sql
  end

  def query
    @params[:query]
  end

  def submission
    Submission.find_by(key: @params[:submission_key])
  end
end
