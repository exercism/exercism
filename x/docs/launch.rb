module X
  module Docs
    class Launch
      def initialize(repository, checklist_issue)
        @repository = repository
        @checklist_issue = checklist_issue
      end

      def launch
        read
      end

      private

      attr_reader :repository, :checklist_issue

      def read
        File.read("./x/docs/md/track/LAUNCH.md").gsub('REPO', repository).gsub('CHECKLIST_ISSUE', checklist_issue.to_s)
      end
    end
  end
end
