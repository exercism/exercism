require 'exercism/markdown'
require 'loofah'

module ExercismWeb
  module Helpers
    module Markdown
      def md(text, language=nil)
        # HACK: Rouge needs Objective C get in form 'objective_c' for correct
        # syntax highlighting
        language = (language && language == 'objective-c') ? 'objective_c' : language

        ConvertsMarkdownToHTML.convert(language ? "```#{language}\n#{text}\n```" : text)
      end
    end
  end
end
