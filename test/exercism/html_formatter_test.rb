require_relative '../test_helper'
require 'rouge'
require 'loofah'
require_relative '../../lib/rouge/formatters/html_exercism'

class HTMLFormatterTest < MiniTest::Test
  def setup
    @formatter = Rouge::Formatters::HTMLExercism.new line_numbers: true
  end

  def test_ocaml_comment
    tokens = load_sample 'ocaml', 'ocaml'
    doc = parse @formatter.format(tokens)
    raw_lines = load_example('ocaml').lines

    assert_equal 6, doc.css('div[id^=L]').size, "Formatting should preserve linecount"
    assert_equal 3, doc.css('span.c').size, "Multiline comment should be split into individual lines with proper style"

    (1..3).each do |lineno|
      line = doc.css("div[id=L#{lineno}]").text.rstrip
      original_line = raw_lines[lineno - 1].rstrip
      assert_equal original_line, line,  "Comment text in line #{lineno} should be preserved"
    end
  end

  def test_python_docstring
    tokens = load_sample 'python', 'python'
    doc = parse @formatter.format(tokens)

    assert_equal 12, doc.css('div[id^=L]').size, "Formatting should preserve linecount"
    assert_equal 3, doc.css('span.s').size, "There should be exactly 3 string tokens in the code"
    assert_equal '', doc.css('div#L4').text.rstrip, "Line 4 should be blank"
    assert_equal '', doc.css('div#L5').text.rstrip, "Line 5 should be blank"
  end

  def test_swift
    tokens = load_sample 'swift', 'swift'
    doc = parse @formatter.format(tokens)

    assert_equal 121, doc.css('div[id^=L]').size, "Formatting should preserve linecount"
    assert_equal "}", doc.css('div#L121').text.rstrip, "Line 121 should have only a closing brace"
    assert_equal "    }", doc.css('div#L120').text.rstrip, "Line 120 should have a four space indent and closing brace"
  end

  private

  def get_lexer(language)
    Rouge::Lexer.find_fancy language
  end

  def load_sample(name, language)
    code = load_example name
    lexer = get_lexer language

    lexer.lex(code)
  end

  def parse(output)
    Loofah::HTML::DocumentFragment.parse(output)
  end

  def load_example(name)
    path = File.join(File.expand_path('../../fixtures/code_formatting', __FILE__), name)
    File.read path
  end
end
