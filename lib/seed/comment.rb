module Seed
  class Comment
    attr_reader :body, :at

    def initialize(body, at)
      @body, @at = body, at
    end

    def by(user, options = {})
      {
        user: user,
        comment: body,
        at: at,
        submission: options[:on]
      }
    end
  end
end
