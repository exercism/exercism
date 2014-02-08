module App
  module User
    class Exercise < SimpleDelegator
      include Named

      def owned_by?(current_user)
        current_user == user
      end

      def url
        File.join('/', user.username, key)
      end

      def reopen_url
        File.join(url, 'reopen')
      end

      def close_url
        File.join(url, 'close')
      end

      def avatar_url
        user.avatar_url + '?s=70'
      end

      def username
        user.username
      end

      def latest_submission_at
        submissions.last.created_at
      end

      def views
        "#{view_count} #{view_qualifier}"
      end

      def view_qualifier
        view_count == 1 ? 'view' : 'views'
      end

      def view_count
        @view_count ||= submissions.inject(0) do |sum, submission|
          sum + submission.view_count
        end
      end

      def nitpick_count
        @nitpick_count ||= submissions.inject(0) do |sum, submission|
          sum + submission.comments.count
        end
      end

      def iterations
        "#{iteration_count} #{iteration_qualifier}"
      end

      def iteration_qualifier
        iteration_count == 1 ? 'iteration' : 'iterations'
      end

      def active?
        ['pending', 'hibernating'].include?(state)
      end

      def status
        case state
        when 'done'
          "Exercise is completed"
        when 'hibernating'
          "Exercise is hibernating"
        when 'pending'
          "Exercise is still in progress"
        end
      end

      def each_comment
        submissions.reverse.each do |submission|
          submission.comments.reverse.each do |comment|
            yield App::User::Comment.new(comment)
          end
        end
      end
    end
  end
end
