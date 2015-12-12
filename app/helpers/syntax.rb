require 'exercism/syntax_highlighter'

module ExercismWeb
  module Helpers
    module Syntax
      def syntax(code, language)
        wrap ExercismLib::SyntaxHighlighter.new(code, language).render
      end

      private

      def wrap(content)
        "<span ng-non-bindable>#{content}</span>"
      end
    end
  end
end
