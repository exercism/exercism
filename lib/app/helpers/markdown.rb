require 'exercism/markdown'
require 'loofah'

module ExercismWeb
  module Helpers
    module Markdown
      ROUGUE_LANG = {
        'objective-c' => 'objective_c',
        'elisp' => 'common_lisp'
      }

      def md(text, language=nil)
        # HACK: Some languages have different names in Rouge
        language = ROUGUE_LANG[language] || language

        ConvertsMarkdownToHTML.convert(language ? "```#{language}\n#{text}\n```" : text)
      end
    end
  end
end
