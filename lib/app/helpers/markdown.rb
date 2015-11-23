require 'exercism/markdown'
require 'loofah'

module ExercismWeb
  module Helpers
    module Markdown
      def md(text)
        ConvertsMarkdownToHTML.convert(text)
      end
    end
  end
end
