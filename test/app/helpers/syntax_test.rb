require_relative '../../test_helper'
require_relative '../../../app/helpers/syntax'

class SyntaxHelperTest < Minitest::Test
  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(ExercismWeb::Helpers::Syntax)
    @helper
  end

  def test_inline_markdown
    code = <<CODE
"""
Method usage:
```
foo.bar()
```
"""

def bar():
    return True
CODE

    output = helper.syntax(code, "python")
    refute_match('<p>', output)
    assert_match('<div class="highlight python">', output)
  end

  def test_language_option
    code = <<CODE
def bar():
    return True
CODE

    output = helper.syntax(code, "python")
    assert_match('<div class="highlight python">', output)
  end

  def test_normalized_language
    output = helper.syntax("", "ecmascript")
    assert_match('<div class="highlight javascript">', output)
  end

  def test_ng_non_bindable
    output = helper.syntax("", "ecmascript")
    assert_match(/\A<span ng-non-bindable>/, output)
    assert_match(/<\/span>\Z/, output)
  end

  def test_crlf_scrubbing
    code = <<CODE
#\r
# Python Comment.\r
#\r
\r
def foo(bar):\r
    bar = bar.strip()\r
\r
\r
CODE

    output = helper.syntax(code, "python")
    refute_match(/\r/, output)
  end
end
