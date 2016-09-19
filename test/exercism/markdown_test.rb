require_relative '../test_helper'
require 'exercism/markdown'

class MarkdownTest < Minitest::Test
  def test_mention
    markdown = "u @goose."
    expected = "<p>u <a class=\"mention\" href=\"/goose\">@goose</a>.</p>\n"
    assert_equal expected, ExercismLib::Markdown.render(markdown)
  end

  def test_hard_breaks
    markdown = "O HAI!\n" \
      "What is your name?  \n" \
      "My name is Alice."
    expected = "<p>O HAI!\nWhat is your name?<br>\nMy name is Alice.</p>\n"
    assert_equal expected, ExercismLib::Markdown.render(markdown)
  end

  def test_lists_without_blank_lines
    markdown = "foo bar baz\n* one two three\n* cats dogs and frogs"
    expected = "<p>foo bar baz</p>\n\n<ul>\n<li>one two three</li>\n" \
               "<li>cats dogs and frogs</li>\n</ul>\n"
    assert_equal expected, ExercismLib::Markdown.render(markdown)
  end

  def test_includes_ids_with_headers_so_they_are_linkable
     markdown = "toc: [Header](#header)\n# Header\n"
     expected = "<p>toc: <a href=\"#header\">Header</a></p>\n\n<h1 id=\"header\">Header</h1>\n"
     assert_equal expected, ExercismLib::Markdown.render(markdown)
  end

  def test_mention_works_multiple_times
    markdown = "u @goose of @doom."
    expected = "<p>u <a class=\"mention\" href=\"/goose\">@goose</a> of " \
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
    assert_match "<pre><span id=\"L1\">@goose\n</span>",
                 ExercismLib::Markdown.render(markdown)
  end

end
