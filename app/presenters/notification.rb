module ExercismWeb
  module Presenters
    class Notification
      include ExercismWeb::Helpers::FuzzyTime

      def self.prepare(item, current_user)
        case item.regarding
        when "code"
          CodeNotification.new(item, current_user)
        when "nitpick"
          NitpickNotification.new(item, current_user)
        when "like"
          LikeNotification.new(item, current_user)
        end
      end

      def initialize(item, current_user)
        @notification = item
        @current_user = current_user
      end

      def content_on_notification_page
        if notification.item
          html = "<li class='alert-row'>"
          html += "<span style='padding-right: 5px;' class='fa #{icon_klass}'></span>"
          html += large_content + " "
          html += ago(notification.created_at)
          html += "</li>"
        end
      end

      def content_on_dashboard_page
        if notification.item
          html = "<li style='list-style-type: none; margin: 0;'>"
          html += shortened_content
          html += "</li>"
        end
      end

      def large_content
        raise NotImplementedError, "This #{self.class} cannot respond to large_content"
      end

      def shortened_content
        "<a href='/#{notification.creator.username}'>#{notification.creator.username}</a> <span style='padding-right: 5px;' class='fa #{icon_klass}'></span> <a href='/submissions/#{notification.item.key}'> #{notification.submission.name} (#{ Language.of(notification.language)})</a>"
      end

      attr_reader :notification, :current_user

    end

    class LikeNotification < Notification

      def large_content
        html = "<a href='/#{notification.creator.username}'>#{notification.creator.username}</a> liked your submission of <a href='/submissions/#{notification.item.key}'>#{notification.item.name} in #{Language.of(notification.language)}</a>"
      end

      def icon_klass
        "fa-thumbs-o-up"
      end

    end

    class CodeNotification < Notification

      def large_content
        if notification.item.user
          html = "<a href='/#{notification.item.user.username}'>#{notification.item.user.username }</a> submitted a "
        end
        html += "new iteration of <a href='/submissions/#{notification.item.key}'><#{notification.item.name} in #{Language.of(notification.language)} </a>"
      end

      def icon_klass
        "fa-code"
      end

    end

    class NitpickNotification < Notification

      def large_content
        if notification.item.user.id == current_user.id
          html = "<a href='/#{notification.creator.username}'> #{notification.creator.username}</a> commented on your "
        else
          html = "<a href='/#{notification.creator.username}'> #{notification.creator.username}</a> commented on <a href='/#{notification.item.user.username}'>#{notification.item.user.username}</a>'s"
        end
        html += "<a href='/submissions/#{notification.item.key}'> #{notification.item.name} in #{Language.of(notification.language)}</a>"
      end

      def icon_klass
        "fa-comment-o"
      end

    end
  end
end
