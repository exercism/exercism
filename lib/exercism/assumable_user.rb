class AssumableUser
  class Identity
    attr_reader :username, :github_id
    def initialize(username, github_id)
      @username = username
      @github_id = github_id
    end
  end

  def self.all
    ::User.order('username ASC')
          .limit(100)
          .map { |user| Identity.new(user.username, user.github_id) }
  end
end
