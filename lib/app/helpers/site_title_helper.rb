module Sinatra
  module SiteTitleHelper

    def title(value = nil)
      @title = value if value
      @title ? "#{@title}" : "exercism.io"
    end
    
  end
end