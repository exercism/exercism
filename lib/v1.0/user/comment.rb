module App
  module User
    class Comment < SimpleDelegator
      def iteration
        "%02d" % submission.version
      end

      def avatar_url
        user.avatar_url + '?s=50'
      end

      def username
        user.username
      end

      def by_original_poster?
        submission.user == user
      end

      def by?(other)
        user == other
      end
    end
  end
end
