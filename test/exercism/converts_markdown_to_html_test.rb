require 'bundler'
Bundler.setup
require_relative '../test_helper'
require_relative '../approval_helper'
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
    expected = "<p>good\n</p>"
    assert_converts_to(input, expected)
  end

  def test_sanitisation_with_code
    input = "```<script type=\"text/javascript\">bad();</script>```good"
    expected = "<p><code>&lt;script type=\"text/javascript\"&gt;bad();&lt;/script&gt;</code>good</p>"
    assert_converts_to(input, expected)
  end

  def test_markdown
    input = "Foo **bold** bar"
    expected = "<p>Foo <strong>bold</strong> bar</p>"
    assert_converts_to(input, expected)
  end

  def test_markdown_paragraphs
    input = "One\n\nTwo  \nThree"
    expected = "<p>One</p>\n<p>Two<br>\nThree</p>"
    assert_converts_to(input, expected)
  end

  def test_markdown_code_with_ampersands
    input = "```\nbig && strong\n```"
    expected = %q{<div class="highlight plaintext">
<table style="border-spacing: 0;"><tbody><tr>
<td class="gutter gl" style="text-align: right;"><pre class="lineno">1</pre></td>
<td class="code"><pre>big &amp;&amp; strong
</pre></td>
</tr></tbody></table>
</div>}
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
    input = %Q{```
  var refill = 99
    , template = "{{current}} of beer on the wall, {{current}} of beer.\n" +
                 "{{action}}, {{remaining}} of beer on the wall.\n";}

    expected = %Q{<div class="highlight plaintext">
<table style="border-spacing: 0;"><tbody><tr>
<td class="gutter gl" style="text-align: right;"><pre class="lineno">1
2
3
4
5</pre></td>
<td class="code"><pre>  var refill = 99
    , template = "{{current}} of beer on the wall, {{current}} of beer.\n" +
                 "{{action}}, {{remaining}} of beer on the wall.\n";
</pre></td>
</tr></tbody></table>
</div>}

    converter = ConvertsMarkdownToHTML.new(input)
    converter.convert
    assert_equal expected, converter.content.strip
  end


  def test_complex_markdown_with_code
    input = %Q{Pre text

```
class Foobar
  foos.each { |foo| foo.bar > 10 }
end
```

Post text}

    expected = %q{<p>Pre text</p>
<div class="highlight plaintext">
<table style="border-spacing: 0;"><tbody><tr>
<td class="gutter gl" style="text-align: right;"><pre class="lineno">1
2
3</pre></td>
<td class="code"><pre>class Foobar
  foos.each { |foo| foo.bar &gt; 10 }
end
</pre></td>
</tr></tbody></table>
</div>
<p>Post text</p>}

    assert_converts_to(input, expected)
  end

  def test_markdown_with_clojure_code
    input = %q{Check out this code:

```clj
(defn to-rna
  [dna-string]
  (clojure.string/replace dna-string \T \U))
```}

    expected = %q{<p>Check out this code:</p>
<div class="highlight clojure">
<table style="border-spacing: 0;"><tbody><tr>
<td class="gutter gl" style="text-align: right;"><pre class="lineno">1
2
3</pre></td>
<td class="code"><pre><span class="p">(</span><span class="k">defn</span><span class="w"> </span><span class="n">to-rna</span><span class="w">
  </span><span class="p">[</span><span class="n">dna-string</span><span class="p">]</span><span class="w">
  </span><span class="p">(</span><span class="nf">clojure.string/replace</span><span class="w"> </span><span class="n">dna-string</span><span class="w"> </span><span class="sc">\T</span><span class="w"> </span><span class="sc">\U</span><span class="p">))</span><span class="w">
</span></pre></td>
</tr></tbody></table>
</div>}
    assert_converts_to(input, expected)
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
end
