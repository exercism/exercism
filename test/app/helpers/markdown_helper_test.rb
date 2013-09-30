require './test/test_helper'
require 'app/helpers/markdown_helper'

class MarkdownHelperTest < Minitest::Test
  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(Sinatra::MarkdownHelper)
    @helper
  end

  def test_sanitize_input_with_language
    code = <<RUBY
CODE
```
<script>alert('hi, bob!')</script>
```
RUBY
    output = helper.md(code, "ruby")
    expected = <<HTML.strip
<pre class="highlight ruby">
  <table>
    <tbody>
      <tr>
        <td class="gutter gl">
          <div class="lineno">1</div>
        </td>
        <td class="code"><span class="no">CODE</span>
</td>
      </tr>
    </tbody>
  </table>
</pre>
&lt;script&gt;alert('hi, bob!')&lt;/script&gt;
<pre class="highlight plaintext">
  <table>
    <tbody>
      <tr>
        <td class="gutter gl">
          <div class="lineno">1</div>
        </td>
        <td class="code">
</td>
      </tr>
    </tbody>
  </table>
</pre>
HTML
    assert_equal expected, output
  end
end
