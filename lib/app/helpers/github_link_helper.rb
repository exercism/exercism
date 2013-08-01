module Sinatra
  module GithubLinkHelper
    def github_profile_link(user, link_text = nil)
      link_text = user.username if link_text.nil?
      '<a href="https://github.com/%s">%s</a>' % [user.username, link_text]
    end
  end
end