require 'delegate'

module Api
  module Notifications
    class Alert < SimpleDelegator
      def id
        "alert-#{__getobj__.id}"
      end

      def hibernation?
        text =~ /hibernation/i
      end

      def regarding
        hibernation? ? 'hibernating' : 'info'
      end

      def count
        0
      end

      def link
        url
      end

      def recipient
        user.username
      end

      def note
        s = text
        if url
          s += " <a href='#{url}'>#{link_text || url}</a>"
        end
        s
      end

      def slug
      end

      def language
      end

      def username
      end

      def team_name
      end
    end
  end
end
