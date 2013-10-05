module Seed
  class Comment
    attr_reader :body, :created_at

    def initialize(body, created_at)
      @body, @created_at = body, created_at
    end

    def by(user, options = {})
      {
        user: user,
        body: body,
        created_at: created_at,
        submission: options[:on]
      }
    end
  end
end
