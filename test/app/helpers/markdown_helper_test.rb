require './test/integration_helper'
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
<div class="highlight ruby"><table><tbody><tr>
<td class=\"gutter gl\"><pre class=\"lineno\">1</pre></td>
<td class="code"><pre><span class="no">CODE</span>
</pre></td>
</tr></tbody></table></div>
&lt;script&gt;alert('hi, bob!')&lt;/script&gt;<div class="highlight plaintext"><table><tbody><tr>
<td class=\"gutter gl\"><pre class=\"lineno\">1</pre></td>
<td class="code"><pre>
</pre></td>
</tr></tbody></table></div>
HTML
    assert_equal expected, output
  end
end
