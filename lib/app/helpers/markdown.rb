require 'exercism/markdown'
require 'loofah'

module ExercismWeb
  module Helpers
    module Markdown
      def md(text, language=nil)
        ConvertsMarkdownToHTML.convert(language ? "```#{language}\n#{text}\n```" : text)
      end
    end
  end
end
