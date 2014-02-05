require 'bundler'
Bundler.setup
require './test/test_helper'
require './lib/exercism/markdown'
require './lib/exercism/code_formatter'
require 'mocha/setup'

class CodeFormatterTest < MiniTest::Unit::TestCase

  def test_formats_to_table
    html = CodeFormatter.format("a = 42\nb = 0", "ruby")
    expected = %q{<table class="code-table highlight ruby">
<tr><td class="lineno">1</td><td><span class="n">a</span> <span class="o">=</span> <span class="mi">42</span></tr></td>
<tr><td class="lineno">2</td><td><span class="n">b</span> <span class="o">=</span> <span class="mi">0</span></tr></td>
</table>}
    assert_equal expected, html
  end

end
