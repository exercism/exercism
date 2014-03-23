module ExercismIO
  module Helpers
    module URL
      def link_to(path)
        File.join(root_path, path)
      end
    end
  end
end
