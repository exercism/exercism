class AssumableUser
  class Identity

    attr_reader :username, :github_id, :steps
    def initialize(username, github_id, steps)
      @username = username
      @github_id = github_id
      @steps = steps
    end

    def progress
      @progress ||= Onboarding.step(steps)
    end

    def status
      @status ||= Onboarding.status(steps)
    end
  end

  def self.all
    ::User.order('created_at DESC').limit(100).map {|user|
      Identity.new(user.username, user.github_id, user.onboarding_steps)
    }.sort_by(&:progress).reverse
  end
end
