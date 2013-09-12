module Seed
  class Comment
    attr_reader :body, :at

    def initialize(body, at)
      @body, @at = body, at
    end

    def by(user)
      {
        user: user,
        comment: body,
        at: at
      }
    end
  end
end
