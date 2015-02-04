require 'exercism/markdown'
require 'loofah'

module ExercismWeb
  module Helpers
    module Markdown
         #needs a test
      def md(text, language = "")
        language = language.split('.')[1] if language.include?('.')

        ConvertsMarkdownToHTML.convert(language ? "```#{language}\n#{text}\n```" : text)
      end
    end
  end
end
