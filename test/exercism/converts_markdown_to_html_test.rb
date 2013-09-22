require './test/integration_helper'

class ConvertsMarkdownToHTMLTest < Minitest::Test

  def check_sanitiation(input, expected)
    converter = ConvertsMarkdownToHTML.new(input)
    converter.convert
    assert_equal expected, converter.content.strip
  end

  def test_convert_class_method_calls_correct_methods
    ConvertsMarkdownToHTML.any_instance.expects(:convert)
    ConvertsMarkdownToHTML.any_instance.expects(:content)
    ConvertsMarkdownToHTML.convert(nil)
  end

  def test_convert_calls_correct_methods
    converter = ConvertsMarkdownToHTML.new(nil)
    converter.expects(:sanitize_markdown)
    converter.expects(:convert_markdown_to_html)
    converter.expects(:sanitize_html)
    converter.convert
  end

  def test_sanitiation
    input = "<script type=\"text/javascript\">bad();</script>good"
    expected = "<p>&lt;script type=\"text/javascript\"&gt;bad();&lt;/script&gt;good</p>"
    check_sanitiation(input, expected)
  end

  def test_markdown
    input = "Foo **bold** bar"
    expected = "<p>Foo <strong>bold</strong> bar</p>"
    check_sanitiation(input, expected)
  end

  def test_ampersands
    input = "```\nbig && strong\n```"
    expected = %Q{<pre class=\"highlight plaintext\">
  <table>
    <tbody>
      <tr>
        <td class=\"gutter gl\">
          <div class=\"lineno\">1</div>
        </td>
        <td class=\"code\">big &amp;&amp; strong
</td>
      </tr>
    </tbody>
  </table>
</pre>}
    check_sanitiation(input, expected)
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
<pre class="highlight plaintext">
  <table>
    <tbody>
      <tr>
        <td class="gutter gl">
          <div class="lineno">1</div>
          <div class="lineno">2</div>
          <div class="lineno">3</div>
        </td>
        <td class="code">class Foobar
  foos.each { |foo| foo.bar &amp;gt; 10 }
end
</td>
      </tr>
    </tbody>
  </table>
</pre>
<p>Post text</p>}

    check_sanitiation(input, expected)
  end

  def test_stubby_lambda
    input = "->"
    expected = "<p>-&gt;</p>"
    check_sanitiation(input, expected)
  end

  def test_elixir_operator
    input = "->>"
    expected = "<p>-&gt;&gt;</p>"
    check_sanitiation(input, expected)
  end

  def test_ascii_hearts
    input = "<3 This is lovely!"
    expected = "<p>&lt;3 This is lovely!</p>"
    check_sanitiation(input, expected)
  end
end
