require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class Markdown < Redcarpet::Render::XHTML
  include Rouge::Plugins::Redcarpet

  def self.render(content)
    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      strikethrough: true,
      lax_html_blocks: true,
      superscript: true,
      hard_wrap: true,
      tables: true,
      space_after_headers: true,
      hard_wrap: true,
      xhtml: true
    }
    markdown = Redcarpet::Markdown.new(Markdown, options)
    markdown.render(content)
  end
end


