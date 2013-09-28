require 'loofah'
require 'exercism/markdown'

class ConvertsMarkdownToHTML

  attr_reader :content

  def self.convert(input)
    converter = new(input)
    converter.convert
    converter.content
  end

  def initialize(input)
    @content = (input || "").dup
  end

  def convert
    sanitize_markdown
    convert_markdown_to_html
    sanitize_html
  end

  private

  def sanitize_markdown
    @content.gsub!('>', '&gt;')
    @content.gsub!('<', '&lt;')
  end

  def sanitize_html
    @content = Loofah.xml_fragment(@content).scrub!(:escape).to_s
  end

  def convert_markdown_to_html
    @content = Markdown.render(@content)
  end
end
