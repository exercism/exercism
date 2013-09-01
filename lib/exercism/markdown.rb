require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class Markdown < Redcarpet::Render::XHTML

  def self.render(content)
    markdown = Redcarpet::Markdown.new(Markdown, options)
    markdown.render(content)
  end

  def self.options
    {
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
  end

  def block_code(code, language)
    lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText

    # XXX HACK: Redcarpet strips hard tabs out of code blocks,
    # so we assume you're not using leading spaces that aren't tabs,
    # and just replace them here.
    if lexer.tag == 'make'
      code.gsub! /^    /, "\t"
    end

    formatter = Rouge::Formatters::HTML.new(
      :css_class => "highlight #{lexer.tag}",
      :line_numbers => true
    )

    formatter.format(lexer.lex(code))
  end

end
