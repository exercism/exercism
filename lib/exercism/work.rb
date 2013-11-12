class Work
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def random
    user.completed.keys.shuffle.each do |language|
      user.completed[language].reverse.each do |slug|
        work = work_for(language, slug)
        if work.count > 0
          return work.limit(10).to_a.sample
        end
      end
    end
    nil
  end

  def work_for(language, slug)
    sql = "LEFT JOIN (SELECT submission_id FROM comments WHERE user_id=#{user.id}) AS tc ON submissions.id=tc.submission_id"
    Submission.pending.joins(sql).where('tc.submission_id IS NULL').where(language: language, slug: slug).unmuted_for(user).order("nit_count ASC")
  end

end
