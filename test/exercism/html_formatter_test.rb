require_relative '../test_helper'
require 'rouge'
require 'loofah'
require_relative '../../lib/rouge/formatters/html_exercism'

class HTMLFormatterTest < MiniTest::Test
  def setup
    @formatter = Rouge::Formatters::HTMLExercism.new line_numbers: true
  end

  def test_ocaml_comment
    load_sample 'ocaml', 'ocaml'

    assert_equal 7, @doc.css('span[id^=L]').size, "Formatting should preserve linecount"
    assert_equal 3, @doc.css('span.c').size, "Multiline comment should be split into individual lines with proper style"

    (1..3).each do |lineno|
      line = @doc.css("span[id=L#{lineno}]").text.rstrip
      original_line = @raw_lines[lineno - 1].rstrip
      assert_equal original_line, line,  "Comment text in line #{lineno} should be preserved"
    end
  end

  def test_python_docstring
    load_sample 'python', 'python'

    assert_equal 13, @doc.css('span[id^=L]').size, "Formatting should preserve linecount but add terminating line"
    assert_equal 3, @doc.css('span.s').size, "There should be exactly 3 string tokens in the code"
    assert_equal '', @doc.css('span#L4').text.rstrip, "Line 4 should be blank"
    assert_equal '', @doc.css('span#L5').text.rstrip, "Line 5 should be blank"
  end

  private

  def get_lexer(language)
    Rouge::Lexer.find_fancy language
  end

  def load_sample(name, language)
    code = load_example name
    @raw_lines = code.lines
    lexer = get_lexer language

    lexemes = lexer.lex(code)
    @output = @formatter.format(lexemes)

    @doc = Loofah::HTML::DocumentFragment.parse(@output)
  end

  def load_example(name)
    path = File.join(File.expand_path('../../fixtures/code_formatting', __FILE__), name)
    File.read path
  end
end
