require_relative '../test_helper'
require 'byebug'
require 'rouge'
require 'loofah'
require_relative '../../lib/rouge/formatters/html_exercism'

class HTMLFormatterTest < MiniTest::Test
  def setup
  end

  def test_ocaml_comment
    code = %{
    (* reverse the first list, then prepend it to the second list. (In
       other words, one by one, move the head of the first list onto the head
       of the second.) *)
    let rec backward_prepend = function
    | ([], lst) -> ([], lst)
    | (hd::tl, lst) -> backward_prepend (tl, hd::lst)
    }.gsub('    ', '')
    raw_lines = code.split "\n"

    lexer = Rouge::Lexer.find_fancy('ocaml')
    formatter = Rouge::Formatters::HTMLExercism.new(line_numbers: true)

    lexemes = lexer.lex(code)
    output = formatter.format(lexemes)

    doc = Loofah::HTML::DocumentFragment.parse(output)

    assert_equal 3, doc.css('span.c').size, "Multiline comment should be split into individual lines with proper style"
    assert_equal 8, doc.css('span[id^=L]').size, "Comments are not properly included in line count"

    (2..4).each do |lineno|
      line = doc.css("span[id=L#{lineno}]")
      assert_equal raw_lines[lineno - 1], line.text.rstrip,  "Comment text in line #{lineno} should be preserved"
    end
  end
end
