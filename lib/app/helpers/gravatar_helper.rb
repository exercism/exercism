module Sinatra
  module GravatarHelper

    def gravatar_tag(url, options = {})
      size = options.fetch(:size) { 20 }
      url ||= "https://secure.gravatar.com/avatar/d41d8cd98f00b204e9800998ecf8427e"
      "<img alt=\"\" src=\"#{url}?s=#{size}\" width=\"#{size}\" height=\"#{size}\">"
    end

  end
end

