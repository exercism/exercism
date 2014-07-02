require 'exercism/markdown'
require 'loofah'

module ExercismWeb
  module Helpers
    module Markdown
      def md(text, language = nil, analysis_results=[])
        ConvertsMarkdownToHTML.convert((language ? "```#{language}\n#{text}\n```" : text), analysis_results)
      end

      def indent_first_line(code, column)
        ' ' * column + code
      end
    end
  end
end
