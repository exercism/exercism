require_relative '../../test_helper'
require 'exercism/converts_markdown_to_html'
require 'app/helpers/markdown'

class MarkdownHelperTest < MiniTest::Unit::TestCase
  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(ExercismWeb::Helpers::Markdown)
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
    expected = <<HTML
<div class="highlight ruby">
<table style=\"border-spacing: 0;\"><tbody><tr>
<td class=\"gutter gl\" style=\"text-align: right;\"><pre class=\"lineno\">1</pre></td>
<td class="code"><pre><span class="no">CODE</span>
</pre></td>
</tr></tbody></table>
</div>

&lt;script&gt;alert('hi, bob!')&lt;/script&gt;
<div class="highlight plaintext">
<table style=\"border-spacing: 0;\"><tbody><tr>
<td class=\"gutter gl\" style=\"text-align: right;\"><pre class=\"lineno\">1</pre></td>
<td class="code"><pre>
</pre></td>
</tr></tbody></table>
</div>
HTML
    assert_equal expected, output
  end
end
