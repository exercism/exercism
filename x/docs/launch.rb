module X
  module Docs
    class Launch
      def initialize(repository)
        @repository = repository
      end

      def launch
        read
      end

      private

      attr_reader :repository

      def read
        File.read("./x/docs/md/track/LAUNCH.md").gsub('REPO', repository)
      end
    end
  end
end
