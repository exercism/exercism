module Stream
  Exercise = Struct.new(:id, :uuid, :problem, :last_activity, :last_activity_at, :iteration_count, :help_requested, :username, :avatar_url) do
    attr_writer :comment_count

    def comment_count
      @comment_count || 0
    end

    def at
      @at ||= last_activity_at.to_datetime
    end

    def viewed!
      @viewed = true
    end

    def unread?
      !@viewed
    end

    def help_requested?
      help_requested
    end
  end
end
