require 'bundler'
Bundler.setup
require_relative '../test_helper'
require_relative '../approvals_hack'
require 'exercism/markdown'
require 'exercism/converts_markdown_to_html'
require 'mocha/setup'

class ConvertsMarkdownToHTMLTest < Minitest::Test
  def assert_converts_to(input, expected)
    converter = ConvertsMarkdownToHTML.new(input)
    converter.convert
    assert_equal expected, converter.content.strip
  end

  def test_sanitisation
    input = "<script type=\"text/javascript\">bad();</script>good"
    expected = "<p>&lt;script type=\"text/javascript\"&gt;bad();&lt;/script&gt;good</p>"
    assert_converts_to(input, expected)
  end

  def test_markdown
    input = "Foo **bold** bar"
    expected = "<p>Foo <strong>bold</strong> bar</p>"
    assert_converts_to(input, expected)
  end

  def test_markdown_paragraphs
    input = "One\n\nTwo  \nThree"
    expected = "<p>One</p>\n\n<p>Two<br>\nThree</p>"
    assert_converts_to(input, expected)
  end

  def test_markdown_code_with_ampersands
    input = "```\nbig && strong\n```"
    expected = '<div class="highlight plaintext">
<table style="border-spacing: 0;"><tbody><tr>
<td class="gutter gl" style="text-align: right;"><pre class="lineno"><a href="#L1">1</a></pre></td>
<td class="code"><pre><span id="L1">big &amp;&amp; strong
</span></pre></td>
</tr></tbody></table>
</div>'
    assert_converts_to(input, expected)
  end

  def test_markdown_code_with_text_and_double_braces
    input = "```\nx{{current}}y\n```"
    Approvals.verify(ConvertsMarkdownToHTML.new(input).convert, name: 'markdown_text_and_double_braces')
  end

  def test_markdown_code_with_double_braces
    input = "```\n{{x: y}}\n```"
    Approvals.verify(ConvertsMarkdownToHTML.new(input).convert, name: 'markdown_double_braces')
  end

  def test_markdown_code_with_javascript_and_double_braces
    input = %(```
  var refill = 99
    , template = "{{current}} of beer on the wall, {{current}} of beer.\n" +
                 "{{action}}, {{remaining}} of beer on the wall.\n";)

    expected = %(<div class="highlight plaintext">
<table style="border-spacing: 0;"><tbody><tr>
<td class="gutter gl" style="text-align: right;"><pre class="lineno"><a href=\"#L1\">1</a>
<a href=\"#L2\">2</a>
<a href=\"#L3\">3</a>
<a href=\"#L4\">4</a>
<a href=\"#L5\">5</a></pre></td>
<td class="code"><pre><span id="L1">  var refill = 99
</span><span id="L2">    , template = \"{{current}} of beer on the wall, {{current}} of beer.
</span><span id="L3">" +
</span><span id="L4">                 \"{{action}}, {{remaining}} of beer on the wall.
</span><span id="L5">";
</span></pre></td>
</tr></tbody></table>
</div>)

    converter = ConvertsMarkdownToHTML.new(input)
    converter.convert
    assert_equal expected, converter.content.strip
  end

  def test_complex_markdown_with_code
    input = %(Pre text

```
class Foobar
  foos.each { |foo| foo.bar > 10 }
end
```

Post text)

    expected = '<p>Pre text</p>
<div class="highlight plaintext">
<table style="border-spacing: 0;"><tbody><tr>
<td class="gutter gl" style="text-align: right;"><pre class="lineno"><a href="#L1">1</a>
<a href="#L2">2</a>
<a href="#L3">3</a></pre></td>
<td class="code"><pre><span id="L1">class Foobar
</span><span id="L2">  foos.each { |foo| foo.bar &gt; 10 }
</span><span id="L3">end
</span></pre></td>
</tr></tbody></table>
</div>

<p>Post text</p>'

    assert_converts_to(input, expected)
  end

  def test_markdown_with_clojure_code
    input = 'Check out this code:

```clj
(defn to-rna
  [dna-string]
  (clojure.string/replace dna-string \T \U))
```'

    Approvals.verify(ConvertsMarkdownToHTML.new(input).convert, name: 'markdown_with_clojure_code')
  end

  def test_stubby_lambda
    input = "->"
    expected = "<p>-&gt;</p>"
    assert_converts_to(input, expected)
  end

  def test_elixir_operator
    input = "->>"
    expected = "<p>-&gt;&gt;</p>"
    assert_converts_to(input, expected)
  end

  def test_ascii_hearts
    input = "<3 This is lovely!"
    expected = "<p>&lt;3 This is lovely!</p>"
    assert_converts_to(input, expected)
  end

  def test_no_newlines_before_and_after_code_in_backticks
    input = "foo\n```ruby\nputs hi\n```\nbar"
    expected = "<p>foo</p>\n<div class=\"highlight ruby\">\n<table style=\"border-spacing: 0;\"><tbody><tr>\n<td class=\"gutter gl\" style=\"text-align: right;\"><pre class=\"lineno\"><a href=\"#L1\">1</a></pre></td>\n<td class=\"code\"><pre><span id=\"L1\"><span class=\"nb\">puts</span> <span class=\"n\">hi</span>\n</span></pre></td>\n</tr></tbody></table>\n</div>\n\n<p>bar</p>"
    assert_converts_to(input, expected)
  end

  def test_with_newlines_before_and_after_code_in_backticks
    input = "foo\n\n```ruby\nputs hi\n```\n\nbar"
    expected = "<p>foo</p>\n<div class=\"highlight ruby\">\n<table style=\"border-spacing: 0;\"><tbody><tr>\n<td class=\"gutter gl\" style=\"text-align: right;\"><pre class=\"lineno\"><a href=\"#L1\">1</a></pre></td>\n<td class=\"code\"><pre><span id=\"L1\"><span class=\"nb\">puts</span> <span class=\"n\">hi</span>\n</span></pre></td>\n</tr></tbody></table>\n</div>\n\n<p>bar</p>"
    assert_converts_to(input, expected)
  end

  def test_no_newlines_before_and_after_code_in_backticks_without_language
    input = "foo\n```\nputs hi\n```\nbar"
    expected = "<p>foo</p>\n<div class=\"highlight plaintext\">\n<table style=\"border-spacing: 0;\"><tbody><tr>\n<td class=\"gutter gl\" style=\"text-align: right;\"><pre class=\"lineno\"><a href=\"#L1\">1</a></pre></td>\n<td class=\"code\"><pre><span id=\"L1\">puts hi\n</span></pre></td>\n</tr></tbody></table>\n</div>\n\n<p>bar</p>"
    assert_converts_to(input, expected)
  end

  def test_code_in_backticks_with_carriage_returns_in_line_endings
    input = "foo\r\n```ruby\r\nputs hi\r\n```\r\nbar"
    expected = "<p>foo</p>\n<div class=\"highlight ruby\">\n<table style=\"border-spacing: 0;\"><tbody><tr>\n<td class=\"gutter gl\" style=\"text-align: right;\"><pre class=\"lineno\"><a href=\"#L1\">1</a></pre></td>\n<td class=\"code\"><pre><span id=\"L1\"><span class=\"nb\">puts</span> <span class=\"n\">hi</span>\n</span></pre></td>\n</tr></tbody></table>\n</div>\n\n<p>bar</p>"
    assert_converts_to(input, expected)
  end

  def test_code_in_too_many_backticks
    input = "too\r\n````\r\nmany\r\n`````\r\nbackticks"
    expected = "<p>too</p>\n<div class=\"highlight plaintext\">\n<table style=\"border-spacing: 0;\"><tbody><tr>\n<td class=\"gutter gl\" style=\"text-align: right;\"><pre class=\"lineno\"><a href=\"#L1\">1</a></pre></td>\n<td class=\"code\"><pre><span id=\"L1\">many\n</span></pre></td>\n</tr></tbody></table>\n</div>\n\n<p>backticks</p>"
    assert_converts_to(input, expected)
  end

  def test_class_convert_method
    input = "<3 This is lovely!"
    expected = "<p>&lt;3 This is lovely!</p>\n"
    assert_equal expected, ConvertsMarkdownToHTML.convert(input)
  end
end
