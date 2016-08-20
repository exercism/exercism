require_relative '../test_helper'
require 'rouge'
require 'loofah'
require 'rouge/formatters/html_exercism'

class HTMLFormatterTest < MiniTest::Test
  def setup
    @formatter = Rouge::Formatters::HTMLExercism.new
  end

  def test_ocaml
    code = load_example 'ocaml'
    tokens = lex_sample code, 'ocaml'
    html = @formatter.format(tokens)
    doc = parse html
    raw_lines = load_example('ocaml').lines

    assert_equal 6, doc.css('span[id^=L]').size, "Formatting should preserve linecount"
    assert_equal 3, doc.css('span.c').size, "Multiline comment should be split into individual lines with proper style"

    (1..3).each do |lineno|
      line = doc.css("span[id=L#{lineno}]").text.rstrip
      original_line = raw_lines[lineno - 1].rstrip
      assert_equal original_line, line,  "Comment text in line #{lineno} should be preserved"
    end
  end

  def test_python
    code = load_example 'python'
    tokens = lex_sample code, 'python'
    html = @formatter.format(tokens)
    doc = parse html

    assert_equal 12, doc.css('span[id^=L]').size, "Formatting should preserve linecount"
    assert_equal 3, doc.css('span.s').size, "There should be exactly 3 string tokens in the code"
    assert_equal '', doc.css('div#L4').text.rstrip, "Line 4 should be blank"
    assert_equal '', doc.css('div#L5').text.rstrip, "Line 5 should be blank"
  end

  def test_swift
    code = load_example 'swift'
    tokens = lex_sample code, 'swift'
    html = @formatter.format(tokens)
    doc = parse html

    assert_equal '}', code[-1], 'Last character should be brace, not newline'
    assert_equal 18, code.count("\n")

    assert_equal 19, doc.css('span[id^=L]').size, "Formatting should preserve linecount"

    # Swift, has separate single- and multi-line comments
    assert doc.css('span#L3 span.c1').size == 1, "Line 3 should contain a single-line comment"
    assert doc.css('span#L9 span.cm').size == 1, "Line 9 should contain a multiline comment"
    assert doc.css('span#L10 span.cm').size == 1, "Line 10 should contain a multiline comment"
    assert_equal "    }", doc.css('span#L17').text.rstrip, "Line 17 should have a four space indent and closing brace"
    assert_equal "}", doc.css('span#L19').text.rstrip, "Line 19 should have only a closing brace"
  end

  private

  def load_example(name)
    path = File.join(File.expand_path('../../fixtures/code_formatting', __FILE__), name)
    File.read path
  end

  def lex_sample(code, language)
    lexer = Rouge::Lexer.find_fancy language
    lexer.lex(code)
  end

  def parse(output)
    Loofah::HTML::DocumentFragment.parse(output)
  end
end
