module ExercismWeb
  class ClientVersion
    attr_accessor :user

    def initialize(user:)
      @user = user
    end

    def notice_when_client_outdated
      unless dismissed?
        <<~HTML
          <span class='client-outdated' data-username='#{user.username}'>
            A new version of the exercism client is available (cli-2.4.0).
            Run <code>exercism upgrade</code> to get the latest hotness!
          </span>
        HTML
      end
    end

    def dismiss_notice!
      user.update_attribute :client_version_update_notification_dismissed_at, Time.now
    end

    private

    def dismissed?
      user.guest? || user.client_version_update_notification_dismissed_at.present?
    end
  end
end
