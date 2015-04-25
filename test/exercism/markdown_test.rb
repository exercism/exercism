require_relative '../test_helper'
require 'exercism/markdown'

class MarkdownTest < Minitest::Test
  def test_mention
    markdown = "u @goose."
    expected = "<p>u <a class=\"mention\" href=\"/goose\">@goose</a>.</p>\n"
    assert_equal expected, ExercismLib::Markdown.render(markdown)
  end

  def test_mention_works_multiple_times
    markdown = "u @goose of @doom."
    expected = "<p>u <a class=\"mention\" href=\"/goose\">@goose</a> of " +
               "<a class=\"mention\" href=\"/doom\">@doom</a>.</p>\n"
    assert_equal expected, ExercismLib::Markdown.render(markdown)
  end

  def test_mention_ignores_code_spans
    markdown = "`@goose`"
    expected = "<p><code>@goose</code></p>\n"
    assert_equal expected, ExercismLib::Markdown.render(markdown)
  end

  def test_mention_ignores_fenced_code_blocks
    markdown = "```\n@goose\n```"
    assert_match "<pre>@goose", ExercismLib::Markdown.render(markdown)
  end

  def test_newlines
    markdown = "Foo\nBar"
    expected = "<p>Foo<br>\nBar</p>\n"
    assert_equal expected, ExercismLib::Markdown.render(markdown)
  end
end
