module Sinatra
  module SiteTitleHelper
    def title(value = nil)
      value || "exercism.io"
    end
  end
end
