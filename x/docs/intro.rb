module X
  module Docs
    class Intro
      %w(local-remote getting-started).each do |topic|
        define_method topic.gsub('-', '_') do
          read topic
        end
      end

      private

      def read(topic)
        File.read("./x/docs/md/intro/#{topic}.md")
      end
    end
  end
end
