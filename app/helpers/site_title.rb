module ExercismWeb
  module Helpers
    module SiteTitle
      def title(value=nil)
        value || "exercism.io"
      end
    end
  end
end
