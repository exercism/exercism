require 'exercism/markdown'
require 'loofah'

module Sinatra
  module MarkdownHelper
    def md(text, language = nil)
      ConvertsMarkdownToHTML.convert(language ? "```#{language}\n#{text}\n```" : text)
    end

    def code(text, language)
      CodeFormatter.format(text, language)
    end
  end
end
