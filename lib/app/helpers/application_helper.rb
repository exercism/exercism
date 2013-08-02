module Sinatra
  module ApplicationHelper

    def title(value = nil)
      @title = value if value
      @title ? "#{@title}" : "exercism.io"
    end
    
  end
end