require 'exercism/syntax_highlighter'

module ExercismWeb
  module Helpers
    module Syntax
      def syntax(code, language)
        ExercismLib::SyntaxHighlighter.new(code, language).render
      end
    end
  end
end
