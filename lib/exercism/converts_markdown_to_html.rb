require 'loofah'
require 'exercism/markdown'

class ConvertsMarkdownToHTML
  attr_reader :content

  def self.convert(input)
    new(input).convert
  end

  def initialize(input)
    @content = (input || "").dup
  end

  def convert
    preprocess_markdown!
    convert_markdown_to_html!
    sanitize_html!
  end

  private

  def sanitize_html!
    @content = Loofah.fragment(@content).scrub!(:escape).to_s
  end

  def convert_markdown_to_html!
    @content = ExercismLib::Markdown.render(@content)
  end

  def preprocess_markdown!
    @content = filter_markdown_code_block(@content)
  end

  def filter_markdown_code_block(string)
    string.gsub(/^`{3,}(.*?)`{3,}\s*$/m) { "\n#{$&}\n" }
  end
end
