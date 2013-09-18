require './test/test_helper'
require 'exercism/markdown'

class MarkdownTest < Minitest::Test

  def test_newlines
    markdown = "Foo\nBar"
    expected = "<p>Foo<br/>\nBar</p>\n"
    assert_equal expected, Markdown.render(markdown)
  end
end
