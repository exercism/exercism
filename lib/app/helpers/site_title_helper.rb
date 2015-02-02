module Sinatra
  module SiteTitleHelper

    def title(value = nil)
      @title = value if value
      @title ? "#{@title}" : "exercism.io"
    end

    def account_source_options
      txt = ""

      source_types.each do |source|
        if current_user.source_type == source
          txt << "<option selected value='#{source}'>#{source}</option>"
        else
          txt << "<option value='#{source}'>#{source}</option>"
        end
      end

      txt
    end

    def source_types
      %w(DB GITHUB)
    end
  end
end
