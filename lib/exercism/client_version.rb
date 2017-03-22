module ExercismWeb
  class ClientVersion
    attr_accessor :user

    def initialize(user:)
      @user = user
    end

    def notice_when_client_outdated
      unless dismissed?
        "A new version of the exercism client is available (cli-2.4.0). Run <code>exercism upgrade</code> to get the latest hotness!"
      end
    end

    private

    def dismissed?
      user.guest? || user.client_version_notification_dismissed_at.present?
    end
  end
end
