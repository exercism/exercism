require 'exercism/markdown'
require 'loofah'

module ExercismWeb
  module Helpers
    module Markdown
     def md(text, language = nil)
         language = language.split('.')[1] if language.include?('.')
         #needs a test

        ConvertsMarkdownToHTML.convert(language ? "```#{language}\n#{text}\n```" : text)
      end
    end
  end
end
