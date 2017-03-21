module X
  module Docs
    class CLI
      %w(overview install linux mac windows).each do |topic|
        define_method topic do
          read topic
        end
      end

      private

      def read(topic)
        File.read("./x/docs/md/cli/#{topic}.md").gsub('COMPLETION_SECTION', File.read('./x/docs/md/cli/completion.md'))
      end
    end
  end
end
