require_relative '../test_helper'
require 'exercism/markdown'
require 'exercism/converts_markdown_to_html'

class MarkdownTest < Minitest::Test
  def test_mention
    markdown = "u @goose."
    expected = "<p>u <a class=\"mention\" href=\"/goose\">@goose</a>.</p>\n"
    assert_equal expected, ExercismLib::Markdown.render(markdown)
  end

  def test_hard_breaks
    markdown = "O HAI!\n" +
      "What is your name?  \n" +
      "My name is Alice."
    expected = "<p>O HAI!\nWhat is your name?<br>\nMy name is Alice.</p>\n"
    assert_equal expected, ExercismLib::Markdown.render(markdown)
  end

  def test_lists_without_blank_lines
    markdown = "foo\n* one\n* two"
    expected = "<p>foo</p>\n<ul>\n<li>one</li>\n<li>two</li>\n</ul>\n"
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

  def test_no_newlines_before_and_after_code
    markdown = "foo\n```ruby\nputs hi\n```\nbar"
    assert_match "<div class=\"highlight", ConvertsMarkdownToHTML.convert(markdown)
  end

  def test_no_newlines_before_and_after_code_without_language
    markdown = "foo\n```\nputs hi\n```\nbar"
    assert_match "<div class=\"highlight", ConvertsMarkdownToHTML.convert(markdown)
  end
end
