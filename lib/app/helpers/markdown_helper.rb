require 'exercism/markdown'
require 'loofah'

module Sinatra
  module MarkdownHelper
    def md(text, language = nil)
      ConvertsMarkdownToHTML.convert(language ? "```#{language}\n#{text}\n```" : text)
    end
  end
end
