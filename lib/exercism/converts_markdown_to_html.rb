require 'loofah'
require 'exercism/markdown'

class ConvertsMarkdownToHTML

  attr_reader :content

  def self.convert(input, analysis_results=[])
    converter = new(input, analysis_results)
    converter.convert
    converter.content
  end

  def initialize(input, analysis_results)
    @content = (input || "").dup
    @analysis_results = analysis_results
  end

  def convert
    convert_markdown_to_html
    sanitize_html
  end

  private

  def sanitize_html
    @content = Loofah.fragment(@content).scrub!(:escape).to_s
  end

  def convert_markdown_to_html
    @content = Markdown.render(@content, @analysis_results)
  end
end
