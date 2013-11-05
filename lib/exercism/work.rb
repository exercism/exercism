class Work
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def random
    user.completed.keys.shuffle.each do |language|
      user.completed[language].reverse.each do |slug|
        work = Submission.pending.where(language: language, slug: slug).unmuted_for(user).order("nit_count ASC")
        if work.count > 0
          return work.limit(10).to_a.sample
        end
      end
    end
    nil
  end

end
