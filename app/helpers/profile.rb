module ExercismWeb
  module Helpers
    module Profile
      def profile_link(user, link_text=nil)
        link_text = user.username if link_text.nil?
        '<a href="/%s">%s</a>' % [user.username, link_text]
      end
    end
  end
end
