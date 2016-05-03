module X
  module Docs
    class Launch

      def launch
        read
      end

      private

      def read
        File.read("./x/docs/md/track/LAUNCH.md")
      end
    end
  end
end
