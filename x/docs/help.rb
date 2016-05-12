module X
  module Docs
    class Help
      %w(contact dns executable firewall).each do |topic|
        define_method topic do
          read topic
        end
      end

      private

      def read(topic)
        File.read("./x/docs/md/help/#{topic}.md")
      end
    end
  end
end
