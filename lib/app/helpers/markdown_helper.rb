require 'exercism/markdown'
require 'loofah'

module Sinatra
  module MarkdownHelper
    def md(text, language = nil)
      html = if language
        Markdown.render("```#{language}\n#{text}\n```")
      else
        Markdown.render(text)
      end
      Loofah.xml_fragment(html).scrub!(:escape).to_s
    end
  end
end
